[![Deploy on Railway](https://railway.com/button.svg)](https://railway.com/new/template/zulip-1?utm_medium=integration&utm_source=button&utm_campaign=zulip)

# Zulip on Railway

One-click [Zulip](https://zulip.com) team chat for [Railway](https://railway.com), built from this repo so deployers get Railway's "update available" notice when the Zulip version is bumped here.

**Zulip Server 13.2** (`ghcr.io/zulip/zulip-server:13.2-0`), with the same five-service stack as upstream [docker-zulip](https://github.com/zulip/docker-zulip):

| Service | Built from | What it does | Volume |
|---|---|---|---|
| **Zulip** | `zulip/` (`ghcr.io/zulip/zulip-server:13.2-0@sha256:c1a6e8ae…`) | Web app, API, real-time events, queue workers. Public HTTPS domain | `/data` (uploads, secrets file) |
| **Postgres** | `postgres/` (`zulip/zulip-postgresql:14@sha256:e71ba861…`) | Database, with PGroonga and the hunspell dictionaries Zulip's full-text search needs | `/var/lib/postgresql/data` |
| **RabbitMQ** | `rabbitmq/` (`rabbitmq:4.2.9@sha256:b9d19787…`) | Queue for Zulip's background workers | `/var/lib/rabbitmq` |
| **Redis** | Railway's Redis | Rate limiting and caches | Railway's Redis volume |
| **Memcached** | `memcached/` (`memcached:1.6.45-alpine@sha256:084fb554…`) | Cache, password-protected (SASL) | none (cache only) |

All services talk over Railway's private network. Every password is generated at deploy time.

## Variables

The deployer is asked for one value:

- `ZULIP_ADMIN_EMAIL`: email address of the first organization owner, also used as Zulip's server administrator address.

Everything else is set for you: `ZULIP_ADMIN_PASSWORD` (generated, 24 characters; read it in the Zulip service's **Variables** tab), the private hostnames and passwords of the other services (reference variables), `SETTING_EXTERNAL_HOST` (the Railway domain) and `PORT=80`.

On the first boot the Zulip service runs migrations and then creates an organization named "Zulip" with that owner (a Zulip post-setup hook in `zulip/create-organization.sh`). It never touches an existing organization, so changing the variables later does nothing.

Optional, add them to the Zulip service yourself (see Zulip's [settings docs](https://zulip.readthedocs.io/projects/docker/en/latest/how-to/compose-settings.html)):

- Outgoing email: `SETTING_EMAIL_HOST`, `SETTING_EMAIL_HOST_USER`, `SETTING_EMAIL_PORT`, `SETTING_EMAIL_USE_TLS`, `SETTING_NOREPLY_EMAIL_ADDRESS`, `SECRETS_email_password`. Without them, Zulip can't send invitations or password-reset mails; add users from **Organization settings → Users** instead.
- Your own domain: add it in Railway, then set `SETTING_EXTERNAL_HOST` to it.
- Mobile push notifications: register the server with `manage.py register_server` (see Zulip's docs).
- Nightly database dumps to the volume: `AUTO_BACKUP_ENABLED=True` (off by default because they aren't rotated).

## Updates

The Dockerfiles pin each image by version and digest. A new Zulip release is a pull request here that bumps `zulip/Dockerfile` and adds a `CHANGELOG.md` entry. When it merges to `main`, Railway shows deployers an "update available" notice, and the Zulip service runs any database migrations on its next boot. Read `CHANGELOG.md` before you apply an update.

PostgreSQL stays on major version 14 (Zulip's own image; Zulip 13 supports 14–18). A major PostgreSQL upgrade needs a manual dump and restore and is never pushed as an automatic update.

## Local test

`compose.test.yaml` runs the same stack with test passwords: `docker compose -f compose.test.yaml up --build`, then open `http://zulip.local:8080` (map `zulip.local` to `127.0.0.1`).
