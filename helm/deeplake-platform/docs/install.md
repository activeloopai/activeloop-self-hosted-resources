# Installing deeplake-platform

Written against a from-scratch install on AKS. Commands are Azure; AWS and GCP
differences are called out inline.

## What you need first

- Kubernetes 1.29+, `helm` 3.12+, `kubectl`
- An object-storage container the cluster can write to
- A cloud identity federated to the cluster's service account (step 2 — the
  step most installs get wrong), or a static key for an S3-compatible endpoint
  (step 2c)
- An ingress controller, or set `ingress-nginx.enabled=true` to get one
- DNS for three hostnames, and cert-manager if you want automatic TLS
- Credentials for `quay.io/activeloopai/deeplake-api` (the only private image;
  the chart and every other image pull anonymously)

Three components are optional and off by default. Enable them if you do not
already run your own: `global.postgres.enabled` (control-plane metadata),
`global.keycloak.enabled` (identity), `ingress-nginx.enabled`.

OpenFGA is **required**. Either set `global.openfga.enabled=true` to run the
bundled one, or point `global.openfga.url` at your own (see
[Appendix: OpenFGA](#appendix-openfga)).

Throughout, `RELEASE=dl` and `NS=deeplake`. The service account the platform
runs as is `$RELEASE-workload`.

## 1. Object storage

```bash
az storage container create --name deeplake --account-name <account> --auth-mode login
```

The root path must match `global.cloud`: `az://<account>/<container>/<prefix>`,
`s3://<bucket>/<prefix>`, or `gs://<bucket>/<prefix>`. A mismatch fails at
template time rather than at runtime.

## 2. Workload identity

Get this wrong and the symptom is severe and non-obvious: `pg_deeplake` aborts
the Postgres backend with signal 6 on the first statement that touches storage,
taking the whole cluster through crash recovery. The pod looks healthy and the
`AZURE_*` environment variables are present — only the token exchange fails.

Grant the identity **Storage Blob Data Contributor** on the container, then
federate it to the service account this release will create:

```bash
ISSUER=$(az aks show -n <cluster> -g <rg> --query oidcIssuerProfile.issuerUrl -o tsv)

az identity federated-credential create \
  --name deeplake-workload \
  --identity-name <identity> -g <rg> \
  --issuer "$ISSUER" \
  --subject "system:serviceaccount:${NS}:${RELEASE}-workload" \
  --audience api://AzureADTokenExchange
```

The subject must match the namespace and release name exactly. If you override
`global.serviceAccount.name`, use that name instead of `$RELEASE-workload`.

On AWS this is an IRSA trust policy for the same subject and
`global.workloadIdentity.aws.roleArn`; on GCP a Workload Identity binding and
`global.workloadIdentity.gcp.serviceAccount`.

To verify after installing:

```bash
kubectl -n $NS exec deploy/$RELEASE-pool -c postgres -- \
  sh -c 'dlstorage list_dirs "$DEEPLAKE_ROOT_PATH"'
```

Exit 0 means the credential chain works. `Failed to get token from
ChainedTokenCredential` means the federated credential is missing or its
subject does not match.

## 2c. S3-compatible storage instead (`global.cloud: s3`)

For a cluster whose object storage is not one of the three clouds — Ceph RGW,
MinIO, or a research platform such as NRP Nautilus — skip step 2 entirely.
There is no identity to federate: the pods authenticate to the endpoint with a
static access key, and the chart refuses to render with
`global.workloadIdentity.enabled=true`.

Create the key Secret before installing:

```bash
kubectl -n $NS create secret generic deeplake-s3-credentials \
  --from-literal=accessKeyId='<access key>' \
  --from-literal=secretAccessKey='<secret key>'
```

Then start from `values-s3.yaml`. It has no ingress or StorageClass defaults,
because a generic cluster has none the chart can assume, so both must be named.
An NRP Nautilus install, with the bundled Postgres, Keycloak and OpenFGA, looks
like this:

```yaml
global:
  cloud: s3
  domain: deeplake.nrp-nautilus.io
  imagePullSecrets: [regcred-quay]

  storage:
    rootPath: "s3://<bucket>/deeplake/"
    s3:
      endpoint: http://rook-ceph-rgw-nautiluss3.rook   # west pool, in-cluster
      region: us-east-1
      credentialsSecret: deeplake-s3-credentials

  workloadIdentity:
    enabled: false

  ingress:
    className: haproxy
    tls:
      enabled: true
      controllerDefault: true   # the controller holds *.nrp-nautilus.io

  storageClass: rook-ceph-block

  auth:
    audience: "https://api.deeplake.nrp-nautilus.io"
  keycloak:
    enabled: true
  postgres:
    enabled: true
  database:
    host: dl-postgres
    user: postgres
    sslMode: disable
  openfga:
    enabled: true
    tokenSecret: deeplake-fga-token
```

Notes for this mode:

- The endpoint is used by `deeplake-api` (as `S3_ENDPOINT_URL`) and by the
  pg-deeplake pods (as `AWS_ENDPOINT_URL`), so it must resolve from inside the
  cluster. Prefer the in-cluster endpoint over a public one: shorter path, and
  no load balancer in between.
- `region` is sent in the request signature. Ceph and MinIO accept any value;
  keep `us-east-1` unless the endpoint documents otherwise.
- `tls.controllerDefault: true` lists the hostnames under `tls:` without a
  secret, so the controller serves its own certificate. On NRP that is the
  `*.nrp-nautilus.io` wildcard. On other clusters leave it false and let
  cert-manager issue one via the annotations.
- Ceph RGW older than 20.x (Tentacle) rejects `If-Match` with a quoted ETag,
  which pg-deeplake uses for its commit protocol. On such a gateway the first
  login hangs for minutes and the pool logs `CAS DDL seq claim failed (ETag
  mismatch: __wal_seq_counter)`. Ask the storage admins for the Ceph version
  before installing.

To verify storage access after installing, run the same `dlstorage list_dirs`
check as in step 2; `InvalidAccessKeyId` or `SignatureDoesNotMatch` means the
Secret holds the wrong key, `connection refused` or `no such host` means the
endpoint is not reachable from the pods.

## 2b. Your own Postgres (skip if using the bundled one)

Create the databases first. The migration job creates `deeplake` if missing,
but Keycloak and OpenFGA do not create theirs:

```bash
az postgres flexible-server db create -g <rg> -s <server> -n deeplake
az postgres flexible-server db create -g <rg> -s <server> -n keycloak
az postgres flexible-server db create -g <rg> -s <server> -n openfga
```

Then point `global.database` at the server and leave `global.postgres.enabled`
false. Verified against Azure Database for PostgreSQL 16 with `sslMode: require`.

## 3. Secrets

The chart never creates credentials. Create these before installing.

```bash
kubectl create namespace $NS

kubectl -n $NS create secret generic deeplake-api-secrets \
  --from-literal=DB_PASSWORD='<control-plane db password>' \
  --from-literal=JWT_SECRET='<random 32+ bytes>' \
  --from-literal=CREDENTIALS_ENCRYPTION_KEY='<random 32 bytes, base64>'

kubectl -n $NS create secret generic deeplake-dlpg-superuser \
  --from-literal=password='<pg-deeplake superuser password>'

# only when global.keycloak.enabled
kubectl -n $NS create secret generic deeplake-keycloak-admin \
  --from-literal=username=admin \
  --from-literal=password='<keycloak admin password>'

# only when global.openfga.tokenSecret is set
kubectl -n $NS create secret generic deeplake-fga-token \
  --from-literal=token='<random 32+ bytes>'

# pull secret for deeplake-api, the one private image
kubectl -n $NS create secret docker-registry regcred-quay \
  --docker-server=quay.io --docker-username='<user>' --docker-password='<token>'
```

| Secret | Keys | Referenced by |
|---|---|---|
| `deeplake-api-secrets` | `DB_PASSWORD`, `JWT_SECRET`, `CREDENTIALS_ENCRYPTION_KEY` | `global.secrets.api` |
| `deeplake-dlpg-superuser` | `password` | `global.secrets.dlpg` |
| `deeplake-keycloak-admin` | `username`, `password` | `global.keycloak.adminSecret` |
| `deeplake-fga-token` | `token` | `global.openfga.tokenSecret` |
| `regcred-quay` | docker config | `global.imagePullSecrets` |

`deeplake-openfga-ids` is created for you by the bootstrap Job — do not create
it by hand.

## 3b. Registries and egress

A minimal install — your own Postgres, identity provider, OpenFGA and ingress —
needs **`quay.io` only**. The optional bundled components add registries:

| Registry | Images | Needed when |
|---|---|---|
| `quay.io` | deeplake-api, deeplake-ui, pg-deeplake-stateless, pg-proxy, curl, keycloak | always |
| `docker.io` | `postgres`, `openfga/openfga` | bundled Postgres / OpenFGA |
| `registry.k8s.io` | ingress-nginx | bundled ingress |

Only `deeplake-api` needs credentials; everything else pulls anonymously.

Docker Hub rate-limits anonymous pulls per source IP, so a cluster behind one
NAT can hit `toomanyrequests` during install. To pull those from a mirror
instead, override each image individually — `global.imageRegistry` only applies
to the Activeloop images:

```yaml
global:
  imageRegistry: mirror.example.com          # activeloopai images
  openfga:
    bootstrap:
      image: mirror.example.com/curl/curl:8.21.0
postgres:
  image: mirror.example.com/postgres:18
openfga:
  image: mirror.example.com/openfga/openfga:v1.8.0
keycloak:
  image: mirror.example.com/keycloak/keycloak:26.7.0
```

## 4. DNS

Three names must resolve to your ingress. With `global.domain=deeplake.example.com`:

```
deeplake.example.com      ->  <ingress IP>
api.deeplake.example.com  ->  <ingress IP>
kc.deeplake.example.com   ->  <ingress IP>   # only with bundled Keycloak
```

The OIDC issuer must be **HTTPS**. The API refuses an HTTP device-authorization
URL (`device authorization URL must use HTTPS, not HTTP`), so an install with
`global.ingress.enabled=false` cannot use the bundled Keycloak over plain HTTP —
terminate TLS somewhere, or point `global.auth.issuerUrl` at an existing HTTPS
provider.

The Keycloak hostname must also resolve **from inside the cluster**. The API
fetches the OIDC discovery document over that public hostname and crash-loops
until it succeeds; it resolves endpoints once at startup and does not retry in
place. On split-horizon DNS, make sure the in-cluster view resolves it too.

## 5. Values

```yaml
global:
  cloud: azure
  domain: deeplake.example.com
  imagePullSecrets: [regcred-quay]

  storage:
    rootPath: "az://<account>/deeplake/"

  workloadIdentity:
    enabled: true
    azure:
      clientId: "<managed identity client id>"
      tenantId: "<tenant id>"

  ingress:
    enabled: true
    annotations:
      cert-manager.io/cluster-issuer: letsencrypt-prod
    tls:
      enabled: true

  auth:
    provider: oidc
    issuerUrl: ""                                   # derived when Keycloak is bundled
    audience: "https://api.deeplake.example.com"

  keycloak:
    enabled: true
  postgres:
    enabled: true

  database:
    host: dl-postgres                               # the bundled service
    user: postgres
    sslMode: disable                                # bundled Postgres has no TLS

  openfga:
    enabled: true
    tokenSecret: deeplake-fga-token                  # Secret with key `token`
```

Two things are easy to miss with the bundled Postgres: `global.database.host`
is required and does **not** default to the bundled service, and `sslMode`
defaults to `require`, which the bundled Postgres does not offer — the chart
refuses to render rather than let that fail at runtime.

Image tags are pinned by the chart — the platform release sets them together,
so you do not normally override them. `test/example-values.yaml` shows the
current set.

## 6. Install

```bash
helm install $RELEASE oci://quay.io/activeloopai/charts/deeplake-platform \
  --version 0.1.3 -n $NS \
  -f values-azure.yaml -f my-values.yaml --timeout 12m
```

`values-azure.yaml` ships inside the chart. To use it as a file, pull the chart
first (`helm pull oci://quay.io/activeloopai/charts/deeplake-platform --version
0.1.3 --untar`) and install from the extracted directory, or set the same keys
in your own values file.

Order is handled for you: with the bundled Postgres the migration Job becomes a
post-install hook and waits for the database; with an external database it stays
a pre-install hook and runs before anything serves.

## 7. Verify

```bash
kubectl -n $NS get pods                    # all Running, no restarts
kubectl -n $NS logs job/$RELEASE-migrate   # Complete
kubectl -n $NS logs job/$RELEASE-fga-bootstrap
kubectl -n $NS logs deploy/$RELEASE-keycloak | grep "imported"
```

Expect `store=... model=...` from the bootstrap Job and `Realm 'deeplake'
imported` from Keycloak.

The API log should show all of these. Any one missing means auth is not fully
wired:

```
OIDC validator initialized
device flow service initialized (CLI authentication enabled)
Organization service initialized
Workspace service initialized
```

Then check the endpoints:

```bash
curl -s -o /dev/null -w '%{http_code}\n' https://kc.deeplake.example.com/realms/deeplake/.well-known/openid-configuration
curl -s -o /dev/null -w '%{http_code}\n' https://api.deeplake.example.com/health
```

Finally, log in through the UI, or exercise the CLI path end to end:

```bash
curl -sX POST https://api.deeplake.example.com/auth/device/code -H 'Content-Type: application/json' -d '{}'
# open verification_uri_complete, sign in, approve the device
curl -sX POST https://api.deeplake.example.com/auth/device/token -H 'Content-Type: application/json' \
  -d '{"device_code":"<device_code>"}'
```

The issued token's `aud` must contain `global.auth.audience`. Device codes are
single-use — a second poll after a successful exchange returns nothing.

API calls need an organization: pass `X-Activeloop-Org-Id` (from `/me`), an
`org_id` query parameter, or use an API token.

## Troubleshooting

| Symptom | Cause | Fix |
|---|---|---|
| Backend killed by signal 6, cluster enters recovery | Federated credential missing or subject mismatch | Step 2 |
| `cloud: s3`: first login hangs, pool logs `CAS DDL seq claim failed (ETag mismatch)` | Ceph RGW older than 20.x rejects quoted `If-Match` | Step 2c; upgrade the gateway |
| `cloud: s3`: `InvalidAccessKeyId` / `SignatureDoesNotMatch` | Wrong key in `global.storage.s3.credentialsSecret`, or the key is for another pool | Step 2c |
| API crash-loops on `failed to resolve OIDC endpoints` | Keycloak hostname does not resolve in-cluster | Step 4, then restart the API |
| `Auth0 not configured - authentication disabled` | API image predates the OIDC merge (19 Aug) | Use chart 0.1.1 or newer, which pins a current image |
| Migration Job: `no such host` for the database | External database not reachable, or `global.database.host` unset | Step 5 |
| Postgres pod: `data directory has wrong ownership` | Missing `prepare-pgdata` init container | Upgrade the chart |
| `Organization ID is required` (400) | No org context on the request | Send `X-Activeloop-Org-Id` |
| Login lands on "Update Account Information" | User has no first/last name | Set both; self-registration collects them |
| `503 workspace seeding is not configured` | Seeding is S3-only upstream | Expected off S3; the feature is unused elsewhere |
| Managed credentials / repositories disabled | `CREDENTIALS_ENCRYPTION_KEY` missing | Step 3 |
| `relation 'workspace#blocked'` (or `#admin`, `#writer`, `#viewer`) not found | Store still on a model older than the API | `helm upgrade` writes the current model (pre-upgrade hook); check the `*-fga-bootstrap` Job logs |
| `device authorization URL must use HTTPS` | HTTP issuer | Use an HTTPS issuer; see step 4 |
| API crash-loops, Keycloak host unresolvable, ingress disabled | Issuer derives to a public host with no DNS | Set `global.auth.issuerUrl`, or enable ingress |
| Keycloak or OpenFGA cannot connect to an external DB | Their databases were never created | See step 3 |

## Appendix: OpenFGA

`deeplake-api` will not serve requests without OpenFGA. Two options:

**Bundled** — `global.openfga.enabled=true`. Runs a single replica against the
same Postgres as the rest of the platform (database `openfga`, created by the
bundled Postgres init or by you). Set `global.openfga.tokenSecret` to require a
preshared key; leave it empty only for in-cluster trials.

**Your own** — leave it disabled and set `global.openfga.url`. If it requires a
token, point `global.openfga.tokenSecret` at a Secret with key `token`.

Either way the chart creates the store and authorization model. Store and model
IDs are ULIDs generated at creation time and cannot be pinned, so a post-install
Job creates them and writes both into the Secret named by
`global.openfga.bootstrap.secretName`, which `deeplake-api` reads.

The Job runs on install and, as a `pre-upgrade` hook, on every `helm upgrade`,
so a new authorization model is in the store and its id in the Secret before
the new API pods start. It is idempotent: it records the SHA-256 of the model
it wrote in the Secret (`FGA_MODEL_SHA256`) and does nothing when that matches
the model the chart ships. For an existing store it only adds a model version,
so tuples stay valid and the previous API keeps working. Upgrading is just:

```sh
helm upgrade <release> <chart> -n <ns> -f values.yaml   # model first (hook), then API
```

Pods read the model id when they start, so when the Job writes a new model it
also restarts the API server and worker Deployments (a pod-template annotation
patch; skipped for Deployments that do not exist yet). On an upgrade that also
changes the API image the pods may roll once before Helm rolls them again.
To start from an empty OpenFGA database, delete the
Secret first so the Job creates a new store.
