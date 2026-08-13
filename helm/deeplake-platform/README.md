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
└── charts/
    ├── deeplake-common/    # library chart — shared helpers, renders nothing
    ├── deeplake-api/       # api-server, api-worker, migration hook
    ├── deeplake-ui/        # Next.js UI + runtime config
    └── dlpg/               # pg-proxy, stateless pool, indexer
```

## Install

```bash
helm install deeplake oci://quay.io/activeloopai/charts/deeplake-platform \
  --version 0.1.0 \
  --namespace deeplake --create-namespace \
  -f values-azure.yaml \
  -f my-values.yaml
```

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

**The chart never creates a secret.** You supply Secret names via
`global.secrets.*`. Generate them yourself or sync them with External Secrets
Operator from Key Vault / Secrets Manager / Secret Manager.

**No SaaS by default.** Stripe, PostHog, Resend, and the hosted embedding
endpoints are all off or empty. A fresh install makes no outbound calls to
Activeloop infrastructure.

## Known gaps

These are real, and tracked rather than hidden.

- **Depends on two unmerged PRs**: deeplake-api #307 (generic `OIDC_*` config
  with Auth0 back-compat) and deeplake-ui #330 (auth adapters, runtime public
  env, distroless Dockerfile). This chart targets those contracts, so it will
  not work against `main` until both land. Specifically it needs `OIDC_ISSUER`
  on the API, and on the UI the `AUTH_PROVIDER`/`OIDC_*` server config plus
  plain-name runtime env (`API_BASE_URL`) — none of which exist on `main`.
- **`deeplake-ui` image must be published.** PR #330 adds the Dockerfile
  (distroless, port 3000, uid 65532) but no CI job pushes it yet. Set
  `deeplake-ui.image.tag` once `quay.io/activeloopai/deeplake-ui` has one.
- **`NEXT_PUBLIC_SITE_URL` is build-time only.** It is not in the
  runtime-overridable key set in `app/lib/env/publicEnv.ts`, so a per-customer
  site URL still needs `--build-arg` at image build. Everything else the chart
  sets is runtime-overridable.
- **`dlpg.proxy.snapshotRestoreOnClaim` must stay `false` on Azure and GCP.**
  `dlsnap` (`indra/postgres/dlsnap/main.go`) only parses `s3://` and only links
  the AWS SDK. With a non-S3 root the entrypoint guard fails and every org claim
  pays a full catalog rebuild instead of a snapshot restore. Correct, but slow.
- **`dlpg.pgPilot` requires Kubernetes ≥ 1.33** with `InPlacePodVerticalScaling`
  for the `pods/resize` subresource. Off by default; verify before enabling.
- **Pool sizing needs review per customer.** Requests are 2Gi/0.5cpu but limits
  are 32Gi/8cpu, and the tail genuinely reaches it. Nodes must be able to
  schedule a pod at the limit.

## Development

```bash
helm lint . -f values-azure.yaml -f test/example-values.yaml
helm template deeplake . -f values-azure.yaml -f test/example-values.yaml
```

The chart has no remote dependencies and renders with no network access.
