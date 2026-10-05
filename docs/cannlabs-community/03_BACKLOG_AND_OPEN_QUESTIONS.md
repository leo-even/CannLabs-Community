# CannLabs Community — Backlog and Open Questions

Status: CURRENT
Date: 2026-10-05 (baseline written 2026-09-29)

> **Backlog ≠ authorization.** Listing an item here does not authorize it. Work starts only through an explicitly authorized slice from the official PM.

Buckets: **NOW** · **NEXT** · **LATER** · **PARKED** · **OPEN**. States are defined in `README.md`; canon references (`§N`) point to `00_PRODUCT_CANON.md`.

## NOW

**Current NOW (2026-10-05, Task 38A): the production-like reproducibility and disaster-recovery proof (Task 37B) is VALIDATED; its deployment definition is now tracked under `ops/discourse/` (`DEC-039`), awaiting official PM validation.** Nothing further is authorized; machine-independent deployment reproducibility is not yet validated, and production remains NOT READY. See `02_PROJECT_STATE.md` → TASK 37B and TASK 38A. See the last sections of this file and `02_PROJECT_STATE.md` → CURRENT STATE. The list below and the later "NOW — TASK …" headings are kept as history in the order they were written; each was current only until the next one.

The current phase is foundation work only. Its sequence is in `02_PROJECT_STATE.md` → NEXT.

- durable product baseline (this directory) — VALIDATED (Tasks 03 / 03A);
- operating model / agents / skills foundation — VALIDATED (Task 04);
- Design System compatibility — design direction VALIDATED (Task 05); static visual prototype VALIDATED (Task 06); theme architecture DECIDED (Task 07 / `DEC-024`); Discourse-native design handoff VALIDATED (Task 08); Community Theme v0.1 VALIDATED (Tasks 10 / 10B);
- **V1 product capability / upstream reuse discovery** (Task 11, read-only) — completed as discovery evidence;
- V1 product specification and readiness — VALIDATED / RATIFIED (Task 12A); implementation remains unauthorized.
- Access Skeleton (Task 14) — VALIDATED and closed; no further runtime mutation is implied.
- Task 16A — VALIDATED local architecture and closed in documentation.
- Task 17 — VALIDATED: upstream gap proven.
- Task 18A — VALIDATED / DECIDED: qualified-access synchronization architecture ratified.
- Task 19 — VALIDATED: bounded plugin v0.1 implementation, local validation and launcher recreation.
- Task 20 — closed as Task 20B (verified-identity boundary ratified, `DEC-031`).

No product feature implementation.

## COMPLETED — VERIFIED ROLES / RESTRICTED SPACES LOCAL ARCHITECTURE

Task 16A recorded the validated local architecture: cumulative native identity groups are separate from `acesso_profissionais` / `acesso_liderancas`, and each restricted native category trusts only its corresponding authorization group. Identity alone does not grant access. No production verification, association onboarding or lifecycle synchronization is authorized.

## COMPLETED — TASK 17 / TASK 18A QUALIFIED-ACCESS ARCHITECTURE

Native CategoryGroup ACLs are OR-based, so qualified authorization must be removed when active membership, identity qualification or leadership authorization ends. Task 17 reviewed the bundled automation plugin and core lifecycle hooks and proved that no safe upstream/native configuration mechanism exists for this intersection.

Task 17 proved the upstream gap. Task 18A ratified a bounded, stateless Community plugin as the only authorized custom exception. `acesso_profissionais` and `acesso_liderancas` are derived state; `liderancas_aprov` is the persistent leadership source. Task 19 is the implementation slice.

## COMPLETED — TASK 19 QUALIFIED ACCESS PLUGIN V0.1

Task 19 is validated locally at plugin revision `ca4f0070d7bf85e42dbfa7f8736469139bb20275` in the separate public repository `leo-even/CannLabs-Community-Qualified-Access`.

The plugin is stateless, uses native group membership and history, reconciles source groups to derived access groups on supported group events, runs a 15-minute drift sweep, fails closed when source state is unavailable, and exposes no client-side feature flag. The local flag is true; production enablement remains unauthorized.

The Founder launcher now has durable Community-only create semantics: it preserves `cannlabs_community_pg`, mounts the authoritative application and plugin WSL repositories, bootstraps dependencies and restores `localhost:3100`. Full removal/recreation acceptance passed without resetting Community data. No application, theme or FeedCheck changes were made.

## NOW — TASK 20 READ-ONLY READINESS

Task 20 is a bounded, read-only upstream/native and official-source review for professional verification, public professional identity, association existence and representation, leadership approval, privacy/LGPD, retention and Trust & Safety. It does not authorize groups, users, settings, forms, uploads, workflows, plugin code or theme changes.

## NEXT — V1 discovery

Task 12A resolved the product model. The remaining discovery items below are implementation-readiness questions, not permission to change runtime state.

Candidates that require an upstream/reuse review before any decision:

- paid membership;
- account / signup model;
- groups / roles;
- professional verification;
- association verification;
- institutional representation;
- category / access model;
- moderation policy;
- Community Guidelines;
- profile model;
- privacy / data minimization;
- authentication;
- payment architecture;
- plugin and default-setting audit.

## V1 Access Skeleton — VALIDATED (Task 14)

The native active-member group, member-only category ACL, login gate, communication defaults and staff support path were validated locally through a reversible synthetic unpaid → active → expired sequence. The exact evidence and rollback boundary are recorded in `02_PROJECT_STATE.md`. This closure does not authorize expansion into verified roles or associations.

## Verified professional roles — OPEN / TASK 15 READINESS

Current product thesis: physician, pharmacist, agronomist, lawyer (`DEC-009`).

Open questions:

- authoritative verification source;
- data needed;
- manual vs automated verification;
- reverification;
- expiry;
- badge semantics;
- privacy and retention.

## Association model — HYPOTHESIS / OPEN / TASK 15 READINESS

Possible elements: verified association; representatives; institutional profile; multiple seats; restricted access.

Open questions: verification; seats; pricing; representative management; permissions.

## Company / organization model — HYPOTHESIS / OPEN / PARKED FROM TASK 15

Explore: institutional verification; representatives; institutional profile; disclosure of commercial interest; promotion boundaries; permitted technical participation.

## Authentication — READINESS REVIEWED (Task 30) / PROVIDERS NOT CONFIGURED

The original exploration question (Google, Facebook, Apple and the native Discourse flows; initial dated inventory in `04_DISCOVERY_BASELINE.md` §1.3) is answered by the Task 30 readiness review: native and bundled Discourse are sufficient, and no custom authentication infrastructure is needed.

- **DECIDED:** local login, Google and Apple are the V1 direction (Canon §22). Google and Apple are disabled and need production credentials later. Google OAuth is locally accepted with core Discourse (Task 35); Apple is untested.
- **OPEN / HYPOTHESIS:** Facebook login, reopened by the Founder (`DEC-034`). Not DECIDED, not V1.
- **REQUIRED BEFORE PRODUCTION:** staff 2FA.

Open items are listed in "AUTHENTICATION READINESS — OPEN ITEMS" at the end of this file. None of them is authorized.

## Paid access — OPEN / REUSE CANDIDATE

Investigate:

- the current `discourse-subscriptions` plugin;
- Stripe;
- BRL;
- limitations for Brazil;
- PIX and other Brazilian payment needs;
- group assignment by subscription;
- institutional billing and seats.

Do not implement billing yet.

Task 12A ratifies only the lifecycle boundary: payment state must eventually drive the canonical active-member group. Provider, pricing, PIX/BRL handling and institutional seats remain OPEN.

## Direct messages / chat — PARKED (Legal + Trust & Safety review)

- Should member-to-member personal messages be disabled in V1?
- Should native Chat be disabled?
- What support / moderation contact remains?
- What are the moderation and privacy expectations?
- How do we reduce prohibited-transaction risk?

Task 12A ratifies the V1 default: member-to-member personal messages and native Chat remain off. Reopen only through Legal / Trust & Safety review and a new explicit decision.

## Public content / CannLabs Web — LATER

Explore:

- invited editorial contributors;
- attribution;
- consent;
- publishing workflow;
- SEO / GEO;
- canonical URLs;
- separation from private Community discussion.

Never automatic republication (`DEC-005`).

## Community strain / cultivar database — PARKED

Concept: a community knowledge base about strains, cultivars, genetics and seeds. Possible future data: name; breeder / source; lineage; reported traits; cultivation observations; discussion references.

This would not be an official scientific registry.

Before any implementation, determine:

- actual member need;
- provenance;
- duplicate naming;
- moderation;
- legal implications;
- whether tags, topics or custom fields already solve enough.

No schema design now.

## Structured posts — PARKED

Possible future formats: cultivation report; cultivar report; medicine experience; extraction / process report; equipment review.

Normal forum usage should first demonstrate the need.

## Design — NEXT

Task 05 decided the register, structural base, list-over-cards law, avatar exception and pt-BR direction (`DEC-018` to `DEC-020`). Task 06 validated the static prototype and the deep L-frame shell (`DEC-022`).

**DECIDED — Theme architecture:** one full theme in the dedicated Community-owned repository `leo-even/CannLabs-Community-Theme`, git-installed; the fork holds no theme code (`DEC-024`).

**VALIDATED — Community Theme v0.1** (Tasks 10 / 10B): shell + `/latest` + `/categories`, light and dark, desktop and mobile (`02_PROJECT_STATE.md`). Further theme work needs a new authorized slice.

**LATER — theme follow-ups from v0.1 QA:** M1 site-wide derived-colour / footer / focus pass; M2 category-square colours once categories are designed; L1 `/categories` "Recentes" title weight; L2 skip-link visual; L3 mixed-language site title.

**LATER — theme release hardening:** theme LICENSE attribution / copyright hygiene; `minimum_discourse_version`; production deployment strategy.

**OPEN / readiness requirement — font binary provenance:** authorized upstream source, exact version / commit, binary hash and retained OFL licence before any font enters the theme repository (`DEC-024`).

**Logo:** the canonical Design System SVG, unchanged, through native `logo` / `mobile_logo`; any optimized derivative needs a separate task (`DEC-024`).

**Implementation QA — `modernize_foundation_theme`:** currently effectively ON for everyone, anonymous included; QA covers that state plus one isolated modernize-OFF run with exact restoration (`02_PROJECT_STATE.md` → runtime notes).

**VALIDATED — Founder local test login (Task 15A):** native local password repair and real-browser login/logout/reload acceptance passed for the normal synthetic `bemstorm` account. No credential is recorded here.

**VALIDATED — Task 16A local architecture:** six native groups and two restricted native categories were accepted locally; `bemstorm` was restored to ordinary active-member state and no synthetic membership remains. The qualified-access lifecycle remains an explicit production dependency.

**TASK 17 READ-ONLY FINDING:** the bundled `automation` plugin is present but disabled with zero configured automations. It has single-group add/remove triggers and recurring/custom-field or badge-based group scripts, but no native AND/intersection predicate or safe qualified-access reconciliation primitive. Core emits group membership events and records group history. Current outcome: `NOT READY — upstream gap proven; bounded custom synchronization requires architecture review`.

**HYPOTHESIS — Petrona for topic-list titles**, pending the real font; Public Sans is the fallback (`DEC-022`).

**OPEN / LATER — letter-avatar colours:** native for the first implementation; no plugin or server-side override for prototype parity (`DEC-023`).

**LATER — fine visual polish** (microspacing, logo sizing, palette and category-colour tuning, dark-mode nuance, small typographic adjustments). Accessibility, responsive behavior, touch targets, text scaling / reflow, focus, upstream compatibility and native interaction preservation are not polish (`DEC-023`).

Design Director questions still to settle in implementation and later design slices:

- the exact Community dark-mode values (the prototype holds measured candidates; `deep` is not dark mode);
- typography adaptation details;
- emoji / reactions policy in product content vs UI chrome;
- final category palette values.

## CannLabs Design System fixes — PARKED (Design System backlog)

Issues found in Task 05 that belong in the CannLabs Design System itself. They are not Community implementation work, and do not block Community prototyping. Changing the Design System repository needs separate authorization:

- an explicit dark-mode contract separate from Estufa / `deep`;
- accessible dark variants for the signal colours;
- an accessible input-border token;
- underlined links in running text;
- reconsider or restrict the 9px `nano` size;
- the circular avatar exception (`DEC-019`);
- a category / identity palette rule;
- a relative (rem) typography scale.

## Legal / Privacy / Trust & Safety — REQUIRED PRE-V1 GATE

A future dedicated reviewer must cover at least:

- LGPD;
- sensitive and health data;
- professional credentials;
- institutional documents;
- data minimization;
- retention;
- moderation;
- user-generated content;
- prohibited cannabis commerce;
- notice and takedown;
- private communications;
- medical and legal boundaries;
- Terms;
- Privacy Policy;
- Community Guidelines;
- minors;
- platform liability;
- records and logging requirements.

No legal conclusions are made in this document (`DEC-015`).

## Security / Launch readiness — REQUIRED PRE-V1 GATE

A future review includes:

- secrets;
- credentials;
- authentication;
- admin / staff;
- permissions;
- dependencies;
- plugins;
- CSP / security headers;
- uploads;
- rate limits;
- abuse;
- backups;
- database;
- Redis;
- logging and privacy;
- production configuration;
- vulnerability scanning.

**OPEN — Infrastructure / Security / Deployment:** review the Cloudflare Workers & Pages GitHub integration's repository access and intended deployment role before production deployment. Its presence does not establish an active Community deployment (`02_PROJECT_STATE.md`).

Until that review, development still avoids real secrets in Git, production credentials, unnecessary public exposure and disabling security controls without need (`DEC-016`).

## TASK 20B — RATIFIED VERIFIED-IDENTITY BOUNDARY

Task 20B is closed as durable readiness: public professional identity uses native `User.name` while username remains the handle; presentation is native; verification is result-only and staff-readable through native User Notes; admins control approval/revocation; public-name changes require re-review; self-service intake and automation are deferred. CRM/CRF/CREA/OAB identifiers and credential evidence are not retained or exposed.

## NOW — TASK 21 SYNTHETIC LIFECYCLE

Run one reversible local synthetic acceptance only: enable native User Notes, create/delete one clearly synthetic result-only note, temporarily set a synthetic public name and native role presentation, add/remove a professional source group, verify derived access and browser presentation, and restore all captured state. Production Legal / Privacy / Trust & Safety, real verification, intake, association onboarding, payment and deployment remain gated.

## TASK 21 — VALIDATED SYNTHETIC PROFESSIONAL LIFECYCLE

Task 21 is durably validated: the native result-only User Note contained no professional identifiers or evidence; normal users could not read it; native public name and title presentation worked without changing the username; `medicos_verif` automatically granted and later revoked `acesso_profissionais`; all synthetic note, name, title and membership state was cleaned up; `bemstorm` returned to its ordinary active-member baseline. No real professional verification occurred.

`user_notes_enabled=true` remains enabled for local development only. Native `User.name` remains user-editable and has no automatic linkage to professional re-review or source-group revocation. A production name-change procedure, owner and re-verification/revocation SOP remain required; no automation is authorized.

## NOW — TASK 22 SYNTHETIC ASSOCIATION IDENTITY / LEADERSHIP LIFECYCLE

Validate one reversible native synthetic association identity group and the independent `liderancas_aprov` → `acesso_liderancas` lifecycle. Real association onboarding/evidence, professional verification, production launch and payment remain unauthorized.

## TASK 22A — VALIDATED ASSOCIATION IDENTITY ARCHITECTURE

Task 22 is closed as a durable local validation. Native Groups proved sufficient for association identity and the independent leadership lifecycle: association affiliation did not grant leadership; `liderancas_aprov` plus `membros_ativos` derived `acesso_liderancas`; removal of either source revoked only the derived access; and the synthetic group, membership and result-only note were cleaned up. No custom Organization model is needed for V1.

Parked without implementation: association dashboards, seats, delegated owners, org-owned private forums, CRM, storefront, marketplace, company organization model and association billing. Existing Canon and `DEC-031` are sufficient; no additional product decision was added.

## NOW — TASK 23 MODERATION / TRUST & SAFETY / OPERATIONS READINESS

Perform a read-only native capability and operating-readiness review. No moderation settings, flags, trust levels, watched words, groups, categories, users, content, plugins, code or documentation changes are authorized in this review. Real onboarding, verification, evidence, payment and production remain gated.

## TASK 26 — NOW: ACTIVE MEMBERSHIP SAFETY BOUNDARY

Implement and validate the native paid/private boundary for General, Uncategorized and Site Feedback, add membros_ativos to native flag eligibility, then complete the synthetic moderation lifecycle. No real users, payment, production or custom moderation code.

Task 23A is validated readiness; Task 24 resumes under this boundary; Task 25 remains read-only evidence.

## TASK 24 — VALIDATED NATIVE MODERATION LIFECYCLE

Task 24 is validated with native flags, Review Queue, staff content action, warning, silence, moderator-notification support, short suspension/unsuspension and cleanup. No custom moderation code or routine User Note was required.

## TASK 26 — PARTIAL ACTIVE MEMBERSHIP SAFETY BOUNDARY

General is member-only and active TL0 reporting works through membros_ativos. Seeded Uncategorized and Site Feedback remain open to authenticated unpaid users because upstream protects their security settings. Task 26 is not validated.

## Task 26B — Site Feedback retirement

- **Decision:** Retire the seeded Site Feedback scaffold from V1 under DEC-033.
- **Status:** Pending safe native lifecycle proof; do not delete or bypass native validation while meta_category_id and seed/reseed behavior remain unresolved.
- **Boundary:** Preserve native staff/moderator-notification support for unpaid help and appeals. Any future feedback/governance surface requires a separate member-only decision.

## TASK 26 — VALIDATED ACTIVE MEMBERSHIP SAFETY BOUNDARY

- **Status:** VALIDATED by official PM after Task 26C.
- **Evidence:** Native Site Feedback retirement survived restart and seed/update probes; General and Comunidade are member-only; Uncategorized normal posting is disabled with residual member-only access; unpaid users cannot read normal discussion or report; active TL0 members can report; native support remains available; PM and Chat remain off.
- **Known dependency:** `meta_category_id=2` is tolerated upstream residue after deletion. It is not a V1 blocker, but every material Discourse upgrade must recheck Site Feedback absence, boot, seed/update tolerance, and the paid/private boundary.
- **Next phase:** Task 27 — Production / Security Foundation Readiness.

## TASK 27 — PRODUCTION / SECURITY FOUNDATION READINESS

Read-only architecture, reproducibility, security, operations, and launch-gate review. No production deployment or implementation is authorized by this review.

## TASK 27 — VALIDATED READINESS REVIEW: PRODUCTION NOT READY

- **Status:** VALIDATED readiness review, accepted by the official PM on 2026-10-02. Production is NOT READY.
- **Principal gap:** reproducible native product bootstrap. Durable conclusions: `07_PRODUCTION_SECURITY_FOUNDATION_READINESS.md`.
- **Site Feedback:** the retirement that Task 26B listed as pending was completed natively in Task 26C; Task 26 is validated.

## NOW — TASK 28 PRODUCT BOOTSTRAP CONTRACT v0.1

A small audit / apply mechanism for the security-critical native product state, with local idempotence and drift proof. It is not a production installer.

Implemented on 2026-10-02 and since VALIDATED by the official PM (see "TASK 28 — VALIDATED PRODUCT BOOTSTRAP v0.1" below); operator guide: `08_PRODUCT_BOOTSTRAP.md`.

## NEXT / OPEN — PRODUCTION FOUNDATION (after Task 28; none authorized)

- **VALIDATED — clean production-like proof (Task 37B):** a pinned production-like build, product bootstrap, production-like logging acceptance and a native backup / zero-state restore proof passed on a disposable instance (see "TASK 37B" below). It does not make production ready. Staging with synthetic data only remains the recommended direction (HYPOTHESIS).
- **DECIDED — DURABLE DEPLOYMENT DEFINITION OWNERSHIP = COMMUNITY REPO** (`DEC-039`, `ops/discourse/`). **OPEN — MACHINE-INDEPENDENT DEPLOYMENT REPRODUCIBILITY:** needs a fresh second host built only from the tracked artifacts and documented values; not validated, not authorized.
- **REQUIRED BEFORE PRODUCTION — staff 2FA:** native `enforce_second_factor`. The acceptance slice is VALIDATED (Task 32: TOTP, backup codes and break-glass recovery). Still required: enroll and verify every real staff account, then rely on persistent `staff` enforcement. Not enabled and not authorized.
- **OPEN — production hostname / domain, HTTPS and the Cloudflare role.**
- **OPEN — SMTP provider** (SPF, DKIM, DMARC, bounce / complaint visibility).
- **OPEN — backup policy:** off-site storage, retention, RPO / RTO and a scheduled restore drill. The native backup and zero-state restore mechanics are VALIDATED in the production-like instance (Task 37B.2); no policy was chosen.
- **OPEN — secrets mechanism,** which depends on the hosting model (`OPEN — DELIVERY MECHANISM NOT YET DECIDED`). Real secrets placed in a `discourse_docker` `env:` block can appear in image and container metadata, so they must not go into the tracked definition; no manager or vendor is chosen.
- **OPEN — monitoring destination and on-call owner.**
- **LATER — theme and logo bootstrap on a clean database** (Git theme installation, logo uploads). Git theme installation by exact pin is proven (Task 37B); logo bootstrap was not addressed.
- **LATER — Founder launcher:** starting Docker Desktop when it is not running, and recreating an existing container whose mounts are wrong.
- **LATER — local browser test stack:** the Playwright Chromium binary is gone since the container was recreated.

## TASK 28 — VALIDATED PRODUCT BOOTSTRAP v0.1

- **Status:** VALIDATED by the official PM at application commit `d4bd6ce55e7f737846d8c753494d1406cd7d859d`.
- **Boundary:** product configuration bootstrap only. Production remains NOT READY; the production-foundation items above are unchanged.

## TASK 29 — VALIDATED LOCAL AUTH BASELINE

- **Status:** VALIDATED. Result: `LOCAL AUTH HEALTHY — bemstorm credential/account-specific issue`.
- **Closure:** the Founder rotated the `bemstorm` password with native tooling; no secret is recorded. An accidental Admin grant during that rotation was reversed natively, and `bemstorm` is an ordinary active member again. Details: `02_PROJECT_STATE.md`.
- **Also closed:** the local clock / Sidekiq incident is RESOLVED / VALIDATED and is not an open item.

## TASK 30 — VALIDATED READINESS REVIEW: AUTHENTICATION AND IDENTITY PROVIDERS

- **Status:** VALIDATED readiness review, read-only. Result: `YES — NATIVE/BUNDLED SUFFICIENT`.
- **Durable findings:** `02_PROJECT_STATE.md` → TASK 30.

## TASK 31 — VALIDATED LOCAL EMAIL RECOVERY ACCEPTANCE

- **Status:** `VALIDATED — LOCAL EMAIL RECOVERY ACCEPTANCE` by official PM adjudication. Native forgot-password (code-based) and email login were proven end to end locally with a temporarily started Mailpit and one synthetic user, since deleted.
- **Durable findings:** `02_PROJECT_STATE.md` → TASK 31.

## TASK 32 — VALIDATED STAFF 2FA ACCEPTANCE

- **Status:** `VALIDATED — STAFF 2FA ACCEPTANCE` by official PM adjudication. Native TOTP enrollment and login, wrong-TOTP rejection, single-use backup codes and `users:disable_2fa` recovery were proven with one synthetic moderator, since deleted. `enforce_second_factor` is back at `no`; no real staff account is enrolled or under persistent enforcement.
- **Durable findings:** `02_PROJECT_STATE.md` → TASK 32.

## TASK 33 — VALIDATED GIT OWNERSHIP HYGIENE

- **Status:** `VALIDATED — GIT OWNERSHIP HYGIENE` by official PM adjudication. The root-owned paths under the application repository's `.git/objects` are RESOLVED: the Founder corrected ownership on seven proven paths, normal unprivileged Git object creation works, and `git fsck` found no corruption. The theme and plugin repositories had no such defect.
- **Operating rules (ratified):** Git commands inside `cannlabs_community_dev` run as the `discourse` user, never as the container's default root; and `STOP — do not change content to evade Git object ownership failures`.
- **OPEN / LATER — local filesystem hygiene (separate, not authorized):** root-owned paths under `tmp/` and the root-owned `plugins/cannlabs-community-qualified-access` mount-point directory. Neither is Git metadata, and neither was repaired.
- **Durable findings:** `02_PROJECT_STATE.md` → TASK 33.

## TASK 35 — VALIDATED GOOGLE OAUTH LOCAL ACCEPTANCE

- **Status:** `GOOGLE OAUTH LOCAL ACCEPTANCE VALIDATED` (official PM). Core Google auth is sufficient (`YES — CORE GOOGLE AUTH IS SUFFICIENT`); no custom OAuth is authorized. Same-email linking without duplicates, membership retained on link, a non-member Google signup, same-account relogin, full native cleanup and exact settings restoration were proven locally with synthetic Community accounts. Production remains NOT READY.
- **Durable findings:** `02_PROJECT_STATE.md` → TASK 35.

## TASK 36 — VALIDATED DEVELOPMENT LOGGING HYGIENE

- **Status:** `VALIDATED` (official PM). A fork-owned initializer filters `code`, `state`, `token`, `access_token`, `refresh_token`, `id_token`, `client_secret` and `authenticity_token` by exact name in every environment, and turns development ActiveRecord SQL logging off by default (`CANNLABS_ENABLE_ACTIVERECORD_LOGS=1` opts one process back in). The contaminated local logs were removed after Founder approval; fresh logs run under the hardened defaults.
- **Durable findings:** `02_PROJECT_STATE.md` → TASK 36.

## TASK 37B — VALIDATED PRODUCTION-LIKE REPRODUCIBILITY AND DISASTER-RECOVERY PROOF

- **Status:** `VALIDATED` (official PM): Task 37B.1, Task 37B.2A, Task 37B.2B and Task 37B overall. `PRODUCTION — NOT READY`; this proves production-like infrastructure and disaster-recovery mechanics only.
- **Durable findings and the validated state:** `02_PROJECT_STATE.md` → TASK 37B; decisions `DEC-037` and `DEC-038`.
- **DECIDED — DURABLE DEPLOYMENT DEFINITION OWNERSHIP = COMMUNITY REPO** (`DEC-039`; was `OPEN` at Task 37B closure). The validated production-like definition (SHA-256 `89222f0a…065f`) is tracked byte-identical at `ops/discourse/cannlabs-prodlike.yml` with a runbook (Task 38A, awaiting PM validation). **OPEN — MACHINE-INDEPENDENT DEPLOYMENT REPRODUCIBILITY:** it needs a fresh second host or distribution built only from the tracked artifacts and documented values. Not validated and not authorized.
- **RESOLVED — PRODUCTION-LIKE DEPLOYMENT DEFINITION: fresh-install defect.** Log hardening assumed a directory that does not exist on empty storage; the definition now creates it (`DEC-037`). The superseded definition (`0eb16493…7885`) must not be used.
- **LOW / OBSERVATION — `remote_themes` rows after a native restore** (`EXPECTED UPSTREAM SEED SIDE EFFECT / NON-BLOCKING`). Do not fix.
- **Retained — MEDIUM:** the stock runit service resets the nginx runtime log permissions on every start; `error_log emerg` is an observability trade-off; the zero-leak logging guarantee is bounded to the proven secret and message shapes.
- **Retained — LOW:** safe `/invites/*` paths are over-redacted; `DISCOURSE_RELATIVE_URL_ROOT` is not covered; production Logster depends on its ignore list.
- **Retained — OBSERVATION:** a launcher rebuild causes downtime; the prebuilt fork asset tarball returns 404 so assets build locally; the native restore flushes the Redis-backed Logster store; scheduled post-restore maintenance is normal; the application container has no Docker `HEALTHCHECK`.
- **INTENTIONALLY RETAINED — CLEANUP NOT YET AUTHORIZED:** the rollback and failed-attempt trees under `/var/discourse/shared/`, the root-safe backup under `/root/prodlike-backups/`, evidence under `/root/prodlike-logs/` and `/root/validate-37b2b`, and dangling Docker images.
- **PRODUCTION — NOT READY; remaining areas (none authorized):** machine-independent deployment reproducibility (ownership is `DECIDED`); real hostname and DNS; TLS and edge; production SMTP; real Google OAuth credentials; Apple OAuth production configuration; billing and paid-membership mechanism; real staff 2FA enrollment and recovery readiness; backup retention and off-machine backup policy; Legal / LGPD / Trust & Safety review; final security, privacy and launch sweep.

## AUTHENTICATION READINESS — OPEN ITEMS (none authorized)

- **NEXT — the remaining approved sequence** (`02_PROJECT_STATE.md` → NEXT AFTER TASK 37B), including the staff 2FA production rollout. Task 37B, the clean production-like build and restore proof, is VALIDATED. Not authorized.
- **RESOLVED — LOCAL DEVELOPMENT (Task 36): OAuth development logging** (the Task 35 MEDIUM). Production-like logging behaviour was acceptance-tested in Task 37B.1 within a defined secret-shape contract.
- **LOW — orphaned Google profile-picture upload** awaiting the native orphan-upload cleanup after its grace period.
- **PARKED — native scheduled backup `[FAILED]` around 03:30Z on 2026-10-03,** not investigated in Task 35.
- **REQUIRED BEFORE PRODUCTION — staff 2FA rollout.** Enroll every real staff account, verify login with its second factor, establish the recovery / backup-code procedure, confirm no staff account remains unenrolled, and only then leave `enforce_second_factor = staff` enabled.
- **MEDIUM — Security / Operational Readiness: staff enforcement boundary.** For an unenrolled staff account, native enforcement redirects HTML navigation to the enrollment page; JSON and API requests are exempt from that redirect. The setting alone does not make an unenrolled staff account safe. Recorded as native behaviour, not as a vulnerability.
- **OPEN — local WebAuthn acceptance / environment issue.** The development WebAuthn origin is tied to `http://localhost:3000` while Community runs on `http://localhost:3100`; security-key and passkey acceptance are untested. No core patch is authorized.
- **RESOLVED — LOCAL DEVELOPMENT (Task 36): TOTP secret in development SQL logging** (was LOW). `second_factor_token` is filtered in request logs.
- **OPEN — local mail catcher (dev-readiness gap).** Task 31 proved the mechanism with a temporary Mailpit, which was stopped afterwards. No mail catcher runs by default, nothing listens on port 1025 and the mail UI port 8025 is not published. Persistent developer-mail ergonomics is a possible future slice, not automatically next. This is not the production SMTP decision.
- **CONDITIONAL RISK — CLI link port (narrowed by Task 31).** The canonical local address for authentication is `http://localhost:3100`. Background-job mail uses it. Only a standalone CLI or Rails-runner context without `UNICORN_PORT=3100` can emit `http://localhost:3000` links; future link-generating CLI commands must account for the port.
- **MEDIUM — Security / Privacy Readiness: transient authentication material in request logs.** Partly resolved by Task 36: the password-reset `code` parameter is now filtered. Reset and login tokens that appear as URL path segments are RESOLVED — PRODUCTION-LIKE, within the defined secret-shape contract (Task 37B.1); the bounded-guarantee limits are recorded under "TASK 37B" above.
- **RESOLVED — LOCAL DEVELOPMENT (Task 36): password hash and salt in development SQL logging** (was LOW).
- **LOW / LATER — localization:** the forgot-password code email arrives in English while the email-login mail is in pt-BR.
- **TESTING CONSTRAINT — `.invalid` recipients receive no mail** (`Email::Sender` skips them). Mail acceptance tests use another reserved domain such as `.test`.
- **OBSERVATION — sender identity:** local mail uses the default sender domain `unconfigured.discourse.org`; part of production SMTP / domain readiness (see the production-foundation list above).
- **REQUIRED BEFORE ENABLING ANY PROVIDER — external-provider acceptance tests,** covering automatic account linking by verified email (Google), provider emails treated as verified (Apple, Facebook), Apple private-relay addresses creating a second account, and external signups that are not automatically in `membros_ativos`. No mitigation is designed or authorized. Google's linking and non-member signup were accepted locally in Task 35; Apple and Facebook remain untested.
- **NEEDS SECURITY REVIEW — Apple private key.** The bundled plugin does not flag `apple_pem` as `secret`. Review before real Apple credentials are entered; do not change plugin code.
- **OPEN / HYPOTHESIS — Facebook login** (`DEC-034`).
- **REQUIRED BEFORE PRODUCTION — staff 2FA** (decision unchanged; acceptance validated in Task 32, rollout above).
