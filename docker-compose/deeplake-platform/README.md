# Deep Lake self-hosted stack

Single-host Docker Compose deployment of [Deeplake](http://deeplake.ai/) with:
  - [Keycloak](https://www.keycloak.org/) as identity provider
  - [OpenFGA](https://openfga.dev/) for authorization
  - Postgres for dependency services
  - pluggable object storage, selected with `STORAGE_TYPE`: an in-stack
    S3-compatible store ([Alarik](https://alarik.io/) or
    [Garage](https://garagehq.deuxfleurs.fr/)), or external storage on Amazon
    S3, Azure Blob Storage, or any S3-compatible endpoint
  - [Caddy](https://caddyserver.com/docs/) as the TLS-terminating reverse proxy.

`dl-stack.sh` is the installer: it generates all secrets, merges the shared
`compose/compose-base.yaml` with the overlay for the selected storage type into
`~/.local/deeplake/compose.yaml`, bootstraps the OpenFGA store and
authorization model, and then starts the stack.

First pull the `dl-stack.sh`:

```bash
curl -fsSL https://raw.githubusercontent.com/activeloopai/activeloop-self-hosted-resources/refs/heads/main/docker-compose/deeplake-platform/dl-stack.sh -o dl-stack.sh && chmod +x dl-stack.sh
```

## What gets deployed

| Service | Container | Public URL |
| --- | --- | --- |
| Deep Lake UI | `dl-deeplake-ui` | `https://app.$BASE_HOST` |
| Deep Lake API | `dl-deeplake-api` | `https://api.$BASE_HOST` |
| Deep Lake worker / setup / indexer | `dl-deeplake-*` | internal |
| Deep Lake stateless nodes | `dl-deeplake-stateless-1` … `-N` | internal |
| Keycloak | `dl-keycloak` | `https://kc.$BASE_HOST` |
| OpenFGA | `dl-openfga` | `https://openfga.$BASE_HOST` |
| Object storage API (`alarik`, `garage`) | `dl-storage-api` | `https://storage-api.$BASE_HOST` |
| Object storage console (`alarik` only) | `dl-storage-ui` | `https://storage.$BASE_HOST` |
| Postgres (shared) | `dl-postgres` | internal, plus `127.0.0.1:5432` on the host |
| pg-proxy (Deep Lake PG endpoint) | `dl-pg-proxy` | internal |
| Caddy | `dl-caddy` | `:80`, `:443` |

Caddy publishes **only** 80 and 443. Postgres is additionally bound to the host
loopback (`127.0.0.1:5432`) for local `psql` access - it is not reachable off
the host. This is the shared control-plane database (Keycloak users, OpenFGA
tuples, Deep Lake metadata); do not widen that binding to `0.0.0.0`.

Data lives in named Docker volumes: `dl_deeplake_postgres`,
`dl_deeplake_indexer`, `dl_deeplake_caddy`, one per stateless node
(`dl_deeplake_stateless`, then `dl_deeplake_stateless_2` and up), plus the
object storage volumes of the selected backend - `dl_deeplake_storage` for
`alarik`, `dl_deeplake_storage_meta` and `dl_deeplake_storage_data` for
`garage`, none for the external backends.

## Storage backends

`STORAGE_TYPE` picks where Deep Lake keeps its data, and with it which overlay
in `compose/` gets applied. The stack itself lives once in
`compose/compose-base.yaml`; each backend adds a small `storage-<type>.yaml`
carrying only what is particular to it - the storage settings for the Deep Lake
containers, plus any storage service, volume and Caddy vhost of its own.
`dl-stack.sh` fetches those two files and merges them with `docker compose
config`, so a checkout is not needed - only the script itself.

Compose merges the overlay's `environment` entries into the services the base
defines. YAML anchors do not cross files, so each overlay declares its own
`x-storage-api-env` / `x-storage-env` anchors rather than reusing the base's.

### In-stack backends

`alarik` and `garage` run an S3-compatible store as part of the stack: they
publish the same S3 API at `https://storage-api.$BASE_HOST`, serve the
`deeplake-storage` bucket path-style, and are addressed with the generated
`STORAGE_ACCESS_KEY` / `STORAGE_SECRET_KEY` pair. Nothing to supply - `setup`
generates the credentials and prints them once.

| | `alarik` | `garage` |
| --- | --- | --- |
| Overlay | `compose/storage-alarik.yaml` | `compose/storage-garage.yaml` |
| Image | `ghcr.io/achtungsoftware/alarik` | `dxflrs/garage:v2.3.0` |
| Web console | yes, at `https://storage.$BASE_HOST` | none |
| Extra DNS records | `storage`, `storage-api` | `storage-api` |
| Volumes | `dl_deeplake_storage` | `dl_deeplake_storage_meta`, `dl_deeplake_storage_data` |

`garage` runs as a single node (`--single-node`, `replication_factor = 1`,
sqlite metadata engine) and creates the bucket and access key on first boot from
`GARAGE_DEFAULT_*`; restarts reuse them. Its `root_domain` is deliberately left
unset, so buckets are only reachable path-style - vhost-style addressing would
put them on `<bucket>.storage-api.$BASE_HOST`, which neither a `*.$BASE_HOST`
record nor an `http01` certificate covers.

### External backends

`aws`, `azure` and `external-s3` run no storage service at all - Deep Lake
talks to a bucket or container you already own. They need no `storage` or
`storage-api` DNS record, create no storage volumes, and `setup` only collects
the settings that reach the storage.

| | `aws` | `azure` | `external-s3` |
| --- | --- | --- | --- |
| Overlay | `compose/storage-aws.yaml` | `compose/storage-azure.yaml` | `compose/storage-external-s3.yaml` |
| Storage | an Amazon S3 bucket | an Azure Blob Storage container | any S3-compatible endpoint (MinIO, Ceph, Wasabi, ...) |
| Console | the AWS console | the Azure portal | whatever the endpoint provides |
| You must supply | `DEEPLAKE_ROOT_PATH`, `AWS_REGION`, and `AWS_ACCESS_KEY_ID` / `AWS_SECRET_ACCESS_KEY` unless the host already has S3 access | `DEEPLAKE_ROOT_PATH`, `AZURE_TENANT_ID`, `AZURE_CLIENT_ID`, `AZURE_CLIENT_SECRET` | `DEEPLAKE_ROOT_PATH`, `S3_ENDPOINT_URL`, `S3_REGION`, `S3_ACCESS_KEY`, `S3_SECRET_KEY` |

All three need storage that already exists, plus a way to reach it: an IAM
access key for `aws`, a service principal for `azure`, an access key/secret
pair for `external-s3`. `DEEPLAKE_ROOT_PATH` is the storage root in
the form the Helm chart uses, and `setup` rejects a root path whose scheme does
not match the backend:

| `STORAGE_TYPE` | `DEEPLAKE_ROOT_PATH` |
| --- | --- |
| `aws` | `s3://<bucket>/<prefix>` |
| `azure` | `az://<account>/<container>/<prefix>` |
| `external-s3` | `s3://<bucket>/<prefix>` |

For `aws` the key pair is optional. If the host is already authorized to reach
S3 - an EC2 instance profile, for instance - leave `AWS_ACCESS_KEY_ID` unset and
press enter at its prompt, and `setup` removes `AWS_ACCESS_KEY_ID` and
`AWS_SECRET_ACCESS_KEY` from the rendered compose file entirely rather than
writing them as empty strings, which would otherwise stop the AWS SDK from
looking for credentials on its own. Give the access key and the secret becomes
required. `AWS_REGION` and `DEEPLAKE_ROOT_PATH` are always required.

`external-s3` differs from `aws` only in that the endpoint is yours rather than
Amazon's, so it fills the same two environment blocks the in-stack backends
fill: `deeplake-api` reads the `S3_*` names, the `pg-deeplake` containers read
the `AWS_*` ones, and the storage root appears as both `DEEPLAKE_ROOT_PATH` and
`DEEPLAKE_ROOT_DIR`. Each pair must hold the same value - otherwise
`deeplake-api` and `pg-deeplake` would read and write different buckets - so
you give each setting once, under the name on the left, and its twin is derived
from your answer:

| you set | it fills |
| --- | --- |
| `DEEPLAKE_ROOT_PATH` | `DEEPLAKE_ROOT_PATH`, `DEEPLAKE_ROOT_DIR` |
| `S3_ENDPOINT_URL` | `S3_ENDPOINT_URL`, `AWS_ENDPOINT_URL` |
| `S3_REGION` | `S3_REGION`, `AWS_REGION` |
| `S3_ACCESS_KEY` | `S3_ACCESS_KEY_ID`, `AWS_ACCESS_KEY_ID` |
| `S3_SECRET_KEY` | `S3_SECRET_ACCESS_KEY`, `AWS_SECRET_ACCESS_KEY` |

Setting a name in the right-hand column has no effect: it is overwritten. Note
that this backend reads **no** `AWS_*` variable from your environment - the
credentials it asks for are `S3_ACCESS_KEY` and `S3_SECRET_KEY`, names nothing
else uses - so an unrelated AWS login in your shell cannot end up pointed at a
storage endpoint that is not Amazon's.

Supply the rest in `.env` or let `setup` prompt for them; the secret of each set
(`AWS_SECRET_ACCESS_KEY`, `AZURE_CLIENT_SECRET`, `S3_SECRET_KEY`) is read
without echo, and none of them are printed back at the end of `setup`. Note that
for `STORAGE_TYPE=aws` the variables are the ordinary `AWS_*` ones: if your
shell already exports them, `setup` uses those without asking. Deep Lake data
lives in your bucket or container, and `./dl-stack.sh destroy` does not touch
it - unlike `alarik` and `garage`, whose volumes it wipes.

The backend cannot be switched in place: the rendered compose file and the
object storage volumes belong to the type chosen at `setup` time.

## Stateless node count

`pg-deeplake-stateless` runs as several independent nodes, one per CPU core
less one - two cores give one node, four give three - leaving a core for
everything else on the host. `setup` detects this with `nproc` and prints the
number it settled on. Set `DEEPLAKE_STATELESS_COUNT` to override it.

Each node is a service of its own (`deeplake-stateless-1`, `-2`, …) rather than
`deploy: replicas`, because each needs a stable hostname, container name and
volume of its own: `pg-proxy` addresses them individually through `LOCAL_PODS`,
which `setup` fills in as `deeplake-stateless-1:5432,deeplake-stateless-2:5432,…`.
`pg-proxy` waits only on the first node being healthy; the rest join as they
come up. Node 1 keeps the volume name `dl_deeplake_stateless` it has always
had, so an existing install does not orphan its data when it grows extra nodes.

The count is fixed into the rendered compose file at `setup` time, but
`scale` changes it afterwards without touching any other setting:

```sh
./dl-stack.sh scale 2
```

It rewrites `~/.local/deeplake/compose.yaml` - adding or removing the service
and volume blocks and updating `LOCAL_PODS` - validates the result before
replacing anything, and applies it right away if the stack is running,
recreating `pg-proxy` so it picks up the new node list. If the stack is down,
the change takes effect on the next `start`.

**Scaling down deletes the data volumes of the nodes it removes** - once their
containers are gone, `dl_deeplake_stateless_2` and up are removed with
`docker volume rm`, and scaling back up starts those nodes empty. Only volumes
the compose file listed for a node above the new count are touched, so node 1
and its `dl_deeplake_stateless` volume are never affected. A volume that is
still in use is reported and left alone rather than failing the scale.

## Startup ordering

Postgres, OpenFGA, Keycloak, `deeplake-indexer` and the `deeplake-stateless`
nodes
define healthchecks, and dependents wait on `condition: service_healthy` rather
than merely `service_started` - `deeplake-api` waits on both `deeplake-setup`
completing and `keycloak` being healthy, since it validates OIDC tokens against
the realm and is useless before Keycloak answers. The Postgres probe
deliberately connects over TCP (`pg_isready -h 127.0.0.1`): during first boot
the entrypoint runs a temporary socket-only server while `provision.sql`
creates the `deeplake` / `keycloak` / `openfga` roles and databases, so a
socket probe would report healthy before those exist. Nothing dependent starts
until that initialization has finished.

## Prerequisites

* Linux host with Docker Engine and the Compose v2 plugin, **v2.24 or newer**
  (the compose file uses inline `configs:` `content:`)
  ([engine](https://docs.docker.com/engine/install/),
  [compose](https://docs.docker.com/compose/install/linux/))
* `envsubst` (`gettext` package), `curl`, `bash` 4+, `sed`
* Ports **80** and **443** free on the host
* A domain you control (`BASE_HOST`) with DNS records pointing at this host for:
  `app`, `api`, `kc`, `openfga`, plus `storage-api` (`alarik`, `garage`) and
  `storage` (`alarik`) - see [Storage backends](#storage-backends)
* For `STORAGE_TYPE=aws`, `azure` or `external-s3`: an existing
  bucket/container and credentials that can read and write it
  - a wildcard `*.$BASE_HOST` A record is easiest
* TLS, one of:
  * **`http01`** - port 80 reachable from the internet; Caddy issues and renews
    certificates automatically via Let's Encrypt
  * **`from_file`** - you supply a certificate and key valid for `*.$BASE_HOST`
* **Pull credentials for `quay.io/activeloopai`** - see below

Most images are public, but the Deep Lake images are hosted in private Quay
repositories and will not pull without authentication:

| Repository | Services it backs |
| --- | --- |
| `quay.io/activeloopai/deeplake-ui` | `deeplake-ui` |
| `quay.io/activeloopai/deeplake-api` | `deeplake-api`, `deeplake-worker`, `deeplake-setup` |

Request credentials from Activeloop before you begin - installation cannot
proceed without them.

## Install

### 1. Authenticate to the registry

```sh
docker login quay.io
```

Do this first. Stack uses the private `deeplake-api` and `deeplake-ui` images, so
without a valid login it will fail.

The login is stored per-user in `~/.docker/config.json`. Run it as the **same
user that runs `dl-stack.sh`** - a login as your own account does not help if
the stack is later started by `root` or by a systemd unit.

### 2. Configure

Edit `.env` (it is `export`-prefixed, so it must be *sourced*, not passed as a
Compose env file):

```sh
export BASE_HOST=example.com
export STORAGE_TYPE=alarik    # storage backend: alarik | garage | aws | azure | external-s3
export DEEPLAKE_STATELESS_COUNT=  # stateless nodes; default: cpu cores - 1

# required when STORAGE_TYPE=aws, ignored otherwise
export DEEPLAKE_ROOT_PATH=    # s3://<bucket>/<prefix>
export AWS_REGION=
# leave the key pair empty when the host itself can already reach S3
export AWS_ACCESS_KEY_ID=
export AWS_SECRET_ACCESS_KEY=

# required when STORAGE_TYPE=azure, ignored otherwise
export DEEPLAKE_ROOT_PATH=    # az://<account>/<container>/<prefix>
export AZURE_TENANT_ID=
export AZURE_CLIENT_ID=
export AZURE_CLIENT_SECRET=

# required when STORAGE_TYPE=external-s3, ignored otherwise
export DEEPLAKE_ROOT_PATH=    # s3://<bucket>/<prefix>
export S3_ENDPOINT_URL=       # https://<host>
export S3_REGION=
export S3_ACCESS_KEY=
export S3_SECRET_KEY=
export TLS_METHOD=http01      # or: from_file
export TLS_CERT_PATH=         # required when TLS_METHOD=from_file
export TLS_KEY_PATH=          # required when TLS_METHOD=from_file
```

Any variable you leave empty is prompted for interactively during `setup`;
`STORAGE_TYPE` is offered as a numbered menu (see
[Storage backends](#storage-backends)). An unsupported `STORAGE_TYPE`, or
no selection at all when there is no TTY, aborts `setup`.

> **Do not run `docker compose` against the files in the `compose/`
> directory.** They are templates, and neither half is a usable file on its own. Compose would auto-load `.env` and fill in
> `BASE_HOST`, but every generated secret resolves to an **empty string** and the
> OpenFGA store/model placeholders stay unsubstituted - bringing up a Postgres
> with blank passwords. Only `dl-stack.sh` renders it correctly, and the rendered
> copy at `~/.local/deeplake/compose.yaml` is the one to point `docker compose`
> at.

### 3. Run setup

```sh
source .env
./dl-stack.sh setup
```

`setup` will:

1. verify prerequisites;
2. resolve the storage type from `STORAGE_TYPE`, or prompt for it;
3. generate every password, access key and signing key (20–64 random chars),
   including the ones specific to the selected storage type, and prompt for any
   storage settings it expects you to provide (`aws`, `azure`, `external-s3`);
4. merge `compose/compose-base.yaml` with `compose/storage-$STORAGE_TYPE.yaml`
   → `~/.local/deeplake/compose.yaml` with all values substituted, adjusting
   the Caddy TLS config for the chosen `TLS_METHOD`;
5. start OpenFGA and Caddy, wait up to 5 minutes for
   `https://openfga.$BASE_HOST/healthz`;
6. create the `deeplake` OpenFGA store and push the authorization model, writing
   both IDs back into the rendered compose file;
7. run `deeplake-setup` (database migrations), then bring the stack down;
8. print the storage and Keycloak admin credentials **once**.

Step 8 is the only time those credentials are shown. Save them - there is no
command to reprint them; the fallback is reading them out of
`~/.local/deeplake/compose.yaml`.

If store or model creation fails, `setup` runs `destroy --force` (no prompt) and
exits - fix DNS/TLS and start over.

`setup` refuses to run if `~/.local/deeplake/compose.yaml` already exists; see
[Upgrading and re-running setup](#upgrading-and-re-running-setup).

### 4. Start

```sh
./dl-stack.sh start
```

Then open `https://app.$BASE_HOST`. Self-registration is enabled on the
`deeplake` Keycloak realm, so the first user can sign up from the login page.

## Commands

| Command | Effect |
| --- | --- |
| `./dl-stack.sh setup` | Generate config and initialize OpenFGA + databases |
| `./dl-stack.sh start` | Start the stack (runs `setup` first if not configured) |
| `./dl-stack.sh stop` | Stop the stack (`compose down`, volumes kept) |
| `./dl-stack.sh scale N` | Run N `deeplake-stateless` nodes; applies immediately if the stack is up. Scaling **down deletes** the removed nodes' volumes |
| `./dl-stack.sh destroy` | `compose down -v` - **deletes all data** - and removes the rendered config. Prompts for confirmation |
| `./dl-stack.sh destroy --force` | Same, without the prompt. For CI/automation |

With no TTY (CI, systemd, piped stdin) a bare `destroy` declines and exits
without removing anything; use `--force` when you mean it.

## Where state lives

* `~/.local/deeplake/compose.yaml` - the rendered compose file. **This is the
  only copy of your generated secrets and of the OpenFGA store/model IDs.**
  `setup` creates it `chmod 600`. Back it up; treat it as a secret.
* Docker volumes listed above hold Postgres, object storage and Deep Lake state.
  Nothing in this repo backs them up - if the host is lost, so are all users,
  authorization tuples and datasets. Snapshot them yourself.

## Upgrading and re-running setup

`setup` refuses to run when `~/.local/deeplake/compose.yaml` already exists,
exiting with a warning rather than touching it. To genuinely reinitialize, run
`./dl-stack.sh destroy` first - which wipes all data - and then `setup` again.
To change a setting without losing data, edit the rendered file (`~/.local/deeplake/compose.yaml`) directly and
`./dl-stack.sh start`.

To pick up new image tags without losing data:

```sh
docker login quay.io   # if the cached credentials have expired
docker compose -f ~/.local/deeplake/compose.yaml pull
./dl-stack.sh start
```

## Troubleshooting

* **`unauthorized`, `access to the requested resource is not authorized`, or
  `manifest unknown` when pulling** - you are not logged in to `quay.io`, the
  credentials have expired, or they lack access to the private Deep Lake
  repositories. Re-run `docker login quay.io` as the user that runs the stack
  and verify with
  `docker pull quay.io/activeloopai/deeplake-api:setup-self-hosted`.
* **`openfga not ready after 5m`** - DNS for `openfga.$BASE_HOST` doesn't resolve
  to this host, port 80/443 is blocked, or ACME issuance failed. Check
  `docker logs dl-caddy`.
* **Certificate errors with `TLS_METHOD=from_file`** - the certificate must cover
  every subdomain (`*.$BASE_HOST`); the paths are mounted into Caddy as
  `/certs/fullchain.pem` and `/certs/privkey.pem`.
* **A service is stuck starting** - `docker compose -f ~/.local/deeplake/compose.yaml ps`
  shows health state. Anything still `(health: starting)` well past its
  `start_period`, or flipping to `unhealthy`, is blocking everything that
  depends on it; `docker inspect --format '{{json .State.Health}}' <container>`
  shows the last probe output.
* **Logs** - `docker compose -f ~/.local/deeplake/compose.yaml logs -f <service>`.
* **Login works but the API rejects tokens** - confirm `BASE_HOST` matches the
  hostname you're actually browsing; the realm's audience mapper and redirect
  URIs are baked in at setup time from `BASE_HOST`.

