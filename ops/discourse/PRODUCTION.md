# CannLabs Community — production deployment definition and ingress contract

> **DEFINITION VALIDATED LOCALLY (`DEC-046`, `DEC-047`). NOT DEPLOYED. PRODUCTION — NOT READY.** `cannlabs-production.yml` is the tracked, non-secret definition that would be deployed to the production host. It was rehearsed once on a disposable local instance with a local certificate authority and fake secrets (Task 40D). **PUBLIC ACME ISSUANCE — NOT YET VALIDATED**: no real DNS, no real certificate and no real host were used. **PRODUCTION STARTING SIZE — HYPOTHESIS**: 2 vCPU, 8 GB RAM, one 80 GB SSD-class disk, São Paulo region preferred, none of it exercised on a real host.

This file is the authority for the production definition and for what must pass before public ingress opens. It does not choose a cloud provider, a firewall product, an SMTP provider or a monitoring service, and it creates no infrastructure. Related authorities: `SECRETS.md` (how secrets and host secret material are delivered), `STAFF_SECURITY.md` (first administrator and staff 2FA), `README.md` (the prodlike deployment, the product bootstrap and the restore acceptance contract). `cannlabs-prodlike.yml` stays byte-identical to the Task 37B validation and is not the production definition.

## 1. Decisions

| Decision | Status |
| --- | --- |
| Canonical application hostname `community.cannlabs.com.br` (Founder) | DECIDED, `DEC-046` |
| Portuguese alias `comunidade.cannlabs.com.br` redirects permanently to the canonical hostname (Founder) | DECIDED, `DEC-046` |
| One production VM, direct-host edge, no Cloudflare in V1 | DECIDED (Task 40C, accepted by the PM) |
| IPv4 only, no AAAA record, no IPv6 publication in V1 | DECIDED |
| Public TCP 80 and 443 only; the provider network firewall is the authoritative ingress control | DECIDED |
| TLS terminates in the Discourse nginx, through the official `discourse_docker` SSL and Let's Encrypt templates | DECIDED |
| Admin IP allowlist OFF in V1 unless a stable trusted egress path later exists | DECIDED (`STAFF_SECURITY.md` section 12) |
| São Paulo region preferred | PREFERENCE, not a binding |
| 2 vCPU / 8 GB / 80 GB SSD-class starting size | **HYPOTHESIS**, not validated |
| Public ACME issuance | **NOT YET VALIDATED** (needs real DNS and a real host) |

The alias is **not** a second Discourse origin, a second cookie scope, a second OAuth callback identity or a second canonical link target. All application-generated URLs, sessions, OAuth callbacks and email links belong to `community.cannlabs.com.br`.

## 2. The tracked definition

`ops/discourse/cannlabs-production.yml`, deployed as `containers/cannlabs-production.yml` of the pinned launcher checkout (`discourse_docker` `8d705a91866c320592ce851f30895ddb4c3e85fe`, detached, so the launcher's self-update never runs).

| Element | Value | Why |
| --- | --- | --- |
| `templates` | `postgres`, `redis`, `web`, `web.ratelimited`, `web.ssl`, `web.letsencrypt.ssl` | the prodlike set plus the official SSL and Let's Encrypt templates, in the order the official setup wizard writes them |
| `expose` | `0.0.0.0:80:80`, `0.0.0.0:443:443` | explicit IPv4 (section 8) |
| `docker_args` | `--log-opt max-size=10m --log-opt max-file=3 --env-file /etc/cannlabs-community/production.env` | the validated log rotation and the `DEC-042` secrets contract; no custom network, no Mailpit |
| `env` | `DISCOURSE_HOSTNAME=community.cannlabs.com.br`, `DISCOURSE_HOSTNAME_ALIASES=comunidade.cannlabs.com.br`, `UNICORN_WORKERS=4` | section 3 and section 5 |
| `params` | `db_shared_buffers: "2048MB"`, `db_default_text_search_config: "pg_catalog.english"` (as validated), `version:` the application pin | section 5 |
| `volumes` | `/var/discourse/shared/standalone` as `/shared`, and its `log/var-log` as `/var/log` | as the prodlike layout |
| `hooks` | the fork's origin, and the Qualified Access plugin cloned at its pin | as the prodlike definition |
| `run` | the prodlike hardening steps, unchanged, plus one production-only block | section 7 |

Pins:
- **Application:** the `version:` commit is the commit that owns `allow_index_in_robots_txt=false` in the production bootstrap profile (`DEC-047`). It is an ancestor of the canon commit, never equal to it. Changing it is a reviewed change with its own acceptance run.
- **Plugin:** the Qualified Access repository and revision equal `plugin` in `config/cannlabs_community/bootstrap.yml` (a spec enforces it).
- **Theme:** not installed by the definition. It is installed afterwards as product state at the revision in the same manifest (`README.md` section 6).

Not in the definition, on purpose: SMTP (the provider is not chosen; its non-secret address, port and authentication entries join `env` when it is, and its credentials go to the secrets file), any secret, Mailpit, `docker_manager`, Cloudflare, IPv6, any hostname other than the two above, and any developer-email variable.

## 3. Upstream review (pinned `discourse_docker`)

All of it was read from the code at `8d705a91…`. Where it could be exercised without a CA or real DNS (the generated outlets, the redirects, HSTS, cookies, the certificate-path rewrite, the publish arguments), it was also measured on the rehearsal instance; the ACME flow itself was not.

- **`web.ssl.template.yml`.** At every container start `configure-ssl` writes (a) a **catch-all** port-80 server with no `server_name` that answers every host with `301 https://${DISCOURSE_HOSTNAME}$request_uri` (so path and query are kept) and has a `/.well-known` location, and (b) HTTPS settings inside the application server: `listen 443 ssl`, TLS 1.2 and 1.3 only (read from the configuration), `Strict-Transport-Security: max-age=31536000`, and `if ($http_host != ${DISCOURSE_HOSTNAME}) { rewrite (.*) https://${DISCOURSE_HOSTNAME}$1 permanent; }`. The application server is `server_name _`. Static certificates at `/shared/ssl/ssl.crt` and `ssl.key` take precedence over Let's Encrypt.
- **`web.letsencrypt.ssl.template.yml`.** `DISCOURSE_HOSTNAME_ALIASES` (comma-separated) becomes extra `-d` arguments of `acme.sh --issue`, for both the RSA-4096 and the ECDSA certificate. So **additional hostnames on one certificate (SAN) are natively supported**. Certificates land in `/shared/ssl/<canonical>.cer`, `.key`, `_ecc.cer` and `_ecc.key`; the template rewrites the nginx certificate directives to use both. The default CA is set to `letsencrypt`. No account email is read at the pin. The flow runs at every container start (acme.sh skips a certificate that is not due) and renews through acme.sh's cron with `--reloadcmd "sv reload nginx"`.
- **`expose`.** An entry containing `:` is passed verbatim to `docker run -p` by the launcher; a bare port becomes `--expose`.
- **Host canonicalization.** Native: every Host other than the canonical one is redirected, on HTTP and on HTTPS.
- **IPv6.** `web.ipv6.template.yml` is deprecated; the templates write `listen [::]` inside the container whenever the container has IPv6 (`/proc/net/if_inet6`). What the host exposes is decided only by the `-p` binding (section 8).
- **Custom extension points.** nginx outlets under `/etc/nginx/conf.d/outlets/` (`before-server`, `server`, `discourse`). The SSL template regenerates its own outlet files at every start, so build-time edits to them are overwritten.

## 4. Canonical hostname and Portuguese alias

**The alias needs no custom nginx, no second container, no second `DISCOURSE_HOSTNAME` and no Cloudflare.** It is the smallest supported implementation (Option A, native): `DISCOURSE_HOSTNAME_ALIASES` puts the alias on the certificate, and the official templates already redirect every other host to the canonical URL. A custom outlet (Option B) was not needed. A provider-native redirect service (Option C) stays a documented alternative and is not implemented.

Measured on the rehearsal instance (local CA, certificate with both names, Host headers on loopback):

| Request | Result |
| --- | --- |
| `http://community…/<path>?<query>` | one `301` to `https://community…/<path>?<query>` |
| `http://comunidade…/<path>?<query>` | one `301` straight to `https://community…/<path>?<query>`: no chain |
| `https://community…` | the application; `Strict-Transport-Security: max-age=31536000`; `_forum_session` is `Secure; HttpOnly; SameSite=Lax` |
| `https://comunidade…` | TLS valid for the alias (SAN), then a `301` to the canonical URL with path and query kept; no application content, no cookie |
| any other Host, HTTP or HTTPS | `301` to the canonical URL |

An alias request never reaches the application, so it cannot create a session or an OAuth callback identity. The redirect is nginx's, produced before any application code runs. **DNS aliasing alone does not change the browser's URL**: the redirect is this HTTP and TLS behavior, so the alias needs a certificate and a listener on the same host.

## 5. Sizing profile

`UNICORN_WORKERS` and `db_shared_buffers` are written into the definition by the official setup wizard and are **not derived at runtime**; a hand-written definition keeps the template defaults (3 workers, 256MB), which is far too little database memory for an 8 GB host. The pinned wizard (`image/setup_wizard/lib/discourse_setup/resource_scaler.rb`) derives them:

- `db_shared_buffers` = 128MB for 1 GB, 256MB for 2 GB, otherwise `256MB × GB`, capped at 4096MB.
- `UNICORN_WORKERS` = `2 × GB` for 2 GB or less, otherwise `2 × CPU cores`, capped at 8.

**2 vCPU / 8 GB STARTING-SIZE PROFILE (a hypothesis, not a universal constant):** `db_shared_buffers: "2048MB"` and `UNICORN_WORKERS: 4`. The wizard counts cores as `lscpu` CPU(s) multiplied by threads per core, which on a VM that reports two threads per core would double-count and reach the cap of 8 workers on 2 vCPUs; the definition uses the documented intent (`2 × cores`), not that arithmetic. For reference, the Task 38B cold build on a 4 vCPU / 16 GB host idled at about 1.14 GiB with the default 3 workers; nothing here has been exercised under load.

If the VM is resized, nothing adjusts itself. Recompute both values from the formulas, change them in a reviewed commit, and `rebuild` (a rebuild is needed because the Postgres setting is applied at bootstrap).

## 6. TLS, ACME and certificate material

- **Public issuance needs real DNS and TCP 80.** HTTP-01 is the only challenge. It needs the A records, reachable port 80 for the first issuance **and for every renewal** (a certificate lives 90 days and acme.sh renews well before that), and no AAAA record (section 9). **PUBLIC ACME ISSUANCE — NOT YET VALIDATED.**
- **How the challenge is served at the pin.** At container start the template runs a temporary nginx on port 80 that answers the challenge for any host. Afterwards, with the main nginx running, the catch-all server's `return 301` runs before its `/.well-known` location, so a renewal request for either name is redirected to `https://community…/.well-known/acme-challenge/…`, which the main HTTPS server serves from the shared web root. Let's Encrypt documents that its validation follows redirects. The code and the redirect itself were read and measured; a real renewal was not (no CA was contacted).
- **Do not drop `/shared/ssl/ssl.crt` and `ssl.key`.** If both exist, the SSL template uses them and Let's Encrypt is silently skipped.
- **First start (read from the code, not measured).** The certificate step runs in the container's init scripts before the services start, so the site is down until issuance completes.
- **Alias certificate.** The alias is a SAN of the same certificate (RSA and ECDSA). Adding or removing an alias means a new issuance; it is a change to `DISCOURSE_HOSTNAME_ALIASES` and a `rebuild`.
- **HSTS.** `max-age=31536000` (one year), no `includeSubDomains`, no preload. Browsers will refuse plain HTTP to the canonical host for a year once they have seen it.
- **Rate limits.** Let's Encrypt limits duplicate certificates; keep `/shared/letsencrypt` across rebuilds and do not loop a failing issuance.
- **Certificate-expiry monitoring is required.** Nothing in the deployment alerts on a failing renewal. The external check in section 11 covers it.
- **Host and deployment secret material.** `/shared/ssl/*.key`, `/shared/ssl/*_ecc.key` and everything under `/shared/letsencrypt` (which includes the ACME account key and the issued private keys) are `HOST/DEPLOYMENT SECRET MATERIAL`: `0600`, root-owned, never in Git, never in a content backup that leaves the host unencrypted, never in a log or ticket. They are recoverable by re-issuance as long as DNS and port 80 work, so a lost host does not need them backed up; a backup that includes them must be treated as secret-bearing (`SECRETS.md` section 12).
- **Known and bounded.** The template downloads `acme.sh` from the upstream repository at a tag (not a content hash) during the build and runs `acme.sh --upgrade --auto-upgrade` at runtime. The temporary nginx writes `/var/log/nginx/access.letsencrypt.log` and `error.letsencrypt.log` in the stock formats, outside the hardened logging contract, during issuance only.
- **What was rehearsed.** The container with the official SSL and Let's Encrypt templates, ACME disabled and local certificates in place: the generated nginx outlets, HTTPS, the redirects, HSTS, cookies and the alias. The template's own certificate-path rewrite (`configure-letsencrypt`'s two `sed` commands, run verbatim) with RSA and ECDSA local certificates: nginx accepted the dual-certificate configuration and served the ECDSA key to an ECDSA client and the RSA key to an RSA client, and the alias verified on the same certificate.

## 7. Logging: the port-80 redirect server

The Task 37B.1 redaction covers the application server. The SSL template adds a second nginx server on port 80, written when the container starts, with no `access_log` of its own, so it inherits nginx's stock http-level default, which logs the raw request line, query string and Referer. **Measured:** a fake credential path requested over plain HTTP was written into `access.log` in full. A client that sends a credential URL over HTTP has already exposed it on the wire, but the log must not keep it on disk.

The production-only block of the definition (guarded like the validated steps) replaces that stock default with `cannlabs_http_safe`: time, host, client address, method, user agent, status and bytes sent. No request line, no query string, no Referer. Re-measured: the same requests left no token in the log; HTTPS requests to the application keep the validated `[FILTERED]` representation, and alias and unknown-host redirects log no URI. The `log_format` sits next to its use because `discourse.conf`, where the validated format lives, is included after the stock line.

Verify on the real host after the first deployment (a fake token only; never a real one):

```bash
curl -s -o /dev/null "http://community.cannlabs.com.br/u/password-reset/FAKE-TOKEN-CHECK?x=FAKE-TOKEN-CHECK"
sudo docker exec <CONTAINER> bash -c 'grep -c FAKE-TOKEN-CHECK /var/log/nginx/access.log'    # must print 0
```

The existing limits still apply: the nginx runtime log permissions are reset by the stock runit service at each start (an open `MEDIUM` of Task 37B), and `error_log` stays at `emerg`.

## 8. IPv6: do not enable in V1

`IPv6 V1 — DO NOT ENABLE YET.` The definition publishes only IPv4, with the explicit `0.0.0.0:` form. **Measured:** a bare `-p 80:80` makes Docker publish `0.0.0.0:80` **and** `[::]:80`; `-p 0.0.0.0:80:80` publishes IPv4 only. The pinned launcher turned the tracked definition into exactly `-p 0.0.0.0:80:80 -p 0.0.0.0:443:443`. nginx still listens on `[::]` inside the container; that is unreachable from outside while the host binding is IPv4. A spec fails if an `expose` entry is anything but those two IPv4 forms.

## 9. DNS contract

Records to create later, by hand, when the host exists (**no DNS is changed by this task**):

| Name | Type | Value |
| --- | --- | --- |
| `community.cannlabs.com.br` | `A` | the VM's static public IPv4 |
| `comunidade.cannlabs.com.br` | `A` | the same address |

- **No `AAAA` for either name** until IPv6 is deliberately validated. A stray `AAAA` makes browsers and the CA try IPv6 and fail.
- The alias uses an `A` record, not a `CNAME`, because it is a separate TLS name whose certificate and redirect are served by this host; a `CNAME` to the canonical name would also resolve but couples the alias to the canonical record for no benefit. Either works for the redirect; the contract uses `A`.
- No CAA record is required; if one is added it must allow `letsencrypt.org`.
- Lower the TTL before the cutover and keep it low until the acceptance in section 13 passes.

## 10. Firewall, client address and administration

**Provider network firewall is the authoritative ingress control.** Docker publishes ports by rewriting the host's packet filter, so a host-level `ufw` rule does not reliably restrict a published port. Do not rely on `ufw` alone for 80 or 443. Provider-neutral requirements (no firewall is changed by this task):

- **Public:** TCP 80 and TCP 443 (443 opens last, section 12).
- **Administrative:** SSH only through the provider's restricted access or a tunnel, or from tightly scoped source addresses. Never open SSH to the world.
- **Never public:** PostgreSQL, Redis, the Docker socket, any Mailpit, any debug port. The definition publishes none of them.

**Client-IP contract.** External IPv4 client → provider network → VM → Docker published IPv4 port → nginx `$remote_addr` → Rails request IP. nginx sets `X-Forwarded-For` to its peer address (`proxy_set_header X-Forwarded-For $remote_addr`), so a client-supplied header cannot override it; no proxy or CDN layer is added. **REAL-HOST ACCEPTANCE REQUIRED** because provider NAT was not measured: (1) a request from an external source is recorded with that source address, not a provider or Docker address (check a staff `UserAuthToken.client_ip`, or the nginx access log, from a known external address); (2) a request that sends its own `X-Forwarded-For` does not change what is recorded; (3) the nginx rate limits (`web.ratelimited`) see the external source; (4) staff login records show the expected source.

## 11. External health contract

`/srv/status` is **shallow liveness only**. It answers `ok` while the workers can be stale (`DEC-045`). External monitoring is a later choice and no service is chosen here. It needs three signals: (1) HTTPS `/srv/status` on the canonical hostname; (2) the certificate's remaining validity, alerting well before the 30-day mark; (3) the privacy canary, which is `anonymous_http_acceptance.py` run on a schedule from outside. A provider load-balancer or health check that probes the IP address or a different Host receives the canonicalization redirect, not `ok`.

## 12. Opening sequence (provider-neutral)

The first administrator exists with a password alone until enrolled (`STAFF_SECURITY.md`), and nothing is protected by a gate until the product bootstrap converges. So public 443 is the **last** step. Do not skip or reorder.

1. The VM, its static public IPv4 and the provider network firewall exist. TCP 443 is closed to the world, and so is TCP 80. SSH follows section 10.
2. The host has Docker and the pinned launcher checkout. `/etc/cannlabs-community/production.env` exists root-only and passes the `SECRETS.md` section 3 checks, including the developer-emails check. `containers/cannlabs-production.yml` is byte-identical to the tracked file. `/shared/ssl` holds no `ssl.crt`.
3. DNS: the two A records point at the static IPv4 and there is no AAAA (section 9). Check from outside the VM that both names resolve to it.
4. Open **TCP 80 only** to the world. ACME HTTP-01 needs it for issuance and for every renewal. Port 80 serves only the redirect and the ACME path, never application content. TCP 443 stays closed.
5. Deploy: `cd /var/discourse && ./launcher rebuild cannlabs-production`. The first start issues the certificate for both names. Confirm the certificate files exist in `/shared/ssl`, `docker ps` shows only `0.0.0.0` bindings and `ss -ltn` shows no `[::]:80` or `[::]:443` listener on the host.
6. Create the first human administrator with `bin/rake admin:create` on the terminal (`STAFF_SECURITY.md` section 4). The holder types the password.
7. Allow TCP 443 **only from the first operator's address** in the provider firewall, because browser 2FA enrollment needs HTTPS.
8. Enroll the first administrator's TOTP and recovery codes (`STAFF_SECURITY.md` section 5).
9. Create and enroll the second administrator; add that person's address to the 443 rule (`STAFF_SECURITY.md` section 6).
10. Set `enforce_second_factor=staff` and run the staff security audit until it prints `STAFF_SECURITY_AUDIT=PASS` (`STAFF_SECURITY.md` sections 7 and 13).
11. Install the pinned theme and run the production bootstrap until `PASS (pass 37, drift 0, blocked 0, gated 1)`. On a fresh site the native Uncategorized lifecycle must happen first; wait on the condition, not on a fixed sleep (`README.md` sections 6 to 8).
12. Restart the application only where a validated procedure requires it: after a native restore (`DEC-045`). A bootstrap apply notifies the running workers through the native setting setter: in the rehearsal the gate passed right after `bootstrap:apply` with the container never restarted. Step 13 is what proves it on the real host.
13. Run the live anonymous HTTP and hostname gate from an allowed address, against the real hostnames (section 13). It must print `HTTP_ACCEPTANCE=PASS`; `INCONCLUSIVE` is not a pass.
14. Complete the real-host acceptance items of section 10 (client address, forwarded header, rate-limit source, staff login source) and the log check of section 7.
15. SMTP must already work: the provider is chosen, its credentials are in the secrets file, and a real message (a password reset to a staff address) was delivered. This is required before any real-member signup opens.
16. Re-run the staff security audit and the bootstrap audit; both must pass. Confirm the open items below are decided or accepted.
17. Open TCP 443 to the world (public, last).
18. Re-run the gate from an unrestricted external vantage point, record the result, and turn on the external monitoring of section 11.

**Open before step 17, not decided here:** the SMTP provider; the backup destination, encryption and a tested restore for this host; Legal, Privacy and Trust & Safety gates; the anti-spam mechanism for open registration (`DEC-043`).

## 13. Acceptance gates

`anonymous_http_acceptance.py` (stdlib Python, anonymous GETs only, `--self-test` built in) is the only privacy and ingress checker. Its hostname group (`N*` checks) was added for this contract; it does not duplicate the privacy group (`H*`).

Production pre-open gate, from an operator host with the real DNS and TLS, after step 12:

```bash
python3 ops/discourse/anonymous_http_acceptance.py \
  --base-url https://community.cannlabs.com.br --canonical community.cannlabs.com.br \
  --alias comunidade.cannlabs.com.br --expect-locale pt_BR --require-noindex
```

It asserts: the live process reports `login_required=true` and the expected locale; `/` is not the install wizard; anonymous boot data holds no categories, topic lists or user; 17 representative data endpoints are denied or absent; the always-reachable endpoints hold only reviewed content; `robots.txt` blocks every crawler except the documented Googlebot group and pages carry `noindex`; `/srv/status` is healthy. Hostname group: the canonical host serves the application over HTTPS on its own host with a valid certificate, HSTS of at least one year and Secure, HttpOnly cookies; plain HTTP redirects once and permanently to the canonical HTTPS URL with path and query kept; the alias, on both schemes and across a panel of paths, answers only a permanent redirect to the canonical URL with no application content and no cookie; an unknown Host is redirected too. A `429`, a `5xx` or an unreachable host is `INCONCLUSIVE`, never a pass; an invalid certificate is `FAIL`.

Restore acceptance (`README.md` section 10, step 5) uses the same script; on the production host run it with the real hostnames and the flags above, never against the loopback address.

Local rehearsal without DNS, as done in Task 40D: add `--connect-http 127.0.0.1:<port> --connect-https 127.0.0.1:<port> --cafile <rehearsal CA>`.

## 14. Private-site indexing (`DEC-047`)

`allow_index_in_robots_txt=false` is owned by the production bootstrap profile (`config/cannlabs_community/bootstrap.yml`, `profile_settings`). The setting defaults to `true`, which left `/login` and `/signup` crawlable, sent no `X-Robots-Tag` and served an indexing `robots.txt`. Native behavior with it off, measured on the rehearsal instance: `robots.txt` lets Googlebot crawl everything except `/uploads/*` (so that it can read the `noindex` header and drop the pages) and disallows every other crawler (`User-agent: *`, `Disallow: /`); every GET response the application renders (`/login`, `/signup`, `/site/basic-info.json`, `/robots.txt`) carries `X-Robots-Tag: noindex, nofollow`, while redirects, `/srv/status` and error answers do not. So it is not a strict disallow-all. Anonymous visitors only ever see the login pages, which carry `noindex`; a strict `robots.txt` would need the native `overridden_robots_txt` setting, which is not used (decision for the PM, not made here). The local profile leaves it `GATED`, so the DEV audit and state are unchanged. The production audit gains one pass: 37 passes against 36 at the prodlike pin.

## 15. Drift protection

`spec/lib/cannlabs_community/production_deployment_spec.rb` fails if: the canonical hostname is not exactly `community.cannlabs.com.br`; the alias is anything but the one SAN alias, or appears in custom nginx; a Cloudflare, IPv6, Mailpit or custom-network element appears; `expose` is anything but the two IPv4 forms; the secrets file is not the only secret route; the prodlike hardening steps stop being a prefix of the production `run:` steps or the production-only logging block loses its guards; the sizing values stop following the pinned formula; the plugin pin differs from the manifest; the application pin is not a full SHA or not an ancestor of HEAD; the bootstrap stops owning `allow_index_in_robots_txt=false`; the prodlike definition changes; or this file loses its labels, its opening-sequence order, or cites a commit that is not a known pin. The existing guards still apply to the new file: no secret, no private key, no developer-emails variable (`production_secrets_contract_spec.rb`).

## 16. Limits: not proven

- Public ACME issuance and renewal: no real DNS, host or CA was used. The challenge path through the redirect is read from code and measured only up to the redirect.
- Behavior behind the provider's real network: client address preservation, rate limiting by source, staff login sources.
- The starting size under load, and the sizing after a resize.
- A real firewall configuration, and that nothing but 80 and 443 is reachable from outside.
- SMTP, OAuth, backups and monitoring: not chosen or configured.
- Re-issuance after a lost `/shared`, and certificate renewal across a `rebuild`.
- That the production-only logging block survives a future upstream change of the SSL template (it is guarded and fails the build if the stock line is not exactly as reviewed).
