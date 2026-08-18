# deeplake-platform

Helm chart for self-hosted Deep Lake. Installs the control-plane API, the web
UI, and the pg-deeplake data plane into a customer's own Kubernetes cluster.

Azure/AKS is the primary target; AWS/EKS and GCP/GKE share the same chart via
`global.cloud`.

## Layout

```
deeplake-platform/
├── Chart.yaml              # chart version IS the platform release
├── values.yaml             # the customer-facing contract (everything is under `global`)
├── values-azure.yaml       # per-cloud overlays
├── values-aws.yaml
├── values-gcp.yaml
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
helm registry login quay.io          # the chart and images are private
helm install deeplake oci://quay.io/activeloopai/charts/deeplake-platform \
  --version 0.1.0-rc.1 \
  --namespace deeplake --create-namespace \
  -f values-azure.yaml \
  -f my-values.yaml
```

Published as a release candidate while deeplake-api #307 and deeplake-ui #330
are unmerged — the pinned images are built from those branches. 0.1.0 follows
once they land and the images are rebuilt from `main`.

Workload identity is the step to get right: a missing or mismatched federated
credential makes `pg_deeplake` abort the Postgres backend on the first
storage-touching statement, rather than returning an error.

## Design decisions worth knowing

**The chart version pins all three components together.** `deeplake-api` and
`pg-deeplake` call each other — pg_deeplake hits the API's
`workspace_storage_resolver`/`creds_key_resolver` on every connection. Letting a
customer bump one image independently produces a broken cluster, so component
image tags are set by the release, not by the customer.

**One ServiceAccount, created at the umbrella level.** `deeplake-api` and the
dlpg pool share `<release>-workload`; only pg-proxy gets its own (it needs K8s
API access but no cloud identity). Subcharts reference it by name and never
create their own — this is what keeps two subcharts from fighting over the same
object.

**One Ingress for the whole platform.** On AWS and Azure an Ingress provisions a
real load balancer. Two Ingress objects means two of them, and the grouping
annotations that would prevent it are cloud-specific.

**The cloud delta lives in one file.** `charts/deeplake-common/templates/_cloud.tpl`
plus the `values-<cloud>.yaml` overlays. It covers workload-identity wiring,
storage URL scheme, ingress class, and StorageClass. Do not fork the chart per
cloud.

**Identity is bring-your-own, with Keycloak as a convenience.** Any OIDC
provider works — set `global.auth.issuerUrl` and the two client IDs. For
customers without one, `global.keycloak.enabled=true` deploys Keycloak and
imports a realm with both clients preconfigured (UI client with PKCE, CLI client
with the device grant, and the audience mapper the API's token validation
depends on). `global.auth.issuerUrl` is then derived and can stay empty; setting
it explicitly always wins, so you can bundle Keycloak and still point the
platform elsewhere.

The realm ConfigMap renders whether or not Keycloak is bundled, so a customer
running their own Keycloak can import the same realm:

```bash
kubectl get cm <release>-keycloak-realm -o jsonpath='{.data.realm\.json}' > realm.json
# then: admin console -> Create realm -> Browse -> realm.json
```

Import happens once, at first startup, and skips a realm that already exists —
edit clients in the admin console after that, not by reinstalling.

**The chart never creates a secret.** You supply Secret names via
`global.secrets.*`. Generate them yourself or sync them with External Secrets
Operator from Key Vault / Secrets Manager / Secret Manager.

**No SaaS by default.** Stripe, PostHog, Resend, and the hosted embedding
endpoints are all off or empty. A fresh install makes no outbound calls to
Activeloop infrastructure.

## Known gaps

These are real, and tracked rather than hidden.

- **The UI's "ingest COCO dataset" button cannot work off S3.** `deeplake-api`
  only derives the signup seed source when `DEEPLAKE_ROOT_DIR` starts with
  `s3://` (`cmd/server/main.go`), so on Azure and GCP the seeder is never
  constructed and the endpoint returns 503. The copier itself is multi-cloud;
  only the default derivation is S3-gated. The prebuilt dataset it copies from
  (`<root>/_signup_seeds/`) is also operator-hosted content that no self-hosted
  install has. Seeding is otherwise unused — user provisioning never calls it.
- **"Ask AI" query suggestion needs `OPENAI_API_KEY`.** Not set by the chart;
  the endpoint 404s without it. Billing endpoints 404 by design.
- **The OpenFGA model is behind the API.** `deeplake-api` checks
  `workspace#blocked` and `workspace#admin`, which the shipped model does not
  define, so those checks fail as warnings and the request proceeds. The model
  in `files/` is byte-identical to the one running in both Activeloop beta and
  prod, and prod logs the same warnings — this is platform-wide, not a
  packaging error. A chart upgrade carrying a changed model does not re-apply
  it: the bootstrap Job short-circuits on the existing Secret.

- **Depends on two unmerged PRs**: deeplake-api #307 (generic `OIDC_*` config
  with Auth0 back-compat) and deeplake-ui #330 (auth adapters, runtime public
  env, distroless Dockerfile). This chart targets those contracts, so it will
  not work against `main` until both land. Specifically it needs `OIDC_ISSUER`
  on the API, and on the UI the `AUTH_PROVIDER`/`OIDC_*` server config plus
  plain-name runtime env (`API_BASE_URL`) — none of which exist on `main`.
- **`deeplake-ui` images are built from the PR branch, not `main`.** The newest
  tag is `v0.44.0-3f291307` (PR #330 head, multi-arch). Anything built from
  `main` lacks the runtime env contract this chart sets.
- **`NEXT_PUBLIC_SITE_URL` is build-time only.** It is not in the
  runtime-overridable key set in `app/lib/env/publicEnv.ts`, so a per-customer
  site URL still needs `--build-arg` at image build. Everything else the chart
  sets is runtime-overridable.
- **`dlpg.proxy.snapshotRestoreOnClaim` defaults to `false`, but no longer for
  cloud reasons.** `dlsnap` was S3-only; it was replaced by `dlstorage`
  (`indra/cpp/dlstorage`) in `1879baf1a`, which speaks `s3://`, `az://`, `gs://`
  and local paths through the same storage layer as the extension. Verified on
  Azure: `dlstorage list_dirs az://…` succeeds from a 4.7.1 pool pod. It stays
  off by default because re-enabling has its own operational gate — see
  `indra/postgres/FINDINGS_restore_on_claim_reenable.md`. Requires a pool image
  at 4.7.1 or newer.
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

## Development

```bash
helm lint . -f values-azure.yaml -f test/example-values.yaml
helm template deeplake . -f values-azure.yaml -f test/example-values.yaml
```

The chart has no remote dependencies and renders with no network access.
