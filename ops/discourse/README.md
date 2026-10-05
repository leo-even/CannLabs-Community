# CannLabs Community — production-like deployment canon

> **THIS IS THE VALIDATED PRODUCTION-LIKE DEFINITION, NOT A PRODUCTION DEFAULT.**
> Production is `NOT READY`. Do not copy values from this directory into a production deployment without a separate, explicit decision.

This directory is the durable, version-controlled owner of the production-like deployment definition (`DEC-039`). Everything else about the project's state and decisions is in `docs/cannlabs-community/` (`02_PROJECT_STATE.md` → TASK 37B, `01_DECISION_LOG.md` → `DEC-037`, `DEC-038`, `DEC-039`).

| File | Responsibility |
| --- | --- |
| `cannlabs-prodlike.yml` | The exact `discourse_docker` container definition validated by Task 37B. Byte-identical to the validated file; the implementation authority for everything below. Do not edit it casually: a change is a new definition and needs its own validation and Decision Log entry. |
| `README.md` | This runbook. |
| `spec/lib/cannlabs_community/prodlike_deployment_parity_spec.rb` | Two parity checks (see "Drift protection"). |

## 1. Purpose and scope

- A **production-like proof**, not the production deployment. Synthetic hostname, local Mailpit, no TLS, no public exposure, no real members, no real provider credentials.
- Validated artifact: `cannlabs-prodlike.yml`, SHA-256 `89222f0af613aefacbbb26bac8c5f33c895aa7243eb70fca0eb4e7c64188065f` (9,292 bytes). The previous definition (`0eb16493…7885`) is `SUPERSEDED` and is not fresh-install-safe.
- `MACHINE-INDEPENDENT DEPLOYMENT REPRODUCIBILITY — NOT YET VALIDATED`. The proof ran on one prepared host. It becomes validated only when a fresh second host or distribution is built from the tracked artifacts and the values documented here, and nothing else.

### Prodlike-only assumptions: do not carry them into production

| In `cannlabs-prodlike.yml` | Why it is prodlike-only |
| --- | --- |
| `DISCOURSE_HOSTNAME: community-prodlike.test` | Synthetic `.test` name; no DNS exists. |
| `expose: 127.0.0.1:80:80`, no 443 | Loopback only; no TLS or edge. |
| `DISCOURSE_SMTP_ADDRESS: mailpit`, port 1025, no STARTTLS, no credentials | A local mail catcher on the prodlike Docker network. Not an SMTP decision. |
| `docker_args: --network cannlabs-prodlike-net` | The dedicated prodlike network from section 4. |
| `volumes` host paths `/var/discourse/shared/standalone` and `…/log/var-log` | Absolute paths of the validated host. |
| `docker_args: --log-opt max-size=10m --log-opt max-file=3` | Validated Docker log limits; production values are undecided. |
| `templates` (one standalone container with Postgres and Redis inside), `docker_manager` not cloned | The validated topology only. |
| `db_default_text_search_config`, `LANG` / `LC_ALL` | Validated defaults only. |

## 2. Required source pins

| Component | Pin |
| --- | --- |
| Application `leo-even/CannLabs-Community` | `73b2484ded24d04c874de49a328e76d10f226be4` (`params.version`) |
| Qualified Access plugin `leo-even/CannLabs-Community-Qualified-Access` | `ca4f0070d7bf85e42dbfa7f8736469139bb20275` (cloned and checked out in `hooks.after_code`) |
| Theme `leo-even/CannLabs-Community-Theme` | tag `v0.1.0`, peeling to `aeb3a9d9154f532064dcc24ac9e78cf587588d77` (not in the YAML, see section 7) |
| `discourse_docker` | `8d705a91866c320592ce851f30895ddb4c3e85fe`, checked out detached |

**The application pin cannot equal this repository's `HEAD`.** The definition lives in the same history that records the pin, so the pin is always a known **ancestor** application commit. That is expected, not drift.

## 3. Host assumptions (validated environment only)

- Ubuntu 24.04 under WSL2 (a disposable distribution) or Linux, with a native Docker Engine. Not the Docker Desktop shared daemon.
- `discourse_docker` cloned at `/var/discourse` and pinned (below). A detached `HEAD` also stops the launcher from self-updating.
- A persistent `/shared` directory: `/var/discourse/shared/standalone` on the host. A fresh install starts from empty storage, and the definition is written for that case (`DEC-037`).
- This is not a generic installation guide.

## 4. Network and Mailpit (prodlike only; create before the container)

Validated order and shape:

```bash
docker network create --driver bridge cannlabs-prodlike-net
docker pull axllent/mailpit:v1.30.6        # linux/amd64, digest axllent/mailpit@sha256:7f33095f80e901f6ad08028f06ca284aa58fe84942be5496008d041d3b9f4d4d
docker run -d --name cannlabs-prodlike-mailpit --restart unless-stopped \
  --network cannlabs-prodlike-net --network-alias mailpit \
  -p 127.0.0.1:8025:8025 axllent/mailpit@sha256:7f33095f80e901f6ad08028f06ca284aa58fe84942be5496008d041d3b9f4d4d --disable-version-check
```

- The Mailpit UI is published on loopback `127.0.0.1:8025` only. SMTP (`mailpit:1025`) is reachable only on `cannlabs-prodlike-net`, never published to the host.
- Mailpit holds every message the instance sends, including reset codes and links. Treat it as sensitive.

## 5. Container definition placement

`discourse_docker` reads container definitions only from `/var/discourse/containers/<name>.yml`, and the container takes the file's name. The tracked file is the canonical source artifact; the file under `/var/discourse/containers/` is a local runtime copy named `cannlabs-prodlike.yml` (the validated copy is root-owned, mode 600).

A future operator copies the tracked file into place and verifies the copy before building:

```bash
sha256sum /var/discourse/containers/cannlabs-prodlike.yml
# must print 89222f0af613aefacbbb26bac8c5f33c895aa7243eb70fca0eb4e7c64188065f
```

## 6. Build order (validated in Task 37B)

1. Clone `https://github.com/discourse/discourse_docker.git` to `/var/discourse` and `git -c advice.detachedHead=false checkout 8d705a91866c320592ce851f30895ddb4c3e85fe`.
2. Create the network and Mailpit (section 4).
3. Place and verify the definition (section 5).
4. `cd /var/discourse && ./launcher rebuild cannlabs-prodlike`. On empty `/shared` this initializes a fresh Postgres cluster. A rebuild takes the site down while it runs, the prebuilt fork asset tarball returns 404 so assets are built locally, and the build must be allowed to finish (it has taken several minutes).
5. Health gate: `curl -H 'Host: community-prodlike.test' http://127.0.0.1:80/srv/status` returns `ok`.
6. First admin, theme and product bootstrap: sections 9, 7 and 8. They were performed in Task 37B.1 on the prepared host. They are not yet re-proven from tracked artifacts alone.

## 7. Theme contract

**The container definition does not install the theme.** `cannlabs-prodlike.yml` clones the plugin only. The theme is installed into the running instance afterwards, as product state, from `https://github.com/leo-even/CannLabs-Community-Theme.git` at tag `v0.1.0`, and the installed commit must equal `aeb3a9d9154f532064dcc24ac9e78cf587588d77` (`DEC-036`: install by tag, verify the exact SHA). Task 37B.1 did this once, with `RemoteTheme.import_theme(url, admin, branch: "v0.1.0")` in a Rails runner, and confirmed the commit. The product bootstrap audits the pin (`config/cannlabs_community/bootstrap.yml` → `theme`). The YAML alone does not make the theme present.

## 8. Product bootstrap

Use the repository's bootstrap, not a copy of its rules: `docs/cannlabs-community/08_PRODUCT_BOOTSTRAP.md`, run inside the container with `PROFILE=production`:

```bash
docker exec -u discourse -w /var/www/discourse -e PROFILE=production cannlabs-prodlike \
  bin/rake cannlabs_community:bootstrap:audit
```

Accepted production-like result: `PASS (pass 36, drift 0, blocked 0, gated 1)`. On an empty database the audit is `BLOCKED` until the data exists, as observed before the Task 37B.2B restore. The bootstrap is not a production installer.

## 9. First admin and the synthetic environment

Task 37B.1 created the first administrator with the native `bin/rake admin:create` inside the container, using synthetic `.test` data. The task prompts for the password, so none is recorded anywhere, and it defaults the Admin prompt to yes. No password, token or synthetic credential belongs in this repository. Creating a first admin is **not** yet a documented, machine-independent recipe, and no production first-admin process is defined here.

## 10. Backup and restore (native Discourse)

- Backup: the native `discourse backup` inside the container (database and uploads). Backups hold private data: never commit one, and keep a copy outside the instance's `/shared`. The validated backup is not stored in Git.
- Restore: `discourse enable_restore`, place the backup under `/shared/backups/default/`, then `discourse restore <file> --no-disable-emails`. **`--no-disable-emails` is required** (`DEC-038`); without it the stock restore changes `disable_emails` from `no` to `non-staff`.
- `allow_restore` must be enabled for a restore and returns to `false` in the validated flow. Accept a restore only when `allow_restore = false`, read-only mode is off, `disable_emails = no` and the bootstrap audit passes.
- Expected side effects: the Redis-backed store and sessions are flushed; scheduled post-restore maintenance runs; `remote_themes` may gain two empty built-in rows from the restore's seed step. None of them is drift.

## 11. Security hardening contract

The YAML is the implementation authority. Its `run:` section does the following, each step with a guard that fails the build when stock config drifts, because `pups replace` is silent when its pattern does not match:

- nginx access log uses a safe request representation (method, redacted path, protocol: no query string) and a Referer reduced to its origin; credential-bearing routes become `[FILTERED]`.
- nginx `error_log` is `emerg`, the only level without request context.
- nginx logrotate creates 0640 files and keeps the stock 7 rotations.
- Log directories `/var/log/nginx` and `/shared/log/rails` are created idempotently with their runtime owners and mode 0750 (fresh-install safe), then checked.
- `nginx -t` runs last.
- Docker `json-file` log limits come from `docker_args`.

## 12. Known retained findings (not reopened here)

Recorded in `docs/cannlabs-community/02_PROJECT_STATE.md` → TASK 37B: the stock runit service resets nginx runtime log permissions on every start; `error_log emerg` trades observability for secrecy; the zero-leak logging guarantee is bounded to the proven secret shapes; the prebuilt asset tarball returns 404 and assets build locally; a launcher rebuild causes downtime.

## Environment and secrets boundary

**This repository may contain:** non-secret deployment configuration, exact pins, prodlike hostnames, localhost bindings, Mailpit configuration and safe environment-variable names.

**This repository must not contain:** SMTP passwords, OAuth client secrets, private keys, API tokens, backup files or production credentials.

**Future production secrets: `OPEN — DELIVERY MECHANISM NOT YET DECIDED`.** Values placed directly in a `discourse_docker` `env:` block can appear in image and container metadata. Do not put real production secrets into this tracked YAML or into baked image metadata. No secrets manager or vendor is chosen here.

## Drift protection

Enforced by `spec/lib/cannlabs_community/prodlike_deployment_parity_spec.rb` (no runtime dependency; it only reads tracked files):

1. The Qualified Access repository and commit in the YAML equal `plugin` in `config/cannlabs_community/bootstrap.yml`.
2. The nginx credential-path rules in the YAML mirror `CannlabsPathSecretRedaction::RULES` (`config/initializers/zz-cannlabs-path-secret-redaction.rb`).

Documented coupling, not enforced: the application pin is an ancestor of `HEAD` (section 2); the theme pin lives in the bootstrap manifest and `DEC-036`, not in the YAML; any new definition needs its own validation, hash and Decision Log entry.
