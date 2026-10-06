# CannLabs Community — production-like deployment canon

> **THIS IS THE VALIDATED PRODUCTION-LIKE DEFINITION, NOT A PRODUCTION DEFAULT.**
> Production is `NOT READY`. Do not copy values from this directory into a production deployment without a separate, explicit decision.

This directory is the durable, version-controlled owner of the production-like deployment definition (`DEC-039`). Everything else about the project's state and decisions is in `docs/cannlabs-community/` (`02_PROJECT_STATE.md` → TASK 37B, TASK 38A, TASK 38B; `01_DECISION_LOG.md` → `DEC-037` to `DEC-047`).

| File | Responsibility |
| --- | --- |
| `cannlabs-prodlike.yml` | The exact `discourse_docker` container definition validated by Task 37B. Byte-identical to the validated file; the implementation authority for everything below. Do not edit it casually: a change is a new definition and needs its own validation and Decision Log entry. |
| `README.md` | This runbook. |
| `spec/lib/cannlabs_community/prodlike_deployment_parity_spec.rb` | Two parity checks, run against both definitions (see "Drift protection"). |
| `cannlabs-production.yml`, `PRODUCTION.md` | The tracked, non-secret **production** deployment definition and its ingress contract (`DEC-046`, `DEC-047`): canonical hostname, the Portuguese alias, the official SSL and Let's Encrypt templates, IPv4-only exposure, sizing profile, opening sequence and acceptance gates. Not deployed; production remains NOT READY. Distinct from the prodlike definition above, which this README documents. |
| `spec/lib/cannlabs_community/production_deployment_spec.rb` | Guards the production definition and `PRODUCTION.md`: hostnames, IPv4-only exposure, no Cloudflare or Mailpit, secrets only through the env file, the frozen prodlike definition, the logging block, sizing, pins, robots ownership, labels and the opening-sequence order. |
| `SECRETS.md`, `production.env.example` | The production secrets delivery contract (`DEC-042`) and its non-secret example. The authority for how real secrets reach the container. |
| `spec/lib/cannlabs_community/production_secrets_contract_spec.rb` | Guards the tracked artifacts against secret values and `DISCOURSE_DEVELOPER_EMAILS`. |
| `STAFF_SECURITY.md` | The production first-admin and staff security runbook (`DEC-044`): first administrator, native 2FA enrollment, the second administrator, enforcement, least privilege, API-key policy, break-glass, offboarding, the IP-allowlist position and the read-only staff security audit. |
| `spec/lib/cannlabs_community/staff_security_runbook_spec.rb` | Guards that runbook: safe order, no forbidden bootstrap route in a command, no secret-shaped value or address, and a read-only audit that parses. |
| `anonymous_http_acceptance.py` | The live anonymous HTTP gate (`DEC-045`): proves that the running web workers serve the configured privacy state. Required by the restore acceptance contract (section 10); reusable as a pre-public-ingress gate. Standard-library Python, anonymous GETs only, `--self-test` built in. |
| `spec/lib/cannlabs_community/post_restore_acceptance_spec.rb` | Guards the restore acceptance contract and that script: step order, no rebuild, liveness-only wording, GET-only and credential-free code, and the script's self-test. |

## 1. Purpose and scope

- A **production-like proof**, not the production deployment. Synthetic hostname, local Mailpit, no TLS, no public exposure, no real members, no real provider credentials.
- Validated artifact: `cannlabs-prodlike.yml`, SHA-256 `89222f0af613aefacbbb26bac8c5f33c895aa7243eb70fca0eb4e7c64188065f` (9,292 bytes). The previous definition (`0eb16493…7885`) is `SUPERSEDED` and is not fresh-install-safe.
- `MACHINE-INDEPENDENT PRODUCTION-LIKE DEPLOYMENT REPRODUCIBILITY — VALIDATED` (Task 38B, 2026-10-05, `DEC-041`). An independent Google Compute Engine VM reproduced the validated production-like deployment from this directory's tracked artifacts at canon commit `d1981640e414d215f2d6fea7a182cd1bf6d1e5e9`, using only pinned public sources and the values documented here. Section 13 states what the claim means and what it does not. It is not production readiness.
- **`FINAL TASK 38B ACCEPTANCE REQUIRES AN ISOLATED FRESH VM OR SEPARATE PHYSICAL HOST`** with an independent network namespace, Docker daemon and filesystem. A second WSL distribution on the same Windows host is not accepted, because WSL distributions on one host share the relevant network namespace and listeners. A same-host WSL rehearsal is optional, is not acceptance evidence, and must be labeled `REHEARSAL ONLY — DOES NOT VALIDATE TASK 38B`.
- **Task 38B proves a clean install and the product bootstrap from the tracked canon.** It does not repeat backup creation, restore or the disaster-recovery proof: Task 37B.2B already validated them. Section 10 is reference, not part of that run.

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
| Base image (named by the pinned `discourse_docker`) | `discourse/base:2.0.20260915-0028`, resolved digest `sha256:5028d077b061225507e7093fda1ff5bdc64d483b5c0397776f9a52c50008cd9b` as pulled in the Task 37B builds |

**Application pin and canon commit.** The definition lives in the same history that records the pin, so the pin can never equal the commit that owns the canon. It is a known **ancestor** of that commit, and ancestry is checkable. This is expected, not drift. A fresh-host run must fail closed unless `git merge-base --is-ancestor 73b2484ded24d04c874de49a328e76d10f226be4 <canon commit>` succeeds, and after the build must find, inside `/var/www/discourse`, `HEAD` equal to the pin and `origin` pointing at the CannLabs fork. Never require the pin to equal the canon `HEAD`.

**Base image.** The YAML is not changed to pin the base image by digest. A future run records the digest the tag resolves to, compares it with the value above, and stops on an unexplained mismatch before claiming reproducibility.

## 3. Host and Docker contract (validated environment only)

Community requirements:

- Ubuntu 24.04 (noble), amd64, with root or `sudo`.
- A native Docker Engine (below), `git`, `curl`, `ca-certificates` and `gnupg`.
- Enough free disk for Docker images and a build (record the free space at the start).
- Outbound access to the public sources in section 13, and a materially correct clock.
- A persistent `/shared` directory: `/var/discourse/shared/standalone` on the host. A fresh install starts from empty storage, and the definition is written for that case (`DEC-037`).

Docker contract (what Task 37B validated):

- **Source:** the official Docker apt repository, `deb [arch=amd64 signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu noble stable`, with its key fetched from `https://download.docker.com/linux/ubuntu/gpg` (key fingerprint `9DC858229FC7DD38854AE2D88D81803C0EBFCD88`). Key material comes from the public upstream, never from another machine.
- **Components:** `docker-ce`, `docker-ce-cli`, `containerd.io`, `docker-buildx-plugin`, `docker-compose-plugin`; the daemon is systemd-managed (`systemctl enable --now docker`); there is no custom `/etc/docker/daemon.json`.
- **Validated versions:** Docker Server `29.8.2`, packages `docker-ce 5:29.8.2-1~ubuntu.24.04~noble` and `containerd.io 2.3.6-1~ubuntu.24.04~noble`. Task 38B also recorded `docker-buildx-plugin 0.37.1-1~ubuntu.24.04~noble` and `docker-compose-plugin 5.6.0-1~ubuntu.24.04~noble`, installed from the same repository without a pin.
- **Fresh data root:** `/var/lib/docker` must be new: no images, containers, volumes or networks.
- **Verification contract:** `docker version --format '{{.Server.Version}}'` prints `29.8.2`; `dpkg-query -W -f='${Version}\n' docker-ce containerd.io` prints the two package versions above; `docker info --format '{{.DockerRootDir}}'` prints `/var/lib/docker`; `docker ps -a` and `docker images` list nothing; `/etc/docker/daemon.json` does not exist. If the apt repository now offers different versions, stop and report: it is a deviation for the PM to decide, not something to repair.

Not Community requirements: the Windows keepalive process, the WSLInterop workaround, `appendWindowsPath=false` and the WSL `systemd=true` setting belong only to the earlier local WSL environment.

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

## 5. Acquire the canon and place the definition

A clean host obtains the canon from the public repository, never from another machine. This clone only supplies the canon: it is **not** the application checkout inside the container, which the YAML pins at `73b2484d…` (section 2).

```bash
CANON=<the exact canon commit the PM authorizes for the run>   # it must contain this runbook and the validated YAML
git clone --filter=blob:none --no-checkout https://github.com/leo-even/CannLabs-Community.git canon
cd canon
git sparse-checkout set --cone ops/discourse
git -c advice.detachedHead=false checkout --detach "$CANON"
test "$(git rev-parse HEAD)" = "$CANON" && test -z "$(git status --porcelain)"
git merge-base --is-ancestor 73b2484ded24d04c874de49a328e76d10f226be4 "$CANON"
sha256sum ops/discourse/cannlabs-prodlike.yml
# must print 89222f0af613aefacbbb26bac8c5f33c895aa7243eb70fca0eb4e7c64188065f
```

`discourse_docker` reads container definitions only from `/var/discourse/containers/<name>.yml`, and the container takes the file's name. The tracked file is the canonical source artifact. The file under `/var/discourse/containers/` is a local runtime copy named `cannlabs-prodlike.yml` (the validated copy is root-owned, mode 600):

```bash
install -m 0600 -o root -g root ops/discourse/cannlabs-prodlike.yml /var/discourse/containers/cannlabs-prodlike.yml
sha256sum /var/discourse/containers/cannlabs-prodlike.yml
# must print 89222f0af613aefacbbb26bac8c5f33c895aa7243eb70fca0eb4e7c64188065f
```

## 6. Fresh-host build and acceptance order

Every step has a stop condition: on any mismatch, stop and report. Do not repair or improvise. All of it is `PRODLIKE ACCEPTANCE ONLY`.

1. **Fresh-host preflight.** Confirm the isolation properties of section 13: no `/var/discourse`, `/shared` or Docker state, no Community containers, images or environment variables. Record OS, kernel, architecture, `date -u` and free disk.
2. **Obtain the canon** at the exact commit (section 5).
3. **Ancestry and pin preflight.** The ancestry check of section 5 succeeds, and the theme tag still peels to the validated commit:
   ```bash
   git ls-remote https://github.com/leo-even/CannLabs-Community-Theme.git 'refs/tags/v0.1.0^{}'
   # must print aeb3a9d9154f532064dcc24ac9e78cf587588d77
   ```
4. **Install and verify Docker** (section 3).
5. **Obtain the pinned `discourse_docker`:** `git clone https://github.com/discourse/discourse_docker.git /var/discourse`, then `git -c advice.detachedHead=false checkout 8d705a91866c320592ce851f30895ddb4c3e85fe`. Confirm `HEAD` equals the pin, is detached and has no local changes. A detached `HEAD` also stops the launcher from self-updating.
6. **Create the network** (section 4).
7. **Pull and start Mailpit by the validated digest** (section 4). Confirm the UI is on loopback only and SMTP is not published.
8. **Copy the tracked YAML** into `/var/discourse/containers/` (section 5).
9. **Verify the YAML SHA-256 is still exact** on the installed copy.
10. **Rebuild.** First record the base image the tag resolves to, and compare it with section 2:
    ```bash
    docker pull discourse/base:2.0.20260915-0028
    docker image inspect --format '{{index .RepoDigests 0}}' discourse/base:2.0.20260915-0028
    ```
    Then `cd /var/discourse && ./launcher rebuild cannlabs-prodlike`, and let it finish (several minutes). On empty `/shared` it initializes a fresh Postgres cluster. A rebuild takes the site down while it runs, and the prebuilt fork asset tarball returns 404 so assets are built locally. A guard failure in the YAML's `run:` section fails the build by design.
11. **Health gate and post-build pins.** `curl -H 'Host: community-prodlike.test' http://127.0.0.1:80/srv/status` returns `ok`. Inside `/var/www/discourse`, `HEAD` equals `73b2484ded24d04c874de49a328e76d10f226be4` and `origin` is the CannLabs fork; inside `plugins/cannlabs-community-qualified-access`, `HEAD` equals `ca4f0070d7bf85e42dbfa7f8736469139bb20275`.
12. **Create the synthetic admin** (section 9).
13. **Import the theme and verify its exact commit** (section 7).
14. **Bootstrap audit #1** (section 8). Expect `BLOCKED` with drift. Do not apply.
15. **Wait for the native Uncategorized promotion** (section 8), condition-based and bounded. Do not force it.
16. **Bootstrap audit #2.** The lifecycle blocker is gone and drift remains.
17. **First legitimate `bootstrap apply`.** Task 38B authorizes it on this clean database.
18. **Final audit.** Hard gate: `PASS (pass 36, drift 0, blocked 0, gated 1)`.
19. **Second apply.** It must report no change.
20. **Security and configuration acceptance** (section 11).

Capture as evidence: the values of steps 1, 4, 5, 9–11 and 13; every audit and apply output; the times of schema creation, admin creation and native promotion; and the acceptance outputs of step 20.

## 7. Theme contract

**The container definition does not install the theme.** `cannlabs-prodlike.yml` clones the plugin only. The theme is installed into the running instance afterwards, as product state, from `https://github.com/leo-even/CannLabs-Community-Theme.git` at tag `v0.1.0`, and the installed commit must equal `aeb3a9d9154f532064dcc24ac9e78cf587588d77` (`DEC-036`: install by tag, verify the exact SHA). The YAML alone does not make the theme present. The product bootstrap audits the pin (`config/cannlabs_community/bootstrap.yml` → `theme`).

Step 13, after the remote tag check of step 3. It uses the native importer, no secret, and aborts unless the installed commit is exact:

```bash
docker exec -i -u discourse -w /var/www/discourse cannlabs-prodlike bin/rails runner - <<'RUBY'
theme = RemoteTheme.import_theme(
  "https://github.com/leo-even/CannLabs-Community-Theme.git",
  Discourse.system_user,
  branch: "v0.1.0",
)
remote = theme.remote_theme.reload
puts "theme id=#{theme.id} name=#{theme.name} branch=#{remote.branch} local_version=#{remote.local_version} error=#{remote.last_error_text.inspect}"
abort "THEME COMMIT MISMATCH" unless remote.local_version == "aeb3a9d9154f532064dcc24ac9e78cf587588d77"
RUBY
```

Task 37B.1 imported the same tag as the synthetic admin; this form uses the system user. If it fails, stop and report. Do not substitute another user or ref.

## 8. Product bootstrap and the native Uncategorized lifecycle

Use the repository's bootstrap, not a copy of its rules: `docs/cannlabs-community/08_PRODUCT_BOOTSTRAP.md`. Run inside the container with `PROFILE=production`; exit status `0` PASS, `1` DRIFT, `2` BLOCKED, `3` usage error:

```bash
docker exec -u discourse -w /var/www/discourse -e PROFILE=production cannlabs-prodlike \
  bin/rake cannlabs_community:bootstrap:audit     # or :apply
```

The bootstrap runs as the system user and needs no admin. The admin is needed by the upstream promotion workflow.

**A clean site cannot converge at once.** The special Uncategorized category must first be replaced by the native upcoming change `remove_and_replace_uncategorized`, and the bootstrap reports `BLOCKED` until then. In the pinned source the native scheduler (`Jobs::CheckUpcomingChanges`, every 20 minutes) promotes it once these gates hold (confirmed by the Task 38B cold build):

- a human admin exists (`User.human_users.admins`);
- the site counts as existing: the earliest `schema_migration_details` row is more than one hour old (`Migration::Helpers.existing_site?`);
- the scheduler's upcoming-change processing then runs (every 20 minutes).

Nothing else has to be prepared. On a fresh site `allow_uncategorized_topics` is `false` by upstream default and the promotion still happens, because a change at `stable` status, above the default `promote_upcoming_changes_on_status` of `beta`, already counts as enabled on a new site. `allow_uncategorized_topics` is therefore not a prerequisite, and nothing may turn it on.

Do not change `allow_uncategorized_topics`, the upcoming change or any related setting manually, and do not call `remove_and_replace_uncategorized` yourself. Task 37B.1 observed schema creation at T0, the admin at about T+4 minutes, native `automatically_promoted` at about T+65 minutes, and the first successful apply immediately after; Task 38B.3 on the independent host saw the admin at about T+7 minutes and promotion at about T+69 minutes. **Do not turn "65 minutes" into a fixed sleep.** Wait on the condition: poll every 5 minutes, bounded (suggested bound: 150 minutes from schema creation), and stop and report if it is not met. The condition is all of:

- a system `automatically_promoted` event exists for `remove_and_replace_uncategorized`;
- `SiteSetting.uncategorized_category_id` is `-1`;
- the audit no longer reports the lifecycle blocker (exit status is not `2`).

```bash
docker exec -i -u discourse -w /var/www/discourse cannlabs-prodlike bin/rails runner - <<'RUBY'
promoted = UpcomingChangeEvent.where(
  upcoming_change_name: "remove_and_replace_uncategorized",
  event_type: :automatically_promoted,
  acting_user_id: Discourse.system_user.id,
).exists?
puts "native_promotion=#{promoted} uncategorized_category_id=#{SiteSetting.uncategorized_category_id}"
RUBY
```

Expected transitions (do not overfit exact counts; upstream internals change them):

| Moment | Audit | Action |
| --- | --- | --- |
| Before native promotion | `BLOCKED` plus `DRIFT` (Task 37B.2B saw `BLOCKED` on an empty database) | No apply. |
| After native promotion, before apply | No lifecycle blocker; `DRIFT` remains | Apply is now legitimate. |
| First apply | Product configuration is created and applied | Record the summary. |
| Final audit | `PASS (pass 36, drift 0, blocked 0, gated 1)` | Hard gate. |
| Second apply | `NO CHANGE` | Idempotence proof. |

`REHEARSAL FALLBACK — NOT ACCEPTANCE`: forcing the promotion by hand may be tried on a rehearsal. Final acceptance must prove the upstream scheduler lifecycle. The bootstrap is not a production installer.

## 9. Synthetic first admin (`PRODLIKE ACCEPTANCE ONLY — NOT PRODUCTION ADMIN BOOTSTRAP`)

A clean installation must have exactly one synthetic human admin before the native promotion can happen (section 8). This is not a production first-admin process. The production procedure (a real human, no developer emails, mandatory 2FA, two administrators) is `STAFF_SECURITY.md` (`DEC-044`). Production has two human administrators; the native promotion needs only that one human admin exists, so the second one does not affect it.

The password exists only in process memory: it is never printed, stored, committed or used, nobody logs in as this user, and it is destroyed with the disposable environment. The email uses the `.test` domain. The runner repeats the steps of the upstream `bin/rake admin:create` (validated in Task 37B.1, there with an operator-entered password): create the user, activate it, grant admin, set trust level 1 and confirm the email. It aborts unless exactly one active human admin results.

```bash
docker exec -i -u discourse -w /var/www/discourse cannlabs-prodlike bin/rails runner - <<'RUBY'
admin = User.new
admin.email = "acceptance@community-prodlike.test"
admin.username = "prodlike_acceptance"
admin.name = "Prodlike Acceptance"
admin.password = SecureRandom.hex(24)
admin.save!
admin.active = true
admin.save!
admin.grant_admin!
admin.change_trust_level!(1) if admin.trust_level < 1
admin.email_tokens.update_all(confirmed: true)
admin.activate
admin.reload
humans = User.human_users.admins
puts "synthetic admin id=#{admin.id} admin=#{admin.admin} active=#{admin.active} email_confirmed=#{admin.email_confirmed?} human_admins=#{humans.count}"
abort "ADMIN PRECONDITION FAILED" unless admin.admin && admin.active && humans.where(active: true).count == 1
RUBY
```

## 10. Backup and restore (native Discourse; reference only, not part of Task 38B)

- Backup: the native `discourse backup` inside the container (database and uploads). Backups hold private data: never commit one, and keep a copy outside the instance's `/shared`. The validated backup is not stored in Git. A backup changes nothing underneath the running application and needs no restart.
- Restore: `discourse enable_restore`, place the backup under `/shared/backups/default/`, then `discourse restore <file> --no-disable-emails`. **`--no-disable-emails` is required** (`DEC-038`); without it the stock restore changes `disable_emails` from `no` to `non-staff`.
- `allow_restore` must be enabled for a restore and returns to `false` in the validated flow.
- Expected side effects: the Redis-backed store and sessions are flushed; scheduled post-restore maintenance runs; `remote_themes` may gain two empty built-in rows from the restore's seed step. None of them is drift.

### Restore acceptance contract (`DEC-045`)

**A native restore replaces the database underneath web workers that are already running, and those workers do not notice.** Each worker keeps `SiteSetting` in memory and re-reads the database only when a `/site_settings` message tells it to. The restore refreshes the settings only in the process that runs it and publishes nothing to the others (`lib/backup_restore/restorer.rb`), and Pitchfork forks its workers from a mold process that was started before the restore (`config/pitchfork.conf.rb`, `Discourse.after_fork` re-subscribes but does not refresh). Measured on the retained prodlike instance (found by Task 40C, reproduced and closed by Task 40C.1): after the Task 37B.2B restore the database, a fresh Rails process and the bootstrap audit all said `login_required=true`, `pt_BR`, chat off and default theme 1, while the running workers served `login_required=false`, `en`, chat on, theme `-1`, the install wizard on `/`, and answered `/about.json` and `/directory_items.json` to anonymous requests. `/srv/status` returned `ok` throughout. One `./launcher restart` converged the instance with no change to the database.

**`/srv/status` is a liveness check. It is necessary and never sufficient after a restore.** Restore acceptance is declared VALIDATED only after all six steps, in this order:

1. The restore completes: `[SUCCESS]` in its output and exit status 0.
2. Restart the application runtime with the supported mechanism, without rebuilding: `cd /var/discourse && ./launcher restart <container>`. At the pinned launcher this is `docker stop -t 600` followed by `docker start` of the **existing** container: the same container and image, no bootstrap, no definition change. Measured: the restart took about 5 seconds and the web stack answered after about 20. Do not substitute `rebuild`, and do not substitute a worker-only reload: workers fork from the old mold, so a reload is not shown to refresh them (not tested).
3. Wait for health: poll `/srv/status` until it answers `ok`, with a bound (suggested 5 minutes), and stop and report if it does not. This proves liveness only.
4. The database and bootstrap audit passes, run in a fresh process: `docker exec -u discourse -w /var/www/discourse -e PROFILE=production <container> bin/rake cannlabs_community:bootstrap:audit` prints `PASS` with `drift 0, blocked 0, gated 1` (the prodlike pin `73b2484d…` has `pass 36`; an application pin that owns `allow_index_in_robots_txt`, such as the production definition's, has `pass 37`), and `allow_restore = false`, read-only mode is off and `disable_emails = no`.
5. The live anonymous HTTP gate passes against the **running** workers: `python3 ops/discourse/anonymous_http_acceptance.py --base-url <url> --host-header <host> --expect-locale pt_BR` prints `HTTP_ACCEPTANCE=PASS` (exit status 0). Run it from the host that serves the instance, with the container's published address for `<url>`.
6. Only then declare restore acceptance VALIDATED. `FAIL` (exit 1) is a blocker. `INCONCLUSIVE` (exit 2: unreachable, rate-limited or 5xx after retries) is not a pass: investigate and re-run.

**What the gate checks (`anonymous_http_acceptance.py`).** Anonymous GETs only, no credentials, no cookies, no synthetic data needed. It asserts semantic invariants, not one status code: the live process reports `login_required=true` (`/site/basic-info.json`) and so does the app shell's boot data; the expected locale if given; `/` is not the install wizard; the anonymous boot data carries no categories, topic lists or user; every one of 17 representative data endpoints is **denied** (a login redirect, 401 or 403) or absent (404), and never a 2xx or an unexpected redirect; the always-reachable `/site/basic-info.json` holds only reviewed keys and `/site/statistics.json` only numbers. Upstream answers anonymous data requests with a login redirect (HTML) or 403 `not_logged_in` (JSON), and a few routes are reachable by design (`/`, `/login`, `/signup`, `/site/*`, `/session/csrf.json`, `/session/hp.json`, `/manifest.webmanifest`, `/service-worker.js`, `/robots.txt`, `/srv/status`); those are checked for content, not for denial. It paces itself (about 0.5 s per request, 30 to 60 seconds in all) to stay under the definition's nginx rate limits, which answer 429. `--require-noindex` additionally demands that `robots.txt` blocks every other crawler and that pages carry noindex; it is not part of restore acceptance and belongs to the later production-ingress gate. Run `--self-test` to verify the script itself.

Known and out of scope for the gate: with the default `allow_index_in_robots_txt = true`, `/login` and `/signup` are crawlable and send no noindex header, and `/site/statistics.json` returns aggregate counts anonymously. Both are Task 40D items; the gate reports them as `INFO`.

**Task 37B interpretation.** The native backup and restore mechanics are VALIDATED (Task 37B.2). The restore acceptance recorded in Task 37B.2B passed the audit but did not check the running workers; Task 40C.1 closes that gap on the retained instance, and this contract applies to every later restore.

## 11. Security hardening contract and bounded acceptance

The YAML is the implementation authority. Its `run:` section does the following, each step with a guard that fails the build when stock config drifts, because `pups replace` is silent when its pattern does not match:

- nginx access log uses a safe request representation (method, redacted path, protocol: no query string) and a Referer reduced to its origin; credential-bearing routes become `[FILTERED]`.
- nginx `error_log` is `emerg`, the only level without request context.
- nginx logrotate creates 0640 files and keeps the stock 7 rotations.
- Log directories `/var/log/nginx` and `/shared/log/rails` are created idempotently with their runtime owners and mode 0750 (fresh-install safe), then checked.
- `nginx -t` runs last.
- Docker `json-file` log limits come from `docker_args`.

**Task 38B step 20 is bounded; it does not repeat the full Phase 15 suite.** No real credentials, no OAuth tokens, no password-reset emails, no broad sentinel matrix.

1. **nginx hardening.** `docker exec cannlabs-prodlike nginx -T` shows exactly one active `error_log /var/log/nginx/error.log emerg;`, a `log_discourse` format that contains `$cannlabs_log_uri` and `$cannlabs_log_referer` and neither `"$request"` nor `"$http_referer"`, and the outlet `35-cannlabs-log-redaction.conf`; `/etc/logrotate.d/nginx` creates 0640; `/shared/log/rails` is `750 discourse:www-data`. Do not require `/var/log/nginx` to be 0750 at run time: the stock runit service resets it on every start (section 12), and the YAML guard checked it at build time.
2. **Redaction modules loaded:**
   ```bash
   docker exec -i -u discourse -w /var/www/discourse cannlabs-prodlike bin/rails runner - <<'RUBY'
   checks = {
     path_secret_request: ActionDispatch::Request.ancestors.include?(CannlabsPathSecretRedaction::RequestExtension),
     rails_log_subscriber: ActionController::LogSubscriber.ancestors.include?(CannlabsLogMessageRedaction::Subscriber),
     logster_env: Logster::Message.singleton_class.ancestors.include?(CannlabsLogsterSecretRedaction),
     logster_logger: Logster::Logger.ancestors.include?(CannlabsLogsterMessageRedaction),
   }
   puts checks.inspect
   abort "REDACTION MODULE MISSING" unless checks.values.all?
   RUBY
   ```
3. **One synthetic sentinel** (not a credential), sent to the loopback port:
   ```bash
   SENTINEL=$(head -c 16 /dev/urandom | od -An -tx1 | tr -d ' \n')
   curl -sS -o /dev/null -H 'Host: community-prodlike.test' "http://127.0.0.1:80/u/password-reset/$SENTINEL"
   ```
4. **Raw value absent** from every sink: all files under `/var/log/nginx` and `/shared/log/rails` (`docker exec cannlabs-prodlike grep -rlF -- "$SENTINEL" /var/log/nginx /shared/log/rails` lists nothing), `docker logs cannlabs-prodlike` (no match), and the Logster store (a runner scanning `Logster.store.latest(limit: 1000)` messages and environments finds none).
5. **`[FILTERED]` appears where expected:** `/u/password-reset/[FILTERED]` in the nginx access log, and in the Rails request log where it records the request line.

## 12. Known retained findings (not reopened here)

Recorded in `docs/cannlabs-community/02_PROJECT_STATE.md` → TASK 37B: the stock runit service resets nginx runtime log permissions on every start; `error_log emerg` trades observability for secrecy; the zero-leak logging guarantee is bounded to the proven secret shapes; the prebuilt asset tarball returns 404 and assets build locally; a launcher rebuild causes downtime.

## 13. Independent-host acceptance

**Isolation.** The final run needs a fresh VM or a separate physical host with an independent network namespace, Docker daemon and `/var/lib/docker`, and no inherited Community filesystem, `/var/discourse`, `/shared`, Docker images, Community containers or Community environment variables. It is a **cold build**. The validated current environment must stay untouched: the run never stops or modifies the existing prodlike instance.

**Allowed inputs:** public GitHub repositories; exact public Git SHAs and tags; Ubuntu public package sources; the official Docker apt source and key; public Docker Hub images by tag or digest; the tracked Community artifacts; documented non-secret values.

**Forbidden inputs:** anything from the existing `/var/discourse` or `/shared`; the rollback tree and the failed zero-state tree; `/root/prodlike-backups`, `/root/prodlike-logs`, `/root/validate-37b2b` and `/root/p15`; old Docker images, Docker exports and `docker save` output; the current DEV worktree or any local worktree copy; shell history; Docker apt keys copied from another host.

**What a pass means.** `MACHINE-INDEPENDENT PRODUCTION-LIKE DEPLOYMENT REPRODUCIBILITY — VALIDATED` is claimed only if the run happens on an independent fresh VM or physical host and passes. Task 38B passed it on 2026-10-05 on a Google Compute Engine VM. It means that, using only the tracked deployment canon, pinned public sources and documented non-secret values, an operator reproduced the exact source pins, the deployment guards, the security hardening, the exact theme, Qualified Access and the product bootstrap final state `36 / 0 / 0 / 1`. It does **not** imply production readiness, production DNS or TLS, production secret delivery, external SMTP, production OAuth, billing, staff 2FA, Legal / LGPD / Trust & Safety readiness, a production first-admin process, or disaster-recovery restore on the second host.

## Environment and secrets boundary

**This repository may contain:** non-secret deployment configuration, exact pins, prodlike hostnames, localhost bindings, Mailpit configuration and safe environment-variable names.

**This repository must not contain:** SMTP passwords, OAuth client secrets, private keys, API tokens, backup files or production credentials.

**Production secrets: `DECIDED` (`DEC-042`).** They reach the container only through one root-only host file passed with `docker_args: --env-file`, as specified in `SECRETS.md`. Never put a real secret into a tracked YAML, into an `env:` block or into a template: those routes print the values in launcher output and process arguments. `DISCOURSE_DEVELOPER_EMAILS` is forbidden in production. No secrets manager or vendor is chosen.

## Drift protection

Enforced by `spec/lib/cannlabs_community/prodlike_deployment_parity_spec.rb`, for both `cannlabs-prodlike.yml` and `cannlabs-production.yml` (no runtime dependency; it only reads tracked files):

1. The Qualified Access repository and commit in the YAML equal `plugin` in `config/cannlabs_community/bootstrap.yml`.
2. The nginx credential-path rules in the YAML mirror `CannlabsPathSecretRedaction::RULES` (`config/initializers/zz-cannlabs-path-secret-redaction.rb`).

`spec/lib/cannlabs_community/production_secrets_contract_spec.rb` guards the secrets contract (`SECRETS.md`): it fails if a populated `*.env` file is tracked, if any non-Markdown file here mentions the developer-emails variable or holds a private key or a `secret_key_base`-shaped literal, if a tracked definition's `env:` holds a secret-class value, or if `production.env.example` holds anything but `<PLACEHOLDER>` values or an undocumented name.

`spec/lib/cannlabs_community/production_deployment_spec.rb` guards the production definition (`PRODUCTION.md`): see section 15 of that file.

`spec/lib/cannlabs_community/staff_security_runbook_spec.rb` guards the staff security runbook (`STAFF_SECURITY.md`): it fails if the first admin, its enrollment and the second admin do not come before the enforcement section, if a command block instructs `/finish-installation`, `rake admin:invite`, `RANDOM_PASSWORD`, a script-set password or turning enforcement off, if the runbook holds a secret-shaped value or an email address, or if its audit snippet stops parsing, writes anything or prints a second-factor secret.

`spec/lib/cannlabs_community/post_restore_acceptance_spec.rb` guards the restore acceptance contract (section 10) and `anonymous_http_acceptance.py`: it fails if the six numbered steps lose their order (restore, restart, health, audit, live HTTP gate, validated), if a step instructs a rebuild, if the contract stops calling `/srv/status` liveness-only or stops saying a backup needs no restart, if the script imports outside the standard library, sends anything but a plain GET, handles cookies or credentials, or if its `--self-test` fails.

Checked by the fresh-host run, not by the spec: the application pin is an ancestor of the canon commit (`git merge-base --is-ancestor`, section 2). Documented coupling, not enforced: the theme pin lives in the bootstrap manifest and `DEC-036`, not in the YAML; any new definition needs its own validation, hash and Decision Log entry.
