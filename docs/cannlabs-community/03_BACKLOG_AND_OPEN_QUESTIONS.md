# CannLabs Community — Backlog and Open Questions

Status: CURRENT
Date: 2026-09-29

> **Backlog ≠ authorization.** Listing an item here does not authorize it. Work starts only through an explicitly authorized slice from the official PM.

Buckets: **NOW** · **NEXT** · **LATER** · **PARKED** · **OPEN**. States are defined in `README.md`; canon references (`§N`) point to `00_PRODUCT_CANON.md`.

## NOW

The current phase is foundation work only. Its sequence is in `02_PROJECT_STATE.md` → NEXT.

- durable product baseline (this directory);
- operating model / agents / skills foundation;
- Discourse capability discovery;
- Design System compatibility;
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

## Design — NEXT (design discovery)

Open questions from Design Director research. The Design Director owns the exploration; this file does not answer them.

- Is Community primarily "Arquivo", "Estufa", or does it need a distinct visual register?
- A Foundation-derived custom theme or a Horizon-derived approach?
- The exact dark-mode contract vs the CannLabs "deep" surface?
- Typography adaptation.
- The avatar exception.
- Emoji / reactions policy in product content vs UI chrome.
- Theme repository location.
- Category visual grammar.

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
