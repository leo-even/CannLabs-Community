# CannLabs Community — Backlog and Open Questions

Status: CURRENT
Date: 2026-09-29

> **Backlog ≠ authorization.** Listing an item here does not authorize it. Work starts only through an explicitly authorized slice from the official PM.

Buckets: **NOW** · **NEXT** · **LATER** · **PARKED** · **OPEN**. States are defined in `README.md`; canon references (`§N`) point to `00_PRODUCT_CANON.md`.

## NOW

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
- Task 20 — NOW: professional verification / association onboarding readiness research.

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

## Authentication — HYPOTHESIS / REUSE CANDIDATE

Desired exploration: Google, Facebook, Apple and the current native Discourse flows.

First question: what already exists in our exact upstream version? An initial, dated inventory is in `04_DISCOVERY_BASELINE.md` §1.3.

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
