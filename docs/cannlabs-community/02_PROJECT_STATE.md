# CannLabs Community — Project State

Status: CURRENT
Date: 2026-10-05 (baseline written 2026-09-29)

Evidence was captured from the development machine when this baseline was written (2026-09-29). Later sections are appended as slices close; where an older section and a later one differ, the later one is current.

## CURRENT STATE — 2026-10-05

- **OPERATING STATE (2026-10-07, `DEC-048`):** `LOCAL PRODUCT DEVELOPMENT — ACTIVE`. `TASK 40F — PARKED` (not cancelled, not validated). `PRODUCTION EXTERNALIZATION TRACK — PARKED UNTIL LOCAL ALPHA MATURITY`. Tasks 38 to 40 stay valid and are not reopened. `TASK 41A — VALIDATED PRODUCT RE-BASELINE`. `TASK 40D — VALIDATED`. The tracked production definition is the last validated infrastructure snapshot: its application pin is deliberately NOT advanced when local product code changes, and production is repinned and revalidated against the then-current product candidate only when the track resumes. `TASK 41B — VALIDATED` (official PM; Founder product acceptance was sufficient to close the slice). `DECIDED — COMMUNITY STRUCTURE V1` (`DEC-049`): six member-wide categories (Comunidade, Acesso & Cuidados, Cultivo, Produção & Qualidade, Ciência & Pesquisa, Regulação & Direitos, Mercado & Ecossistema), five content-type tags (pergunta, relato, guia, estudo, notícia), no subcategories, no profession-per-category architecture, no patient category, no generic public association category, Solved only in Cultivo, Produção & Qualidade, restricted spaces unchanged. `TASK 41C — Testing — Awaiting PM Validation`.
- **NOW:** Task 37B (production-like reproducibility and disaster-recovery proof: 37B.1, 37B.2A, 37B.2B) is VALIDATED and closed; see "TASK 37B" near the end of this file. Task 38A (the validated production-like deployment definition tracked under `ops/discourse/`, `DEC-039`) is VALIDATED. Task 38B (machine-independent production-like deployment reproducibility: 38B.2 independent host, 38B.3 cold build) is VALIDATED (`DEC-041`) and its Google Cloud test resources are deleted; see "TASK 38B" below. Task 40A (production secrets delivery contract, `DEC-042`) is VALIDATED; see "TASK 40A" near the end of this file. Task 40B (production first-admin and staff security procedure, `DEC-044`) is VALIDATED (procedure readiness; production enrollment stays OPEN); see "TASK 40B" near the end of this file. Task 40C.1 (post-restore HTTP process convergence, `DEC-045`) is VALIDATED; see "TASK 40C.1" near the end of this file. Task 40D (production deployment definition and ingress acceptance, `DEC-046`, `DEC-047`) is VALIDATED by the official PM; see "TASK 40D" near the end of this file. Task 41A (product re-baseline) and Task 41B (member front door) are VALIDATED and Task 41C (Community structure) is Testing — Awaiting PM Validation; see "TASK 41A" and "TASK 41B" at the end of this file.
- **Production:** NOT READY. Task 27 is a validated readiness review (`07_PRODUCTION_SECURITY_FOUNDATION_READINESS.md`). Task 28 closed the product-configuration bootstrap part of its principal gap. Task 37B proved a production-like build and native backup / zero-state restore mechanics on a disposable instance, and Task 38B proved that the tracked deployment canon reproduces it on an independent host; neither makes production ready. Hostname / DNS, TLS / edge, SMTP, authentication-provider credentials, payment, staff 2FA enrollment, backup policy, and the Legal / Privacy / Trust & Safety and final launch gates remain open. No production or staging environment exists.
- **Validated so far:** repository bootstrap, isolation and operating layer (through Task 04B); design direction, prototype, theme architecture and handoff (Tasks 05–08); Community Theme v0.1 (Tasks 10 / 10B); V1 product model (Task 12A); Access Skeleton (Task 14); Founder local login (Task 15A); verified roles and restricted spaces (Tasks 16 / 16A); qualified-access gap, architecture and plugin v0.1 (Tasks 17, 18A, 19); verified-identity boundary and synthetic professional lifecycle (Tasks 20B, 21); synthetic association / leadership lifecycle (Tasks 22 / 22A); moderation readiness and native moderation lifecycle (Tasks 23A, 24); Active Membership Safety Boundary including the native Site Feedback retirement (Task 26, `DEC-032`, `DEC-033`); production / security foundation readiness review (Task 27); Product Bootstrap v0.1 (Task 28); local-auth baseline (Task 29); authentication and identity-provider readiness review (Task 30); local email recovery acceptance (Task 31); staff 2FA acceptance (Task 32); Git ownership hygiene of the application repository (Task 33); Google OAuth local acceptance (Task 35); development logging hygiene (Task 36); production-like build, production-like logging acceptance and native backup / zero-state restore proof (Task 37B); the tracked production-like deployment canon (Task 38A) and its machine-independent reproducibility (Task 38B).
- **Authentication:** native and bundled Discourse are sufficient for V1 (`YES — NATIVE/BUNDLED SUFFICIENT`). Local login, Google and Apple are the DECIDED direction; Facebook is OPEN / HYPOTHESIS (`DEC-034`); staff 2FA is required before production. Its native mechanics are validated (Task 32) and the production procedure is validated locally (Task 40B, `DEC-044`), but it is not enabled (`enforce_second_factor = no`) and no real staff account is enrolled. Google OAuth is locally accepted with core Discourse (Task 35) and Google signup does not grant paid membership; no external provider is enabled or configured. Local password reset and email login are proven end to end with a temporarily started mail catcher (Task 31); no production SMTP provider is selected.
- **Repositories:** application `leo-even/CannLabs-Community` (this fork; docs, the operating layer and the Task 28 bootstrap mechanism); theme `leo-even/CannLabs-Community-Theme` at `aeb3a9d9154f532064dcc24ac9e78cf587588d77`; plugin `leo-even/CannLabs-Community-Qualified-Access` at `ca4f0070d7bf85e42dbfa7f8736469139bb20275`.
- **Latest decision:** `DEC-047`.

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
- plugin implementation beyond the validated Qualified Access plugin v0.1 (Task 19, `DEC-030`). Its enable flag is part of the production product profile (`DEC-035`), but no production deployment is authorized;
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

Reconciled on 2026-10-03 (Task 36C); Tasks 28 to 33, 35 and 36 are validated and closed.

1. Staff 2FA production rollout: enroll and verify every real staff account first, then rely on persistent `staff` enforcement (operational rule in "TASK 32" below). Required before production; not authorized.
2. A later slice proving a clean production-like environment end to end: supported production deployment, theme and plugin installation, bootstrap application, secrets, external services, production-like logging acceptance (Task 36 limitation) and smoke tests (`07_PRODUCTION_SECURITY_FOUNDATION_READINESS.md`). This is Task 37: Phase A accepted and Task 37B (the build and the restore proof) VALIDATED; see "TASK 37" and "TASK 37B" below. Production readiness still needs the open areas listed there.
3. Legal / Privacy / Trust & Safety review.
4. The remaining authentication providers (external-provider acceptance tests first) and payment readiness as separate slices.

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
- **Profiles:** `local` also manages `user_notes_enabled` and `cannlabs_qualified_access_enabled`; in `production` both are gated and never applied. Later (Task 37A.1, `DEC-035`): `production` now manages `cannlabs_qualified_access_enabled=true`; User Notes stays gated.
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
| Google | core | target DECIDED | disabled; local OAuth acceptance VALIDATED with a DEV client (Task 35); production credentials not configured |
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

External-provider acceptance tests are therefore required before any provider is enabled. Later (Task 35): Google's verified-email auto-link and the non-member signup were accepted locally; Apple and Facebook remain untested.

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

- **MEDIUM — Security / Privacy Readiness: transient authentication material in request logs.** In the development request log, the password-reset code input is not filtered, and reset and login tokens appear in request paths. This does not block the local validation. It must be reviewed before production. Production logging was not tested, and no exploitability is claimed beyond this observation. Discourse logging is unchanged. Later (Task 36): the reset `code` parameter is now filtered; tokens in URL paths remain open.
- **LOW — development hygiene: password credential logging.** The development environment can write newly generated password hash and salt values to `development.log`. No plaintext synthetic password was logged. Logging behaviour is unchanged. Later (Task 36): resolved for local development (SQL logging off by default).
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

A TOTP secret can appear in `development.log` through development SQL logging. The request parameter `second_factor_token` was filtered in request logs during the test. Logging is unchanged; this stays part of the broader pre-production logging / security review. Later (Task 36): resolved for local development (SQL logging off by default).

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

## NEXT AFTER TASK 33 — GOOGLE DIRECTION (HISTORICAL)

Status superseded: the Google direction was carried out as Tasks 34 and 35; see "TASK 35" below. The text is kept as the record of what was recommended.

After this closure the official PM chooses the next bounded authentication slice. The likely direction is **Google Authentication Provider Readiness**: local password authentication, local account recovery and the native staff TOTP / recovery mechanics are validated; Google is already a DECIDED product target and is core Discourse; custom authentication remains unjustified. Before anything starts, the official PM determines whether the next step is (A) credential / domain readiness only, or (B) an actual local Google OAuth acceptance with Founder-created provider credentials. This is a direction, not an authorization. Google is not configured: no provider credentials exist, `enable_google_oauth2_logins` is not enabled, no secret was added and no OAuth acceptance has started.

Task 32A itself was documentation only: staff 2FA was not enabled, no real staff account was enrolled, and nothing in the runtime, the database, logging or the authentication settings was changed. Task 33A was documentation only as well: no ownership, runtime, database or authentication change.

## TASK 35 — VALIDATED GOOGLE OAUTH LOCAL ACCEPTANCE

Status: `GOOGLE OAUTH LOCAL ACCEPTANCE VALIDATED` (official PM). Task 35 made no repository write. Production remains NOT READY.

- **Upstream-first conclusion — `YES — CORE GOOGLE AUTH IS SUFFICIENT`.** This is the conclusion of the Task 34 read-only Google readiness review as stated by the official PM; Task 34 has no separate durable closure. The core provider (`google_oauth2`, `Auth::GoogleOAuth2Authenticator`, enabled by `enable_google_oauth2_logins` with `google_oauth2_client_id` / `google_oauth2_client_secret`) is the supported path. No custom Google OAuth implementation is authorized, and none was needed.
- **Method.** A Founder-created DEV OAuth client (Google Cloud project `cannlabs-community-dev-2026`, client `community-dev-localhost`, callback `http://localhost:3100/auth/google_oauth2/callback`) and one Founder-controlled Google test identity. The credential file stays outside every repository; its contents are recorded nowhere. Google was configured and enabled only for the test, through native site settings, with the secret kept out of command lines, scripts and logs. Every Community account involved was synthetic, and the three browser logins were performed by the Founder.
- **Redirect contract.** Native initiation redirected to Google with the exact callback `http://localhost:3100/auth/google_oauth2/callback` (not `127.0.0.1`).
- **Same-email link (login #1):** a verified Google email matching an existing synthetic local account linked to that account; no duplicate was created; its existing `membros_ativos` membership survived; no Qualified Access was granted.
- **New Google signup (login #2):** native signup created a new account. It was passwordless, TL0, non-staff, and received no `membros_ativos`, no Qualified Access, no professional or association-leadership group, no protected-category access, no personal-message ability and no flagging ability. **Google authentication does not grant paid membership.**
- **Relogin (login #3):** returned to the same account through the same provider association; no duplicate and no repeated signup.
- **Cleanup.** Native user deletion removed both synthetic users with their provider associations, provider access- and refresh-token material, auth sessions, group memberships and Qualified Access state; no synthetic content existed. A server session left valid after one login (the window was closed without logging out) was removed by the native deletion.
- **Baseline restoration.** The three Google settings are back to the exact pre-task state: `enable_google_oauth2_logins` default (disabled), no local client ID, no local client secret, and no override row for any of them. Google is not exposed as a local provider. No other authentication setting changed.
- **Regression.** `user1` and `bemstorm` are unchanged apart from normal Founder-driven `last_seen_at`; category ACLs, custom groups, reporting, personal-message rules and Chat are unchanged; Qualified Access is healthy; the bootstrap audit passed 37 of 37; the runtime stayed healthy; all three repositories stayed clean.
- **Retained on purpose.** The DEV Google Cloud project and OAuth client, and the credential file outside the repositories, remain for future controlled testing. The Founder removed the controlled Google account's grant to CannLabs Community (Dev) after the test.

### OAuth development logging — MEDIUM (Security / Privacy Readiness) — RESOLVED — LOCAL DEVELOPMENT (Task 36)

Development logging exposed Google OAuth token material during Task 35: access-token material, refresh-token material, the OAuth callback authorization `code` and the OAuth `state` were observed in development logging (SQL debug lines writing the provider association, and the callback request lines and parameters). The client secret was not found. **Production behaviour was not tested**, and no production-leakage conclusion may be drawn from this task. External containment: the Founder revoked the Dev grant from the controlled Google account. The local development log was intentionally left untouched as evidence; logging configuration is unchanged. Follow-up: Task 36 (below).

### Other observations

- **LOW — orphaned profile-picture upload.** A Google login downloads the Google profile picture as the avatar. After the final deletion that upload is unreferenced and awaits the native orphan-upload cleanup after its grace period; nothing was deleted manually.
- A Google-created account is passwordless, so the native UI will not disconnect its only login method; native user deletion removed the association.
- Removing a provider association locally does not revoke the upstream Google grant.
- In this test Google issued refresh-token material on first consent only, not on later logins.
- Closing a private browser window does not end the server session; an explicit Community logout does.
- `bypass_wizard_check = true` was written by native setup-wizard behaviour during the test window; it was not a Task 35 change and was not reverted.
- **PARKED — not investigated in Task 35:** a native scheduled backup logged `[FAILED]` around 03:30Z on 2026-10-03.
- The local runtime was down at the start of the task because the container started before the WSL bind mounts were available, leaving `/src` empty; a manual container restart restored it. No launcher change follows from this closure.

## NEXT AFTER TASK 35 — TASK 36 (HISTORICAL)

Status superseded: Task 36 was carried out and is VALIDATED; see "TASK 36" below. The text is kept as the record of what was recommended.

The recommended next bounded slice is **Task 36 — OAuth Dev Logging Security Hygiene**. It is OPEN and not started; nothing is authorized until the official PM says so. Intended scope only: prevent OAuth token material from appearing in development SQL logs; review and filter the callback `code` and `state`; decide the safe handling of the already-contaminated local development logs; keep useful debugging available; distinguish development from production logging behaviour explicitly; no authentication redesign unless evidence requires it.

Task 35A itself was documentation only: no runtime, database, Google Cloud, authentication-setting or logging change.

## TASK 36 — VALIDATED DEVELOPMENT LOGGING HYGIENE

Status: `VALIDATED` (official PM). Phase A (read-only root-cause review) was accepted; Phase B (implementation, commit `a1a163a6`) was validated; Task 36C removed the contaminated local logs after explicit Founder approval. Production remains NOT READY.

- **Root causes — two independent paths.**
  1. SQL debug lines carried literal values. Discourse runs with `prepared_statements: false`, so ActiveRecord writes values inline into the SQL text, and Rails bind filtering cannot redact them. In development this exposed OAuth access and refresh tokens, the Google `id_token`, password hashes and salts, and TOTP secrets.
  2. Request parameters such as the OAuth callback `code` and `state` were not in the parameter-filter list, so they appeared in the request line and the parameter log.
- **Validated fix.** One fork-owned initializer, `config/initializers/zz-cannlabs-logging-hygiene.rb`, with a spec; no upstream file modified, no prepared-statements change, no authentication redesign.
  - Exact, anchored parameter filters in every environment, appended to the upstream list. Names covered: `code`, `state`, `token`, `access_token`, `refresh_token`, `id_token`, `client_secret`, `authenticity_token`. Names that merely contain them (for example `country_code`, `invite_code`) stay visible.
  - In development, ActiveRecord SQL logging is off by default for every process (web, Sidekiq, runner, rake). `CANNLABS_ENABLE_ACTIVERECORD_LOGS=1` restores it for one process when debugging; those lines can contain sensitive values.
- **Acceptance.** All eight names are `[FILTERED]` in both the request line and the parameter log; the negative controls stay visible; no SQL lines are written by default (runner, rake, web, Sidekiq); a single opted-in process does write them; normal request, processing and completion logging is unchanged; `google_oauth2_verbose_logging` stays `false`.
- **Local log cleanup.** After the Founder approved it, the historical contaminated `log/development.log` and `log/development.log.0` were deleted with ordinary local deletion while the dev server was stopped. Task 36C kept no copies. The restarted runtime created a fresh `development.log` under the hardened defaults; re-acceptance on the fresh log showed the eight names filtered and no SQL lines.
- **Historical finding resolution.** The Task 35 development-logging MEDIUM is `RESOLVED — LOCAL DEVELOPMENT`. The same mechanism also resolves, for local development, the password hash / salt (Task 31) and TOTP secret (Task 32) SQL logging findings and the unfiltered reset `code` parameter (Task 31). Reset and login tokens that appear as URL path segments (`/u/password-reset/…`, `/session/email-login/…`) are not covered by parameter filters and remain open.
- **Limitation.** Production-like logging behaviour has not yet been acceptance-tested. The stock production configuration logs at `:info`, where SQL lines are not emitted, but no production-like environment has been checked.

## NEXT AFTER TASK 36 — APPROVED SEQUENCE (HISTORICAL)

Status superseded: the official PM moved to the production-like environment proof (Task 37); see "TASK 37" below. The text is kept as the record of what was recommended.

Task 36 is closed. The next items come from the existing NEXT list above, unchanged in substance: the staff 2FA production rollout, then the clean production-like environment proof, which now also carries the production-like logging acceptance. The official PM chooses; nothing is authorized and no other authentication provider is started.

Task 36C changed no product code, database state, authentication setting or Google Cloud resource; it deleted only the two authorized local log files and restarted the local dev server.

## TASK 37 — PRODUCTION-LIKE ENVIRONMENT PROOF

### Phase A — ACCEPTED (read-only architecture / readiness review)

The official PM accepted the Task 37 Phase A review and took these readiness decisions. The production-like proof (Task 37B) was authorized afterwards and is VALIDATED; see "TASK 37B" below.

- **Architecture direction for the proof:** the official `discourse_docker` lifecycle; the CannLabs application fork built at a pinned revision; the theme installed from an immutable tag with exact installed-commit verification (`DEC-036`); the Qualified Access plugin pinned at `ca4f0070d7bf85e42dbfa7f8736469139bb20275`; a clean database; the production Rails environment; a persistent `/shared` directory. A synthetic local hostname and a local Mailpit are acceptable. Public DNS, TLS, OAuth, payment and real staff are not required for this proof.
- **Qualified Access:** DECIDED — enabled in the production product profile (`DEC-035`). User Notes stays gated; the two are independent.
- **Task 37B execution target:** a new, disposable Ubuntu 24.04 WSL2 distribution with its own Docker Engine. Not the current development distribution, not the Docker Desktop shared daemon, not staging; it is destroyed after acceptance. No development database or filesystem is reused.
- **Backup / restore correction:** native backups also live under `/shared`, so the proof must not delete the only copy. Contract: create a native backup; record its filename, size and checksum; copy it outside the instance's `/shared` but inside the disposable machine; destroy the instance and its `/shared`; rebuild from zero; put the saved backup in the restore location; restore; re-run the product audit; remove the temporary copy when the proof ends. No off-site backup infrastructure is needed for this proof. (Task 37B followed this contract. The temporary copies and the rollback trees were not removed; they are retained until cleanup is authorized, see "TASK 37B".)

### Task 37A.1 — production-like build prerequisites — VALIDATED

- **Qualified Access production profile.** `config/cannlabs_community/bootstrap.yml` now lists `cannlabs_qualified_access_enabled: production: true` beside `local: true`; no runner code changed. The production audit passes when the flag is on, reports drift when it is off, and apply repairs it through the native site-setting setter without touching memberships; a second apply changes nothing. `user_notes_enabled` remains gated in production.
- **Theme immutable pin.** The theme repository had no tags. Annotated tag `v0.1.0` was created on `aeb3a9d9154f532064dcc24ac9e78cf587588d77` and pushed alone; no theme commit was made. The bootstrap already verifies the installed commit (`local_version`) against the manifest revision, so the contract "deploy by tag, verify exact SHA" needed no code change.

Task 37A.1 was validated by the official PM before Task 37B. Task 37B.1 later exercised both prerequisites as supplementary evidence: the production audit passed with the Qualified Access flag on, and the theme was installed from `v0.1.0` and verified at its exact commit. Production remains NOT READY.

## TASK 37B — VALIDATED PRODUCTION-LIKE REPRODUCIBILITY AND DISASTER-RECOVERY PROOF

Status: `VALIDATED` (official PM) for Task 37B.1, Task 37B.2A, Task 37B.2B and Task 37B overall (reproducibility and disaster-recovery proof). Production remains `PRODUCTION — NOT READY`: Task 37B proves production-like infrastructure and disaster-recovery mechanics only, on a disposable instance with a synthetic local hostname and a local Mailpit. Decisions: `DEC-037`, `DEC-038`.

### Authoritative state

- **Application** `leo-even/CannLabs-Community`: `73b2484ded24d04c874de49a328e76d10f226be4`.
- **Theme** `leo-even/CannLabs-Community-Theme`: `aeb3a9d9154f532064dcc24ac9e78cf587588d77`, deployed by ref `v0.1.0` (`DEC-036`).
- **Qualified Access plugin:** `ca4f0070d7bf85e42dbfa7f8736469139bb20275`.
- **`discourse_docker`:** `8d705a91866c320592ce851f30895ddb4c3e85fe` (detached, clean).
- **Production-like deployment definition (validated):** `/var/discourse/containers/cannlabs-prodlike.yml` on the disposable WSL distribution `CannLabsCommunityProdLike`, SHA-256 `89222f0af613aefacbbb26bac8c5f33c895aa7243eb70fca0eb4e7c64188065f`.
- **Superseded definition:** SHA-256 `0eb16493d21536bc7e7add07abde8d83db170348898a71241610c122231d7885` is `SUPERSEDED` (not fresh-install-safe, `DEC-037`).
- The definition was a host-local file when Task 37B closed. Its custody is now decided (`DEC-039`) and it is tracked byte-identical under `ops/discourse/` (see "TASK 38A").

### Task 37B.1 — VALIDATED production-like build and acceptance

- A pinned production-like build with product bootstrap applied: audit `PASS (pass 36, drift 0, blocked 0, gated 1)`, paid / private boundary intact, Qualified Access enabled (`DEC-035`), theme at its exact pinned commit.
- Local password recovery and email-login flows work in the production-like instance.
- **Logging security**, within a defined secret-shape contract, closes the Task 36 limitation that production-like logging had not been acceptance-tested. Three application commits implement it: `10a0511b` (credential URL path segments and Logster request environment), `35c92fd4` (secrets in Rails log messages such as router misses and redirects) and `73b2484d` (Logster failure path, which prints to the container log). Acceptance used real tokens across every log sink with zero raw secrets found. The guarantee is bounded: it covers the proven secret and message shapes only, not text that a database or library echoes into its own messages.
- Operational soak, controlled restart and a non-destructive rebuild over the existing persistent state were all accepted.
- **Phase 18 scope — `VALIDATED — NON-DESTRUCTIVE REBUILD OVER EXISTING PERSISTENT STATE`.** It rebuilt the container over persisted state. It did not prove an install or rebuild from truly empty persistent state; that was exposed, fixed and validated in Task 37B.2B. Phase 18 alone does not prove fresh-install reproducibility.

### Task 37B.2A — VALIDATED native backup and restore readiness

- Native Discourse backup of database and uploads, recognised by Discourse: `cannlabs-prodlike-37b2a-20261005-144245-v20260928103925.tar.gz`, 4,759,155 bytes, SHA-256 `e09ed040c0dec78cbb9615e7e8512be0423cbc268026c6bfb9d4b239c62412c0`.
- A root-safe copy outside the instance's `/shared`, with the checksum verified, and the restore prerequisites confirmed.

### Task 37B.2B — VALIDATED destructive zero-state rebuild and native restore

- The active state was isolated by renaming it aside (retained, see below). The first zero-state attempt failed on a real fresh-install defect, which was fixed forward and re-validated; the single retry built a truly fresh PostgreSQL cluster.
- Before restore: old product state absent and the bootstrap `BLOCKED`, as expected on an empty database. Native restore from the validated backup, with `--no-disable-emails`, succeeded. Restored data matched the snapshot, uploads were byte-identical, the bootstrap returned to `PASS (pass 36, drift 0, blocked 0, gated 1)`, and the pins and security settings were exact. After restore `disable_emails = no`, `allow_restore = false` and read-only mode is off.
- **Three-cluster proof (PostgreSQL `system_identifier`):** original `7692772761484267569`; failed first attempt `7693197652249301041`; successful fresh retry `7693203710308749361`; after restore `7693203710308749361`. The original cluster did not survive. The restored data lives in the fresh cluster.
- **Fresh-install defect — `RESOLVED — PRODUCTION-LIKE DEPLOYMENT DEFINITION`.** The log hardening assumed `/var/log/nginx` already existed during bootstrap. On empty storage `/var/log` is an empty bind mount and the stock runit service creates the nginx directory only after bootstrap, so the old `chmod` failed. The fix creates both log directories idempotently with their runtime owners before the existing fail-closed guards (`DEC-037`).
- **Restore observation — LOW / OBSERVATION, `EXPECTED UPSTREAM SEED SIDE EFFECT / NON-BLOCKING`:** `remote_themes` went from 11 rows in the dump to 13 after restore. Rows 1–11 match the dump; rows 12 and 13 are empty built-in Foundation and Horizon records created by the native restore's seed step. The bootstrap passes and the theme pin is exact. Do not fix (`DEC-038`).

> **Correction (Task 40C.1, 2026-10-06, `DEC-045`).** The restore acceptance above verified the database and the bootstrap audit in fresh processes. It did not verify the web workers that were already running when the restore replaced the database, and they kept serving the pre-restore defaults. The native backup and restore **mechanics** stay VALIDATED. The retained instance was converged by one supported restart, and every later restore needs the six-step acceptance contract in `ops/discourse/README.md` section 10. See "TASK 40C.1" at the end of this file. The evidence above is unchanged.

### Retained findings (severities unchanged)

- **MEDIUM:** the stock runit service resets the nginx runtime log directory and file permissions on every start, so the 0750 / 0640 hardening is not durable at runtime.
- **MEDIUM:** `error_log emerg` is an observability trade-off: nginx logs less.
- **MEDIUM:** the zero-leak logging guarantee is bounded to the proven secret and message shapes.
- **LOW:** safe `/invites/*` paths are over-redacted; `DISCOURSE_RELATIVE_URL_ROOT` is not covered; production Logster depends on its ignore list.
- **OBSERVATION:** a launcher rebuild causes downtime; the prebuilt fork asset tarball returns 404, so assets are built locally; the native restore flushes the Redis-backed Logster store; scheduled post-restore maintenance is normal; the application container has no Docker `HEALTHCHECK`.

### Intentionally retained artifacts — `INTENTIONALLY RETAINED — CLEANUP NOT YET AUTHORIZED`

- Rollback tree `/var/discourse/shared/standalone.pre-37b2b-20261005T145537Z`.
- Failed-attempt tree `/var/discourse/shared/standalone.failed-37b2b-20261005T151854Z`.
- Root-safe backup under `/root/prodlike-backups/` (checksum unchanged).
- Evidence and build logs under `/root/prodlike-logs/`, validation artifacts under `/root/validate-37b2b`, and dangling Docker images.

Nothing is deleted by this closure.

### Current runtime (recorded, not changed by this closure)

The restored production-like instance is healthy on the fresh cluster `7693203710308749361`, in a container built from the validated definition (`89222f0a…065f`); bootstrap `PASS (pass 36, drift 0, blocked 0, gated 1)`.

### Open at closure

- **`OPEN — DURABLE DEPLOYMENT DEFINITION OWNERSHIP` — since `DECIDED` (`DEC-039`): the Community repository, under `ops/discourse/`.** At Task 37B closure the validated definition was not a version-controlled canonical artifact, and the candidate options were (A) a sanitized operations artifact in this repository, (B) a separate operations repository, (C) generation from another mechanism. Option A was chosen; see "TASK 38A".

## NEXT AFTER TASK 37B — NOT AUTHORIZED

`PRODUCTION — NOT READY.` Areas that remain, listed and not started; the official PM chooses the order:

1. Machine-independent deployment reproducibility: VALIDATED by Task 38B (`DEC-041`); no longer open.
2. Real hostname and DNS.
3. TLS and edge.
4. Production SMTP.
5. Real Google OAuth credentials.
6. Apple OAuth production configuration.
7. Billing and paid-membership mechanism.
8. Real staff 2FA enrollment and recovery readiness.
9. Backup retention and off-machine backup policy.
10. Legal / LGPD / Trust & Safety review.
11. Final security, privacy and launch sweep.

Cleanup of the retained artifacts also needs its own authorization.

## TASK 38A — TRACKED PRODLIKE DEPLOYMENT CANON — VALIDATED

Status: `TRACKED DEPLOYMENT CANON — ESTABLISHED` and `VALIDATED` (official PM). `MACHINE-INDEPENDENT DEPLOYMENT REPRODUCIBILITY — NOT YET VALIDATED` at that time (since VALIDATED by Task 38B, `DEC-041`). `DEC-039`: the Community repository owns the durable deployment definition, under `ops/discourse/`. Repository-only slice: no runtime, rebuild, restart or production configuration was touched.

- **Tracked artifact.** `ops/discourse/cannlabs-prodlike.yml` is the validated production-like definition copied byte for byte: SHA-256 `89222f0af613aefacbbb26bac8c5f33c895aa7243eb70fca0eb4e7c64188065f`, 9,292 bytes, equal to the host file. It is named prodlike and is not a production default. A bounded secret review found no secret value (SMTP is Mailpit without credentials; the only long strings are commit pins, paths and URLs).
- **Runbook.** `ops/discourse/README.md` carries the prodlike-only warning and assumptions, the source pins, host contract, prodlike network and Mailpit, definition placement, build order, theme contract (the YAML does not install the theme), bootstrap reference, first-admin note (not yet a machine-independent recipe), backup / restore (`--no-disable-emails`), the security-hardening contract, retained-finding pointers and the environment / secrets boundary. Real production secrets were `OPEN — DELIVERY MECHANISM NOT YET DECIDED` at that time; the mechanism is now `DECIDED` (`DEC-042`, Task 40A).
- **Drift protection.** `spec/lib/cannlabs_community/prodlike_deployment_parity_spec.rb` checks that the YAML's Qualified Access repository and commit equal the bootstrap manifest, and that its nginx credential-path rules mirror `CannlabsPathSecretRedaction::RULES`. Both fail on a deliberate mutation and pass on the tracked file.
- **Application pin.** The deployment pin (`73b2484d…`) is a known ancestor of the repository `HEAD`, never `HEAD`, because the definition lives in the history that records the pin. This is expected, not drift.
- **Not done, by decision.** No separate operations repository, generator, shared template or CI deployment; no upstream `containers/`, `samples/` or `templates/` change.
- **Next validation (not authorized).** Machine-independent reproducibility needs a fresh host built only from the tracked artifacts and the documented values; see "TASK 38B" below (`DEC-040`).

## TASK 38B — MACHINE-INDEPENDENT PRODUCTION-LIKE DEPLOYMENT REPRODUCIBILITY — VALIDATED

Status: `VALIDATED` (official PM): Task 38B.2 (independent virgin host), Task 38B.3 (independent Community cold build) and Task 38B overall. Claim: `MACHINE-INDEPENDENT PRODUCTION-LIKE DEPLOYMENT REPRODUCIBILITY — VALIDATED` (`DEC-041`). Production remains `PRODUCTION — NOT READY`. The runbook-closure record that preceded the run (Task 38B.0, `DEC-040`) is kept below as history; its "not executed" wording is superseded by the sections after it.

- **Isolation decision.** Final acceptance needs an isolated fresh VM or a separate physical host (independent network namespace, Docker daemon, `/var/lib/docker` and filesystem, nothing inherited). A second WSL distribution on the same Windows host is not accepted, because the readiness review showed that WSL distributions on one host share the relevant network namespace and listeners; such a rehearsal is optional and `REHEARSAL ONLY — DOES NOT VALIDATE TASK 38B`. The current prodlike instance is not touched.
- **Scope decision.** The run proves a clean install and the product bootstrap from the tracked canon. It does not repeat backup, restore or the Task 37B.2B disaster-recovery proof.
- **Five runbook gaps closed in `ops/discourse/README.md` (documentation only, nothing executed).**
  1. D1: how a clean host acquires the canon (public clone, exact commit, state, ancestry and YAML SHA checks, then the install of the runtime copy).
  2. D2: the Docker contract (official apt repository, Docker Server `29.8.2`, `docker-ce 5:29.8.2-1~ubuntu.24.04~noble`, `containerd.io 2.3.6-1~ubuntu.24.04~noble`, fresh data root, verification).
  3. D3: one synthetic human admin, `PRODLIKE ACCEPTANCE ONLY`, password in process memory only.
  4. D4: the native Uncategorized promotion, a condition-based bounded wait with the observed gates (human admin, site older than one hour, scheduler run); the manual path is only a rehearsal fallback.
  5. D5: the exact theme import and exact-commit verification, after a remote tag check.
- **Also recorded.** The 20-step acceptance order and expected bootstrap transitions (`BLOCKED` before promotion; first legitimate apply; final `PASS (pass 36, drift 0, blocked 0, gated 1)`; second apply no change); the application-pin ancestry preflight and the post-build pin check; the allowed and forbidden input boundary; the recorded base-image digest to compare (the YAML is not changed); the bounded security acceptance (one synthetic `/u/password-reset/` sentinel); and the WSL-only workarounds, which are not Community requirements.
- **Success claim (met by Task 38B.3, see below):** `MACHINE-INDEPENDENT PRODUCTION-LIKE DEPLOYMENT REPRODUCIBILITY — VALIDATED`. It does not imply production readiness, DNS or TLS, secret delivery, external SMTP, production OAuth, billing, staff 2FA, Legal / LGPD / Trust & Safety readiness, a production first-admin process or restore on the second host.

### Task 38B.2 — VALIDATED independent virgin host

- **Host.** A dedicated Google Cloud project (no organization or folder parent) with one `e2-standard-4` VM (4 vCPU, 16 GB) in `us-central1-a`, a 60 GB `pd-balanced` boot disk, image `ubuntu-2404-noble-amd64-v20260918` (Ubuntu 24.04.5 LTS, amd64), a dedicated custom VPC with SSH allowed only from the operator's IP, no attached service account and an ephemeral external IPv4. Spend authorization was R$50; the run cost a small fraction of it.
- **Virgin pre-flight, before anything was installed.** A real hypervisor (`systemd-detect-virt=google`), not WSL or a container; no shared host mounts; no Community, `discourse_docker`, `/shared` or Docker state; no listener on the Community ports; no `CANNLABS_` / `DISCOURSE_` variables; NTP synchronized; outbound access to the public sources. The first run had two FAILs caused by my check criteria (GCE reports `google`, and a CDN-cached `Date` header); a rerun with corrected criteria passed, and both transcripts are kept.
- **Docker.** Official apt repository, Docker Server `29.8.2` (`docker-ce` and `docker-ce-cli 5:29.8.2-1~ubuntu.24.04~noble`, `containerd.io 2.3.6-1~ubuntu.24.04~noble`; Buildx `0.37.1`, Compose `5.6.0`), systemd-managed, no `daemon.json`, empty Docker state.

### Task 38B.3 — VALIDATED independent Community cold build

- **Inputs.** Canon commit `d1981640e414d215f2d6fea7a182cd1bf6d1e5e9` from a public clone; tracked definition SHA-256 `89222f0af613aefacbbb26bac8c5f33c895aa7243eb70fca0eb4e7c64188065f`; application `73b2484d…` (an ancestor of the canon commit), Qualified Access `ca4f0070…`, theme `v0.1.0` → `aeb3a9d9…`, `discourse_docker` `8d705a91…`; base image `discourse/base:2.0.20260915-0028` resolved to the recorded digest `sha256:5028d077b061225507e7093fda1ff5bdc64d483b5c0397776f9a52c50008cd9b`; Mailpit pulled by its recorded digest. Nothing came from the existing machines.
- **Build.** One `./launcher rebuild cannlabs-prodlike`, exit 0 in 351 s. Every nginx / logging guard and the fresh-install-safe directory creation passed, assets were built locally after the prebuilt-asset 404, and `/srv/status` answered 200 on the first poll, within 49 s. The app and plugin were at their exact pins.
- **Freshness — four PostgreSQL clusters.** Old production-like `7692772761484267569`; failed first fresh attempt `7693197652249301041`; Task 37B.2B fresh retry and restore `7693203710308749361`; independent GCP cold build `7693236165663342641`. The independent host did not inherit any prior cluster or state.
- **Lifecycle.** One synthetic human admin (`PRODLIKE ACCEPTANCE ONLY`) and the exact-commit theme import came first. Audit #1 was `BLOCKED (pass 13, drift 21, blocked 1, gated 1)`. The native `automatically_promoted` event happened about 69 minutes after schema creation with no manual action. Audit #2 was `DRIFT (pass 14, drift 22, blocked 0, gated 1)`. The first apply changed 22 items and gave `PASS (pass 36, drift 0, blocked 0, gated 1)`; the final audit was identical and the second apply was `NO CHANGE`.
- **Product boundary (bounded, read-only).** General and the other managed spaces were restricted to their groups with no category open to everyone or the trust-level groups; anonymous visitors and an in-memory unpaid signup saw no category; the paid group was empty and staff-controlled; personal messages stayed staff-only, chat was off, Qualified Access and its derived groups and reconciliation job were present, and the theme was pinned and default.
- **Security evidence, and its limits.** nginx showed the safe request and Referer log fields, the effective `error_log` at `emerg`, logrotate `create 0640`, and `nginx -t` passing. The Rails and Logster redaction modules and their signature guards were loaded, and the production ignore patterns were present. One synthetic `/u/password-reset/` sentinel had 0 raw occurrences in the nginx, Rails, Docker and filesystem sinks, and `[FILTERED]` appeared where expected. **The fresh Logster store held 0 messages, so the store-content part of that sentinel test was vacuous.** Task 38B reproduced and loaded the previously validated Logster hardening; full Logster failure-path acceptance remains inherited from the validated Task 37 / Phase 15 evidence, and the independent-host sentinel is bounded deployment evidence only. This is non-blocking.
- **Stability and sizing.** After the run the application container used about 1.14 GiB of 16 GiB with CPU at about 1–11%, `/shared` held about 99 MB, and the root disk held 8.9 GB including the 5.74 GB application image and the 5.05 GB base image. Sidekiq had no retries or dead jobs and the error logs were empty.
- **Not repeated, by decision.** Backup and restore (Task 37B.2B) and the full Phase 15 logging matrix.

### Task 38B — runbook correction, teardown and retained evidence

- **Runbook correction (`ops/discourse/README.md`).** It had said the native Uncategorized promotion needs `allow_uncategorized_topics` to stay on. On a fresh site that setting is `false` by upstream default and the promotion still happens, because a change at `stable` status counts as enabled on a new site. The real gates are a human admin, a site older than about one hour (`existing_site?`), and the scheduler's upcoming-change processing running. The setting is not a prerequisite and must not be toggled; the manual promotion stays `REHEARSAL FALLBACK — NOT ACCEPTANCE`.
- **Teardown.** The local evidence was verified first (31 files, aggregate hash `38802943a17a4a459b95bd77b83e53e3a0a7a4b55e88d59cb34e558a04c06fe9`, every member hash, a clean secret scan). The VM and its boot disk were then deleted and the whole dedicated project was deleted (`DELETE_REQUESTED`; its ID is not reusable), with the earlier mistaken empty project that had been created under an organization. The ephemeral SSH key pair and the dedicated gcloud configuration were removed, and no existing environment was touched.
- **`RETAINED — TASK 38B ACCEPTANCE EVIDENCE`:** `/home/leo/cannlabs-38b-evidence/task38b-evidence/` (31 non-secret files) and `/home/leo/cannlabs-38b-evidence/teardown-record.txt`. The Task 37 artifacts remain `INTENTIONALLY RETAINED — CLEANUP NOT YET AUTHORIZED`.
- **What Task 38B does not validate:** production readiness, real DNS, TLS or edge, production secret delivery, external SMTP, production Google or Apple OAuth, billing or membership, real staff 2FA readiness, a production first-admin process, an off-machine backup retention policy, Legal / LGPD, Trust & Safety, and the final launch sweep.

## TASK 40A — VALIDATED PRODUCTION SECRETS DELIVERY CONTRACT

Status: `PRODUCTION SECRETS CONTRACT VALIDATED` by official PM adjudication. `DEC-042` and `DEC-043`. Local and no-spend: fake secrets only, no production infrastructure, no cloud, DNS, TLS issuance or real SMTP, OAuth or billing credential, and no change to the validated prodlike definition (SHA-256 `89222f0a…065f`).

- **Contract.** `ops/discourse/SECRETS.md` is the authority. All secret values live in one root-only host file passed to the pinned launcher with `docker_args: --env-file`; the tracked definition names the path only. Names and routes: SMTP credentials, the Google OAuth client secret and the S3 backup credentials (environment, shadowing the site settings, 0 DB rows); `DISCOURSE_SECRET_KEY_BASE` (pinned, 128 hex characters); `apple_pem` (a DB-stored site setting set through a runner, because a multi-line value cannot travel by environment). `ops/discourse/production.env.example` lists the names with placeholders.
- **Candidates proven against the pinned launcher** (`discourse_docker` `8d705a91…`, read from its code and measured with fake sentinels):
  - A (untracked secrets-only template) and B (untracked full YAML) are supported but print every secret through the `set -x` trace of `launcher start` and `rebuild` and show it in `ps` argv for the whole bootstrap. Rejected.
  - C (`docker_args: --env-file`) is supported by `merge_user_args` for both bootstrap and start. Chosen: 0 secret occurrences in launcher output across four rebuilds, a restart, a destroy and start, and `start-cmd`, and 0 in 261 `ps` samples.
  - D (`DISCOURSE_<SETTING>` shadowing) works on top of C. E (mounted secret files) is not read by Discourse.
- **Corrections and additions to Task 39A.** The container regenerates `discourse.conf` from its runtime environment at every start (`/etc/runit/1.d/copy-env`), so `launcher restart` does not rotate a secret but `destroy` then `start` does; the image configuration also bakes the bootstrap-time environment, so a rebuild plus removal of the superseded images by ID is the clean rotation. Values must avoid `'`, `<%`, newlines and edge whitespace, because `discourse.conf` is parsed line by line through ERB.
- **Local rehearsal** (inside the local prodlike distribution, with its own launcher clone at the pin, container, network, shared state and loopback port 8088; the running prodlike instance was not touched). Four rebuilds, all exit 0, with the nginx and logging guards passing in each.
  - SMTP, Google and S3 values reached the application and matched the host file by hash; Mailpit (authenticating) accepted the mail sent with the env credentials.
  - `secret_key_base`: without a pin, a Redis wipe changed it and invalidated a stored session token and a signed message (the Task 39A claim, confirmed); with the pin it did not, and it was identical across a rebuild.
  - SMTP rotation: a plain restart did not rotate, `destroy` and `start` did, a rebuild made the image current, the old credential was rejected after provider-side revocation, and two superseded images that still held the old pair were removed by ID. `secret_key_base` rotation changed the effective key and invalidated the old session.
  - Exposure matrix (in `SECRETS.md`): env-delivered secrets are PRESENT only in the container environment, container and image `inspect`, and `discourse.conf` (root or `docker` group boundary), and ABSENT from launcher logs, `ps`, image layers, the app DB, native backups, container logs and evidence. The DB-stored `apple_pem` control is PRESENT in the DB and the backup, with no staff-log row when set through a runner.
  - `DISCOURSE_DEVELOPER_EMAILS` was absent and the application reported no developer emails.
  - Bootstrap on the fresh rehearsal site: audit only, `BLOCKED (pass 11, drift 19, blocked 2, gated 1)`, the expected fresh-site baseline. Full convergence was not repeated: it is unrelated to secrets delivery and would add the roughly 70-minute native promotion already proven in Task 38B.
- **Guards.** `spec/lib/cannlabs_community/production_secrets_contract_spec.rb` (6 examples) fails on a tracked populated env file, the developer-emails variable, a private-key or `secret_key_base`-shaped literal, a secret-class value in a tracked definition's `env:`, and a non-placeholder or undocumented name in the example; each guard was mutation-tested.
- **Findings (non-blocking).** `launcher start` can exit 0 after a failed `docker run`, so `/srv/status` must be checked. The image configuration is secret-bearing and must never be pushed. Each rebuild leaves a superseded image holding the old values until it is removed. `apple_pem` is DB-stored and so present in every backup. Not proven: real S3, Google and Apple flows, an escaped or multi-line `apple_pem` through the plugin, removing a key from the file.
- **Cleanup and evidence.** The rehearsal containers, network, image, shared state and fake-secret sources were removed (the sources shredded), and the Docker state of the prodlike distribution matches its state before the task. `RETAINED — TASK 40A REHEARSAL EVIDENCE`: 55 masked, non-secret files in `/home/leo/cannlabs-40a-evidence/evidence-export/`, aggregate hash of `SHA256SUMS` `b3fc4b838148286dbc45d55b942155779bd4a5092b8504958fd08b56d3a1604b`.
- **PM classification corrections** are recorded in `DEC-043` and in `00_PRODUCT_CANON.md` (§16, §18, §22): ordinary signup needs no manual approval, Apple is DECIDED for V1, and V1 moderation is CannLabs staff with native flags and trust. The anti-spam mechanism is the open item.

Production remains `PRODUCTION — NOT READY`. The next slice, production first-admin and staff security readiness, is Task 40B (below).

## TASK 40B — VALIDATED PRODUCTION FIRST-ADMIN AND STAFF SECURITY PROCEDURE

Status: `PRODUCTION STAFF SECURITY PROCEDURE VALIDATED` locally (procedure readiness) by official PM adjudication. `DEC-044`. Local and no-spend: synthetic `.test` identities only, no production infrastructure, no cloud, DNS, TLS, real SMTP, OAuth or billing, and no change to the validated prodlike definition (SHA-256 `89222f0a…065f`). **Procedure readiness is not production enrollment:** `OPEN — PRODUCTION ENROLLMENT NOT DONE`. No real host exists and no real staff account is enrolled.

- **Authority.** `ops/discourse/STAFF_SECURITY.md` is the runbook: contract, roles, prerequisites, first admin, enrollment and recovery-code custody, second admin, enforcement, later staff, API-key policy, break-glass, offboarding, the IP-allowlist position and the read-only audit. `spec/lib/cannlabs_community/staff_security_runbook_spec.rb` guards it.
- **Upstream review at the pin** (read from code, then measured): `rake admin:create` (`lib/tasks/admin.rake`) prompts through HighLine with echo off, creates or promotes a human, and writes no staff-log row; `/finish-installation` registers only an address that is in the developer-emails variable; `make_developer_admin` re-grants admin at every login (`DEC-042` forbids the variable); `enforce_second_factor` is `no`, `staff` or `all` and its redirect skips JSON requests, API requests, anonymous users and, optionally, external-auth sessions; backup codes are 10 × 32 hex, hashed, single use, and replaced on regeneration; admin promotion through the UI demands the actor's TOTP (a backup code is refused); `rake users:disable_2fa` removes TOTP, second-factor security keys and backup codes (not passkeys); the admin IP allowlist is checked only at admin login.
- **Chosen first-admin path.** `bin/rake admin:create` on a terminal, with the account holder typing the password at the no-echo prompt. Measured: the password never reached the terminal output (control: the typed email did), 0 hits in 26 to 27 host `ps` samples per run, and was absent from the database dump (hash only), every log and the mail. Not used, with evidence: the developer-emails variable, `/finish-installation` (a POST created nobody, HTTP 400), `rake admin:invite` (needs SMTP), `RANDOM_PASSWORD=1`, a runner that sets a password.
- **The hypothesised sequence held.** Create admin, log in, enroll, recovery codes, second admin, enforcement, break-glass and re-enrollment all worked in that order. One refinement: for the **first** admin, "enroll before promote" is not possible without SMTP (an account created with admin declined cannot log in until its email is confirmed, which `admin:create` does only in the grant branch). The first administrator is therefore protected by a password alone between creation and enrollment, so those steps belong before public ingress. For later staff, enroll-before-promote works and is the rule.
- **Admin redundancy.** The PM preference (two human administrators before real-member beta) is supported and recorded. One administrator plus the root `users:disable_2fa` path would also work, but that path writes no staff-log row and sends no email, while the peer-administrator path in the admin UI is audited and notifies the person. The root path is always available as the fallback.
- **JSON / API exemption, characterised.** With `enforce_second_factor = staff`, an unenrolled admin was redirected on browser navigation but its JSON session read the user list, site settings and API key list and minted an all-users API key. That key acted as an enrolled admin with no TOTP and wrote; a read-only key's write was refused; a default-allowed user API key with `write` also reached admin routes. Key creation has no second-factor challenge and is logged. The rule that protects the site is "no staff without a second factor", checked by the audit, and the policy is no staff API keys by default.
- **Least privilege.** An enrolled moderator suspended, unsuspended, closed a topic and read the staff log, and was refused 10 admin-only actions (route constraint 404, or 403 for disabling another user's 2FA); it saw no other member's email by default.
- **Break-glass.** Root `users:disable_2fa`: one admin's TOTP and codes removed, no log row, no email, session still valid until closed, the audit failed exactly while 2FA was off, re-enrollment with a new seed and new codes killed the old material, and the audit passed. The peer-administrator UI path wrote a `disabled_second_factor` row and emailed the person. A lost password was reset with `admin:create` without SMTP and ended an open session. A root-side runner removed and an administrator restored a role.
- **IP allowlist.** Off by default and recommended off: zero rows restrict nothing; a row blocks other admin logins only (not moderators, open sessions or API keys); a spoofed `X-Forwarded-For` did not bypass it behind nginx; the root-side runner recovers a lockout. Behind a published Docker port the app saw the bridge gateway address, so what it records for a real client must be checked on the real host.
- **Rehearsal.** The local prodlike distribution, with its own launcher clone at the pin, container, network, shared state and loopback port 8090 (the running prodlike instance, the DEV stack and FeedCheck were not touched), the `SECRETS.md` contract with a fake pinned key, a Mailpit sink and a fresh-state snapshot for repeatability. The final pass ran 130 checks, 130 passed, 0 failed, and the transcript scan for 75 generated secret values found 0. Three earlier passes (an abort and two with script or criterion errors: shared-IP login limits, nginx rate limits, a status code, a missing read-only scope, an over-broad count) are retained as evidence. Final audit state: two human administrators and one moderator, all with 2FA, `enforce_second_factor = staff`, no developer-email escalation, no API keys.
- **Findings.** MEDIUM: `enforce_second_factor` does not constrain JSON or API use (policy set; the user-API-key defaults and `allow_impersonation` are OPEN for PM arbitration, unchanged). MEDIUM: `admin:create` does not apply the admin password minimum (a 12-character password was accepted); the length rule is procedural. MEDIUM: TOTP keys are stored in clear text in the database and so in every native backup (recovery codes and API keys are hashes). MEDIUM: `admin:create` and `users:disable_2fa` leave no staff-log row, so the operations record is their audit trail. LOW: `admin:create` names the account `userN` (rename with `users:rename`); upstream does not stop promoting a user without 2FA; one source address has 30 logins per hour and 6 per minute; any administrator session can disable another administrator's 2FA or revoke admin without a challenge. OBSERVATION: `users:disable_2fa` does not remove passkeys; `disable_2fa` does not close sessions; the upstream Cloudflare template downloads address ranges at build time. Not proven: security keys, passkeys and WebAuthn (the Task 32 local-origin issue remains), real SMTP, a real authenticator app, and behavior behind a proxy, Cloudflare or TLS.
- **Cleanup and evidence.** The disposable containers, network, image, shared state, snapshot and the fake pinned key were removed (the key shredded); the Docker state of the prodlike distribution matches its state before the task, and the prodlike runtime (up, `/srv/status` 200), the launcher checkout, the DEV container and FeedCheck were untouched. `RETAINED — TASK 40B REHEARSAL EVIDENCE`: 24 masked, non-secret files (transcripts of all four passes, launcher output, the reproduction scripts) in `/home/leo/cannlabs-40b-evidence/evidence-export/`, aggregate hash of `SHA256SUMS` `9cec19fb78a90ba7c640efcdff1cb969256db7b513801735afa484d4f56bfade`.
- **Correction recorded.** Task 40A is VALIDATED by the official PM; its heading and status line above are updated accordingly.

Production remains `PRODUCTION — NOT READY`. Not authorized: real first-admin creation, real staff enrollment, production cloud, SMTP, DNS and TLS, OAuth, backup destination and billing.

## TASK 40C.1 — VALIDATED POST-RESTORE HTTP PROCESS CONVERGENCE

Status: `VALIDATED — POST-RESTORE HTTP PROCESS CONVERGENCE` on the retained production-like instance; the official PM formally accepted the runtime evidence on 2026-10-06. `DEC-045`. Origin: Task 40C (a read-only host and edge review, validated by the official PM) reported that the database held the bootstrapped Community settings while the running web workers appeared to serve stale pre-restore settings. Task 40C.1 reproduced it, restarted the application once, accepted the result over HTTP and corrected the restore runbook. No backup, no restore, no rebuild, no image or definition change, no database or setting write, no cloud. The validated prodlike definition is unchanged (SHA-256 `89222f0a…065f`). DEV and FeedCheck were not touched (Docker Desktop was down during the runtime work, see the findings and "Durable closure").

- **Pre-restart evidence (all anonymous or read-only).**
  - A fresh Rails process and the database said: `login_required=true`, `default_locale=pt_BR`, `chat_enabled=false`, default theme 1 (`CannLabs Community`, pinned revision), 29 settings rows, 6 categories all restricted, 8 topics all in restricted categories. The production bootstrap audit: `PASS (pass 36, drift 0, blocked 0, gated 1)`.
  - The running workers said, in their own boot data: `login_required=false`, `default_locale=en`, `chat_enabled=true`, theme `-1`; `/` was the install wizard (title "Discourse Setup"); `/about.json` and `/directory_items.json` (9 member entries) answered anonymous requests with 200; `/latest.json` answered 200 with 0 topics. `/srv/status` returned 200 `ok`. 40 of 40 samples agreed; only `worker[0]` had served requests, so the other two workers were not observed.
  - No restricted topic content was observed in the probed endpoints before the restart (the leak detector was run only afterwards), but member directory data and the about payload were anonymously readable.
- **Diagnosis, proof separated from inference.**
  - **Proven.** The divergence existed between the running workers and the database at the same instant. The workers started before the restore: the final build ended 2026-10-05 15:23:04Z (Docker's `StartedAt` agrees), `enable_restore` ran at 15:24:51Z and the restore ran 15:24:57–15:25:19Z, with no restart since (`RestartCount` 0). A restart that left the database unchanged, and that reloaded Redis from its snapshot (`/shared/redis_data`, 324 keys loaded), removed the divergence; `lib/site_setting_extension.rb` does not use Redis, so the stale state lived in process memory. The stale values are exactly the stock zero-state defaults, including `has_login_hint=true`.
  - **Read from code.** `Restorer#run` flushes Redis, restores the database, then calls `SiteSetting.refresh!` in its own process only and never publishes a `/site_settings` message; workers refresh only on such a message (`SiteSettingExtension`); Pitchfork forks workers from a mold started before the restore, and `Discourse.after_fork` calls `SiteSetting.after_fork`, which re-subscribes without refreshing.
  - **Inferred, not tested.** That the missing message is the whole cause; that a worker-only reload would not help; that Sidekiq also held stale settings; that a restore run from the admin UI behaves the same.
  - **Note on timestamps.** `ps` start times inside the container were about 44 minutes earlier than Docker's `StartedAt` and runit's uptime (WSL clock stepping), so the proof uses the wall-clock stamps written at event time, not `ps`.
- **Restart.** `cd /var/discourse && ./launcher restart cannlabs-prodlike` (the pinned launcher `8d705a91`, which runs `docker stop -t 600` and then `docker start` of the existing container). 2026-10-06 07:54:43.2Z to 07:54:48.6Z, exit 0. Container `ce0b4670…` and image `e3e481b4…` identical before and after (`StartedAt` advanced to 07:54:48Z, `RestartCount` 0). `/srv/status` answered 200 at 07:55:07Z (000, 502, 503, then 200).
- **Post-restart evidence.**
  - The fresh-process database view and the audit output are byte-identical to the pre-restart captures (same 29 rows, same product state, `PASS (pass 36, drift 0, blocked 0, gated 1)`): no product or database change.
  - The running workers now say `login_required=true`, `pt_BR`, chat off, theme 1 (with the CannLabs color scheme and no chat assets). `/` is the app shell, not the wizard. 17 of 17 representative data endpoints are denied (HTML: 302 to `/login`; JSON: 403 `not_logged_in`). 40 sequential and 48 concurrent anonymous requests all returned the converged state, and all three workers served requests (`worker[0]` +18, `worker[1]` +15, `worker[2]` +15), so every worker was observed.
  - A paced probe of 42 paths with a crawler and a browser user agent (84 responses) found 0 occurrences of any of the 8 restricted topic titles and 0 of the 11 member usernames.
- **Correction to my own reading of the code.** `AboutController#index` redirects an anonymous visitor to `/login`, which suggested `/about.json` would be a 302. Observed: 403, because the application-wide `redirect_to_login_if_required` runs first for JSON. The gate therefore accepts "denied" (login redirect, 401 or 403) and not one status code.
- **Privacy canary.** Not `/latest.json == 403`. The semantic assertions are in `ops/discourse/anonymous_http_acceptance.py` and listed in `ops/discourse/README.md` section 10. They hold because upstream gives anonymous data requests a login redirect (HTML) or 403 (JSON) under `login_required`; the routes that are reachable by design (`/`, `/login`, `/signup`, `/site/basic-info.json`, `/site/statistics.json`, `/session/csrf.json`, `/session/hp.json`, `/manifest.webmanifest`, `/service-worker.js`, `/robots.txt`, `/srv/status`) are checked for content instead. The pre-restart state is detectable by four independent assertions (live `login_required`, boot data, the wizard on `/`, and the 200 data endpoints). Anonymous `/latest.json` alone would not have caught it: it returned 200 with zero topics because no category is public.
- **Reusable gate.** `ops/discourse/anonymous_http_acceptance.py` is standard-library Python, anonymous GETs only, no credentials or cookies, no synthetic data, paced under the nginx limits (the validated definition rate-limits to 429, which the first probe of this task hit), fail-closed (a 2xx where denial is required or a wrong live setting is `FAIL`; unreachable, 429 or 5xx after retries is `INCONCLUSIVE`, never a pass). `--self-test` runs 29 mutation-tested cases on canned responses, including a replay of this task's stale state. Live: `PASS` on the converged instance; `FAIL` with a wrong `--expect-locale`; `FAIL` with `--require-noindex` on the current robots posture; `INCONCLUSIVE` on a dead port. A first live run raised a false alarm on `/site/statistics.json` (37 numeric keys against a name allowlist built from a truncated look); the check now asserts "every value is a number".
- **Restore acceptance contract.** `ops/discourse/README.md` section 10 now requires, in order: restore success; `./launcher restart` (no rebuild); health; the fresh-process audit; the live HTTP gate; only then VALIDATED. `/srv/status` is liveness only. A backup needs no restart. A guard spec, `spec/lib/cannlabs_community/post_restore_acceptance_spec.rb`, pins this.
- **Task 37 interpretation.** The backup and restore mechanics stay VALIDATED. The Task 37B.2B restore acceptance passed the audit but did not check the running workers (see the correction note under it). Task 40C.1 closes that gap on the retained instance.
- **Findings.** HIGH (closed): running workers served pre-restore settings after the restore. MEDIUM: a restore silently diverges the running workers from the database, so the contract must be followed every time (it is now a guard-tested runbook sequence, not an enforced mechanism). LOW, `READY FOR TASK 40D`, unchanged: `allow_index_in_robots_txt` is true and unmanaged (crawlable `/login` and `/signup`, no noindex header); `/site/statistics.json` returns aggregate counts anonymously. OBSERVATION: the first exposure probe was rate-limited to 429 by nginx (discarded, kept as evidence); `/tos`, `/privacy` and `/directory` answer 404; Docker Desktop was stopped during the runtime work, so the DEV and FeedCheck containers were unreachable and specs, lint and the dev-container commit had to wait (not repaired, by standing instruction; see "Durable closure" below).
- **Evidence.** `RETAINED — TASK 40C.1 EVIDENCE`: masked, non-secret captures in `/home/leo/cannlabs-40c1-evidence/` (pre- and post-restart database, audit, HTTP, worker and process views; the restart record; the exposure probe; the live runs of the script; the final runtime state; the scripts as run). The detector file holding real topic titles and usernames was destroyed after use. Aggregate hash of `SHA256SUMS`: `5a2a6df16a8943072c22deef6ce49022b043be270a9c9d5589ed0bf1abd2082a`.

Production remains `PRODUCTION — NOT READY`. Not authorized: Task 40D, production infrastructure, any backup or restore.
- **Durable closure (resumed step, 2026-10-06).** Docker Desktop and the DEV container were running again, FeedCheck was up (read-only check), HEAD was still `edcd4103` with exactly the six expected uncommitted files, and prodlike was unchanged and healthy (same container and image, `StartedAt` 07:54:48Z, `RestartCount` 0, `/srv/status` 200). No runtime action was repeated: no restart, rebuild, backup, restore or product write. `bin/lint --fix` passed and only reformatted the new spec (regex literals, one modifier, line wrapping; reviewed, semantically identical). The four `ops/discourse` specs (the new post-restore acceptance spec, the Task 40A secrets contract spec, the Task 40B staff security runbook spec and the deployment parity spec) ran 19 examples, 0 failures, with the script's self-test executed (not skipped). The new spec's guards were mutation-tested: 18 distinct mutations (step order, a dropped, extra or reworded step, a rebuild instruction, lost liveness wording, a backup restart, an inconclusive-as-pass sentence, a missing flag, a non-stdlib import, a cookie handler, a request body, a credential word, a broken classifier, a broken exit-status line) were all caught. Two of the first 13 mutations appeared uncaught because my mutator edited an earlier numbered list in the README, not section 10; scoped to section 10 they were caught, and the evidence is that each mutation was checked to change only the intended text. `anonymous_http_acceptance.py --self-test` passed 29/29. No restricted topic title, username, secret or credential is stored in the repository or the evidence.

## TASK 40D — PRODUCTION DEPLOYMENT DEFINITION AND INGRESS ACCEPTANCE (VALIDATED)

Status: `PRODUCTION DEPLOYMENT DEFINITION VALIDATED` locally and VALIDATED by the official PM. `DEC-046` and `DEC-047`. Repository and local rehearsal only: no cloud resource, no DNS, no certificate authority contact, no real SMTP, OAuth or billing, no real secret, and no change to the validated prodlike definition (SHA-256 `89222f0a…065f`). `PUBLIC ACME ISSUANCE — NOT YET VALIDATED`. `PRODUCTION STARTING SIZE — HYPOTHESIS`. Production remains `PRODUCTION — NOT READY`.

- **Founder decisions recorded (`DEC-046`).** Canonical hostname `community.cannlabs.com.br`; `comunidade.cannlabs.com.br` permanently redirects to it and is not a second origin. Direct host, no Cloudflare in V1, IPv4 only and no AAAA, official `discourse_docker` TLS path, provider firewall authoritative, São Paulo preferred, `2 vCPU / 8 GB / 80 GB SSD-class` as a starting-size hypothesis.
- **Upstream review at the pinned `discourse_docker` (`8d705a91…`).** The SSL template writes, at every start, a catch-all port-80 server (no `server_name`) that sends every host to `https://${DISCOURSE_HOSTNAME}$request_uri`, and an HTTPS block with TLS 1.2 and 1.3, HSTS `max-age=31536000` and `if ($http_host != canonical) rewrite … permanent`. The Let's Encrypt template natively supports additional hostnames on one certificate: `DISCOURSE_HOSTNAME_ALIASES` becomes extra `-d` arguments for both the RSA and the ECDSA certificate. Static `/shared/ssl/ssl.crt` and `ssl.key` take precedence and silently disable Let's Encrypt. No account email is read. An `expose` entry with `:` goes verbatim to `docker run -p`. The pinned launcher turned the tracked definition into exactly `-p 0.0.0.0:80:80 -p 0.0.0.0:443:443`.
- **Alias: the smallest supported implementation is native (Option A).** No custom nginx, no second container, no second `DISCOURSE_HOSTNAME`. Rehearsal, with a local CA and a certificate carrying both names: `http://community…` and `http://comunidade…` each answer one `301` to the canonical HTTPS URL with path and query kept; `https://comunidade…` has a valid certificate (SAN), then a `301` to the canonical URL with no application content and no cookie; any other Host is redirected too; the canonical host serves the application with HSTS and a `Secure; HttpOnly; SameSite=Lax` session cookie. Option C (a provider redirect service) is documented, not implemented.
- **Production definition.** `ops/discourse/cannlabs-production.yml` and `ops/discourse/PRODUCTION.md`: the prodlike set plus the SSL and Let's Encrypt templates, `0.0.0.0` IPv4 exposure of 80 and 443, the `DEC-042` env-file, no Mailpit, no custom network, no SMTP yet, the application pinned at the commit that owns the robots setting, the plugin pin equal to the manifest, and the prodlike hardening steps copied unchanged as a prefix of `run:`.
- **Sizing.** The pinned wizard (`resource_scaler.rb`) derives `db_shared_buffers = min(256MB × GB, 4096MB)` and `UNICORN_WORKERS = 2 × cores` (cap 8), and writes them only into the YAML. A hand-written definition keeps 3 workers and 256MB. Starting profile for 8 GB and 2 vCPU: `2048MB` and `4`. The wizard's core count is `lscpu` CPU(s) times threads per core and can double-count; the definition uses `2 × cores`. Nothing adjusts on a resize.
- **Finding (fixed in the definition): the port-80 redirect server logged credential URLs.** The SSL template adds a second nginx server with no `access_log`, so it inherited the stock default, which logs the raw request line. A fake credential path sent over plain HTTP appeared in `access.log` in full. A production-only, guarded block now replaces the stock default with a format that has no request line, query string or Referer; the same requests then left no token in the log. The guards were negative-controlled in a throwaway container: the reviewed stock file passes and eight deviations (already patched, stock line twice or replaced, a leaky `$request` or `$request_uri` format, a surviving stock line, a missing format or access_log line) all fail the build.
- **IPv6.** Measured: a bare `-p 80:80` publishes `0.0.0.0:80` and `[::]:80`; `-p 0.0.0.0:80:80` publishes IPv4 only. nginx still listens on `[::]` inside the container; the host binding decides exposure. DNS contract: `A` records only, no AAAA.
- **TLS rehearsal.** Fully local: a local CA, RSA and ECDSA certificates with both names, the official templates, ACME disabled. Stage 1 used the static certificate pair the template looks for first; stage 2 ran the template's own certificate-path rewrite (`configure-letsencrypt`'s two `sed` commands, extracted verbatim) and nginx accepted the dual-certificate configuration, served the 256-bit ECDSA key to an ECDSA client and the 2048-bit RSA key to an RSA client, and the alias verified on the same certificate. No CA was contacted and no public issuance was attempted.
- **Robots / private-site indexing.** `allow_index_in_robots_txt` defaulted to `true` and was unmanaged. It is now owned by the production bootstrap profile (`false`, `profile_settings`, `DEC-047`); the local profile leaves it `GATED`. Specs (30 examples with plugins loaded, 3 new, mutation-tested) and the rehearsal: the audit on the fresh production-profile instance reported `settings.allow_index_in_robots_txt` as `DRIFT` (true, expected false); after the native Uncategorized promotion and `bootstrap:apply` the production audit was `PASS (pass 37, drift 0, blocked 0, gated 1)` with that row passing, and a second apply changed nothing. **What upstream really renders with it off:** `robots.txt` lets Googlebot crawl everything except `/uploads/*` (so it can read the noindex header) and disallows every other crawler; every page the application renders carries `X-Robots-Tag: noindex, nofollow`. So it is the upstream equivalent of a private-site posture, not a strict disallow-all (a strict file would need the native `overridden_robots_txt`, not used; a PM decision). The running workers served it right after the apply with the container never restarted.
- **Ingress acceptance.** The existing `ops/discourse/anonymous_http_acceptance.py` is the only privacy and ingress checker. It gained TLS and connection options (`--cafile`, `--connect-http`, `--connect-https`) so loopback can stand in for DNS, and a hostname group (`--canonical`, `--alias`): canonical HTTPS with HSTS and Secure cookies, single-hop HTTP to HTTPS, alias redirect-only on both schemes over a path panel, unknown Host redirected. A `429`, `5xx` or unreachable host is `INCONCLUSIVE`; an invalid certificate is `FAIL`. `--self-test`: 58 cases (the 29 earlier ones, 26 hostname cases and 3 for upstream's rendered robots form), each mutation caught.
- **Client address, firewall, health.** Documented in `PRODUCTION.md`: the client-address path, the four real-host acceptance items (`REAL-HOST ACCEPTANCE REQUIRED`, provider NAT was not measured), the provider-neutral firewall contract (provider firewall authoritative, never `ufw` alone), and `/srv/status` as shallow liveness with external HTTPS, certificate-expiry and privacy-canary monitoring (no service chosen).
- **Opening sequence.** `PRODUCTION.md` section 12: 18 provider-neutral steps, with 443 closed until the staff, bootstrap, gate and SMTP steps are done and public 443 last. `STAFF_SECURITY.md` now points at it.
- **Secret material.** TLS private keys under `/shared/ssl` and `/shared/letsencrypt` are classified `HOST/DEPLOYMENT SECRET MATERIAL` (`SECRETS.md` section 12).
- **Guards.** `spec/lib/cannlabs_community/production_deployment_spec.rb` (12 examples) plus the parity spec now covering both definitions: 39 mutations of the definition, the runbook, the bootstrap manifest and the frozen prodlike file were all caught.
- **Rehearsal results (disposable instance, loopback ports, local CA, fake pinned key, no real secret, no public DNS or ACME).** Built from the tracked production definition, mechanically derived (loopback ports, own network, volumes and env-file, `DISABLE_LETSENCRYPT`): two builds, both exit 0 with every guard passing. Synthetic admin, native promotion about 65 minutes after schema creation, theme installed at the exact commit, then the validated bootstrap steps: audit #1 `BLOCKED (pass 13, drift 22, blocked 1, gated 1)`; audit #2 `DRIFT (pass 14, drift 23, blocked 0, gated 1)`; first apply `PASS (pass 37, drift 0, blocked 0, gated 1)`, 23 changes; final audit `PASS (pass 37, drift 0, blocked 0, gated 1)`; second apply `NO CHANGE`. The full gate `anonymous_http_acceptance.py --canonical community.cannlabs.com.br --alias comunidade.cannlabs.com.br --expect-locale pt_BR --require-noindex` (with `--connect-*` and the rehearsal CA) printed `HTTP_ACCEPTANCE=PASS` with 17 of 17 data endpoints denied. On the fresh, unbootstrapped instance the same gate printed `FAIL` (live `login_required` false, wrong locale, 17 exposed endpoints, no noindex) while its hostname group passed: the gate fails closed on an unconverged site. Negative controls: a wrong expected locale fails; a certificate the trust store does not know is a TLS `FAIL`; an unreachable host is `INCONCLUSIVE`.
- **Cleanup and evidence.** The rehearsal container, network, images (including the replaced first build, by ID), shared state, the fake key and the local CA and certificate keys (shredded) were removed. The Docker state, the retained prodlike runtime (up, `/srv/status` 200, restarts 0), the launcher checkout, DEV, FeedCheck and all Task 37 retained artifacts, including its five dangling images, are as before. `RETAINED — TASK 40D REHEARSAL EVIDENCE`: 24 masked, non-secret files in `/home/leo/cannlabs-40d-evidence/` (rehearsal logs, the launcher publish arguments, the gate outputs, the leak test before and after, the IPv6 test, the certificate-path rewrite, the guard negative controls, the scripts), aggregate hash of `SHA256SUMS` `1be81bf458d1e83d2acfe7b08fb66ad0bfa1867bca315ddb31423e1256b56b2c`.
- **Two commits.** The application pin must contain the bootstrap change and a commit cannot contain its own SHA, so the work is two commits: `43bb05bd…` (bootstrap ownership of `allow_index_in_robots_txt`, pushed first and used as the production application pin) and the definition, runbook, gate extension, guards and canon.
- **Findings.** See the Backlog entry for Task 40D.

## TASK 41A — VALIDATED PRODUCT RE-BASELINE

Read-only. The permanent Coder inspected the actual DEV database and the repositories (no browser, the server was down). Result: a strong, validated access and trust substrate (closed community, `membros_ativos`, derived qualified access, native moderation) and a thin first-use experience: stock English welcome and guidelines, six restricted categories, no tags, no user fields, no flair on the verification groups, no association group, a theme that covers only the shell, `/latest` and `/categories`, and an unpaid account that saw nothing and was told nothing. It recommended exactly one next slice (the member front door), and the Founder direction in `DEC-048` followed. One correction recorded later: the `/guidelines` static page does render the seeded guidelines topic to a logged-in member even though that topic sits in the Staff category (it renders the first post without a topic ACL check), so the defect was the stock English content and the Staff placement, not unreachability.

## TASK 41B — MEMBER FRONT DOOR V1 (VALIDATED)

Status: VALIDATED by the official PM; Founder product acceptance was sufficient to close the slice. Local DEV only: no cloud, DNS, AWS, real SMTP, OAuth or billing. The production definition and its application pin are untouched.

- **What changed.** The bootstrap manifest now owns the member front door in Brazilian Portuguese (`08_PRODUCT_BOOTSTRAP.md`): `site_description` and `short_site_description`; three native text overrides (`login_required.welcome_message`, `js.welcome_banner.subheader.logged_in_members`, `js.topics.none.education.generic`); the topic behind `welcome_topic_id` (adopted once from the unedited seed) and a new member-visible, pinned, closed "Regras da Comunidade" topic behind `guidelines_topic_id`, both with their Markdown under `config/cannlabs_community/content/pt_BR/`; the description and native title of every category's About topic; the default sidebar categories (by slug, propagated to existing users); the built-in links of the public Community sidebar section; and the residual Uncategorized category, which is now staff-only.
- **Boundary.** Only one ACL changed: the residual Uncategorized category went from `membros_ativos` to staff-only, so ordinary members no longer list it or can post into it. Groups, other ACLs, settings that define the paid boundary, PM and Chat are unchanged.
- **Known limitations (left as they are).** The welcome banner is not rendered on mobile, so the "Fale com a equipe" link is desktop-only; on mobile the unpaid empty state carries the same sentence without a link (the About page remains the route). The empty-state button still reads "Navegue pelos tópicos mais recentes" (its key is shared). The sidebar "Mais" drawer still lists Usuários(as), Sobre and Diretrizes; `KNOWN STOCK SIDEBAR REMAINDER — DEFERRED TO DESIGN/NAVIGATION PASS`. The member directory remains reachable by an unpaid account (profile and directory gating is a later slice). The login-required landing shows no visible logo (a paper-coloured wordmark on a light card): a design-pass item.
- **Owned text is Git text.** A direct edit of an owned topic, override or description in the admin UI is drift; edit the manifest or the Markdown and apply. A `default_locale` change re-seeds an unedited seeded welcome topic (`014-track-setting-changes`); re-apply the bootstrap afterwards.
- **Recorded with the slice:** `TASK 41A — VALIDATED PRODUCT RE-BASELINE`, `LOCAL PRODUCT DEVELOPMENT — ACTIVE`, `TASK 40F — PARKED`, `PRODUCTION EXTERNALIZATION TRACK — PARKED UNTIL LOCAL ALPHA MATURITY`, `TASK 40D — VALIDATED`.
