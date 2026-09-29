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
