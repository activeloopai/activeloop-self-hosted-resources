# Deep Lake self-hosted stack

Single-host Docker Compose deployment of [Deeplake](http://deeplake.ai/) with:
  - [Keycloak](https://www.keycloak.org/) as identity provider
  - [OpenFGA](https://openfga.dev/) for authorization
  - Postgres for dependency services
  - [Alarik](https://alarik.io/) for S3-compatible object store
  - [Caddy](https://caddyserver.com/docs/) as the TLS-terminating reverse proxy.

`dl-stack.sh` is the installer: it generates all secrets, renders `compose.yaml`
into `~/.local/deeplake/compose.yaml`, bootstraps the OpenFGA store and
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
| Deep Lake worker / setup / indexer / stateless | `dl-deeplake-*` | internal |
| Keycloak | `dl-keycloak` | `https://kc.$BASE_HOST` |
| OpenFGA | `dl-openfga` | `https://openfga.$BASE_HOST` |
| Object storage API | `dl-storage-api` | `https://storage-api.$BASE_HOST` |
| Object storage console | `dl-storage-ui` | `https://storage.$BASE_HOST` |
| Postgres (shared) | `dl-postgres` | internal, plus `127.0.0.1:5432` on the host |
| pg-proxy (Deep Lake PG endpoint) | `dl-pg-proxy` | internal |
| Caddy | `dl-caddy` | `:80`, `:443` |

Caddy publishes **only** 80 and 443. Postgres is additionally bound to the host
loopback (`127.0.0.1:5432`) for local `psql` access - it is not reachable off
the host. This is the shared control-plane database (Keycloak users, OpenFGA
tuples, Deep Lake metadata); do not widen that binding to `0.0.0.0`.

Data lives in named Docker volumes: `dl_deeplake_postgres`,
`dl_deeplake_storage`, `dl_deeplake_indexer`, `dl_deeplake_stateless`,
`dl_deeplake_caddy`.

## Startup ordering

Postgres, OpenFGA, Keycloak and the two `pg-deeplake-stateless` containers
define healthchecks, and dependents wait on `condition: service_healthy` rather
than merely `service_started`. The Postgres probe deliberately connects over TCP
(`pg_isready -h 127.0.0.1`): during first boot the entrypoint runs a temporary
socket-only server while `provision.sql` creates the `deeplake` / `keycloak` /
`openfga` roles and databases, so a socket probe would report healthy before
those exist. Nothing dependent starts until that initialization has finished.

## Prerequisites

* Linux host with Docker Engine and the Compose v2 plugin, **v2.24 or newer**
  (the compose file uses inline `configs:` `content:`)
  ([engine](https://docs.docker.com/engine/install/),
  [compose](https://docs.docker.com/compose/install/linux/))
* `envsubst` (`gettext` package), `curl`, `bash` 4+, `sed`
* Ports **80** and **443** free on the host
* A domain you control (`BASE_HOST`) with DNS records pointing at this host for:
  `app`, `api`, `kc`, `openfga`, `storage`, `storage-api`
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
export TLS_METHOD=http01      # or: from_file
export TLS_CERT_PATH=         # required when TLS_METHOD=from_file
export TLS_KEY_PATH=          # required when TLS_METHOD=from_file
```

Any variable you leave empty is prompted for interactively during `setup`.

> **Do not run `docker compose` against the `compose.yaml` in this directory.**
> It is a template, not a usable file. Compose would auto-load `.env` and fill in
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
2. generate every password, access key and signing key (20–64 random chars);
3. render `compose.yaml` → `~/.local/deeplake/compose.yaml` with all values
   substituted, adjusting the Caddy TLS config for the chosen `TLS_METHOD`;
4. start OpenFGA and Caddy, wait up to 5 minutes for
   `https://openfga.$BASE_HOST/healthz`;
5. create the `deeplake` OpenFGA store and push the authorization model, writing
   both IDs back into the rendered compose file;
6. run `deeplake-setup` (database migrations), then bring the stack down;
7. print the storage and Keycloak admin credentials **once**.

Step 7 is the only time those credentials are shown. Save them - there is no
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

