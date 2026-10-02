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
