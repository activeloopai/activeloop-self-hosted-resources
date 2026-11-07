# deeplake-platform

Helm chart for self-hosted Deep Lake. Installs the control-plane API, the web
UI, and the pg-deeplake data plane into a customer's own Kubernetes cluster.

Azure/AKS is the primary target; AWS/EKS and GCP/GKE share the same chart via
`global.cloud`. `global.cloud: s3` targets any other cluster whose object
storage is an S3-compatible endpoint with a static key (Ceph RGW, MinIO, NRP
Nautilus); see `values-s3.yaml`.

## Layout

```
deeplake-platform/
├── Chart.yaml              # chart version IS the platform release
├── values.yaml             # the customer-facing contract (everything is under `global`)
├── values-azure.yaml       # per-cloud overlays
├── values-aws.yaml
├── values-gcp.yaml
├── values-s3.yaml          # S3-compatible endpoint + static key (Ceph, MinIO, NRP)
├── docs/install.md         # setup guide: prerequisites, install, verify
└── charts/
    ├── deeplake-common/    # library chart — shared helpers, renders nothing
    ├── deeplake-api/       # api-server, api-worker, migration hook
    ├── deeplake-ui/        # Next.js UI + runtime config
    └── dlpg/               # pg-proxy, stateless pool, indexer
```

## Install

Full walkthrough in [docs/install.md](docs/install.md) — object storage,
workload identity, secrets, DNS, and a verification checklist. Once the
prerequisites are in place:

```bash
helm install deeplake oci://quay.io/activeloopai/charts/deeplake-platform \
  --version 0.1.4 \
  --namespace deeplake --create-namespace \
  -f values-azure.yaml \
  -f my-values.yaml
```

The chart pulls anonymously. `deeplake-api` and `deeplake-ui` are private images, so you also
need a pull secret — `global.imagePullSecrets` — created from credentials we
issue you. Everything else (`deeplake-ui`, `pg-deeplake-stateless`, `pg-proxy`)
pulls anonymously too.

Workload identity is the step to get right: a missing or mismatched federated
credential makes `pg_deeplake` abort the Postgres backend on the first
storage-touching statement, rather than returning an error. With
`global.cloud: s3` there is no identity to federate: the pods read a static key
from the Secret named in `global.storage.s3.credentialsSecret`.

KeyCloak realm ConfigMap renders whether or not Keycloak is bundled, so a installation
running it's own Keycloak can import the same realm:

```bash
kubectl get cm <release>-keycloak-realm -o jsonpath='{.data.realm\.json}' > realm.json
# then: admin console -> Create realm -> Browse -> realm.json
```

Import happens once, at first startup, and skips a realm that already exists —
edit clients in the admin console after that, not by reinstalling. Settings the
platform depends on are the exception: with the bundled Keycloak, a
`post-install`/`post-upgrade` Job applies them to the live realm (see Notes).

**The chart never creates a secret.** You supply Secret names via
`global.secrets.*`. Generate them yourself or sync them with External Secrets
Operator from Key Vault / Secrets Manager.

## Notes

- **"Ask AI" query suggestion needs `OPENAI_API_KEY`.** Not set by the chart;
  the endpoint 404s without it. Billing endpoints 404 by design.
- **The OpenFGA model ships with the chart and is applied on every upgrade.**
  `deeplake-api` checks the `workspace` relations `admin`, `writer`, `viewer`
  and `blocked`; a store still on the older model fails every workspace request.
  The bootstrap Job runs as a `pre-upgrade` (and `post-install`) hook, so on
  `helm upgrade` the current model is written to the existing store and its id
  patched into the `global.openfga.bootstrap.secretName` Secret *before* new
  API pods start. Writing a model only adds to the store: existing tuples stay
  valid and the previous API keeps working on it. The Job skips the write when
  the Secret's `FGA_MODEL_SHA256` already matches the shipped model. Pods read
  the id at start, so when the Job writes a new model it also restarts the API
  server and worker Deployments (it patches a pod-template annotation; RBAC is
  limited to get/patch on those two Deployments). On an upgrade that also
  changes the API image this can roll the pods once before Helm rolls them again.
- **SSO users are told apart by the `identity_provider` claim.** The UI reads
  it (`global.auth.oidc.idpClaim`, passed as `OIDC_IDP_CLAIM`) to decide
  whether a user signed in with a password or through an identity provider,
  and shows "Change password" only to password users. The realm emits it from
  a User Session Note mapper (`identity-provider`) on the UI and CLI clients;
  Keycloak sets the note on brokered logins only. Realms imported by chart
  0.1.3 or older lack the mapper, so every user looks like a password user.
  - **Existing installs get it with `helm upgrade`.** Realm import skips an
    existing realm, so the `<release>-keycloak-reconcile` Job (a
    `post-install`/`post-upgrade` hook, on when `global.keycloak.enabled`,
    `importRealm` and `reconcileRealm` are all true) logs in as the admin from
    `global.keycloak.adminSecret` and creates the mapper on each client, or
    replaces it when it differs; reruns change nothing. It waits up to 10
    minutes for Keycloak, which restarts on this upgrade because the realm
    ConfigMap changed. If that admin no longer exists in Keycloak the Job fails
    and so does the upgrade: fix the Secret, or set
    `global.keycloak.reconcileRealm=false` and apply the mapper by hand.
  - **By hand** (own Keycloak, `importRealm: false`, or the Job disabled):
    admin console → realm → Clients → `deeplake-ui` → Client scopes →
    `deeplake-ui-dedicated` → Add mapper → By configuration → User Session
    Note. Name `identity-provider`, User Session Note `identity_provider`,
    Token Claim Name `identity_provider`, Claim JSON Type `String`, ID token,
    access token, userinfo and introspection on. Repeat for `deeplake-cli`. Or,
    against the bundled Keycloak:

    ```bash
    kubectl -n $NS exec -i deploy/$RELEASE-keycloak -- bash -c '
    K=/opt/keycloak/bin/kcadm.sh; C="--config /tmp/kcadm.config"; REALM=deeplake
    $K config credentials $C --server http://localhost:8080 --realm master \
      --user "$KC_BOOTSTRAP_ADMIN_USERNAME" --password "$KC_BOOTSTRAP_ADMIN_PASSWORD"
    for CLIENT in deeplake-ui deeplake-cli; do
      ID=$($K get clients $C -r $REALM -q clientId=$CLIENT --fields id --format csv --noquotes)
      $K create clients/$ID/protocol-mappers/models $C -r $REALM \
        -s name=identity-provider -s protocol=openid-connect \
        -s protocolMapper=oidc-usersessionmodel-note-mapper \
        -s "config.\"user.session.note\"=identity_provider" \
        -s "config.\"claim.name\"=identity_provider" \
        -s "config.\"jsonType.label\"=String" \
        -s "config.\"id.token.claim\"=true" \
        -s "config.\"access.token.claim\"=true" \
        -s "config.\"userinfo.token.claim\"=true" \
        -s "config.\"introspection.token.claim\"=true"
    done
    rm -f /tmp/kcadm.config'
    ```

    Change the realm and client names if yours differ. Users pick the claim up
    at their next login.
  - **Limitation: Keycloak still lets an SSO user set a local password.** The
    claim only drives the UI. The account console
    (`/realms/<realm>/account`) and `kc_action=UPDATE_PASSWORD` stay open to
    every user, and a password set there signs in without the identity
    provider, bypassing its MFA and offboarding. Keycloak 26.7 has no setting
    that forbids local credentials for brokered users: disabling the Update
    Password required action removes it for password users too, and no
    built-in flow condition detects an identity-provider link. Where this
    matters, one approach (test it against your own flows): give every
    identity provider a Hardcoded Role mapper (say
    `sso-only`), and add a conditional sub-flow to the browser and direct
    grant flows, after the password step, that denies access with
    `Condition - user role` = `sso-only` → `Deny access`. The chart does not
    do this because it does not own your identity providers or flows. Also
    disable the user in Keycloak, not only in the identity provider, when
    offboarding.
- **`dlpg.pgPilot` requires Kubernetes ≥ 1.33** with `InPlacePodVerticalScaling`
  for the `pods/resize` subresource. Off by default; verify before enabling.
- **The device grant always shows an approval page.** `consentRequired` is false
  on both clients, but Keycloak still renders a confirm step for the device flow
  — the user is approving the device, not the client's scopes. `hivemind` users
  see it after login. This is correct OAuth behaviour, not a misconfiguration.
- **Bundled Keycloak runs a single replica.** Clustering it means configuring
  jgroups discovery; `keycloak.replicas > 1` is not wired up.
- **Users need first and last name.** Keycloak forces an "Update Account
  Information" step otherwise, which stalls the device flow. Self-registration
  collects both; users created through the admin API must set them too.
- **Pool sizing needs review per customer.** Requests are 2Gi/0.5cpu but limits
  are 32Gi/8cpu, and the tail genuinely reaches it. Nodes must be able to
  schedule a pod at the limit.

The chart has no remote dependencies and renders with no network access.
