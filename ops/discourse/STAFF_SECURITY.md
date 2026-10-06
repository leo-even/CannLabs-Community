# CannLabs Community — production first-admin and staff security runbook

> **PROCEDURE VALIDATED LOCALLY (`DEC-044`). PRODUCTION ENROLLMENT NOT DONE.** This is the exact path from a freshly bootstrapped production site to human administrators protected by native two-factor authentication. It was rehearsed once on a disposable local instance with synthetic `.test` identities (Task 40B). No production host exists, and no real person, password, TOTP seed or recovery code was ever used. "Procedure readiness" is not "production enrollment complete": that stays **OPEN** until the real host exists and the real staff have completed section 5 and section 6 on it.

`SECRETS.md` is the authority for how secrets reach the container; this file is the authority for who may administer the site and how that access is protected. Nothing here chooses a hostname, provider, region, TLS shape, SMTP provider or VM size.

## 1. The contract

1. The first administrator is created with the upstream task `bin/rake admin:create`, run by an operator with host access, on an interactive terminal. Nothing else creates the first administrator. `DISCOURSE_DEVELOPER_EMAILS`, `/finish-installation`, `rake admin:invite`, `RANDOM_PASSWORD=1`, and a Rails runner that sets a password are **not** used (section 3 explains each).
2. At launch there are exactly **two standing human administrators**, each with their own account, their own authenticator device and their own recovery codes. There is no shared account, no standing "break-glass" account and no third standing administrator.
3. Native two-factor authentication is mandatory for all staff. `enforce_second_factor` is set to `staff` **only after** both administrators are enrolled, and every later staff member **enrolls before being promoted** (sections 7 and 8).
4. `enforce_second_factor = staff` is a navigation control, not an authentication boundary: JSON and API requests are exempt from it (section 9). The invariant that protects the site is "no staff account without a second factor", and the audit in section 13 is how it is checked.
5. Staff keep the least privilege that their work needs (section 2). API keys follow section 9. The admin IP allowlist stays off unless a stable trusted egress path exists (section 12).
6. Break-glass is a documented, logged procedure that always ends with the affected person re-enrolled (section 10).

## 2. Roles and the standing roster

| Role | Who | What it is for |
| --- | --- | --- |
| Admin | Two named humans (the Founder and one trusted backup) | Site settings, API keys, backups, themes and plugins, email logs, impersonation, role changes, forced logouts, disabling another user's 2FA, group membership, the Sidekiq and log dashboards |
| Moderator | CannLabs staff who moderate | Flags, silencing and suspending members, closing topics, reading the staff action log and reports, user list (without email addresses) |
| Ordinary member | Everyone else, including a staff member's non-staff account if one is ever needed | Nothing elevated |

Evidence for the split (Task 40B, section 14): an enrolled moderator could suspend, unsuspend, close a topic and read the staff action log. The same moderator was refused (HTTP 404 from the route constraint, or 403 from the guardian) for site settings, API keys, backups, themes, granting or revoking admin, granting moderation, forcing a logout, disabling another user's 2FA, and impersonation. By default a moderator does not see member email addresses (`moderators_view_emails` is `false`) and does see IP addresses (`moderators_view_ips` is `true`).

Rules:
- Use a moderator account for routine moderation; an admin may moderate in an emergency. Do not give admin because it is convenient.
- A new standing administrator beyond the two requires a recorded reason and a PM decision.
- Admin and moderator roles are never shared between people.

## 3. Prerequisites and why the other first-admin routes are not used

Before section 4:
1. The production bootstrap is healthy (`/srv/status` answers) and `SECRETS.md` is in force.
2. The developer-emails variable is absent. Run the two read-only checks in `SECRETS.md` section 3 (the `grep -c` on the host file must print `0`) and confirm inside the container: `sudo docker exec <CONTAINER> env | grep -c DEVELOPER_EMAILS` must print `0`. Never paste the output of `env` anywhere else.
3. The operator has host access (root or the `docker` group) and the account holder has a password manager.
4. **Ingress.** From the moment the first administrator exists until section 6 is finished, that account is protected by a password alone. Do sections 4 to 6 before the site is publicly reachable, or while ingress is limited to the operators. How that is arranged depends on the host slice and is not decided here. If it cannot be arranged, accept the window and keep it as short as possible.
5. Upstream rate limits apply to the operators too: 30 logins per hour and 6 per minute per source address, and 6 second-factor attempts per minute per address and per user. Several people behind one office address share the budget. Do not retry in a loop.
6. SMTP is not required for sections 4 to 7. It is required for the notification email upstream sends when someone's 2FA is disabled through the UI, and for the "forgot password" and invitation flows.

Routes that are **not** used, with the evidence:
- **`DISCOURSE_DEVELOPER_EMAILS`.** `make_developer_admin` re-grants admin to any active user whose email is listed, at every login (`SECRETS.md` section 10). Forbidden.
- **`/finish-installation`.** It only registers an address that is in the developer-emails variable. On the fresh rehearsal site, with the variable absent, the register page was served but a POST created nobody (HTTP 400, 0 users), and after the first admin existed it answered 403. It cannot create the first admin without the forbidden variable.
- **`rake admin:invite`.** It creates the account with a random password and sends a password-reset email, so it needs working SMTP and puts the first administrator's recovery on an email link.
- **`RANDOM_PASSWORD=1`.** It sets an unknown random password and prints nothing, so the account is unusable without a reset.
- **A Rails runner that sets `password`.** The password would have to be written into a script.

## 4. First admin (create)

On the host, as an operator, with the account holder present:

```bash
sudo docker exec -it -u discourse -w /var/www/discourse <CONTAINER> bin/rake admin:create
```

The task prompts for `Email:`, then `Password:` and `Repeat password:`, then `Do you want to grant Admin privileges to this account? (Y/n)`. Answer `y`. It prints `Account created successfully with username userN`.

- **The account holder types the password at the no-echo prompt.** An operator never types a password on another person's behalf. The password comes from the holder's password manager, is **at least 20 random characters**, is unique, and is never reused for anything else. The task does **not** enforce the admin minimum of 15 characters (a 12-character password was accepted and granted admin in the rehearsal, because the policy is checked only when the account is already an admin), so the length rule is procedural.
- Do not pass the password in a command line, an environment variable, a file or a script. The prompt is the only place it is entered. Use `-it` (a terminal); without one the no-echo prompt does not apply.
- Rehearsed exposure: the password never reached the terminal output, never appeared in any process argument list (host `ps` sampled every 0.25 s while the prompt was open), and was absent from the database dump (a salted hash only), the application logs and the container logs.
- Use an email address the human controls. The upstream task confirms it without sending anything.
- The username is generated as `userN` (email-based suggestion is off by default). Rename it to the person's chosen username (letters, digits, underscore) with the supported task:

```bash
sudo docker exec -u discourse -w /var/www/discourse <CONTAINER> bin/rake "users:rename[user1,<USERNAME>]"
```

- `rake admin:create` writes **no** staff action log row. Record the creation (date, operator, who the holder is, no secrets) in the operations record.

Verify (read-only; section 13 prints the same data): the account exists, is active, is an admin, and has no 2FA yet.

## 5. First admin: log in, enroll 2FA, store recovery codes

1. Log in normally at the site's login page with the username and password. First login is the normal local-login path; no developer email is involved. (The first administrator is also given the moderator flag by upstream at that login.)
2. Open the account's security preferences (`/u/<USERNAME>/preferences/security`). Add an authenticator app: confirm the password, scan the QR code or enter the key in the authenticator, and enter the six-digit code. The server must accept a valid code and refuse an invalid one.
3. In the same page generate **recovery codes**. Upstream generates **10** codes of 32 hexadecimal characters; each works **once** and only for login. Regenerating replaces all ten, so the old ones stop working. Store them as in "Custody" below before closing the page.
4. Log out and log in again with the password and a TOTP code to prove the second factor works. A password alone is now refused and a replayed TOTP code is refused (one use per 30-second step).
5. Run the audit (section 13). The first administrator must show `second_factor=yes totp=1 backup_codes_left=10`.

**Custody (synthetic values only were used in the rehearsal):**
- Each human keeps **their own** recovery codes and authenticator. Nothing is shared between the two administrators.
- Never put recovery codes or the TOTP key in the Community database (posts, messages, notes, profile fields), in Git, in a ticket, a chat, an email, a screenshot, a runbook record or a backup of the operations record.
- Keep the codes in the holder's password manager in a vault entry that does not live only on the phone that holds the authenticator, so one lost device does not lose both.
- A recovery code replaces the TOTP at **login only**. It is not accepted for the second-factor challenge that guards granting admin (the rehearsal refused it with HTTP 403). After a login with a recovery code, re-enroll the authenticator (section 10 steps 5 to 7).
- No standing break-glass copy of anyone's codes is kept. Break-glass is root access (section 10).
- The TOTP key is stored in the database in clear text (rehearsal, section 14), so every native backup and database dump contains it. Treat backups as secret-bearing (`SECRETS.md` section 9). The recovery codes and API keys are stored only as hashes.

## 6. Second admin

Do sections 4 and 5 again for the second human, with their own email, their own password typed at the prompt, their own authenticator and their own recovery codes. Upstream accepts a second `admin:create` while an admin exists.

Verify independence: the two accounts have different TOTP keys and different recovery codes (the rehearsal confirmed two distinct stored secrets), and the audit shows two administrators, both `second_factor=yes`.

Alternative after SMTP works (not rehearsed end to end): the second person signs up as an ordinary member, enrolls 2FA as an ordinary member, and the first administrator promotes them from the admin UI. That promotion asks for the first administrator's **TOTP** (not a recovery code) and works without SMTP. Rehearsed with a fixture user: the call returns 403 plus a challenge nonce, a recovery code is refused, a wrong TOTP is refused, and the correct TOTP completes the promotion and writes a `grant_admin` log row.

## 7. Turn enforcement on

Only when the audit shows **both** administrators with `second_factor=yes`, `staff_without_second_factor=0` and `admins_human=2`:

1. Set `enforce_second_factor` to `staff` in Admin → Settings (setting name `enforce_second_factor`; the supported values are `no`, `staff` and `all`). Upstream refuses other values, and it refuses `staff` while local logins are disabled or DiscourseConnect is enabled.
2. Leave `enforce_second_factor_on_external_auth` at its default `true`, and leave `enable_local_logins` on. With the default, a staff member who logs in with Google or Apple is still asked for their second factor.
3. Run the audit again; it must print `STAFF_SECURITY_AUDIT=PASS`.
4. Verify behavior: an enrolled admin and an enrolled moderator navigate normally; an unenrolled staff member is redirected from every browser page to `/u/<USERNAME>/preferences/second-factor`, where the setup page itself stays reachable.

Do not use `all` unless the PM decides it separately. Do not turn enforcement on first and enroll afterwards: it does not protect an unenrolled account (section 9).

## 8. Moderators and later staff

The order is **enroll, then promote**:
1. The person becomes an ordinary member (normal signup or an invitation).
2. They enroll TOTP and recovery codes as an ordinary member (sections 5 steps 2 to 4). Ordinary members can enroll; enforcement does not apply to them.
3. An administrator promotes them in Admin → Users (grant moderation; for another admin see section 6). Upstream does **not** check that the person has a second factor (the rehearsal promoted an unenrolled user without complaint), so this order is procedural and the audit is the control.
4. Run the audit; it must still print `PASS`.

If a person was promoted before enrolling, they are protected only by a password until they enroll, and JSON requests are not constrained meanwhile. Treat that as an incident: remove the role (section 11) or have them enroll at once, and re-run the audit.

## 9. API keys and other non-interactive access

Measured with enforcement set to `staff` (Task 40B, section 14):
- **Exempt paths.** The enrollment redirect is skipped when the request format is JSON, when the request is API-authenticated, when the user is anonymous, and (only if `enforce_second_factor_on_external_auth` is turned off) when the session came from external authentication. It is applied to ordinary browser (HTML) requests only.
- An **unenrolled** admin's session, over JSON, still read the user list, the site settings and the API key list, and could create an all-users API key, while the same session's browser pages were redirected.
- An admin API key (an all-users key used with `Api-Username`) acted as an administrator who **has** 2FA, reaching admin-only endpoints and performing an admin write, with no TOTP asked. API authentication is independent of interactive 2FA. API-authenticated HTML requests are not redirected either.
- A **read-only** key could read, and its write was refused (the admin route answered 404, because the key is not authenticated for that route). A user API key with the `write` scope, which the default settings allow for admins, also reached admin-only endpoints with no 2FA.
- Key creation is an authenticated JSON call with no second-factor challenge, and it is logged (`api_key_create`, revoke and destroy) in the staff action log. The raw key is shown once and stored only as a hash.
- API keys and the IP allowlist are independent: a key worked while the allowlist was blocking admin logins.

Production policy:
1. **No personal or staff API keys by default.** No admin creates a key "for convenience".
2. A machine integration may have a key only with an explicit written purpose, a named owner, the **minimum scope** (prefer `granular`, otherwise `read_only`; never an all-powerful `global` key), an expiry or review date, and a rotation plan. Keys are bound to a user only when the integration needs one.
3. Record each key (purpose, owner, scope, created, review date), never the key itself.
4. Revoke the keys an offboarded staff member created or held (section 11). The audit counts active keys and the final state is zero.
5. Never treat an API credential as protected by interactive 2FA. A leaked key is a leaked administrator.
6. Defaults that the PM may want to tighten (not changed here, no core patch): `allow_user_api_key_scopes` (default `read|write|message_bus|push|notifications|session_info|one_time_password`) and `user_api_key_allowed_groups` (default admins, moderators and every member). Without a user-API-key client in V1, restricting them removes a route for a staff session to mint a key. Also `revoke_api_keys_unused_days` defaults to 180.

## 10. Break-glass (a staff member cannot complete 2FA)

**Authority.** The Founder (or, if the Founder is the affected person, the PM-designated second authority) approves each event. The operator performing it must hold host access. There is no standing bypass account and nothing here is performed unattended.

1. **Verify the identity** of the person out of band, on a channel that is not the site and not the lost device (for example a live video or voice call with someone who knows them, plus a second known channel). Record who verified, how and when (no secrets).
2. **Choose the least powerful path.**
   - **Peer admin (preferred, audited).** Another administrator opens Admin → Users → the person → disable second factor. Rehearsed: it needs no second-factor challenge, writes a `disabled_second_factor` staff action log row, and sends the person a notification email (which needs working SMTP).
   - **Root (when no administrator can act).** On the host:

```bash
sudo docker exec -u discourse -w /var/www/discourse <CONTAINER> bin/rake "users:disable_2fa[<USERNAME>]"
```

   It prints `2FA disabled for <USERNAME>`. It removes the TOTP, any second-factor security keys and the recovery codes for that one account and nothing else. Rehearsed: it writes **no** staff action log row and sends **no** email, so the operations record is the only audit trail.
3. **Close the old sessions.** Neither path ends the person's existing sessions (an old session stayed valid after the root command). A peer admin uses Admin → Users → log out. Without one, from the host:

```bash
sudo docker exec -i -u discourse -w /var/www/discourse <CONTAINER> bin/rails runner - <<'RUBY'
u = User.find_by!(username: "<USERNAME>")
u.user_auth_tokens.destroy_all
u.logged_out
puts "sessions_left=#{u.user_auth_tokens.count}"
RUBY
```

4. **Review the password.** If a device was lost or stolen, or compromise is possible, reset the password: the person types a new one with `rake admin:create` against their existing email (answer `y` to the reset question, then `n` to granting admin again). That needs no SMTP and does not remove 2FA. Rehearsed: the old password stopped working, the new one worked, a second factor was still required, and a session that was open before the reset was invalidated.
5. **Re-enroll immediately**, in the same session: the person logs in with the password alone (no second factor is asked now), enrolls a **new** authenticator and generates **new** recovery codes (section 5). The old TOTP key and old recovery codes are dead (rehearsed).
6. **Enforcement stays on.** `enforce_second_factor` is never changed during break-glass. While the person has no second factor they are redirected in the browser to the setup page, and JSON still works, so do not leave this state open.
7. Run the audit. It must print `STAFF_SECURITY_AUDIT=PASS` before the event is closed. If the person cannot re-enroll in the same session, take their role away until they can (section 11) rather than leave staff without a second factor.
8. Close the record: who authorized, who verified, which path, when it started and ended, the audit result. No secrets.

**A lost password alone** (second factor intact): use step 4 only.
**All administrators locked out:** the root path in step 2 for one administrator, then steps 3 to 7.

## 11. Offboarding and role revocation

1. An administrator removes the role: Admin → Users → the person → revoke admin or revoke moderation. Rehearsed: it needs no second-factor challenge and writes `revoke_admin` and `revoke_moderation` rows.
2. Force the person's sessions closed (Admin → Users → log out). Rehearsed: after revocation and log out the old session could no longer reach any admin endpoint.
3. Revoke every API key the person created or holds (Admin → API) and any user API key.
4. If they had host access, rotate the secrets they could read, per `SECRETS.md` section 8, and remove their host access.
5. Run the audit and update the roster.

Root-side fallback when no administrator is available: `bin/rails runner` with `User.find_by!(username: "<USERNAME>").revoke_moderation!` (or `.revoke_admin!`). Upstream does not allow an administrator to revoke their own role, so the last administrator cannot demote themselves.

## 12. Admin IP allowlist

**Default for V1: off**, unless a stable trusted egress path exists. Measured at the pin:
- It is checked **only when an admin logs in** (password login and external-auth login). An already open session, a moderator login and API-key authentication are not affected.
- Enabling `use_admin_ip_allowlist` with **zero** allow rows restricts nothing (an empty list is unrestricted). With at least one `allow_admin` row, an admin login from any other address is refused before the password or the second factor is checked.
- It uses `request.remote_ip`. With nginx directly in front of the app, nginx overwrites `X-Forwarded-For` with the peer address and a spoofed header did not bypass the list. Behind a reverse proxy or Cloudflare the app must be configured to see the real client address, or every admin is blocked or the wrong address is trusted. The upstream Cloudflare template does that by downloading Cloudflare's address ranges while the image is built, which is not reproducible from the tracked inputs alone, so treat any proxy introduction as its own decision.
- Behind a published Docker port the app saw the Docker bridge gateway (`172.19.0.1` in the rehearsal), not the real client, because the test client was local. Check what address the app records for a real client (the `client_ip` of a session) on the real host before ever entering an allow row.
- Lockout risk: residential and mobile addresses change. The recovery is root-side:

```bash
sudo docker exec -i -u discourse -w /var/www/discourse <CONTAINER> bin/rails runner - <<'RUBY'
ScreenedIpAddress.where(action_type: ScreenedIpAddress.actions[:allow_admin]).destroy_all
SiteSetting.use_admin_ip_allowlist = false
puts "allowlist_enabled=#{SiteSetting.use_admin_ip_allowlist}"
RUBY
```

  That was rehearsed, and an admin could log in again straight after.
- It is a trade-off, not a free hardening step, because it makes root access the only recovery from a wrong entry.

## 13. Verification: the staff security audit

Read-only. It prints counts, booleans and usernames only, never a password, a TOTP key, a recovery code or an API key. Run it after every staff change, before turning enforcement on, after every break-glass event and on a schedule (suggested monthly):

```bash
sudo docker exec -i -u discourse -w /var/www/discourse <CONTAINER> bin/rails runner - <<'RUBY'
# Staff security audit. READ-ONLY. Prints counts, booleans and usernames only.
staff = User.human_users.where("admin OR moderator").order(:id).to_a
admins = staff.select(&:admin)
mods = staff.reject(&:admin)
protected_staff = ->(u) { u.has_any_second_factor_methods_enabled? }
unprotected = staff.reject(&protected_staff)

puts "== staff security audit =="
puts "admins_human=#{admins.size} moderators_only_human=#{mods.size}"
staff.each do |u|
  role = u.admin ? "admin" : "moderator"
  puts "  #{role.ljust(9)} #{u.username} active=#{u.active} suspended=#{u.suspended?} second_factor=#{protected_staff.call(u) ? "yes" : "NO"} totp=#{u.totps.count} security_keys=#{u.second_factor_security_keys.count} backup_codes_left=#{u.user_second_factors.backup_codes.count}"
end
puts "staff_without_second_factor=#{unprotected.size}"
puts "enforce_second_factor=#{SiteSetting.enforce_second_factor} enforce_second_factor_on_external_auth=#{SiteSetting.enforce_second_factor_on_external_auth} enable_local_logins=#{SiteSetting.enable_local_logins}"
puts "developer_emails_in_global_settings=#{GlobalSetting.respond_to?(:developer_emails) && GlobalSetting.developer_emails.present? ? "SET" : "none"}"
puts "developer_emails_in_rails_config=#{Rails.configuration.respond_to?(:developer_emails) ? Rails.configuration.developer_emails.size : 0}"
puts "developer_table_rows=#{Developer.count}"
puts "api_keys_active=#{ApiKey.active.count} (hidden=#{ApiKey.active.where(hidden: true).count}) user_api_keys_active=#{UserApiKey.active.count}"
puts "admin_ip_allowlist_enabled=#{SiteSetting.use_admin_ip_allowlist} allow_admin_rows=#{ScreenedIpAddress.where(action_type: ScreenedIpAddress.actions[:allow_admin]).count}"
puts "has_login_hint=#{SiteSetting.has_login_hint} allow_impersonation=#{GlobalSetting.allow_impersonation}"
checks = {
  "at_least_two_human_admins" => admins.count { |u| u.active } >= 2,
  "no_staff_without_second_factor" => unprotected.empty?,
  "enforce_second_factor_is_staff_or_all" => %w[staff all].include?(SiteSetting.enforce_second_factor),
  "no_developer_email_escalation" => !(GlobalSetting.respond_to?(:developer_emails) && GlobalSetting.developer_emails.present?) && Developer.count == 0,
  "no_standing_api_keys" => ApiKey.active.where(hidden: false).count == 0 && UserApiKey.active.count == 0,
}
checks.each { |name, ok| puts "check #{name}=#{ok ? "PASS" : "FAIL"}" }
puts "STAFF_SECURITY_AUDIT=#{checks.values.all? ? "PASS" : "FAIL"}"
RUBY
```

Reading the result:
- Before section 7 `enforce_second_factor_is_staff_or_all` is expected to fail; every other check must pass.
- A `FAIL` on `no_staff_without_second_factor` names the account in the lines above it. In the rehearsal the audit failed exactly when an unenrolled admin existed and exactly while a break-glass reset was open, and passed again after re-enrollment.
- A non-zero `api_keys_active` is not an error by itself once a machine integration is approved (section 9); the check is a prompt to compare the count with the key register.

Native companions (not replacements): the **staff action log** in Admin (`grant_admin`, `revoke_admin`, `grant_moderation`, `revoke_moderation`, `disabled_second_factor`, `api_key_create`, `api_key_update`, `api_key_destroy`, and the site setting change for `enforce_second_factor`), the admin-only **Admin logins** report, and `bin/rake users:list_recent_staff` on the host (it prints staff email addresses: operator eyes only). Rake-based changes (`admin:create`, `users:disable_2fa`, root-side runners) appear in none of them, which is why each needs an entry in the operations record.

## 14. What the rehearsal proved

Task 40B: one disposable instance built from the validated production-like definition with the `SECRETS.md` contract (its own container, network, shared state and loopback port; the retained prodlike instance, the DEV stack and FeedCheck were not touched), synthetic `.test` identities, and passwords, TOTP keys and recovery codes held only in memory and never printed. The final pass ran **130 checks, 130 passed, 0 failed**, and a scan of the transcript for the 75 secret values it had generated found 0. Three earlier passes fixed errors in the rehearsal's own scripts and criteria (not in any product behavior) and are kept as evidence. The check-by-check record is in `docs/cannlabs-community/02_PROJECT_STATE.md` → TASK 40B; the evidence is outside Git.

| Area | Measured |
| --- | --- |
| Fresh site | The developer-emails variable was absent from the container environment, `discourse.conf` and the Rails configuration, and the `developers` table was empty. `/finish-installation/register` was served, but a POST created nobody (HTTP 400), and after the first admin existed it answered 403. |
| First admin | `rake admin:create` on a pty exited 0 and granted admin. The password was never echoed (control: the typed email was), never found in host `ps` argument lists (26 to 27 samples per run), and absent from the pty output, the database dump, every log and the mail. No `grant_admin` log row. A 12-character password was accepted and granted admin (the admin minimum of 15 is not applied by the task). |
| Enrollment | Invalid TOTP refused and valid accepted at enrollment and at login; a password alone refused for an enrolled account; a replayed code refused; 10 recovery codes of 32 hex characters; one use each; regeneration invalidated all old ones. |
| Second admin | Independent creation, two distinct stored TOTP keys, disjoint recovery codes. Promotion through the admin UI needed the actor's TOTP and refused a recovery code and a wrong TOTP. |
| Enforcement | `no`, `staff` and `all` are the supported values (`admins` was refused with 422). Under `staff` an unenrolled admin was redirected on browser navigation to the setup page; its JSON requests (user list, site settings, API key list, key creation) were not constrained. |
| API | An all-users admin key acted as an enrolled admin with no TOTP, reached admin-only endpoints and wrote; a read-only key's write was refused; a default-allowed user API key with `write` reached admin endpoints; revocation was immediate; creation and revocation were logged. |
| Least privilege | An enrolled moderator suspended, unsuspended, closed a topic and read the staff log, and was refused 10 admin-only actions (404 route constraint, or 403 for disabling another user's 2FA). It saw no other member's email. |
| IP allowlist | Zero rows restricted nothing; one row blocked other admin logins, not moderators, existing sessions or API keys; a spoofed `X-Forwarded-For` did not bypass it; the root-side runner recovered it. |
| Break-glass | Root `users:disable_2fa` removed one admin's TOTP and codes and wrote no log row and sent no email; the old session stayed valid until closed; the person logged in with the password alone, was redirected to enroll, and re-enrolled with a new seed and new codes while the old ones died; the audit failed exactly while 2FA was off and passed again. The peer-admin UI path wrote a `disabled_second_factor` row and emailed the person. A lost password was reset with `admin:create` without SMTP. A root-side runner removed a role (no log row) and an admin restored it. |
| Final state | Audit `PASS`: two human administrators and one moderator, all with 2FA, `enforce_second_factor = staff`, no developer-email escalation, no API keys. |
| Exposure | No password, recovery code or API key value in the database dump, the native backup, container or application logs, launcher output, mail or the transcript. **TOTP keys are in the database dump and the native backup in clear text.** |

## 15. Limits: not proven

- Security keys, passkeys and WebAuthn: the local origin issue recorded after Task 32 remains, and no security key was available.
- Real SMTP: the emails (2FA-disabled notification, password reset, invitations) were observed only in a local mail sink.
- A real signup, a real Google or Apple login for staff, and the invitation flow.
- That a person with a real authenticator app completes enrollment from a phone: a standards-based TOTP generator stood in for the app.
- Behavior behind a reverse proxy, Cloudflare or TLS.
- The two-admin sequence on a real host, and the first-admin ingress window on a real network.
