# Installing deeplake-platform

Written against a from-scratch install on AKS. Commands are Azure; AWS and GCP
differences are called out inline.

## What you need first

- Kubernetes 1.29+, `helm` 3.12+, `kubectl`
- An object-storage container the cluster can write to
- A cloud identity federated to the cluster's service account (step 2 — the
  step most installs get wrong)
- An ingress controller, or set `ingress-nginx.enabled=true` to get one
- DNS for three hostnames, and cert-manager if you want automatic TLS
- Pull access to `quay.io/activeloopai`

Three components are optional and off by default. Enable them if you do not
already run your own: `global.postgres.enabled` (control-plane metadata),
`global.keycloak.enabled` (identity), `ingress-nginx.enabled`.

OpenFGA is **required and not bundled**. Supply your own and point
`global.openfga.url` at it, or deploy one through `extraManifestsRaw` (see
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

## 3. Secrets

The chart never creates credentials. Create these before installing.

```bash
kubectl create namespace $NS

kubectl -n $NS create secret generic deeplake-api-secrets \
  --from-literal=DB_PASSWORD='<control-plane db password>' \
  --from-literal=JWT_SECRET='<random 32+ bytes>'

kubectl -n $NS create secret generic deeplake-dlpg-superuser \
  --from-literal=password='<pg-deeplake superuser password>'

# only when global.keycloak.enabled
kubectl -n $NS create secret generic deeplake-keycloak-admin \
  --from-literal=username=admin \
  --from-literal=password='<keycloak admin password>'

kubectl -n $NS create secret docker-registry regcred-quay \
  --docker-server=quay.io --docker-username='<user>' --docker-password='<token>'
```

| Secret | Keys | Referenced by |
|---|---|---|
| `deeplake-api-secrets` | `DB_PASSWORD`, `JWT_SECRET`, optional `CREDENTIALS_ENCRYPTION_KEY` | `global.secrets.api` |
| `deeplake-dlpg-superuser` | `password` | `global.secrets.dlpg` |
| `deeplake-keycloak-admin` | `username`, `password` | `global.keycloak.adminSecret` |

`deeplake-openfga-ids` is created for you by the bootstrap Job — do not create
it by hand.

## 4. DNS

Three names must resolve to your ingress. With `global.domain=deeplake.example.com`:

```
deeplake.example.com      ->  <ingress IP>
api.deeplake.example.com  ->  <ingress IP>
kc.deeplake.example.com   ->  <ingress IP>   # only with bundled Keycloak
```

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
    url: "http://dl-openfga:8080"
```

Two things that are easy to miss with the bundled Postgres: `global.database.host`
is required and does **not** default to the bundled service, and `sslMode`
defaults to `require`, which the bundled Postgres does not offer.

Pin image tags per release. Until deeplake-api #307 and deeplake-ui #330 merge,
use branch builds — `main` images do not understand the `OIDC_*` contract and
start with authentication disabled (`Auth0 not configured`). See
`test/example-values.yaml` for current tags.

## 6. Install

```bash
helm install $RELEASE . -n $NS -f values-azure.yaml -f my-values.yaml --timeout 12m
```

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
| API crash-loops on `failed to resolve OIDC endpoints` | Keycloak hostname does not resolve in-cluster | Step 4, then restart the API |
| `Auth0 not configured - authentication disabled` | API image predates the `OIDC_*` contract | Use a branch build |
| Migration Job: `no such host` for the database | External database not reachable, or `global.database.host` unset | Step 5 |
| Postgres pod: `data directory has wrong ownership` | Missing `prepare-pgdata` init container | Upgrade the chart |
| `Organization ID is required` (400) | No org context on the request | Send `X-Activeloop-Org-Id` |
| Login lands on "Update Account Information" | User has no first/last name | Set both; self-registration collects them |

## Appendix: OpenFGA

The chart creates the store and authorization model but does not deploy the
server. Point `global.openfga.url` at your own, or deploy one in the release:

```yaml
global:
  openfga:
    url: "http://dl-openfga:8080"

extraManifestsRaw:
  - |
    apiVersion: apps/v1
    kind: Deployment
    metadata:
      name: {{ .Release.Name }}-openfga
    # ... datastore pointed at your Postgres, OPENFGA_AUTHN_METHOD=preshared
```

`extraManifestsRaw` entries are templated, so `{{ .Release.Name }}` works.

Store and model IDs are ULIDs generated at creation time and cannot be pinned,
so a Job creates them and writes both into the Secret named by
`global.openfga.bootstrap.secretName`. The Job is idempotent on that Secret: if
it already holds a store ID the Job exits without doing anything. Re-running
after wiping OpenFGA's database means deleting that Secret first, and a chart
upgrade carrying a changed model does not re-apply it.
