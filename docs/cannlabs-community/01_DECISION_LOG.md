# CannLabs Community — Decision Log

Status: CURRENT
Baseline date: 2026-09-29

Append-only record of ratified decisions. To change a decision, add a new entry that supersedes it and mark the old entry SUPERSEDED; never rewrite an entry's history. Canon references (`§N`) point to `00_PRODUCT_CANON.md`.

---

## DEC-001 — Community is a separate product

- **Date:** 2026-09-29
- **Status:** DECIDED
- **Decision:** CannLabs Community is a separate product and application from FeedCheck, CannLabs Traceability and every other CannLabs product.
- **Rationale:** Established at bootstrap: FeedCheck and the other CannLabs products are not a base, template, upstream, or source of configuration, database state, migrations, plugins or code for Community.
- **Consequences / open items:** Separate repository, code, database, deploy, product canon and implementation history. The CannLabs Design System may still be adapted without merging applications (`DEC-013`).
- **Supersedes:** —

## DEC-002 — Technical base is the official Discourse project

- **Date:** 2026-09-29
- **Status:** DECIDED
- **Decision:** The technical base is the official open-source Discourse project. The repository is a true GitHub fork of `discourse/discourse`.
- **Rationale:** Discourse already provides mature forum and community mechanics, which are an advantage to reuse rather than rebuild (§1).
- **Consequences / open items:** Upstream documentation and code are the authority for upstream behavior. Fork-divergence strategy and upstream sync cadence remain OPEN (`04_DISCOVERY_BASELINE.md` §3).
- **Supersedes:** —

## DEC-003 — Upstream-first, reuse before custom (permanent)

- **Date:** 2026-09-29
- **Status:** DECIDED
- **Decision:** UPSTREAM-FIRST · REUSE BEFORE CUSTOM is a permanent operating law.
- **Rationale:** Reusing proven Discourse primitives avoids rebuilding what already exists and keeps custom infrastructure to what is proven necessary.
- **Consequences / open items:** Follow the inspection order in §20. Any new system for users, roles, groups, permissions, moderation, messaging, notifications, search, invites, badges, events, subscriptions, scheduling or authentication requires proof that native primitives are insufficient. Core modification is the last resort and requires explicit PM authorization.
- **Supersedes:** —

## DEC-004 — Community is private and paid

- **Date:** 2026-09-29
- **Status:** DECIDED
- **Decision:** CannLabs Community is private, membership-based and paid.
- **Rationale:** Product thesis (§1, §2).
- **Consequences / open items:** Vanilla defaults currently mismatch this (for example `login_required` is `false`; see `04_DISCOVERY_BASELINE.md` §1.4). Changing them requires an explicitly authorized configuration slice. Pricing and the institutional plan remain OPEN (§17).
- **Supersedes:** —

## DEC-005 — CannLabs Web is the separate public surface

- **Date:** 2026-09-29
- **Status:** DECIDED
- **Decision:** CannLabs Web is the separate public surface for editorial and educational content, SEO, GEO / AI discoverability, guides, public articles and acquisition.
- **Rationale:** The Community is private and must not become the default public SEO surface (§2).
- **Consequences / open items:** Community posts are never automatically public. Moving content from Community to CannLabs Web is a separate editorial act. The contributor workflow is LATER (backlog).
- **Supersedes:** —

## DEC-006 — The core product is a community / forum

- **Date:** 2026-09-29
- **Status:** DECIDED
- **Decision:** The fundamental product is a community / forum, not a generic social network.
- **Rationale:** Product thesis (§1).
- **Consequences / open items:** Prefer native Discourse forum mechanics over new social features.
- **Supersedes:** —

## DEC-007 — Cannabis commerce is out of scope

- **Date:** 2026-09-29
- **Status:** DECIDED
- **Decision:** Cannabis commerce and transaction facilitation are outside product scope. CannLabs Community is not a cannabis marketplace.
- **Rationale:** Commerce boundary (§11).
- **Consequences / open items:** Enforcement language belongs to the Community Guidelines after Legal / Trust & Safety review. Lawful technical and equipment discussion remains allowed (§12). Direct messages and chat are PARKED pending review (§15).
- **Supersedes:** —

## DEC-008 — Users may hold multiple roles

- **Date:** 2026-09-29
- **Status:** DECIDED
- **Decision:** Roles are cumulative; one user may hold several professional and institutional identities.
- **Rationale:** Real participants combine roles, for example physician + association representative (§8).
- **Consequences / open items:** No exclusive `user_type`. Discourse Groups as the native primitive is a HYPOTHESIS pending an upstream/reuse review.
- **Supersedes:** —

## DEC-009 — Initial verified professional families

- **Date:** 2026-09-29
- **Status:** DECIDED
- **Decision:** The initial verified professional families include physician, pharmacist, agronomist and lawyer.
- **Rationale:** Initial professional personas of the product thesis (§5).
- **Consequences / open items:** Verification workflows, sources, reverification, expiry and badge semantics remain OPEN.
- **Supersedes:** —

## DEC-010 — Associations are a core institutional participant

- **Date:** 2026-09-29
- **Status:** DECIDED
- **Decision:** Cannabis associations are a core institutional participant type.
- **Rationale:** Associations are part of the core ecosystem served by the product (§6).
- **Consequences / open items:** The association model (verified identity, representatives, seats, profile) is HYPOTHESIS / OPEN and not designed yet.
- **Supersedes:** —

## DEC-011 — Ecosystem companies may participate institutionally

- **Date:** 2026-09-29
- **Status:** DECIDED
- **Decision:** Legitimate ecosystem companies and organizations may participate institutionally without turning the product into a marketplace.
- **Rationale:** Lawful suppliers are part of the ecosystem (§7) while commerce stays out of scope (`DEC-007`).
- **Consequences / open items:** Verification, commercial-disclosure rules, promotion boundaries and conflicts of interest remain OPEN. Specific partners are not encoded in canon.
- **Supersedes:** —

## DEC-012 — Verification is part of the product direction

- **Date:** 2026-09-29
- **Status:** DECIDED
- **Decision:** Professional and institutional verification are part of the product direction. The exact workflow remains OPEN.
- **Rationale:** Evaluating identity and credentials is part of the core problem (§3, §5).
- **Consequences / open items:** Data minimization applies. Prefer verification against authoritative sources over storing document copies when feasible (§14).
- **Supersedes:** —

## DEC-013 — CannLabs Design System is the visual foundation

- **Date:** 2026-09-29
- **Status:** DECIDED
- **Decision:** The existing CannLabs Design System is the visual foundation to be adapted for Community.
- **Rationale:** Reuse the established CannLabs visual language without merging products (§19).
- **Consequences / open items:** Principles and tokens before components. Do not blindly import global Design System CSS, React components or Traceability-specific components. The Design Director owns compatibility and handoff.
- **Supersedes:** —

## DEC-014 — Data minimization; not a patient medical record

- **Date:** 2026-09-29
- **Status:** DECIDED
- **Decision:** Minimize personal and sensitive data. CannLabs Community is not a patient medical record.
- **Rationale:** LGPD / privacy product law (§14).
- **Consequences / open items:** Ordinary membership does not require medical documentation. Verification collects only the minimum necessary.
- **Supersedes:** —

## DEC-015 — Legal / Privacy / Trust & Safety review before V1

- **Date:** 2026-09-29
- **Status:** DECIDED
- **Decision:** A dedicated Legal / Privacy / Trust & Safety review is a mandatory gate before V1.
- **Rationale:** The product touches health-adjacent data, professional credentials, user-generated content and a prohibited-commerce boundary.
- **Consequences / open items:** Scope is listed in `03_BACKLOG_AND_OPEN_QUESTIONS.md`. The canon makes no legal conclusions.
- **Supersedes:** —

## DEC-016 — Security / Launch Readiness review before V1

- **Date:** 2026-09-29
- **Status:** DECIDED
- **Decision:** A dedicated Security / Launch Readiness review is a mandatory gate before V1.
- **Rationale:** Comprehensive hardening is PARKED into a single pre-V1 sweep so that it does not block local development.
- **Consequences / open items:** Scope is listed in `03_BACKLOG_AND_OPEN_QUESTIONS.md`. Until then, development still avoids real secrets in Git, production credentials, unnecessary public exposure and disabling security controls without need.
- **Supersedes:** —

## DEC-017 — Authoritative development worktree is WSL / Linux

- **Date:** 2026-09-29
- **Status:** DECIDED — VALIDATED by the official PM (Task 02)
- **Decision:** The single authoritative development worktree is `/home/leo/source/repos/CannLabs-Community` in the Ubuntu-24.04 WSL distribution (Linux filesystem).
- **Rationale:** Upstream Discourse guidance for Windows requires the source to live on a Linux filesystem, and a single editable worktree ensures that the running app executes exactly the files being edited.
- **Consequences / open items:** The development container `cannlabs_community_dev` bind-mounts this worktree at `/src`. The Windows clone `C:\Users\Leo\source\repos\CannLabs-Community` is a bootstrap / reference clone only. No second editable copy may exist.
- **Supersedes:** The temporary runtime source used during the vanilla start (Docker volume `cannlabs_community_src`, now removed). That arrangement was never a formal decision.

## DEC-018 — Community design direction: "Arquivo em casca de Estufa" on a thin Foundation/core base

- **Date:** 2026-09-29
- **Status:** DECIDED — ratified by the Founder on the official PM's recommendation (Task 05)
- **Decision:**
  - **Visual register:** CannLabs Community uses "Arquivo em casca de Estufa". The navigation / shell / presence layer is Estufa; the discussion / reading / durable-knowledge layer is Arquivo. This is a composition inside the existing CannLabs Design System family, not a third brand system.
  - **Structural base:** Community design starts from the Discourse core / Foundation structure with a thin CannLabs adaptation, using supported design tokens, colour schemes, theme APIs and bounded surface adjustments. Horizon is not the structural base; it remains reference evidence only.
  - **List over cards:** forum discussion and content are primarily an archive / list structure, not a card feed. 1px structural rules and information density are preferred.
- **Rationale:** The Design System already uses a deep shell around paper content, which is the sidebar/content contrast the Founder values. Foundation keeps forum density and native interaction structure with the least override pressure; Horizon's cards, pills and radii work against the Design System and add upstream-owned surface to track. Evidence: the Task 05 Design Director proposal.
- **Consequences / open items:**
  - Guardrail: the shell is Estufa, the content is Arquivo; avoid gratuitous extra surface families.
  - Exact hex values and token implementation are not frozen. Dark mode needs an explicit contract; `deep` is not dark mode.
  - A bounded card remains possible where a specific future use case justifies it.
  - Upstream Foundation itself evolves; implementation must re-verify current Discourse behavior.
  - Design System issues found in Task 05 are PARKED in the backlog and do not block Community prototyping.
  - Resolves the Foundation vs Horizon HYPOTHESIS in `04_DISCOVERY_BASELINE.md` §2.6. Refines `DEC-013` without superseding it.
  - Does not authorize theme implementation.
- **Supersedes:** —

## DEC-019 — Circular avatars are a formal Design System exception

- **Date:** 2026-09-29
- **Status:** DECIDED — ratified by the Founder on the official PM's recommendation (Task 05)
- **Decision:** Circular avatars are a formal CannLabs Community Design System exception: circle = person.
- **Rationale:** The circle is Discourse's native grammar for recognizing people, and recognition matters in a trust-sensitive community. Native behavior outweighs visual purity.
- **Consequences / open items:** Circular geometry is not generalized to other UI elements. Recording the exception in the CannLabs Design System itself is PARKED in the Design System backlog.
- **Supersedes:** —

## DEC-020 — Intended Community language is pt-BR

- **Date:** 2026-09-29
- **Status:** DECIDED — ratified by the Founder on the official PM's recommendation (Task 05)
- **Decision:** The intended Community product language is pt-BR.
- **Rationale:** The product serves the Brazilian cannabis ecosystem (§1).
- **Consequences / open items:** This does not change `default_locale` (currently `en`; `04_DISCOVERY_BASELINE.md` §1.4). Locale configuration is a future bounded configuration slice that needs explicit authorization.
- **Supersedes:** —

## DEC-021 — First visual prototype is static; theme packaging stays OPEN

- **Date:** 2026-09-29
- **Status:** DECIDED — ratified by the Founder on the official PM's recommendation (Task 05)
- **Decision:** The first Community visual prototype is static / non-persistent. It does not install a theme, create colour schemes in the database, change the active theme, change site settings or persist runtime state.
- **Rationale:** Validate the visual direction before theme architecture and runtime state are introduced.
- **Consequences / open items:**
  - **OPEN — Community theme packaging architecture.** Candidates: a separate Community theme repository; a Community-owned additive location in the fork; bounded theme components where appropriate. Engineering / architecture review follows the prototype evidence. No theme repository is created.
  - The prototype itself still needs explicit official PM activation.
- **Supersedes:** —

## DEC-022 — Visual prototype validated; the Community shell is the deep L-frame

- **Date:** 2026-09-29
- **Status:** DECIDED — Task 06 VALIDATED by the official PM after Founder visual review (Tasks 06 / 06A / 06B)
- **Decision:**
  - The static Task 06 prototype, corrected in Task 06A to use the real CannLabs wordmark, validates the visual direction: "Arquivo em casca de Estufa" works on a real forum-shaped interface, the thin Foundation/core direction and the dense list treatment remain supported, and desktop / mobile and light / dark converged sufficiently for engineering handoff.
  - **Shell:** the Community uses the deep L-frame — deep Estufa header and sidebar around the Arquivo content surface, with the official paper CannLabs wordmark on the deep shell. The paper-header alternative is rejected as the primary direction.
- **Rationale:** The paper header weakens the Estufa / Arquivo register and reads closer to the public CannLabs website; the real wordmark strengthened the deep-shell result. Evidence: the Task 06 / 06A Design Director results and screenshots, kept outside the repository.
- **Consequences / open items:**
  - This validates a visual prototype and design direction only. It is not pixel-perfect visual QA, theme implementation validation or production readiness. Exact dimensions and CSS values are not frozen.
  - **HYPOTHESIS — topic-list titles in Petrona**, pending validation with the real Petrona font in implementation or prototype conditions; the prototype used a local stand-in. Public Sans is the fallback if real-font testing shows unacceptable density or readability. This does not block architecture work.
  - Theme packaging remains OPEN pending the architecture / reuse review (`DEC-021`).
- **Supersedes:** —

## DEC-023 — Implementation defaults: native letter avatars, polish later, accessibility throughout

- **Date:** 2026-09-29
- **Status:** DECIDED — official PM (Task 06B)
- **Decision:**
  - **OPEN / LATER — letter-avatar colour treatment.** Initial implementation keeps native Discourse letter-avatar behavior. No plugin or server-side override is introduced merely to match prototype colours; reopen only if real implementation shows a material visual problem. Circular avatars remain decided (`DEC-019`).
  - **LATER — fine visual polish:** microspacing, exact logo sizing, fine palette and category-colour tuning, minor dark-mode nuance, small typographic adjustments and decorative refinements.
  - Mandatory throughout implementation, never deferred as polish: WCAG contrast, responsive behavior, mobile touch targets, text scaling and reflow, focus behavior, upstream compatibility and native Discourse interaction preservation.
- **Rationale:** Keep the project moving after Founder approval without letting cosmetic parity create custom infrastructure or letting structural quality slip to the end.
- **Consequences / open items:** Neither the letter-avatar colours nor polish blocks the first theme slice. Task 06 found a 200% text-scaling reflow gap in the static prototype; it is an acceptance criterion for implementation, not polish.
- **Supersedes:** —

## DEC-024 — Community theme architecture: one full theme in a dedicated theme repository

- **Date:** 2026-09-29
- **Status:** DECIDED — official PM, after the Task 07 architecture / upstream reuse review (Task 07A)
- **Decision:**
  - CannLabs Community uses **one full Discourse theme in a dedicated, Community-owned theme repository**, installed through the standard Discourse git-theme mechanism, on the core / Foundation styling.
  - **Application repository** `leo-even/CannLabs-Community`: the Discourse fork, the Community product canon and docs, and Community application / runtime integration. It holds no custom theme source.
  - **Theme repository** `leo-even/CannLabs-Community-Theme` (intended name; not yet created): the Community-only theme — two paired light / dark colour schemes, per-scheme variables, bounded SCSS, authorized theme assets and theme-local tests. No backend or product infrastructure.
  - Options: A (separate theme repository) ADOPTED. B (theme source inside the fork) REJECTED: the standard git theme installer does not support it without non-standard runtime import or core modification. C (theme components only) REJECTED as the primary architecture; components remain possible later for optional, separable behavior. D (modify Foundation / core) REJECTED. E (core modifications) NOT REQUIRED.
  - **Ownership boundary.** The theme owns the two paired colour schemes, per-scheme variables, bounded SCSS, fonts once provenance is approved, theme-local locales only if needed, and theme-local tests. Site configuration owns the default / active theme, native `logo` / `mobile_logo` uploads, the pt-BR site locale, category data and any explicitly authorized upcoming-change configuration. The fork owns no Community theme code.
  - **Update and rollback.** Updates are manual, explicit and version-pinned; no automatic, unreviewed production updates. Rollback: first switch the default theme back to Foundation; second, restore a previously validated theme version. No data migrations in the first slice.
  - **Logo.** The canonical CannLabs Design System SVG is used unchanged in the initial implementation, through native `logo` / `mobile_logo` configuration: no redraw, tracing, geometry change or optimized derivative unless separately authorized, and no CSS background replacement in the theme. If payload size later proves material, a separate task may evaluate a lossless derivative with visual equivalence and a recorded source hash.
  - **OPEN / readiness requirement — font binary provenance.** Petrona, Public Sans and DM Mono have family-level SIL OFL 1.1 evidence (Task 07), but no CannLabs-owned binaries exist. Before any font is added to the theme repository: an authorized upstream source, the exact version / commit, the binary hash, and the retained OFL licence. Petrona topic titles remain HYPOTHESIS (`DEC-022`).
- **Rationale:** The git theme mechanism is the only option with a supported install, update and rollback path, and it keeps fork divergence at zero. Evidence: the Task 07 review, kept outside the repository.
- **Consequences / open items:**
  - A second Community-owned repository does not merge products: product separation (`DEC-001`) means isolation from FeedCheck, CannLabs Traceability and every other CannLabs product, and no code, database, deploy or canon is shared with them. `README.md` → Product separation is updated accordingly.
  - Resolves the OPEN theme-packaging item of `DEC-021`.
  - Creating the theme repository, installing a theme, creating colour schemes in the database, setting the default theme and uploading logos each need explicit official PM authorization.
- **Supersedes:** —

## DEC-025 — V1 product model is ratified as one bounded native Community

- **Date:** 2026-10-01
- **Status:** DECIDED — ratified by the Founder / official PM (Task 12A)
- **Decision:** V1 is a private, paid, forum-first Community using one canonical active-member access group, native Discourse permissions and bounded restricted spaces. Unpaid accounts remain outside member content and member-to-member communications.
- **Rationale:** Preserve a clear membership boundary while using the mature Discourse primitives already present in the application.
- **Consequences / open items:** The durable V1 contract is in `00_PRODUCT_CANON.md` §22 and `05_V1_PRODUCT_SPEC.md`. Implementation remains separately authorized; payment provider, legal/T&S review and exact group/category names remain open.
- **Supersedes:** —

## DEC-026 — Membership is the canonical access signal

- **Date:** 2026-10-01
- **Status:** DECIDED — Task 12A
- **Decision:** An active-member native Discourse Group is the single canonical signal for member content access. Registration, payment state and staff verification may feed that signal, but no parallel custom ACL truth is created.
- **Rationale:** A reversible, auditable native primitive is safer than duplicating authorization in custom code.
- **Consequences / open items:** The exact technical group name and payment-to-group adapter remain implementation decisions. Unpaid accounts have only account/onboarding/support surfaces.
- **Supersedes:** —

## DEC-027 — V1 communication boundary

- **Date:** 2026-10-01
- **Status:** DECIDED — Task 12A
- **Decision:** Member-to-member personal messages and native Chat are off for V1. Staff support and moderation communication remain available through reviewable native paths; no custom messaging system is authorized.
- **Rationale:** Reduce moderation, privacy, medical/legal-boundary and prohibited-commerce risk while preserving support.
- **Consequences / open items:** Exact native settings and the staff support path are implementation-readiness questions. Legal / Trust & Safety review remains required.
- **Supersedes:** The PARKED communication question in `DEC-007` / Canon §15.

## DEC-028 — Cumulative roles with bounded verification

- **Date:** 2026-10-01
- **Status:** DECIDED — Task 12A
- **Decision:** Professional and institutional roles are cumulative, represented with native groups where possible, and verified manually with data minimization. One primary visible role/flair may be shown without deleting other verified roles.
- **Rationale:** Participants legitimately hold multiple roles; a single exclusive user type would misrepresent them.
- **Consequences / open items:** Exact evidence, expiry, reverification and group names remain OPEN. Ordinary membership does not require medical documentation.
- **Supersedes:** Refines `DEC-008` and `DEC-012`.

## DEC-029 — V1 restricted spaces and payment boundary

- **Date:** 2026-10-01
- **Status:** DECIDED — Task 12A
- **Decision:** V1 uses only two bounded restricted spaces (Verified Professional Forum and Association Leadership Forum) and no profession-pair matrix. Payment provider selection remains OPEN; the only ratified lifecycle contract is payment state → active-member group.
- **Rationale:** Keep information architecture useful and auditable while avoiding premature provider or workflow lock-in.
- **Consequences / open items:** Exact category/group names, provider, pricing, institutional seats and Brazilian payment requirements require later authorized decisions.
- **Supersedes:** —

## DEC-030 — Qualified access is derived and reconciled by a bounded Community plugin

- **Date:** 2026-10-01
- **Status:** DECIDED — Task 18A, ratified by the official PM
- **Decision:** `acesso_profissionais` and `acesso_liderancas` are derived, system-managed native groups. Professional access requires `membros_ativos` plus at least one verified-profession identity. Leadership access requires `membros_ativos` plus the persistent staff-controlled source group `liderancas_aprov`.
- **Rationale:** Native CategoryGroup ACLs are OR-based, and current Discourse core plus bundled automation cannot safely express or reconcile the required intersection. A bounded Community-specific plugin is therefore authorized as the smallest provider-independent extension.
- **Consequences / open items:** The plugin owns only source-native-group to derived-native-group reconciliation, with fail-closed missing-source behavior, native group history, no custom tables/migrations/ACLs, source-event reconciliation and a 15-minute drift safety sweep. The plugin is packaged in the separate public repository `leo-even/CannLabs-Community-Qualified-Access`. Real verification, association onboarding, payment and production enablement remain separately unauthorized.
- **Supersedes:** Extends `DEC-026`, `DEC-028` and `DEC-029` with the qualified-access lifecycle boundary.

## DEC-031 — Verified professional identity is public-name plus result-only metadata

- **Date:** 2026-10-01
- **Status:** DECIDED — Task 20B, ratified by the official PM / Founder
- **Decision:** While verified, a professional has a non-empty public native `User.name`; username remains the handle; native professional role presentation may be shown. Community V1 retains only result-only metadata (name, profession, result, source class/URL, date, reviewer and optional short revocation reason). CRM, CRF, CREA, OAB and comparable identifiers, credential copies, CPF/RG, addresses and health data are not public or retained. Native User Notes are staff-readable operational notes, never credential evidence; admins control initial approval and revocation. Name changes require re-review, with no automation; self-service intake is deferred.
- **Rationale:** A bounded, reversible result-only record preserves the useful public identity and access decision while minimizing sensitive data and avoiding a credential repository.
- **Consequences / open items:** Task 21 may validate only a synthetic local create/present/revoke/delete lifecycle using native primitives. Production Legal / Privacy / Trust & Safety review, real verification, intake, association onboarding and deployment remain unauthorized.
- **Supersedes:** Refines the identity and verification boundary in `DEC-028` and Canon §22–24.

## DEC-032 — Active Membership Safety Boundary

- **Date:** 2026-10-02
- **Status:** DECIDED — official PM / Founder, Task 26
- **Decision:** CannLabs Community V1 is a closed, paid Community: normal discussion content requires membership in membros_ativos. General, Uncategorized and Site Feedback are normal Community spaces, not onboarding spaces, and are member-only. Every active member may use native reporting from day one regardless of Trust Level; reporting eligibility is based on membros_ativos, not generic TL0 or everyone access. Authenticated unpaid users do not gain ordinary reading or reporting access merely by logging in. The native equipe support path remains available to unpaid accounts under the existing support model. Trust levels remain independent native reputation and anti-abuse controls. No custom moderation code is required.
- **Rationale:** Align the paid/private access boundary and the reporting boundary with one auditable native membership signal while preserving staff support and native trust controls.
- **Consequences / open items:** General, Uncategorized and Site Feedback require native member-only ACL treatment. flag_post_allowed_groups must include membros_ativos while preserving legitimate staff/trust groups. Payment, onboarding, 2FA, production and provider configuration remain separately gated.
- **Supersedes:** Clarifies and operationalizes DEC-025, DEC-026, DEC-027 and Task 24 readiness findings.

## DEC-033 — Retire Seeded Site Feedback Scaffold

- **Date:** 2026-10-02
- **Status:** DECIDED — official PM / Founder, Task 26B
- **Decision:** The upstream seeded Site Feedback category and definition topic are scaffold only and are not a V1 product surface. Retire them only through a supported native Discourse lifecycle after the meta_category_id dependency and seed/reseed behavior are proven safe. Keep the native staff/moderator-notification support path for unpaid help and appeals. Any future feedback or governance surface requires a separate deliberate member-only product decision; no custom replacement or custom deletion code is authorized.
- **Rationale:** Remove seeded surface ambiguity without weakening the paid/private membership boundary or bypassing native lifecycle and seed behavior.
- **Consequences / open items:** Site Feedback remains pending safe native retirement; Task 26 is not validated until the paid/private boundary is closed. This decision refines only the Site Feedback portion of DEC-032 and does not reopen General, Uncategorized, Comunidade, reporting, moderation, PM, Chat, payment, onboarding, 2FA, production, or provider decisions.

## DEC-034 — Facebook login is reopened for consideration

- **Date:** 2026-10-02
- **Status:** OPEN / HYPOTHESIS — explicit Founder decision, relayed by the official PM and recorded in Task 30A
- **Decision:** Facebook login is no longer PARKED. It is reopened for consideration as an OPEN / HYPOTHESIS authentication option. It is not DECIDED and not part of V1. Local login, Google and Apple remain the DECIDED V1 authentication direction, and staff accounts still require native 2FA.
- **Rationale:** The Founder explicitly reopened the option. Facebook login is a core Discourse capability, so considering it needs no custom authentication infrastructure.
- **Consequences / open items:** Nothing is configured or enabled by this entry. Facebook stays disabled. Enabling any external provider first requires the external-provider acceptance tests recorded by the Task 30 readiness review (`02_PROJECT_STATE.md`). Making Facebook part of the product requires a new Decision Log entry.
- **Supersedes:** Only the "Facebook is parked" wording of the Task 12A V1 contract (`DEC-025`, Canon §22, `05_V1_PRODUCT_SPEC.md`). It reopens no other Task 12A decision.

## DEC-035 — Qualified Access is enabled in the production product profile

- **Date:** 2026-10-03
- **Status:** DECIDED — official PM, after the Task 37 Phase A readiness review
- **Decision:** The production product profile intentionally requires `cannlabs_qualified_access_enabled = true`. It is applied reproducibly through the product bootstrap (`config/cannlabs_community/bootstrap.yml`), never by a manual toggle. User Notes is unaffected: `user_notes_enabled` stays gated in production.
- **Rationale:** Restricted professional and association-leadership access is part of the V1 product model. A production-like proof must test the intended product, not a version with Qualified Access disabled.
- **Consequences / open items:** The production audit reports drift when the flag is off and apply repairs it through the native site-setting setter. The plugin stays pinned at `ca4f0070d7bf85e42dbfa7f8736469139bb20275`; its access model is unchanged. This does not authorize a production deployment, real memberships, real verification or payment.
- **Supersedes:** Only the "production enablement remains separately unauthorized" part of `DEC-030` for the plugin's enable flag. It does not change any other part of `DEC-030`.

## DEC-036 — Production-like theme installs use an immutable tag

- **Date:** 2026-10-03
- **Status:** DECIDED — official PM, after the Task 37 Phase A readiness review
- **Decision:** A production-like (and later production) theme install uses an immutable Git tag as its deployment ref, because the upstream theme importer installs a branch or tag, not an arbitrary commit. The tag must point exactly at the validated theme commit. Verification stays exact: the product bootstrap checks that the installed theme resolves to the pinned commit SHA, never to a tag name only. For Community Theme v0.1 the tag is `v0.1.0` → `aeb3a9d9154f532064dcc24ac9e78cf587588d77`.
- **Rationale:** A tag gives the deployment layer a stable, installable ref without weakening the exact-commit pin.
- **Consequences / open items:** Tags are never moved or overwritten; a new theme release gets a new tag and a manifest revision change.
- **Supersedes:** Extends the pinning rule of `DEC-024`; does not replace it.

## DEC-037 — The production-like deployment definition must install from empty storage

- **Date:** 2026-10-05
- **Status:** DECIDED — official PM, Task 37B validation
- **Decision:** The production-like deployment definition must install and rebuild from truly empty persistent storage, not only rebuild over existing persistent state. Its log hardening therefore creates the directories it protects instead of assuming they exist: `/var/log/nginx` (`www-data:www-data`, mode 0750) and `/shared/log/rails` (`discourse:www-data`, mode 0750), idempotently, before the existing fail-closed owner and mode guards. The validated definition is `/var/discourse/containers/cannlabs-prodlike.yml` with SHA-256 `89222f0af613aefacbbb26bac8c5f33c895aa7243eb70fca0eb4e7c64188065f`. The previous definition, SHA-256 `0eb16493d21536bc7e7add07abde8d83db170348898a71241610c122231d7885`, is SUPERSEDED and must not be used for a fresh install.
- **Rationale:** The first zero-state rebuild of Task 37B.2B failed on the old `chmod` of a log directory that the stock base image creates only after bootstrap, so a rebuild over existing state (Task 37B.1, Phase 18) had hidden a fresh-install defect. The corrected definition was then validated by a truly fresh install and a native restore.
- **Consequences / open items:** This validates the content of the definition, not its custody. Where the canonical definition lives is `OPEN — DURABLE DEPLOYMENT DEFINITION OWNERSHIP` (`03_BACKLOG_AND_OPEN_QUESTIONS.md`); machine-independent production deployment reproducibility cannot be claimed until it is resolved. This does not authorize a production deployment.
- **Supersedes:** The log-directory hardening step of the earlier definition (hash `0eb16493…`). Does not change `DEC-035` or `DEC-036`.

## DEC-038 — Native restore conventions for the production-like instance

- **Date:** 2026-10-05
- **Status:** DECIDED — official PM, Task 37B.2B validation
- **Decision:** A native Discourse restore of a CannLabs Community instance runs with `--no-disable-emails`. The stock restore otherwise changes `disable_emails` from `no` to `non-staff`. A restore is accepted only when `allow_restore` is back to `false`, read-only mode is off, `disable_emails` is `no`, and the product bootstrap audit passes.
- **Rationale:** Task 37B.2B restored a native backup into a truly fresh database cluster and proved these checks. Without the flag the restore silently changes outgoing-mail behaviour.
- **Consequences / open items:** Extra `remote_themes` rows (empty built-in Foundation and Horizon records) after a restore are an expected upstream seed side effect, not drift, and are not repaired. This does not select a backup retention, off-machine storage or schedule policy; those stay OPEN.
- **Supersedes:** —

## DEC-039 — Durable deployment definition ownership is the Community repository

- **Date:** 2026-10-05
- **Status:** DECIDED — official PM / Founder, Task 38 (option A)
- **Decision:** The CannLabs Community application repository owns the durable deployment definition, under `ops/discourse/`. The validated production-like definition is tracked there byte-identical (`cannlabs-prodlike.yml`, SHA-256 `89222f0af613aefacbbb26bac8c5f33c895aa7243eb70fca0eb4e7c64188065f`), named prodlike so it does not imply production, with an adjacent runbook. No separate operations repository, custom deployment generator or shared multi-environment template is created. Environment abstraction is deferred until real production configuration exists. Custom operations artifacts stay isolated under `ops/discourse/`; upstream `containers/`, `samples/`, `templates/` and the launcher are not modified. Real secrets are never tracked.
- **Rationale:** Make the validated truth durable first, with the lowest upstream-merge conflict, before any abstraction.
- **Consequences / open items:** `TRACKED DEPLOYMENT CANON — ESTABLISHED`. `MACHINE-INDEPENDENT DEPLOYMENT REPRODUCIBILITY — NOT YET VALIDATED`: it needs a fresh second host or distribution built only from tracked artifacts and documented values. The deployment's application pin is a known ancestor of the repository `HEAD`, never `HEAD` itself, because the definition lives in the history that records the pin. The delivery mechanism for real production secrets stays `OPEN — DELIVERY MECHANISM NOT YET DECIDED`. Production remains NOT READY.
- **Supersedes:** The `OPEN — DURABLE DEPLOYMENT DEFINITION OWNERSHIP` consequence recorded in `DEC-037` (custody is now decided). It does not change the validated content of `DEC-037` or `DEC-038`.

## DEC-040 — Fresh-host reproducibility is accepted only on an independent host, with a bounded scope

- **Date:** 2026-10-05
- **Status:** DECIDED — official PM, after the Task 38B readiness review (recorded in Task 38B.0)
- **Decision:** Final Task 38B acceptance runs on a genuinely fresh, isolated VM or a separate physical host, with an independent network namespace, Docker daemon, `/var/lib/docker` and filesystem, and no inherited Community state. A second WSL distribution on the same Windows host is not accepted, because the review showed that WSL distributions on one host share the relevant network namespace and listeners; a same-host rehearsal is optional and is not acceptance evidence. The current prodlike instance is never stopped or modified for it. The run proves a clean install and the product bootstrap from the tracked canon, and does not repeat backup, restore or the disaster-recovery proof (Task 37B.2B). It must use the native Uncategorized promotion lifecycle (condition-based, never forced and never a fixed sleep), exactly one synthetic human admin (`PRODLIKE ACCEPTANCE ONLY`), and a fail-closed ancestry preflight (`git merge-base --is-ancestor` of the application pin and the canon commit). The runbook is `ops/discourse/README.md`.
- **Rationale:** An independent host is the only way to prove that nothing was inherited from the prepared environment; the other points close the gaps the review found in the tracked runbook.
- **Consequences / open items:** `MACHINE-INDEPENDENT DEPLOYMENT REPRODUCIBILITY — NOT YET VALIDATED`. The success claim (`MACHINE-INDEPENDENT PRODUCTION-LIKE DEPLOYMENT REPRODUCIBILITY — VALIDATED`) needs a passing run on an independent host and does not imply production readiness, DNS or TLS, production secret delivery, external SMTP, production OAuth, billing, staff 2FA, Legal / LGPD / Trust & Safety readiness, a production first-admin process or restore on the second host. Executing it needs separate PM authorization. Production remains NOT READY.
- **Supersedes:** The "fresh second host or distribution" wording of `DEC-039` and the Task 38A next-validation note, which allowed a second distribution. It does not change `DEC-039`'s ownership decision.

## DEC-041 — Machine-independent production-like deployment reproducibility is validated

- **Date:** 2026-10-05
- **Status:** VALIDATED — official PM, Task 38B
- **Decision:** `MACHINE-INDEPENDENT PRODUCTION-LIKE DEPLOYMENT REPRODUCIBILITY — VALIDATED`. An independent Google Compute Engine VM, with its own kernel and network namespace, its own Docker daemon, fresh Docker state and a fresh filesystem, reconstructed the production-like Community using only the tracked Community canon at commit `d1981640e414d215f2d6fea7a182cd1bf6d1e5e9`, exact public Git pins and tags, public package and image sources, and documented non-secret environment values. It reproduced the application, Qualified Access, theme and `discourse_docker` pins, the nginx and logging hardening, fresh-install behaviour, the native Uncategorized lifecycle, the final bootstrap `PASS (pass 36, drift 0, blocked 0, gated 1)` and an idempotent second apply, on a PostgreSQL cluster (`7693236165663342641`) that differs from every Task 37 cluster.
- **Boundary:** the claim covers the production-like deployment only. It does not repeat backup and restore (Task 37B.2B) or the full Phase 15 logging matrix: the independent-host sentinel is bounded deployment evidence, and the fresh Logster store held no messages, so its store-content check was vacuous. It is not production readiness and validates none of: real DNS, TLS or edge, production secret delivery, external SMTP, production Google or Apple OAuth, billing or membership, real staff 2FA readiness, a production first-admin process, an off-machine backup retention policy, Legal / LGPD, Trust & Safety, or the final launch security and privacy sweep.
- **Rationale:** `DEC-040` required an independent host and a bounded scope; the run met both and passed every gate.
- **Consequences / open items:** Production remains NOT READY. The runbook's description of the native Uncategorized promotion was corrected: its gates are a human admin, a site older than about one hour and the scheduler running, and `allow_uncategorized_topics` is not a prerequisite. A changed deployment definition needs a new validation under the same isolation and scope rules. The independent host and its Google Cloud project were deleted after the evidence was verified; the local evidence directory is retained as `RETAINED — TASK 38B ACCEPTANCE EVIDENCE`.
- **Supersedes:** The `MACHINE-INDEPENDENT DEPLOYMENT REPRODUCIBILITY — NOT YET VALIDATED` status recorded in `DEC-039` and `DEC-040`. It does not change `DEC-040`'s isolation and scope rules, which remain the standard for any re-validation.

## DEC-042 — Production secrets are delivered through one root-only host file

- **Date:** 2026-10-05
- **Status:** DECIDED — official PM, Task 40A
- **Decision:** Real production secrets reach the Community container only through one root-only host file (`/etc/cannlabs-community/production.env`, mode `0600`, root-owned, in a `0700` directory, outside every checkout and outside `/shared`), passed to the pinned `discourse_docker` launcher with its native `docker_args: --env-file` option. The tracked production definition names the file by path only and carries no secret name in its `env:` block. `DISCOURSE_SECRET_KEY_BASE` is supplied externally and pinned (128 lowercase hex characters); rotating it ends every session and is done only deliberately. A secret that cannot travel by environment (`apple_pem`, multi-line) is a DB-stored site setting set through a Rails runner and never through the admin UI. Rotation uses `./launcher rebuild`, followed by the removal of the superseded images by ID. `DISCOURSE_DEVELOPER_EMAILS` is forbidden in every production deployment artifact. The contract is `ops/discourse/SECRETS.md`; a spec (`spec/lib/cannlabs_community/production_secrets_contract_spec.rb`) guards the tracked artifacts.
- **Rationale:** The two other supported ways to inject secrets, an untracked secrets-only template under `templates:` and a full untracked YAML with secrets in `env:`, both print every secret through the launcher's `set -x` trace on `start` and `rebuild` and show it in the process arguments of the bootstrap `docker run`. The env-file route leaked nothing into launcher output or `ps` across four rebuilds, a restart, a destroy and start, and `start-cmd`, using fake secrets on a disposable local instance.
- **Consequences / open items:** Known and accepted exposure: the secrets are present in the container environment, `docker inspect` of the container and the image configuration (not its layers), and `discourse.conf`, so host root or `docker` group access is the trust boundary and the image must never be pushed or shared. Env-delivered secrets are absent from the app database and from native backups; DB-stored ones (such as `apple_pem`) are present in both, so backups are treated as secret-bearing. `launcher restart` does not rotate a secret; a rebuild does. Not proven: real S3, Google or Apple flows, a multi-line or escaped `apple_pem` through the plugin, and removing a key from the file. This chooses no hostname, provider, region, TLS shape or VM size, and creates no production infrastructure.
- **Supersedes:** The `OPEN — DELIVERY MECHANISM NOT YET DECIDED` status recorded in `DEC-039`'s consequences and in `ops/discourse/README.md`.

## DEC-043 — Ordinary signup, Apple and V1 moderation are decided (current-state record)

- **Date:** 2026-10-05
- **Status:** DECIDED — official Founder decisions relayed by the official PM, recorded in Task 40A
- **Decision:** (1) Ordinary individual registration does not require manual approval; `invite_only` and `must_approve_users` are not the ordinary-member V1 model. The open item is the anti-spam mechanism for open registration, not the approval policy. (2) Sign in with Apple remains DECIDED for V1 (`DEC-025`), even though its production configuration is incomplete. (3) V1 moderation is CannLabs staff, native flags and native trust and moderation mechanisms; category moderators remain PARKED.
- **Rationale:** The Task 39A production-readiness review listed these as open product decisions. They are already decided; recording them durably keeps them from being re-asked.
- **Consequences / open items:** Facebook stays OPEN / HYPOTHESIS (`DEC-034`). The anti-spam mechanism (for example the bundled captcha plugin, new-user approval settings or watched words) is OPEN and needs no Founder decision on approval. Nothing is configured by this entry.
- **Supersedes:** The "HYPOTHESIS (V1)" wording of `00_PRODUCT_CANON.md` §18 for the moderation model. It changes none of `DEC-025`, `DEC-032` or `DEC-034`.

## DEC-044 — Production first admin and staff 2FA procedure

- **Date:** 2026-10-05
- **Status:** DECIDED — official PM direction, Task 40B. The procedure is VALIDATED locally and awaits official PM validation. Production enrollment is OPEN.
- **Decision:** (1) The first production administrator is created with the upstream `bin/rake admin:create`, run by an operator with host access on an interactive terminal, with the account holder typing the password at the no-echo prompt (at least 20 random characters: the task does not enforce the admin minimum of 15). `DISCOURSE_DEVELOPER_EMAILS` (`DEC-042`), `/finish-installation`, `rake admin:invite`, `RANDOM_PASSWORD=1` and any script that sets a password are not used. (2) Production has exactly two standing human administrators before any real-member beta, each with their own authenticator and recovery codes. There is no shared account, no standing bypass account and no third standing administrator. (3) Native staff 2FA is mandatory. Each administrator enrolls TOTP and recovery codes first, and only then is `enforce_second_factor` set to `staff`; later staff enroll as ordinary members before they are promoted. The read-only audit in `ops/discourse/STAFF_SECURITY.md` is the invariant check. (4) Staff hold no API keys by default; a machine key needs a written purpose, a named owner, the minimum scope and a review date. (5) Break-glass prefers a peer administrator through the admin UI (audited); root `rake users:disable_2fa[<username>]` is the fallback; the sessions are closed, the person re-enrolls with a new authenticator and new recovery codes in the same session, and enforcement is never changed. (6) The admin IP allowlist stays off in V1 unless a stable trusted egress path exists.
- **Rationale:** Rehearsed on a disposable local instance with synthetic identities (Task 40B). The password never reached terminal output, any process argument list, the database (a hash only), the logs or mail. `/finish-installation` cannot create anyone without the forbidden variable. `enforce_second_factor` only redirects browser navigation: an unenrolled admin's JSON session, and any API key, still worked, so the protection is the invariant "no staff without 2FA", checked by the audit. Two administrators give an audited peer recovery path; the root path is simpler but leaves no staff-log row and sends no email.
- **Consequences / open items:** `PRODUCTION FIRST-ADMIN + STAFF SECURITY READINESS — VALIDATED` means procedure readiness only. `OPEN — PRODUCTION ENROLLMENT NOT DONE`: no real host exists and no real staff account is enrolled. The first administrator is protected by a password alone between creation and enrollment, so those steps belong before public ingress (a host-slice constraint). Upstream does not stop a promotion without 2FA, so enroll-before-promote is procedural. `rake admin:create` and `users:disable_2fa` write no staff-action-log row; the operations record is their audit trail. OPEN for PM arbitration, with no change made: tightening `allow_user_api_key_scopes` and `user_api_key_allowed_groups`, and the `allow_impersonation` default. Not proven: security keys and passkeys (the Task 32 local-origin issue remains), real SMTP, and any proxy, Cloudflare or TLS behavior.
- **Supersedes:** The "staff 2FA production rollout" wording of `03_BACKLOG_AND_OPEN_QUESTIONS.md` for procedure only; the rollout itself stays open.
