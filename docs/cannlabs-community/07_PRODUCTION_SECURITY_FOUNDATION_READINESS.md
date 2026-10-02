# CannLabs Community — Production / Security Foundation Readiness

> STATUS: VALIDATED READINESS REVIEW — PRODUCTION NOT READY
>
> Task 27 · read-only review · accepted by the official PM on 2026-10-02 (Task 27A).
>
> Principal gap: reproducible native product bootstrap.

This file records the durable conclusions of the Task 27 read-only review. It is readiness evidence, not a deployment plan and not a decision record. Nothing here was implemented, and no production deployment was performed.

Items marked **RECOMMENDED DIRECTION** are the current architectural direction. They are HYPOTHESIS until later implementation evidence and an explicit decision; none of them is DECIDED by this file. No new Decision ID was created.

## Result

- The product and access architecture is already decided and validated (Canon §22–§26, `DEC-030` to `DEC-033`).
- A significant part of the product-critical state lives only in the native database and runtime of one local development environment.
- A fresh Discourse database would not reproduce CannLabs Community correctly.
- This is primarily an operations / bootstrap problem. It does not require a new product feature or new product logic.
- Domain, SMTP, secrets, Cloudflare, payment and external monitoring remain unresolved and are separate workstreams.

## Clean-database delta

A clean Discourse production database, as upstream seeds it, would be missing or wrong for:

| Area | Validated Community state | Clean upstream database |
| --- | --- | --- |
| Custom groups | `membros_ativos`, four `*_verif` identity groups, `liderancas_aprov`, derived `acesso_profissionais` and `acesso_liderancas`, all staff-controlled | absent |
| Category ACLs | General and Comunidade → `membros_ativos`; Profissionais Verificados → `acesso_profissionais` only; Lideranças de Associações → `acesso_liderancas` only | General open to everyone; the Community categories absent |
| Paid / private boundary | `login_required=true`; no unpaid discussion surface | public site |
| Site Feedback | retired natively (`DEC-033`) | seeded and readable |
| Uncategorized | normal posting disabled; residual category not an unpaid surface | upstream default lifecycle |
| Reporting | admins, moderators, native TL1 and `membros_ativos` | upstream default, without `membros_ativos` |
| Messaging | member-to-member PM off (admins and moderators only); Chat off | upstream defaults |
| User Notes | enabled locally only; production use is Legal / Privacy / T&S gated | off |
| Theme | Community Theme v0.1 installed, default and pinned | Foundation |
| Qualified Access | plugin present; feature flag enabled locally only | plugin absent |

## Configuration classes

| Class | Examples | State |
| --- | --- | --- |
| A — version-controlled | application source, theme source, plugin source, canon / docs | exists |
| B — deployment configuration | production container definition, image / source pinning, build hooks, hostname, TLS, SMTP configuration references, backup target | not implemented |
| C — native database product state | site settings, groups, categories, ACLs, active theme records, plugin feature-setting state | not reproducibly bootstrapped (Task 28 addresses the product/security-critical part) |
| D — external operations state | DNS, Cloudflare, SMTP credentials, off-site backup storage, monitoring, access policies | not configured |

Group memberships are operational data, not bootstrap configuration.

## Bootstrap gap

The validated product must become reproducible before production. The bootstrap must be idempotent, auditable, rerunnable and upstream-safe; it must use Discourse's own models and services, never direct SQL; it must not become a provisioning framework; and it is operational automation, not product business logic.

Configuration drift worth detecting, with a simple operator audit rather than a monitoring framework: Chat re-enabled; `membros_ativos` removed from reporting eligibility; General or Comunidade made public; Site Feedback recreated; Uncategorized behaviour changed; Qualified Access disabled; a restricted category ACL changed; theme or plugin revision drift.

## Production direction — RECOMMENDED DIRECTION (HYPOTHESIS)

- Supported Discourse production Docker mechanisms (the official `discourse_docker` lifecycle and its container definition), not the development image. `discourse/discourse_dev` is development only.
- Pinned inputs: a pinned application fork commit that still tracks upstream separately; the pinned validated theme revision; the pinned Qualified Access revision installed during the production build. Never deploy an unpinned `main`.
- Persistent data, private database and Redis, TLS through the supported reverse-proxy pattern, no WSL bind mounts.
- Public network exposure limited to web / TLS. PostgreSQL, Redis, Docker control and backups stay private.

## Staff 2FA — REQUIRED BEFORE PRODUCTION

A Security / Product / Operations requirement, not a counsel gate. Native support exists through `enforce_second_factor`, which can enforce it for staff. It is not enabled. Enabling it needs a bounded acceptance slice with recovery codes and a break-glass procedure.

## Open gates

| Gate | State |
| --- | --- |
| Production hostname / domain | OPEN operations / product decision. No hostname is ratified. |
| HTTPS / TLS | Follows the hostname decision. |
| Cloudflare | OPEN. No verified Community production architecture exists; the existing GitHub integration is not assumed to belong to this product (`02_PROJECT_STATE.md`). |
| SMTP | Not configured; provider OPEN. Requirements: transactional delivery, SPF, DKIM, DMARC, bounce / complaint visibility, sender-domain control, and delivery of activation, password-reset and moderation mail. |
| Backup / restore | Native Discourse backup is adequate in principle. Open: schedule, private off-site storage, retention, encryption / access, monitoring, documented RPO / RTO and an actual restore drill. A backup policy is not validated until a restore succeeds. |
| Secrets | Never committed. Expected later: database, SMTP, Google, Apple, payment provider, object storage, API keys and TLS material where applicable. The mechanism depends on the hosting model, which is not chosen. |
| Authentication providers | Google and Apple are the ratified direction and are not configured. |
| Payment | Unresolved and a separate workstream. The only ratified contract is payment state → `membros_ativos`. |
| Legal / Privacy / Trust & Safety | Mandatory pre-production gates. |

## Update / upgrade regression

No blind upstream tracking. Acceptance for every material Discourse upgrade includes: a backup; local or staging acceptance; theme and plugin compatibility; the paid / private ACL boundary; General and Comunidade access; the Uncategorized state; Site Feedback still absent with `meta_category_id` tolerated; active TL0 reporting and unpaid reporting denial; Qualified Access derivation and revocation; theme active; plugin loaded; health after the upgrade.

Qualified Access compatibility: the plugin boots; the source group event hooks fire; regular reconciliation and the 15-minute drift job run; the source predicates and fail-closed behaviour hold; the native Group API is unchanged.

## Observability minimum

No monitoring destination or on-call owner is ratified. Minimum eventual production signals: web health; 5xx / application errors; background job failures; database and storage; Redis; email failures; backup failures; TLS expiry; origin health; Qualified Access reconciliation and source errors. Do not build a full observability stack yet.

## Environment model — RECOMMENDED DIRECTION (HYPOTHESIS)

- **Local / dev:** the current WSL / Docker development runtime.
- **Staging:** an isolated production-like environment with synthetic data only. Recommended because of Discourse upgrades, authentication-provider callbacks, SMTP, the custom Qualified Access plugin, the paid / private boundary and destructive-lifecycle regression. It does not exist.
- **Production:** separate host, storage, secrets and external services. It does not exist.

## Next slice

Task 28 — Product Bootstrap Contract v0.1: a small audit / apply mechanism for the security-critical native product state, with local idempotence and drift proof. Task 28 proves product configuration bootstrap. It does not prove a complete clean production deployment, which remains a later slice.
