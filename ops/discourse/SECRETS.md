# CannLabs Community — production secrets delivery contract

> **DECIDED (`DEC-042`).** Real production secrets reach the container only through one root-only host file, passed with the launcher's native `docker_args: --env-file`. No secret is ever tracked in Git. No production infrastructure exists yet: this contract was rehearsed locally on a disposable instance with fake secrets (Task 40A), and it binds no hostname, provider, region, TLS shape or VM size.

This file is the authority for how secrets are delivered. `README.md` describes the validated prodlike deployment; `cannlabs-prodlike.yml` is unchanged and carries no secret.

## 1. The contract

1. All secret values live in **one host file**, `/etc/cannlabs-community/production.env`: mode `0600`, owner `root:root`, in a `0700` directory. It is outside every Git checkout, outside `/shared` (which is mounted into the container) and outside the `discourse_docker` checkout.
2. The tracked production definition names that file only by path, in its `docker_args` (for example `docker_args: "<network and log options> --env-file /etc/cannlabs-community/production.env"`). `docker_args` is read from the container definition only, and applies to both bootstrap and start.
3. The tracked definition's `env:` block holds no secret-class name at all. Non-secret values (hostname, SMTP address and port, and similar) may be tracked. A key must never appear in both places.
4. `DISCOURSE_DEVELOPER_EMAILS` is **forbidden** everywhere in production (section 9).
5. `production.env.example` lists the names with `<PLACEHOLDER>` values. A populated copy is never committed (a spec enforces this).

## 2. What is delivered how

| Secret class | Name (in `production.env`) | Route | Stored in the app DB and native backup? |
| --- | --- | --- | --- |
| SMTP credentials | `DISCOURSE_SMTP_USER_NAME`, `DISCOURSE_SMTP_PASSWORD` | environment only (global settings) | No |
| Google OAuth client secret | `DISCOURSE_GOOGLE_OAUTH2_CLIENT_SECRET` | environment shadows the site setting; hidden from the admin UI | No (0 rows in the rehearsal) |
| S3-compatible backup credentials | `DISCOURSE_S3_ACCESS_KEY_ID`, `DISCOURSE_S3_SECRET_ACCESS_KEY` | same shadowing rule | No |
| `secret_key_base` | `DISCOURSE_SECRET_KEY_BASE` | environment, exactly 128 lowercase hex characters (section 7) | No |
| Database password | none | the single container uses a unix socket and has no database password | not applicable |
| Future provider or API secrets | `DISCOURSE_` + the upper-cased site-setting name | the same shadowing rule | No, when shadowed |
| **Apple private key (`apple_pem`)** | none | **cannot travel by environment** (multi-line). It is a DB-stored site setting, set through a Rails runner fed on stdin, never through the admin UI | **Yes** |

Notes:
- The environment name is `DISCOURSE_` plus the setting name in capitals. A setting whose name already starts with `discourse_` therefore gets a doubled prefix.
- A shadowed setting becomes read-only and hidden in the admin UI. That is expected.
- `apple_pem` is not flagged `secret` in the bundled plugin, so a value typed in the admin UI is written raw into the staff action log (`lib/site_setting_extension.rb`: only `secret` settings are logged as `[FILTERED]`). Set through a runner it wrote no staff-log row in the rehearsal. It is stored in the DB and therefore in every native backup, so backups must be handled as secret-bearing.
- Apple's client, team and key identifiers are identifiers, not secrets, and may live in the tracked definition or the DB.
- Facebook is not part of V1 (`DEC-034`) and has no entry here.

## 3. File format (verified)

One `KEY=VALUE` per line. `docker --env-file` passes values verbatim (`=`, `#`, backslash and quotes are kept), but the container then writes them into `discourse.conf` through `/etc/runit/1.d/copy-env`, which Discourse reads line by line and runs through ERB (`app/models/global_setting.rb`). So a value must **not** contain a single quote (it is silently truncated), `<%` (evaluated as ERB), a newline, or leading or trailing whitespace. Generate secrets from letters, digits and `+/=_-.`. Check the file before every deploy; this prints line numbers only, never values, and prints nothing when the file is valid:

```bash
sudo stat -c '%a %U:%G %n' /etc/cannlabs-community /etc/cannlabs-community/production.env   # expect 700 root:root and 600 root:root
sudo grep -nvE '^#|^$|^[A-Z][A-Z0-9_]*=[^[:space:]]' /etc/cannlabs-community/production.env | cut -d: -f1   # lines that are not KEY=VALUE
sudo grep -nE "'|<%|[[:space:]]$" /etc/cannlabs-community/production.env | cut -d: -f1                     # unsupported characters
sudo grep -c '^DISCOURSE_DEVELOPER_EMAILS' /etc/cannlabs-community/production.env                          # must print 0
```

A missing file fails closed: `docker run --env-file` exits 125 and no container is created. The launcher does not check the file's permissions (it only warns about a world-readable container definition), so the `stat` check is mandatory. After any `launcher start` or `rebuild`, confirm `/srv/status` answers: `launcher start` can exit 0 even when the underlying `docker run` failed.

## 4. Why this mechanism (candidates proven against the pinned launcher)

All code evidence is `discourse_docker` `8d705a91866c320592ce851f30895ddb4c3e85fe`. Exposure was measured with fake sentinel secrets.

| Candidate | Supported at the pin? | Result |
| --- | --- | --- |
| **A. Untracked secrets-only template listed under `templates:`** | Yes (`set_template_info` reads each template with `cat`; the config file is merged last and wins) | **Rejected.** Values become `-e KEY=VALUE` arguments. `run_start` runs under `set -x`, so `launcher start` and `rebuild` print every secret (1 occurrence per secret in the trace); the bootstrap `docker run` shows them in `ps` argv for the whole build |
| **B. Complete untracked runtime YAML with secrets in `env:`** | Yes | **Rejected**, same code path and same two exposures as A |
| **C. Root-only host file via `docker_args: --env-file`** | Yes (`merge_user_args`, used by both bootstrap and start) | **Chosen.** 0 secret occurrences in launcher output across `rebuild`, `restart`, `destroy`, `start` and `start-cmd`, and 0 in 261 `ps` samples over four builds |
| D. `DISCOURSE_<SETTING>` shadowing | Yes, but it is a naming layer on top of A, B or C | Used with C for site-setting secrets |
| E. Other | `--docker-args` on the command line is the same as C but puts the option in the shell command. Mounted secret files (`/run/secrets`) are not read: Discourse reads only `discourse.conf` and `DISCOURSE_*`, with no `_FILE` convention | Not used |

## 5. Measured exposure (chosen mechanism)

Rehearsal with fake secrets, final state after two rotations. `PRESENT` and `ABSENT` are measurements. `ROOT-ONLY` means the access boundary, not a measurement of content. Nothing here is "secure": every `PRESENT` is reachable by whoever has root or the `docker` group on the host.

| Where | Env-delivered secrets (SMTP, Google, S3, `secret_key_base`) | DB-stored `apple_pem` |
| --- | --- | --- |
| Source file | ROOT-ONLY (`0600 root:root`, `0700` directory) | not applicable |
| Git (tracked tree, untracked files, final diff) | ABSENT | ABSENT |
| Launcher stdout and stderr | ABSENT | not applicable |
| Process arguments (`ps`, 3-second samples through every build) | ABSENT | not applicable |
| Operator shell history | ABSENT in the rehearsal root shell. Operators' own history is NOT PROVEN: never type a value on a command line, edit the file with an editor | ABSENT (script fed on stdin) |
| `docker inspect` container | PRESENT | ABSENT |
| `docker inspect` image | PRESENT (image configuration metadata) | ABSENT |
| Image history and flattened image filesystem | ABSENT | ABSENT |
| Container environment | PRESENT | ABSENT |
| `discourse.conf` in the container | PRESENT (`0600`, owned by `discourse`) | ABSENT |
| `~/boot_env` in the container (written at each start, `0644`) | PRESENT, inside the `0700` `/root` of the container | ABSENT |
| Rails database (`pg_dump`) | ABSENT | PRESENT |
| Native Discourse backup | ABSENT | PRESENT |
| Container logs and `/shared/log` | ABSENT | ABSENT |
| Host evidence and log files of the rehearsal | ABSENT | ABSENT |
| CI logs | NOT APPLICABLE (no CI) | NOT APPLICABLE |
| Public Docker images | NOT APPLICABLE: the image is never pushed | NOT APPLICABLE |

Trust boundary and rules that follow from it:
- The committed image `local_discourse/<name>` carries the secrets in its configuration (not in its layers). **Never push, save or share it**, and treat a VM snapshot or disk image of the host as secret-bearing.
- Do not paste the output of `docker inspect` or `docker exec … env` into any log, ticket or chat.
- Host access control (who has root or the `docker` group) is part of the security model.

## 6. Launcher logging rule

With `--env-file`, `set -x` in `run_start` prints only the file path. The normal workflow is therefore safe to log. Never use mechanism A or B, and never put a secret in `docker_args` itself.

## 7. `secret_key_base`

- Without `DISCOURSE_SECRET_KEY_BASE`, Discourse generates a key and keeps it in Redis (`GlobalSetting.safe_secret_key_base`). Redis data is not in a native backup. Rehearsed result: a plain restart kept the key; wiping the Redis state changed it, and an existing session token and a signed message both became invalid. A restore or a move to a new host therefore logs everyone out.
- With the value pinned in `production.env`, the same wipe changed nothing and the sessions stayed valid, and the key was identical across rebuilds.
- Format: exactly 128 lowercase hex characters (`/\A[0-9a-f]{128}\z/`). Anything else is replaced by a generated key and only a warning is printed, so check the effective value after deploy.
- Generate it outside Git (`openssl rand -hex 64`), keep it with the deployment recovery material (section 9), and never include it in a content backup.
- Discourse derives its auth-token digests and signed or encrypted cookies from it. **Rotating it logs every user out.** Rotate only deliberately.

## 8. Rotation runbook (measured behavior)

For SMTP, OAuth, S3 and other API-type secrets:
1. Create the new credential at the provider and keep the old one valid.
2. Edit `production.env` with an editor, then run the checks in section 3.
3. Run `./launcher rebuild <name>`. A `launcher restart` does **not** pick up the change (it restarts the existing container, which keeps its old environment). `destroy` then `start` does pick it up, but leaves the old value in the image configuration, so use `rebuild`.
4. Verify without printing: compare the first 12 hexadecimal characters of the SHA-256 of the effective value inside the container (for SMTP, `GlobalSetting.smtp_settings`) with that of the value in the file, and send a test message. Never print the value.
5. Revoke the old credential at the provider, and confirm that the old credential is rejected and the new one accepted.
6. **Remove the superseded images.** Each rebuild leaves the previous image holding the old values in its configuration. List the images, identify them by ID, remove them with `docker rmi <id>`, and re-check. Do not run a broad `docker image prune`.
7. Record the change (date, who, which credential), never the values.

For `secret_key_base`:
1. Decide deliberately. State that every session will end, and record why (for example a suspected leak).
2. Replace the value in `production.env` and run the checks in section 3.
3. Run `./launcher rebuild <name>` and remove the superseded images (step 6 above).
4. Verify that the effective key's 12-character hash changed to the new value's hash, and that an old session no longer works.
5. Keep a change or incident record.

Not rehearsed: deleting a key from the file (rebuild, then verify the variable is gone) and rotating against a real provider.

## 9. Backup and restore boundary

- **In a native Discourse backup:** everything stored in the database, which includes every secret that lives in a DB site setting (rehearsed: the fake `apple_pem`) and user data. Treat every backup as secret-bearing and protect it accordingly (encryption and the real destination are separate, later work).
- **Not in a backup:** env-delivered secrets and `secret_key_base` (rehearsed: ABSENT), and the file `production.env` itself.
- **Deployment recovery material, stored separately and securely:** `production.env` (especially the pinned `secret_key_base`), the tracked definition at its commit, and the pins in `README.md`. Restore the file first, then rebuild, then restore the backup. With the key pinned, sessions survive the restore.
- Restores keep the existing rule `--no-disable-emails` (`DEC-038`).

## 10. `DISCOURSE_DEVELOPER_EMAILS` is forbidden

Task 39A and the source (`lib/auth/default_current_user_provider.rb`, `make_developer_admin`) show that any active user whose email is in that variable is promoted to admin again at **every** login. The tracked production artifacts must not set it, template it or hold a placeholder for it. `spec/lib/cannlabs_community/production_secrets_contract_spec.rb` fails if any non-Markdown file under `ops/discourse/` mentions it. In the rehearsal the variable was absent and the application reported no developer emails. Check the host file with the `grep -c` line in section 3.

## 11. Limits: not proven

- Real S3, Google or Apple flows. Only the delivery and effective values were proven.
- A multi-line or escaped-newline `apple_pem` through the Apple plugin.
- Removing a key from the file.
- That the same key in both `--env-file` and `-e` resolves in a particular order: never define it twice.
- Disk or snapshot encryption, and host hardening: outside this task.

Evidence is kept outside the repository (masked, non-secret); see `docs/cannlabs-community/02_PROJECT_STATE.md` → TASK 40A.
