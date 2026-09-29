# CannLabs Community — Backlog and Open Questions

Status: CURRENT
Date: 2026-09-29

> **Backlog ≠ authorization.** Listing an item here does not authorize it. Work starts only through an explicitly authorized slice from the official PM.

Buckets: **NOW** · **NEXT** · **LATER** · **PARKED** · **OPEN**. States are defined in `README.md`; canon references (`§N`) point to `00_PRODUCT_CANON.md`.

## NOW

The current phase is foundation work only. Its sequence is in `02_PROJECT_STATE.md` → NEXT.

- durable product baseline (this directory) — VALIDATED (Tasks 03 / 03A);
- operating model / agents / skills foundation — VALIDATED (Task 04);
- Design System compatibility — design direction VALIDATED (Task 05); the static visual prototype is next (see Design below);
- Discourse capability discovery;
- V1 product specification and readiness.

No product feature implementation.

## NEXT — V1 discovery

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

## Verified professional roles — OPEN

Current product thesis: physician, pharmacist, agronomist, lawyer (`DEC-009`).

Open questions:

- authoritative verification source;
- data needed;
- manual vs automated verification;
- reverification;
- expiry;
- badge semantics;
- privacy and retention.

## Association model — HYPOTHESIS / OPEN

Possible elements: verified association; representatives; institutional profile; multiple seats; restricted access.

Open questions: verification; seats; pricing; representative management; permissions.

## Company / organization model — HYPOTHESIS / OPEN

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

## Direct messages / chat — PARKED (Legal + Trust & Safety review)

- Should member-to-member personal messages be disabled in V1?
- Should native Chat be disabled?
- What support / moderation contact remains?
- What are the moderation and privacy expectations?
- How do we reduce prohibited-transaction risk?

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

Task 05 decided the register, structural base, list-over-cards law, avatar exception and pt-BR direction (`DEC-018` to `DEC-020`).

**Design-ready (pending official PM activation):** a static / non-persistent visual prototype of the shell and topic list — header, sidebar, mobile drawer, `/latest` and `/categories`, light and dark, desktop and mobile (`DEC-021`). No theme install, database colour schemes, active-theme change, site-setting change or persisted runtime state.

**OPEN — Theme packaging architecture:** a separate Community theme repository, a Community-owned additive location in the fork, or bounded theme components where appropriate. Engineering / architecture review follows the prototype evidence.

Design Director questions still to settle through the prototype and later design slices:

- the exact Community dark-mode contract (`deep` is not dark mode);
- typography adaptation details;
- emoji / reactions policy in product content vs UI chrome;
- category visual grammar.

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
