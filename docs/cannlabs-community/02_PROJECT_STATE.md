# CannLabs Community — Project State

Status: CURRENT
Date: 2026-10-02 (baseline written 2026-09-29)

Evidence was captured from the development machine when this baseline was written (2026-09-29). Later sections are appended as slices close; where an older section and a later one differ, the later one is current.

## CURRENT STATE — 2026-10-02

- **NOW:** no slice is in progress. Task 33A (documentation closure) brought the durable state up to date through Task 33. The official PM intends to move toward the first external authentication provider; Google Authentication Provider Readiness is the likely next direction, not an authorization, and nothing of it is started (last section of this file).
- **Production:** NOT READY. Task 27 is a validated readiness review (`07_PRODUCTION_SECURITY_FOUNDATION_READINESS.md`). Task 28 closed the product-configuration bootstrap part of its principal gap; a clean production-like deployment, staff 2FA, SMTP, secrets, authentication providers, payment and the Legal / Privacy / Trust & Safety gates remain open. No production or staging environment exists.
- **Validated so far:** repository bootstrap, isolation and operating layer (through Task 04B); design direction, prototype, theme architecture and handoff (Tasks 05–08); Community Theme v0.1 (Tasks 10 / 10B); V1 product model (Task 12A); Access Skeleton (Task 14); Founder local login (Task 15A); verified roles and restricted spaces (Tasks 16 / 16A); qualified-access gap, architecture and plugin v0.1 (Tasks 17, 18A, 19); verified-identity boundary and synthetic professional lifecycle (Tasks 20B, 21); synthetic association / leadership lifecycle (Tasks 22 / 22A); moderation readiness and native moderation lifecycle (Tasks 23A, 24); Active Membership Safety Boundary including the native Site Feedback retirement (Task 26, `DEC-032`, `DEC-033`); production / security foundation readiness review (Task 27); Product Bootstrap v0.1 (Task 28); local-auth baseline (Task 29); authentication and identity-provider readiness review (Task 30); local email recovery acceptance (Task 31); staff 2FA acceptance (Task 32); Git ownership hygiene of the application repository (Task 33).
- **Authentication:** native and bundled Discourse are sufficient for V1 (`YES — NATIVE/BUNDLED SUFFICIENT`). Local login, Google and Apple are the DECIDED direction; Facebook is OPEN / HYPOTHESIS (`DEC-034`); staff 2FA is required before production. Its native mechanics are validated (Task 32), but it is not enabled (`enforce_second_factor = no`) and no real staff account is enrolled. No external provider is enabled or configured. Local password reset and email login are proven end to end with a temporarily started mail catcher (Task 31); no production SMTP provider is selected.
- **Repositories:** application `leo-even/CannLabs-Community` (this fork; docs, the operating layer and the Task 28 bootstrap mechanism); theme `leo-even/CannLabs-Community-Theme` at `aeb3a9d9154f532064dcc24ac9e78cf587588d77`; plugin `leo-even/CannLabs-Community-Qualified-Access` at `ca4f0070d7bf85e42dbfa7f8736469139bb20275`.
- **Latest decision:** `DEC-034`.

The sections below are kept as validated history in the order they were written.

## VALIDATED

### Repository bootstrap — VALIDATED

- Public, true GitHub fork `leo-even/CannLabs-Community` of `discourse/discourse`; default branch `main`.
- Remotes: `origin` = `https://github.com/leo-even/CannLabs-Community.git`; `upstream` = `https://github.com/discourse/discourse.git`.
- Isolated from FeedCheck, CannLabs Traceability and every other CannLabs product.

### Vanilla Discourse local start — VALIDATED

- Started with the official Discourse development image and upstream workflow, with no customization.
- Fresh, isolated database containing only upstream default data.

### Authoritative WSL development worktree — VALIDATED (Task 02)

- Active worktree: `/home/leo/source/repos/CannLabs-Community` (Ubuntu-24.04, ext4, not under `/mnt/c`).
- Community runtime: `http://localhost:3100`.
- FeedCheck, a separate product: `http://localhost:3000`.
- Upstream base when this baseline was written: `d8d59f720e4d9a2687a94984ed1c927f1ebd4933` ("FEATURE: Allow admins to test CAPTCHA keys (#44178)"). It was equal to `origin/main` and `upstream/main` before the commit that adds this directory.

### Durable product baseline — VALIDATED (Task 03 and 03A)

- `docs/cannlabs-community/` baseline (commit `e02f6d4c`) and its factual corrections (commit `0fcdc9bd`).

### Community agent/skill operating layer — VALIDATED (Task 04)

- Four Community-specific additive skills exist beside the upstream ones: `community-repo-audit`, `community-feature-planning`, `community-design-handoff` and `community-review` (commit `77c55b5d`).
- The upstream `discourse-*` skills remain intact.
- The Community operating contract lives at `.skills/community-repo-audit/references/operating-contract.md`.
- No upstream `AI-AGENTS.md`, `AGENTS.md`, `CLAUDE.md`, `.gitignore` or `discourse-*` skill was modified for this layer.
- The layer passed fresh-session acceptance in native WSL Claude Code.

### Design Director WSL rebind — VALIDATED (Task 04A / 04B)

- The permanent Design Director continuation operates from `/home/leo/source/repos/CannLabs-Community`.
- In that WSL-native session, the skill mechanism naturally discovered all 4 `community-*` skills and all 17 upstream `discourse-*` skills, and `community-repo-audit` loaded the Community operating contract.
- Old Windows Design Director chats are historical, read-only evidence.
- The Windows reference clone remains non-authoritative.

### Community design direction — VALIDATED (Task 05)

Only the design direction is validated; no theme exists and nothing was implemented.

- The permanent WSL Design Director completed read-only design discovery; the official PM reviewed the proposal and the Founder ratified the recommended decisions (`DEC-018` to `DEC-021`).
- Visual register "Arquivo em casca de Estufa": Estufa shell, Arquivo content.
- Structural base: a thin CannLabs adaptation on the Discourse core / Foundation structure; Horizon is reference only. Discussion is a list, not a card feed.
- Circular avatars are a formal Design System exception (circle = person).
- Intended language: pt-BR. `default_locale` is unchanged.
- The first visual prototype will be static / non-persistent. Theme packaging was left OPEN; it is now decided in `DEC-024`.
- The Design Director proposal is kept as evidence outside the repository; it is not canon.

### Community static visual prototype — VALIDATED (Task 06)

The visual direction is validated; no production theme exists, and fine polish is LATER (`DEC-023`).

- The Design Director built a static, non-persistent prototype of the shell, `/latest`, `/categories` and the mobile drawer, in light and dark, desktop and mobile, with fictional pt-BR fixture content. Task 06A replaced the typed stand-in with the real CannLabs wordmark from the Design System. Nothing was installed in Discourse and the runtime was unchanged.
- The Founder reviewed it visually and approved moving forward; the official PM set Task 06 VALIDATED (`DEC-022`).
- Shell: deep L-frame, with the paper CannLabs wordmark on the deep shell.
- Topic-list titles in Petrona remain a HYPOTHESIS until tested with the real font; Public Sans is the fallback.
- Letter-avatar colours stay native for the first implementation (`DEC-023`).
- The prototype, screenshots and measurements are kept as evidence outside the repository; they are not canon.

### Architecture / upstream reuse review — VALIDATED (Task 07)

- A fresh, read-only native-WSL reviewer compared the packaging options against the current fork and upstream. Nothing was implemented, installed or created.
- The official PM adopted the architecture: one full Discourse theme in a dedicated Community-owned theme repository, `leo-even/CannLabs-Community-Theme`, installed through the standard git-theme mechanism; the fork holds no theme code (`DEC-024`). The theme repository does not exist yet.
- Logo: the canonical Design System SVG, unchanged, through native `logo` / `mobile_logo` settings. Fonts: binary provenance is OPEN and required before bundling.
- The review is kept as evidence outside the repository; it is not canon.

### Discourse-native design handoff — VALIDATED (Task 08)

The implementation contract for Community Theme v0.1. Nothing was implemented in Task 08; the theme was built in Task 10 (below).

- The permanent Design Director produced the handoff through `community-design-handoff` and signed it off; the official PM validated it.
- **v0.1 scope:** header, desktop sidebar, mobile drawer, `/latest` and `/categories`, light and dark schemes, desktop and mobile. No JavaScript, plugins, theme components or core changes; no topic page (beyond inherited tokens), composer, profile, auth, verification, organization or payment work.
- **Typography:** Petrona topic titles remain HYPOTHESIS behind a single title-family variable. Fonts do not block v0.1, which runs on defined fallback stacks; font binaries still need recorded provenance before bundling (`DEC-024`).
- **Acceptance baseline for the first implementation:** the handoff's accessibility criteria A1–A11; native responsive geometry; 200% browser text; 320 CSS px reflow; 44px mobile targets; light and dark; anonymous and logged-in where they differ; the current modernize state plus one isolated modernize-OFF run with exact restoration; a rollback drill to Foundation. Fine visual polish stays LATER (`DEC-023`).
- The handoff (`community-theme-v0.1-handoff.md`) and its contrast measurements are kept as evidence outside the repository; they are not canon.

### Coder native-WSL rebind — VALIDATED (Task 09)

- The permanent Coder continuation is a native-WSL Claude Code session working from the authoritative worktree.
- It discovered the Community and upstream `discourse-*` skills naturally, ran `community-repo-audit`, and passed read-only readiness acceptance before it became a writer.
- The old Windows-hosted Coder context is historical / read-only.

### Community Theme v0.1 — VALIDATED (Task 10 / 10B)

- **Implementation:** the dedicated repository `leo-even/CannLabs-Community-Theme`, validated at commit `aeb3a9d9154f532064dcc24ac9e78cf587588d77`. A full Discourse theme installed through the standard git-theme mechanism, with two paired Community colour schemes; no custom JavaScript, plugin or core modification; fallback fonts only. The application fork contains no theme implementation code (`DEC-024`).
- **Validated surfaces:** header, desktop sidebar, mobile drawer, `/latest` and `/categories`, in light and dark, on desktop and mobile.
- **Evidence:** Design Director real-app QA PASS; 5 theme system specs with 0 failures; the restricted-category lock (B1-R) at 5.38:1 in light and 5.84:1 in dark; findings B1, H1 and H2 resolved; the Task 10 200% text / reflow evidence remains accepted; rollback to Foundation proven; the application repository stayed clean and isolated.
- **Task 10A — PARTIAL / SUPERSEDED by Task 10B.** Accepted evidence: the Community dev workers were restarted onto the current application HEAD, so the stale app-version cache workaround is no longer needed; the minimum Chromium runtime libraries were installed inside the Community dev container, and the theme system specs became executable and passed. Its B1-R code correction targeted the wrong variable; Task 10B supplied the validated correction.
- Kept LATER / OPEN (not solved by v0.1): the site-wide derived-colour / footer / focus pass (M1); category-square colours once categories are designed (M2); the `/categories` "Recentes" title weight (L1); the skip-link visual (L2); the mixed-language site title (L3); fine polish (`DEC-023`); real font binaries and their provenance, and the Petrona hypothesis (`DEC-022`, `DEC-024`); theme LICENSE attribution / copyright hygiene; `minimum_discourse_version`; the production deployment strategy. None blocks V1 product discovery.

### Founder local test login — VALIDATED (Task 15A)

- The local `bemstorm` test account exists as a normal active, non-admin, non-moderator user and remains in `membros_ativos`.
- Its local password was repaired through the native Discourse `UserPassword` mechanism; the password is intentionally not recorded here.
- Real-browser acceptance passed: login, authenticated transition, reload persistence, normal logout, anonymous gate restoration and a second successful login. `Comunidade` was visible with expected member permissions.
- No source, theme, authentication architecture or runtime architecture change was required.

### Source-of-truth reconciliation

- **Current truth:** exactly one editable source copy exists, the WSL worktree. The development container bind-mounts it at `/src`. The Windows clone `C:\Users\Leo\source\repos\CannLabs-Community` is a bootstrap / reference clone only. The temporary Docker source volume used for the vanilla start (`cannlabs_community_src`) has been removed.
- **SUPERSEDED:** the pre-Task-02 observation of three source copies (Windows clone, Docker source volume and a planned WSL worktree). Task 02 resolved it.

### Access Skeleton — VALIDATED (Task 14)

- The native `membros_ativos` / “Membros da Community” group is the single active-member authorization signal. It is not a payment, professional-verification, association, company or staff-role system.
- The native `Comunidade` category is restricted by the active-member group only. Registered users outside that group cannot read, create or reply there; public discovery remains on CannLabs Web.
- Local development is login-gated (`login_required=true`); registration remains enabled. Member-to-member personal messages and native Chat remain off, while the native `equipe` staff support path remains available.
- The validated unpaid → active → expired acceptance sequence passed with the synthetic local `bemstorm` account; account and staff-support persistence were preserved. No custom code, plugin, theme or core change was needed.
- The WSL application and theme repositories are clean and synchronized at the validated commits recorded above. No production deployment is implied.

### Task 16 — VALIDATED LOCAL ARCHITECTURE

- Native profession-specific identity groups exist for physicians, pharmacists, agronomists and lawyers. Their technical names are implementation details constrained by Discourse's native 20-character `Group.name` limit.
- Qualified authorization is separate from identity through `acesso_profissionais` and `acesso_liderancas`.
- Native restricted categories exist for `Profissionais Verificados` and `Lideranças de Associações`, each trusting only its corresponding authorization group.
- Identity membership does not itself grant restricted access. Multiple professional identities coexist cumulatively.
- Local acceptance proved ordinary active members could not see restricted spaces, identity alone did not grant access, qualified authorization did grant access, revoking authorization removed access while retaining identity, leadership authorization was independent, and the synthetic memberships were removed after QA.
- Founder account `bemstorm` returned to the ordinary active-member state. No real verification data was processed, and no custom code, plugin, core or theme change was required.

### Task 17 — QUALIFIED-ACCESS LIFECYCLE / AUTOMATION READINESS

- The production invariant is `membros_ativos` **AND** at least one verified-profession identity for `acesso_profissionais`; leadership access additionally requires active CannLabs leadership authorization.
- Native category group ACLs are OR-based. Removing `membros_ativos` alone is therefore insufficient if a qualified authorization group remains.
- The bundled `automation` plugin is present in the current fork but `discourse_automation_enabled=false` and there are no configured automations. It exposes user-added/removed-from-group triggers and recurring triggers, plus scripts that can add groups through a custom field or synchronize a group through a badge; it does not provide a native multi-group intersection predicate or a qualified-access reconciliation action.
- Core emits supported `user_added_to_group` and `user_removed_from_group` events and records group membership history, but no native configuration in this checkout safely enforces the required AND invariant. No listener, automation, plugin, source or runtime mutation was made.
- **Recommendation:** `NOT READY — upstream gap proven; bounded custom synchronization requires architecture review`. Do not implement verification, billing, onboarding or synchronization until PM review.

## COMPLETED READ-ONLY DISCOVERY

This is research and discovery evidence, not product implementation.

- **Coder context load** — completed, read-only.
- **Design Director context load** — completed, read-only.

The durable findings are summarized in `04_DISCOVERY_BASELINE.md`.

## ACTIVE — AS OF TASK 20 (HISTORICAL)

Superseded as the current pointer by "CURRENT STATE" above; Task 20 closed as Task 20B.

- Task 16A is closed as the durable documentation closure for the validated local verified-professional identity, qualified access and restricted-space skeleton.
- Task 17 is validated: the upstream/native gap was proven.
- Task 18A is validated/decided: qualified-access synchronization architecture is ratified.
- Task 19 is validated: the bounded Community Qualified Access plugin v0.1 is implemented and locally accepted.
- Task 20 was, when this list was written, the active read-only readiness research slice for professional verification and association onboarding.
- Task 12A V1 product decisions are ratified and recorded in `00_PRODUCT_CANON.md` §22, `01_DECISION_LOG.md` DEC-025–DEC-029 and `05_V1_PRODUCT_SPEC.md`.
- Task 14 Access Skeleton is validated and closed in documentation.
- Task 15 is closed as the preceding readiness review; Task 17 and Task 18A supersede its lifecycle question.

## Task 19 — VALIDATED LOCAL PLUGIN V0.1

The official PM validated the bounded Qualified Access plugin v0.1 and its local recovery path.

- Separate public repository: `leo-even/CannLabs-Community-Qualified-Access`.
- Validated revision: `ca4f0070d7bf85e42dbfa7f8736469139bb20275` (`chore: keep qualified access flag server-side`).
- No application-core or theme customization, custom database tables, migrations, ACL system or credential storage.
- Native source groups reconcile to native derived groups through native group events, idempotent per-user reconciliation and a 15-minute drift sweep.
- Missing-source state fails closed; native group history remains the audit trail.
- The enable flag is server-only; local value is true and production enablement is not authorized.
- `liderancas_aprov` is the persistent staff-controlled leadership source group; `acesso_liderancas` remains derived.
- The Founder launcher can reuse, start or recreate the Community container, preserve `cannlabs_community_pg`, mount both authoritative WSL repositories and bootstrap bundle dependencies.
- Acceptance passed: 22 examples / 0 failures; professional, leadership and drift lifecycles; complete launcher recreation; persistent product state; clean application, theme and plugin repositories; Founder restored to ordinary active-member state.
- FeedCheck was untouched.

## NOT AUTHORIZED

Nothing below is authorized. Presence in the backlog does not authorize work.

- product feature implementation;
- a custom roles system;
- a custom ACL system;
- category taxonomy implementation;
- payment implementation;
- authentication configuration or customization;
- professional verification implementation;
- association workflow implementation;
- company workflow implementation;
- private messaging changes;
- Design System import or integration;
- theme implementation beyond the validated v0.1;
- plugin implementation beyond the validated Qualified Access plugin v0.1 (Task 19, `DEC-030`), and production enablement of that plugin;
- a strain database;
- structured-post mechanics;
- production or staging deployment, domain, DNS, Cloudflare, HTTPS, SMTP and secrets;
- staff 2FA enablement;
- real memberships, real professional verification and real association onboarding.

Authorized exceptions are only those a validated slice records: the native local configuration of Tasks 14, 16, 21, 22, 24 and 26, and the Task 28 bootstrap mechanism.

## CURRENT RUNTIME NOTES

- Community runs at `http://localhost:3100` in the Docker container `cannlabs_community_dev` (official image `discourse/discourse_dev:20260812-0036`, database volume `cannlabs_community_pg`).
- FeedCheck runs at `http://localhost:3000`. It is a separate product; do not touch it.
- The WSL worktree is authoritative, and the container runs exactly its files.
- The Windows clone is reference-only; do not develop there.
- Native Claude Code is installed inside Ubuntu (WSL), under the user's home, for Community agent sessions started from the WSL worktree.
- A local development admin exists for authenticated QA. It was created with the upstream `bin/rake admin:create` task, and its credential is stored outside the repository, under `~/.config/cannlabs-community/` in the WSL user's home. Never commit credentials.
- The local preview configuration `.claude/launch.json` (ignored by the upstream `/.claude` rule) targets `http://localhost:3100`. Never start a second development server on port 3000.
- After a Docker engine restart the container comes back on its own, but the app server must be relaunched. Since Task 19 the Founder launcher does this (see "Runtime notes — 2026-10-02" below). The original manual command, kept as history:

  ```bash
  docker exec -d -u discourse:discourse -w /src -e RUBY_GLOBAL_METHOD_CACHE_SIZE=131072 -e LD_PRELOAD=/usr/lib/libjemalloc.so cannlabs_community_dev bash -c "exec bin/dev >> /src/log/bin-dev.log 2>&1"
  ```

- Git state before this baseline commit: `main` = `origin/main` = `upstream/main` at `d8d59f72`; clean working tree.
- **`modernize_foundation_theme` (technical evidence, Tasks 07 / 07B / 08).** Source YAML default `false`, status `beta`; `promote_upcoming_changes_on_status` is `beta`; no database override for either. The current effective state is **ON for everyone**: the change is enabled site-wide and for logged-in users, and live anonymous pages also carry `body.uc-modernize-foundation-theme` (Task 08), which corrects the earlier note that anonymous visitors do not get the body class. The Task 05 description "off by default" is stale. Do not change either setting outside an authorized slice. Implementation QA covers the current state plus one isolated modernize-OFF run with exact restoration afterwards.
- **Local Community configuration (development only).** Community Theme v0.1 is installed and the default theme, pinned to a reviewed commit with manual updates only (no automatic updates). Local development uses the pt-BR locale, and the canonical CannLabs wordmark is configured through the native `logo` / `mobile_logo` settings. No production deployment exists.
- **Local test stack.** The Community dev container has the `discourse_test` database and the Playwright Chromium binary with its minimum runtime libraries, so theme system specs run inside the container.

## KNOWN ENVIRONMENT FOLLOW-UPS

None of these is solved in this slice.

- **Git author identity.** A repository-local identity derived from the authenticated GitHub account (profile name plus the account's GitHub no-reply address) was set for the baseline commit. The Founder should confirm or replace it before normal development commits.
- **lefthook / pre-commit.** The upstream `pnpm install` installs a lefthook `pre-commit` hook. The development image sets `LEFTHOOK=0`, so the hook is skipped inside the container, while a commit made directly from Ubuntu would need a Ruby and Node toolchain that the host does not have. Reconcile this with container-based development before the first code slice.
- **Push credentials from WSL.** No Git credential helper is configured in WSL. Decide a durable, least-privilege setup before routine pushes.
- **GitHub Actions on the fork — OPEN.** The workflow definitions contain push triggers that appear applicable to changes on `main` (including `Tests`, `Linting` and `Licenses`), but the baseline push `e02f6d4c` produced no GitHub Actions runs, no run IDs and no Actions status checks. The cause is unresolved. CI enablement and policy must be reviewed before the project relies on GitHub Actions as validation evidence (`04_DISCOVERY_BASELINE.md` §1.5 and §3).
- **Cloudflare GitHub integration — OPEN (Infrastructure / Security / Deployment).** The GitHub app `cloudflare-workers-and-pages` has access to this repository. The baseline push produced a Cloudflare-associated check suite, which was still queued when inspected; no deployment was observed. Review the integration's repository access and intended deployment role before production deployment. Its presence does not establish an active Community deployment.
- **Windows host clock — RESOLVED / VALIDATED (2026-10-02).** The Founder corrected Windows time synchronization and the official PM validated the result; see "LOCAL CLOCK / SIDEKIQ INCIDENT" below. History: the earlier WSL clock-drift attribution was incorrect, and a later comparison with GitHub server time showed the Windows host clock about 304 seconds (roughly five minutes) ahead. This is no longer an open follow-up.
- **Passkeys on port 3100.** Upstream hardcodes the development WebAuthn origin to `http://localhost:3000` (`lib/discourse_webauthn.rb`), so passkeys do not work on the Community development port. Do not patch core for this. **OPEN — local WebAuthn acceptance / environment issue:** security-key and passkey acceptance were not part of Task 32 and remain separate; this does not affect the TOTP acceptance.
- **Correction-loop rule — future operating-layer improvement.** Lesson from Tasks 10–10B: bound a correction loop by finding and scope, not by a fixed number of commits. For the same validated finding, with an evidenced root cause and a tightly bounded correction that expands no product or scope, the official PM may authorize further bounded correction until the acceptance criterion converges. This is not an unlimited fix loop: a materially new finding returns to normal readiness / scope arbitration. The operating skills are not changed yet.

## NEXT

Reconciled on 2026-10-02 (Task 33A); Tasks 28 to 33 are validated and closed.

1. The next bounded authentication slice — the official PM's choice. The likely direction is Google Authentication Provider Readiness (last section of this file). Nothing is authorized or started.
2. Staff 2FA production rollout: enroll and verify every real staff account first, then rely on persistent `staff` enforcement (operational rule in "TASK 32" below). Required before production; not authorized.
3. A later slice proving a clean production-like environment end to end: supported production deployment, theme and plugin installation, bootstrap application, secrets, external services and smoke tests (`07_PRODUCTION_SECURITY_FOUNDATION_READINESS.md`).
4. Legal / Privacy / Trust & Safety review.
5. The remaining authentication providers (external-provider acceptance tests first) and payment readiness as separate slices.

The order is a candidate sequence, not an authorization. Visual polish is no longer the critical path. The Founder local test login is validated by Task 15A and its credential was rotated after Task 29; no credential is stored in the repository.

No implementation starts automatically; each step needs explicit official PM authorization.

## TASK 20B — VERIFIED IDENTITY / RESULT-ONLY BOUNDARY (RATIFIED)

Task 20B ratified the local V1 operating boundary in `DEC-031` and Canon §24: a verified professional uses a non-empty native public name while username remains the handle; native role presentation is allowed; only result-only verification metadata is retained; native User Notes are staff-readable operational notes and never credential evidence; approval/revocation is admin-only; name changes require re-review and there is no automation or self-service intake.

This is documentation ratification only. Task 21 is a synthetic local lifecycle acceptance using reversible native primitives. No real credential, identifier, document, CPF/RG, address, health data, association onboarding, payment, production verification or deployment is authorized. Production Legal / Privacy / Trust & Safety remains a required gate.

## TASK 21 — SYNTHETIC LIFECYCLE (AUTHORIZED LOCAL VALIDATION)

The bounded local test may temporarily enable native User Notes, create one clearly synthetic result-only note for `bemstorm`, set a synthetic public professional name, apply native presentation, add and remove one professional source group, verify derived access and native browser presentation, delete the note, and restore every captured state. User Notes remains enabled locally after acceptance as explicitly authorized; all other temporary mutations must be restored exactly.

## TASK 21 — VALIDATED SYNTHETIC PROFESSIONAL LIFECYCLE

Task 21 is validated locally using native Discourse primitives only. One clearly synthetic result-only User Note was created without CRM/CRF/CREA/OAB/CPF/RG identifiers, documents or evidence; normal users could not read it; native public `User.name` and professional title presentation were proven while the username remained unchanged; adding `medicos_verif` automatically derived `acesso_profissionais` and removing it revoked access; the note and all synthetic identity/presentation state were deleted/restored; `bemstorm` returned to ordinary active-member state. No real professional verification occurred.

`user_notes_enabled=true` remains enabled for local development only. Production use remains gated.

### Production operating dependency

Native `User.name` remains user-editable. There is no automatic name-change → professional re-review → source-group revocation lifecycle. Before real verified professionals, define the name-change review procedure, operational owner and re-verification/revocation SOP. No automation is authorized.

## NOW — TASK 22 SYNTHETIC ASSOCIATION IDENTITY / LEADERSHIP LIFECYCLE

Task 22 is the next bounded synthetic native-group acceptance. Real professional verification, real credential intake, real association onboarding/evidence, production launch and payment remain unauthorized.

## TASK 22A — VALIDATED SYNTHETIC ASSOCIATION IDENTITY / LEADERSHIP ARCHITECTURE

Task 22 is durably validated against the authoritative WSL Community worktree. A synthetic native association group was created with logged-on-user visibility and no public admission or exit. Association membership alone did not grant leadership; `liderancas_aprov` derived `acesso_liderancas` only while `membros_ativos` was present. The synthetic group, membership and note were removed and the local baseline restored.

Native Groups are sufficient for V1 association identity and leadership authorization. No custom Organization model, dashboard, seat management, delegated owners, org-owned private forum, CRM, storefront, marketplace, company organization model or association billing is authorized. Existing Canon and `DEC-031` remain authoritative.

## NOW — TASK 23 MODERATION / TRUST & SAFETY / OPERATIONS READINESS

## TASK 23A — VALIDATED READINESS: NATIVE MODERATION SUFFICIENT FOR V1

Task 23 is closed as readiness evidence. Native flags, Review Queue, warning, silence, suspension, content actions, moderation/review history, post revisions, trust levels and new-user limits are sufficient for V1. Category moderators, custom moderation plugins, AI moderation, custom reputation and bespoke flagging are not justified. Member-to-member PM and Chat remain off; support remains through `equipe`; User Notes remain concise operational notes only. The cannabis boundary remains no sale, negotiation or intermediation of cannabis through Community. Public rules and exact medical/legal disclaimers remain draft and counsel-gated. No new Decision ID was required.

## NOW — TASK 24 SYNTHETIC NATIVE MODERATION LIFECYCLE

Validate one reversible synthetic report → Review Queue → staff action → warning/silence → support/appeal path using native primitives only. No real moderation, real users, custom code or global policy changes are authorized.


## TASK 26 — NOW: ACTIVE MEMBERSHIP SAFETY BOUNDARY

The official PM ratified DEC-032: normal Community content requires membros_ativos; General, Uncategorized and Site Feedback are member-only, not onboarding spaces; all active members may report regardless of Trust Level; unpaid accounts retain only account/onboarding/legal/support surfaces and no ordinary reporting rights. Task 23A remains validated readiness. Task 24 is authorized to resume after the native flag eligibility correction. Task 25 evidence remains read-only readiness evidence.

Staff 2FA is a Security / Product / Operations requirement, not a counsel gate; it is not implemented by Task 26.

## TASK 24 — VALIDATED NATIVE MODERATION LIFECYCLE

Task 24 is durably validated with native Discourse primitives: an active TL0 member reported through native group-based eligibility after membros_ativos was included; an unpaid TL0 account could not report; the inappropriate flag created a ReviewableFlaggedPost; Review Queue and staff agree_and_hide worked; ReviewHistory/UserHistory were sufficient; native warning, silence, moderator-notification support, short suspension and unsuspension worked; ordinary member PM and Chat remained disabled; no routine User Note was required; and all synthetic users/content/state were cleaned up. Appeal support was proven through the native moderator-notification/support path, not ordinary direct PM to equipe.

## TASK 26 — PARTIAL ACTIVE MEMBERSHIP SAFETY BOUNDARY

Validated components: General is member-only and active TL0 reporting works through membros_ativos while unpaid TL0 reporting remains denied. Open blocker: seeded Uncategorized and seeded Site Feedback remain readable by authenticated unpaid users because current Discourse prevents ordinary security edits to those special categories.

## TASK 26B — SITE FEEDBACK RETIREMENT PENDING SAFE NATIVE LIFECYCLE

DEC-033 ratifies retiring the upstream seeded Site Feedback scaffold from V1. The category and definition topic remain present while the local meta_category_id dependency, native delete behavior, and seed/reseed durability are reviewed. No custom deletion code or direct database bypass is authorized. Task 26 remains partial and unvalidated until the paid/private boundary is closed.

## TASK 26 — VALIDATED ACTIVE MEMBERSHIP SAFETY BOUNDARY

Task 26 is validated by the official PM following Task 26C runtime evidence. Normal Community discussion requires `membros_ativos`, unless a stricter qualified group applies. General and Comunidade are member-only; normal Uncategorized usage is disabled through the upstream lifecycle and its residual category is not an unpaid discussion surface; seeded Site Feedback was retired natively under DEC-033. Authenticated unpaid accounts cannot read normal Community discussion, active TL0 members can report through native group eligibility, unpaid TL0 accounts cannot report, native staff-support/moderator-notification support remains available, member-to-member PM and Chat remain off, and no custom access or moderation code was required.

`meta_category_id=2` remains tolerated upstream residue after native Site Feedback deletion. It is a known upgrade-regression dependency, not a V1 blocker. After every material Discourse upgrade, verify that Site Feedback is not recreated, boot remains healthy, seed/update behavior remains tolerant, and the unpaid boundary remains closed.

## NOW — TASK 27 PRODUCTION / SECURITY FOUNDATION READINESS

Task 27 is a strictly read-only architecture and operations review. Production deployment, credentials, payment, real onboarding, and implementation remain unauthorized.

## TASK 27 — VALIDATED READINESS REVIEW: PRODUCTION NOT READY

The official PM accepted the Task 27 read-only review on 2026-10-02 (Task 27A). Result: **NOT READY FOR PRODUCTION — principal gap: reproducible native product bootstrap.** The durable conclusions are in `07_PRODUCTION_SECURITY_FOUNDATION_READINESS.md`.

- The product and access architecture is already decided and validated.
- Significant product-critical state lives only in the native database and runtime; a fresh Discourse database would not reproduce CannLabs Community correctly.
- This is primarily an operations / bootstrap problem, not a new product-feature problem.
- The production direction favours supported Discourse production Docker mechanisms and pinned inputs. This is a recommended direction (HYPOTHESIS), not a decision.
- No production deployment was performed. Domain, SMTP, secrets, Cloudflare, payment and external monitoring remain unresolved and separate.
- Staff 2FA is required before production and is not enabled.

No new Decision ID was created.

**Site Feedback (`DEC-033`) — later resolution.** `DEC-033` recorded the retirement as pending, which was correct when written. The seeded Site Feedback category was retired through the native lifecycle in Task 26C, and Task 26 is validated. The Decision Log entry is unchanged.

## TASK 27A — LOCAL OPERATIONS RECONCILIATION

- **Founder launcher helper path — repaired.** The Desktop entry `Launch CannLabs Community.cmd` runs `%LOCALAPPDATA%\CannLabsCommunity\launch-community.ps1`. The validated helper had been written by a packaged Windows application, whose `%LOCALAPPDATA%` is redirected, so it never existed at the real path and a normal double-click would have failed. The same helper content was restored unchanged to the real `C:\Users\Leo\AppData\Local\CannLabsCommunity\`, where its `launcher.log` now lives. The Desktop entry was then run as a normal Windows session runs it and reused the healthy Community without recreating anything. The launcher is local operator tooling and lives in no repository.
- **Known launcher limits (unchanged, not redesigned):** it checks that Docker is available and stops with a message if it is not, rather than starting Docker Desktop; it recreates only a missing container, and stops with a repair message if an existing container has wrong mounts.
- **Stale documentation reconciled:** the current-state header, ACTIVE, NOT AUTHORIZED, NEXT and the runtime notes of this file, the `README.md` inventory, and the backlog's NOW bucket.
- **Generic Project Source Pack.** It is Project-level operating material and is intentionally not tracked in this repository. Its absence is not a repository defect.

## RUNTIME NOTES — 2026-10-02

These supersede the matching lines of "CURRENT RUNTIME NOTES" above.

- **Container.** `cannlabs_community_dev` was recreated by the Founder launcher on 2026-10-01 with the same image, the same `cannlabs_community_pg` volume and `127.0.0.1:3100` only. It bind-mounts the application worktree at `/src` and the Qualified Access worktree at `/src/plugins/cannlabs-community-qualified-access`.
- **App server.** The container's own command starts only PostgreSQL, Redis and system services. The Founder launcher starts the development server (`bin/dev`) inside the container and writes its output to `/home/discourse/.cache/cannlabs-community/local-launcher/bin-dev-launcher.log`.
- **Running workers keep the application revision they booted with.** A commit made after the development server started leaves the workers on the older revision. Cache invalidations published by a separate Rails process are then ignored by those workers until the development server is restarted; site-setting changes still propagate. Restart the Community development server before collecting runtime evidence that depends on theme or cache invalidation.
- **Local test stack.** The `discourse_test` database lives in the persisted volume and survived the recreation. The Playwright Chromium binary installed in Task 10A lived in the old container and is gone, so the theme system specs are not runnable until it is installed again in an authorized slice. Non-browser specs run.
- **Root-owned Git object directories — RESOLVED / VALIDATED (Task 33).** The Founder corrected the ownership and the official PM validated the result; see "TASK 33" below. History: directories and objects under `.git/objects` of the application worktree were owned by root, left by commits made as root inside the container on 2026-10-02, so a commit whose new objects hashed into a root-owned directory failed with "insufficient permission". Git commands in the container run as the unprivileged `discourse` user. This is no longer an open follow-up.
- **FeedCheck** remains a separate product. It is neither touched nor inspected from Community sessions.

## NOW — TASK 28 PRODUCT BOOTSTRAP CONTRACT v0.1

A small audit / apply mechanism for the security-critical, non-secret native product state: managed global settings, the custom group definitions, the category definitions and ACLs, the retired seeded surfaces, and theme / plugin prerequisites as audited expectations. Group memberships are operational data and are never bootstrapped. Local-only settings stay profile-gated.

Task 28 proves product configuration bootstrap. It does not authorize or prove production deployment, staging, domain, DNS, Cloudflare, HTTPS, SMTP, secrets, staff 2FA enablement, authentication providers, payment, real memberships, real professionals or real associations.

## TASK 28 — IMPLEMENTED, AWAITING OFFICIAL PM VALIDATION

Status superseded: the official PM has since validated Task 28 (see "TASK 28 — VALIDATED PRODUCT BOOTSTRAP v0.1" below). This section is kept as the implementation record.

Product Bootstrap v0.1 is implemented in this repository. Operator guide: `08_PRODUCT_BOOTSTRAP.md`.

- **Shape:** a declarative manifest (`config/cannlabs_community/bootstrap.yml`), one Rails-backed runner (`lib/cannlabs_community/bootstrap.rb`) and two rake tasks, `cannlabs_community:bootstrap:audit` (default-safe, no writes) and `cannlabs_community:bootstrap:apply`. No core file was modified; the fork gains four new files and their documentation.
- **Reuse:** native site-setting setter, group creation service, category permissions, Guardian-checked category deletion, and the native staff-action and group-history logs. No direct SQL, no schema, no request-time code.
- **Identity:** groups by technical name, native automatic groups by their stable key, categories by native site setting or slug. No database ids and no secrets in the manifest.
- **Profiles:** `local` also manages `user_notes_enabled` and `cannlabs_qualified_access_enabled`; in `production` both are gated and never applied.
- **Automated evidence:** 24 examples, 0 failures (`spec/lib/cannlabs_community/bootstrap_spec.rb`, plugins loaded).
- **Local runtime evidence (2026-10-02):** audit PASS on all 37 invariants; two consecutive applies reported NO CHANGE with an unchanged database fingerprint; one bounded live drift (removing `membros_ativos` from reporting eligibility) was detected by audit, repaired by apply and left no further change.
- **Finding kept for later:** once a group has an automatic trust level, core accepts only 0 ("none") to clear it, and treats 0 and unset as the same. The bootstrap follows that.
- **Not proven:** a clean production-like database, theme and plugin installation, the logo upload, secrets and external services. Those remain a later slice.

## TASK 28 — VALIDATED PRODUCT BOOTSTRAP v0.1

The official PM validated Task 28. Product Bootstrap v0.1 is validated at application commit `d4bd6ce55e7f737846d8c753494d1406cd7d859d`; the section above is kept as the implementation record. Production remains NOT READY: the bootstrap proves product configuration only, and the "Not proven" list above is unchanged.

## LOCAL CLOCK / SIDEKIQ INCIDENT — RESOLVED / VALIDATED

- **Observed:** the Windows host clock ran about 293 seconds ahead; WSL / container time repeatedly jumped forward and back; Sidekiq restarted about once per minute.
- **Repair:** the Founder corrected Windows Time / NTP synchronization. Nothing in any Community repository or in the container was changed for it.
- **Evidence after the repair:** Windows, WSL and container clocks aligned within milliseconds; no further WSL time jumps; the same Sidekiq process survived more than 10 minutes; the heartbeat-failure count stopped increasing; `/srv/status` stayed `ok`.
- **Official PM classification:** `VALIDATED — clock stabilization removed the observed Sidekiq restart condition`.

This closes the "Windows host clock" follow-up above. The clock is not an open issue.

## TASK 29 — VALIDATED LOCAL AUTH BASELINE

Result: `LOCAL AUTH HEALTHY — bemstorm credential/account-specific issue`.

- **Why:** the Founder's local `bemstorm` login was rejected as invalid credentials. Task 29 isolated whether local authentication itself was broken.
- **Evidence:** one clearly synthetic ordinary user was created through the native model lifecycle and exercised over the real HTTP CSRF / session flow against the running application: a wrong password was rejected, the correct password was accepted, the authenticated identity was confirmed, logout was confirmed and the old auth cookie was rejected afterwards. The synthetic user was then fully deleted through the native lifecycle. The product bootstrap audit passed before and after, and all three repositories stayed clean.
- **Conclusion:** local authentication is healthy; the failure was specific to the stored `bemstorm` credential. No code or configuration change was needed.
- **Password rotation:** the Founder then rotated the `bemstorm` password with native Discourse tooling (`bin/rake admin:create`, which offers a password reset for an existing account). No password, hash or other secret material is recorded in any repository. A password that was previously exposed in a chat is compromised and must never be reused.
- **Accidental Admin promotion — reversed.** The native `admin:create` task ends with an Admin prompt that defaults to yes, so `bemstorm` was granted Admin by accident during the rotation. The Founder reversed it immediately with native Discourse methods.
- **Final verified state of `bemstorm`:** `admin = false`, `moderator = false`, `trust_level = 0`, groups `membros_ativos` and the automatic TL0 group only. It is the ordinary active-member test account again.
- **Operating note:** when `bin/rake admin:create` is used on a non-staff account, answer `n` to the Admin prompt explicitly.

## TASK 30 — VALIDATED READINESS REVIEW: AUTHENTICATION AND IDENTITY PROVIDERS

Task 30 was a read-only review; no product or runtime write occurred, and nothing below was implemented. Result: `YES — NATIVE/BUNDLED SUFFICIENT`. V1 authentication does not require custom authentication infrastructure (Canon §16, §20, §22).

| Mechanism | Source | Product state | Local runtime |
| --- | --- | --- | --- |
| Local password | core | V1 (DECIDED) | enabled |
| Email login link | core | native default | enabled by default; deliverable locally only while a mail catcher runs (none runs by default; proven in Task 31) |
| Google | core | target DECIDED | disabled; credentials required later |
| Apple | bundled plugin `plugins/discourse-apple-auth` | target DECIDED | disabled; Apple credentials and domain prerequisites required later |
| Facebook | core | OPEN / HYPOTHESIS (`DEC-034`); not DECIDED, not V1 | disabled |
| Staff 2FA | core | required before production | not enabled; native mechanics validated in Task 32 |

### Local mail path — current dev-readiness gap

The development container has the Mailpit binary, but no Mailpit process is running, nothing listens on SMTP port 1025, and the mail UI port 8025 is not published by the current Community launcher. Local flows that depend on email (password reset, email login) therefore cannot be acceptance-tested yet. This is a local development finding only; it is not a production SMTP decision, and the production SMTP provider remains OPEN.

Later (Task 31): both flows were acceptance-tested with a temporarily started Mailpit; see "TASK 31" below. No mail catcher runs by default, so the gap remains for everyday development.

### Canonical local URL

- For authentication and canonical-link purposes the local application address is `http://localhost:3100`, not `http://127.0.0.1:3100`. The server runs with `UNICORN_PORT=3100`, browser and request contexts generate correct `localhost:3100` URLs, and OAuth callbacks derive from the Discourse base URL.
- **CONDITIONAL RISK — CLI contexts.** A CLI or Rails-runner process that does not receive `UNICORN_PORT=3100` can emit `http://localhost:3000` links. The served runtime is not broken. Any future CLI command that generates links (for example a reset or login link) must account for the port. Task 31 narrowed this risk: mail generated by background jobs uses `http://localhost:3100`, so only standalone CLI contexts are affected.

### Account-linking safety — readiness / security concern

Observed native behaviour, recorded as a concern and not as new product logic. No mitigation was implemented.

- Google can auto-link to an existing account by a verified matching email.
- Apple treats the provider email as verified.
- The Facebook implementation treats the returned email as verified.
- An Apple private-relay address may create a second Community account instead of matching an existing local account.
- An external signup creates a valid Discourse account that is not automatically in `membros_ativos`.

External-provider acceptance tests are therefore required before any provider is enabled.

### Apple private key — NEEDS SECURITY REVIEW

The bundled plugin's setting definition does not flag `apple_pem` as `secret`. The plugin is not changed. A security review of how that key is handled is required before real Apple credentials are entered.

## NEXT — LOCAL EMAIL RECOVERY ACCEPTANCE (RECOMMENDED, NOT AUTHORIZED)

Status superseded: this slice was authorized and is VALIDATED as Task 31 (next section). One assumption in the scope below was wrong: the native forgot-password mail carries a short-lived code, not a link. The text is kept as the record of what was recommended.

The recommended next bounded slice. It starts only on explicit official PM authorization.

- **Objective:** make password reset and email login provable in the current local Community runtime, using the Mailpit capability that already exists in the development container.
- **Expected scope:** start Mailpit temporarily inside the development container; create one synthetic user; test forgot-password end to end; test email login end to end; verify that the generated links use `http://localhost:3100`; delete the synthetic user and its session state; leave every repository clean.
- **Not part of it:** changing the launcher, publishing port 8025, changing the Docker configuration, production SMTP, OAuth, Google or Apple credentials, Facebook, and 2FA.

Task 30A itself was documentation only: Mailpit was not started and nothing in the runtime, the database or the authentication settings was changed.

## TASK 31 — VALIDATED LOCAL EMAIL RECOVERY ACCEPTANCE

Status: `VALIDATED — LOCAL EMAIL RECOVERY ACCEPTANCE` (official PM adjudication). Task 31 made no repository write.

- **Adjudication.** The Coder first returned `LOCAL EMAIL RECOVERY NOT VALIDATED — precise blocker`, because the written criterion expected the forgot-password email itself to contain a reset URL on `localhost:3100`. The official PM superseded that classification: an emailed reset link does not apply to the current native flow. This is a specification correction, not a product failure, and upstream behaviour is not altered to produce a link.
- **Native forgot-password is code-based.** With the native code-login behaviour active (`enable_local_logins_via_code`), an anonymous request goes: `POST /session/forgot_password` → an email with a short-lived numeric code → `POST /session/password-reset-code/verify` → the server returns the native reset path `/u/password-reset/<token>` → the browser uses that route to set the new password. The email contains no Community URL in this configuration, so it has no link to classify and no incorrect `localhost:3000` link either.
- **Forgot-password — proven end to end** with one synthetic user over the real HTTP flow: request accepted; mail delivered; code verified; reset path returned; reset token accepted and its replay rejected; old password rejected and new password accepted through normal local login; authenticated identity confirmed; logout and session invalidation confirmed; a session opened before the reset was also invalidated.
- **Email login — proven end to end:** request accepted; mail delivered; the generated link was `http://localhost:3100/session/email-login/<redacted>`, with no `localhost:3000` and no `127.0.0.1`; consuming it established an authenticated session; identity confirmed; logout invalidated the session; replaying the token failed.
- **Background-job links:** `CONFIRMED — Sidekiq-generated auth links use localhost:3100`. The `localhost:3000` risk recorded by Task 30 is narrowed to standalone CLI / Rails-runner contexts that lack `UNICORN_PORT=3100`. Background-job mail is not affected.

### Temporary Mailpit — proven mechanism, not infrastructure

Mailpit v1.30.6 already exists in the development image. For the test it was started temporarily inside the existing container, with SMTP on `127.0.0.1:1025` and its API on `127.0.0.1:8025` inside the container only. Port 8025 was not published to Windows, and no launcher or container configuration was changed. It was stopped at the end: port 1025 is not listening again and its temporary store was removed on exit. No mail catcher runs by default. Persistent developer-mail ergonomics is a possible future slice and is not authorized.

### Testing constraint — `.invalid` recipients receive no mail

`Email::Sender` skips recipients whose address ends in `.invalid`. A mail acceptance test must therefore not use `.invalid` addresses; Task 31 used a synthetic `.test` address. This is a testing constraint, not product behaviour.

### Security / privacy findings — recorded, not fixed

- **MEDIUM — Security / Privacy Readiness: transient authentication material in request logs.** In the development request log, the password-reset code input is not filtered, and reset and login tokens appear in request paths. This does not block the local validation. It must be reviewed before production. Production logging was not tested, and no exploitability is claimed beyond this observation. Discourse logging is unchanged.
- **LOW — development hygiene: password credential logging.** The development environment can write newly generated password hash and salt values to `development.log`. No plaintext synthetic password was logged. Logging behaviour is unchanged.
- **LOW — localization.** The forgot-password code email arrived in English while the email-login mail rendered in pt-BR. Not an authentication blocker.
- **OBSERVATION — sender identity.** Local mail used the default sender domain `unconfigured.discourse.org`. This belongs to future production SMTP / domain readiness; no provider is selected.

### Cleanup and regression

The synthetic user was deleted through the native lifecycle: zero synthetic auth tokens, no posts, topics or PMs, no group residue and no Qualified Access residue. `/srv/status` stayed `ok` and Sidekiq stayed on the same process. `bemstorm` is unchanged (non-admin, non-moderator, TL0, `membros_ativos`); ACLs and personal-message settings are unchanged; Chat is off; Qualified Access is healthy; the bootstrap audit passed 37 of 37; all three repositories stayed clean. What remains is the normal audit, send-log and reset-code lifecycle residue, which is not product-state drift.

Production remains NOT READY. No production SMTP provider is selected and no external authentication provider is enabled.

## NEXT AFTER TASK 31 — STAFF 2FA ACCEPTANCE CANDIDATE (HISTORICAL)

Status superseded: Staff 2FA Acceptance was authorized and is VALIDATED as Task 32 (next section). The text is kept as the record of what was recommended.

After this closure the official PM chooses among the remaining authentication-readiness work. The likely candidate is **Staff 2FA Acceptance**: staff 2FA is already required before production, native TOTP is testable locally, it needs no Google, Apple or Facebook credentials, and Task 31 has shown that local mail and recovery work when a mail catcher is temporarily enabled. This is a candidate, not an authorization. Persistent Mailpit integration is not automatically next.

Task 31A itself was documentation only: Mailpit was not started and nothing in the runtime, the database or the authentication settings was changed.

## TASK 32 — VALIDATED STAFF 2FA ACCEPTANCE

Status: `VALIDATED — STAFF 2FA ACCEPTANCE` (official PM adjudication). Task 32 made no repository write.

The validation covers the native Discourse staff-enforcement behaviour, TOTP enrollment and login, wrong-TOTP rejection, backup-code generation and login, single-use backup codes, native break-glass recovery, the post-recovery re-enrollment requirement, baseline restoration and synthetic cleanup. It does **not** mean that production staff 2FA is enabled, that any real staff account is enrolled, or that `enforce_second_factor = staff` alone is a complete security boundary for an unenrolled staff account.

- **Synthetic staff only.** One synthetic user, `qa_staff_t32`, was created and promoted to moderator only, never Admin. In this flow `staff = admin OR moderator`. No real staff user was modified. The one real staff account, `user1`, is unchanged and has no second factor enrolled. `bemstorm` is unchanged: non-admin, non-moderator, TL0, `membros_ativos`.
- **Temporary enforcement.** Baseline `enforce_second_factor = no`. It was changed to `staff` through the supported native site-setting mechanism, held by a bounded process with automatic restoration, for about one minute. Afterwards it is `no` again with no database override row, and the site-settings fingerprint is back at baseline. **Staff enforcement is not currently enabled.**
- **TOTP — proven through the native application path:** the enrollment creation and confirmation endpoints were exercised; TOTP became enabled; password-only authentication no longer completed a login; a wrong TOTP was rejected; a correct TOTP completed authentication; the authenticated identity was confirmed; logout invalidated the session. The synthetic secret was transient and is recorded nowhere.
- **Backup codes — proven:** native generation created 10 codes; one valid code completed authentication and the identity was confirmed; the same consumed code was rejected on replay (single-use); nine codes remained unused at that stage. No code value is recorded.
- **Native break-glass recovery — proven:** the rake task `users:disable_2fa[<username>]` was run against the synthetic user only. It removed TOTP and the backup-code rows; it would also remove second-factor security keys; it changed neither the password nor the moderator role; it does **not** remove passkeys. With `staff` enforcement still temporarily active, password login then succeeded and normal HTML navigation again redirected the recovered user to enrollment. Recovery therefore does not permanently exempt an account from the staff enrollment policy.

### Enforcement boundary — MEDIUM (Security / Operational Readiness)

Native enforcement of an unenrolled staff account is not a universal server-side authorization barrier.

- An authenticated synthetic moderator without 2FA was redirected on normal HTML navigation: `/latest` returned 302 to `/u/<username>/preferences/second-factor`, and the enrollment page was accessible.
- JSON requests remained accessible: `/latest.json` and `/review.json` returned 200. Current source explicitly exempts JSON and API requests from the `ApplicationController` second-factor redirect.
- The frontend has native restricted routing (the `restricted-routing` service) that keeps the normal browser application on the enrollment route while the user needs 2FA. This was confirmed in source and not exercised in a browser.

Operational interpretation: `enforce_second_factor = staff` must not be treated as the control that makes a previously unenrolled staff account safe by itself. JSON endpoints are not protected by the enrollment redirect. This is recorded as native behaviour, not as a vulnerability; that conclusion would need a later security review.

**Production operational rule:** every real staff account must be enrolled and its recovery path verified **before** CannLabs relies on persistent staff enforcement in production. The intended sequence, none of it implemented or authorized here:

1. identify every real staff account;
2. enroll each staff account in native 2FA;
3. verify login with its second factor;
4. establish the recovery / backup-code procedure;
5. confirm no staff account remains unenrolled;
6. only then leave `enforce_second_factor = staff` enabled as ongoing policy.

### Passkey / WebAuthn boundary — OPEN (local acceptance / environment issue)

The development checkout still ties the WebAuthn origin to `http://localhost:3000`, while the Community local runtime uses `http://localhost:3100`. Security-key and passkey acceptance were therefore not part of Task 32. No core patch is authorized. This does not invalidate the TOTP acceptance and is not a Task 32 blocker.

### Development hygiene — LOW

A TOTP secret can appear in `development.log` through development SQL logging. The request parameter `second_factor_token` was filtered in request logs during the test. Logging is unchanged; this stays part of the broader pre-production logging / security review.

### Instrumentation correction

During the test a long-lived `rails runner` process returned stale ActiveRecord query-cache counts, and the probe's apparent FAIL was that instrumentation defect, not a Discourse product failure. Those cached mid-run row counts are discounted. The authoritative evidence is the actual authentication behaviour, the server SQL trace, fresh-process uncached reads and the final regression. No product change is needed.

### Cleanup and final state

`enforce_second_factor = no` with no database override; the synthetic moderator privilege was removed and the synthetic user deleted; zero synthetic auth tokens, TOTP rows, backup-code rows and security-key rows; no custom-group or Qualified Access residue and no synthetic content. Real staff, real staff 2FA state and `bemstorm` are unchanged; ACLs, reporting and personal-message settings are unchanged; Chat is off; Qualified Access is healthy; the bootstrap audit passed 37 of 37; `/srv/status` is `ok`; Sidekiq is healthy; all repositories are clean. The normal staff-action and deletion audit history remains.

Production remains NOT READY.

## TASK 33 — VALIDATED GIT OWNERSHIP HYGIENE

Status: `VALIDATED — GIT OWNERSHIP HYGIENE` (official PM adjudication). Task 33 made no tracked-file change, commit or push. The Git-metadata ownership defect of the application repository is RESOLVED.

- **Defect.** Seven paths under `.git/objects` of the application repository were `root:root`: two loose-object directories and five loose object files. No ownership anomaly existed elsewhere under `.git`. The theme and Qualified Access repositories had no analogous defect.
- **Root cause — `ROOT CAUSE CONFIRMED`.** Two earlier Git commits were executed as uid 0 inside the development container, whose default exec identity is root.
- **Repair.** The Founder manually corrected ownership on those seven proven paths only. No recursive change, no chmod, no change to object content or history, no deleted object and no other repository.
- **After the repair.** Every path under the application `.git` is `leo:leo`; loose-object files are still mode 444 and object directories mode 755; every object directory is writable by the normal workflow identity.
- **Unprivileged write proof.** As `leo` (uid / gid 1000), `git hash-object -w --stdin` on harmless constant text created a loose blob owned by `leo:leo` with mode 444. HEAD, index, refs and worktree were unchanged; no commit and no push. The proof blob is intentionally unreachable and was not deleted; normal Git GC may remove it later.
- **Integrity.** `git fsck` exited 0: no missing objects, no corrupt objects, no broken links, and two harmless dangling blobs. One is the proof object; the other predates Task 33 and appears to come from an earlier reset (its content was not inspected). A dangling blob is not corruption, and no cleanup is authorized.

### Operating rules — ratified

- **Container Git identity.** Git commands executed inside `cannlabs_community_dev` must run as the `discourse` user (`docker exec -u discourse ...`), not as the container's default root user. `discourse` is uid / gid 1000, which is `leo:leo` on the WSL ext4 bind mount. The rule is specific to Git and other repository-writing operations.
- **`STOP — do not change content to evade Git object ownership failures`.** If correct source or documentation content produces a Git object whose destination is unwritable because of filesystem ownership: stop; report the ownership defect; repair the repository or environment deliberately; do not rewrite otherwise-correct content merely to obtain a different Git hash. Task 32A met exactly this situation. Its wording change was legitimate on its merits, but a content change used as a permissions workaround must not recur.
- The agent operating contract (`.skills/community-repo-audit/references/operating-contract.md`) is unchanged by this closure. Moving these rules into it is a later official PM decision.

### Scope distinction — separate local filesystem hygiene debt

Task 33 closes Git-metadata ownership under the application `.git` only. It does not claim that every root-owned path in the development worktree is fixed. Still root-owned at this closure, by read-only inspection: the paths under `tmp/` (cache) and the `plugins/cannlabs-community-qualified-access` mount-point directory. Both are git-ignored, neither is Git metadata, and Task 33 did not prove either to be a Git blocker. They are local runtime / filesystem hygiene debt, not repaired and not authorized.

Production remains NOT READY.

## NEXT — OFFICIAL PM TO CHOOSE (NOTHING AUTHORIZED)

After this closure the official PM chooses the next bounded authentication slice. The likely direction is **Google Authentication Provider Readiness**: local password authentication, local account recovery and the native staff TOTP / recovery mechanics are validated; Google is already a DECIDED product target and is core Discourse; custom authentication remains unjustified. Before anything starts, the official PM determines whether the next step is (A) credential / domain readiness only, or (B) an actual local Google OAuth acceptance with Founder-created provider credentials. This is a direction, not an authorization. Google is not configured: no provider credentials exist, `enable_google_oauth2_logins` is not enabled, no secret was added and no OAuth acceptance has started.

Task 32A itself was documentation only: staff 2FA was not enabled, no real staff account was enrolled, and nothing in the runtime, the database, logging or the authentication settings was changed. Task 33A was documentation only as well: no ownership, runtime, database or authentication change.
