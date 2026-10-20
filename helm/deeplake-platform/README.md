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
  --version 0.1.1 \
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
edit clients in the admin console after that, not by reinstalling.

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
