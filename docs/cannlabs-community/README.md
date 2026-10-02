# CannLabs Community — Product Documentation

Status: CURRENT · Baseline date: 2026-09-29 · Inventory reconciled: 2026-10-02

This directory holds the durable, Community-specific product truth for CannLabs Community. It exists so that PM, Coder and Design Director sessions start from written, ratified state instead of reconstructing the product from chat history.

## Product separation

> **CannLabs Community is a separate product and application.** It is not part of FeedCheck, CannLabs Traceability or any other CannLabs product, and it shares no state with them.

| Dimension | Rule |
| --- | --- |
| Repository | Only Community-owned repositories, never shared with another CannLabs product. `leo-even/CannLabs-Community`, a fork of `discourse/discourse`, is the authoritative application repository. The dedicated theme repository `leo-even/CannLabs-Community-Theme` is allowed as an implementation artifact owned exclusively by Community (`DEC-024`). The dedicated plugin repository `leo-even/CannLabs-Community-Qualified-Access` is the one authorized bounded custom plugin, also owned exclusively by Community (`DEC-030`). |
| Code | Never copied from another CannLabs product. |
| Database | Its own. Never shared with, copied from or restored from another product. |
| Deploy | Its own. Nothing inherited from another product. |
| Product canon | Only the files in this directory. |
| Implementation history | Only Community-owned repositories and their validated slices. |

The existing CannLabs Design System may be adapted for Community later (Product Canon §19). Adapting a visual foundation does not merge applications.

## Authority order

When sources disagree, the higher item wins:

1. Explicit, current Founder decision.
2. Latest ratified Product Canon and Decision Log.
3. Current Project State.
4. Approved current specs, design and architecture.
5. Validated implementation evidence.
6. Current code and tests.
7. Historical artifacts.

Also:

- Project Instructions override the Generic Source Pack where they conflict.
- Upstream Discourse documentation and code remain the authority for upstream behavior.
- Community-specific product truth lives in this directory, not in chat transcripts.
- History is provenance, not competing truth.

## Files

| File | Purpose |
| --- | --- |
| `00_PRODUCT_CANON.md` | What the product is and is not: thesis, audiences, boundaries and product laws, each marked with an explicit state. |
| `01_DECISION_LOG.md` | Dated, append-only record of ratified decisions (`DEC-NNN`) with rationale, consequences and supersession. |
| `02_PROJECT_STATE.md` | Where the project is now: validated milestones, completed discovery, active work, what is not authorized, runtime notes, environment follow-ups and next steps. |
| `03_BACKLOG_AND_OPEN_QUESTIONS.md` | Candidate work and unresolved questions, grouped as NOW / NEXT / LATER / PARKED / OPEN. Backlog is not authorization. |
| `04_DISCOVERY_BASELINE.md` | Dated snapshot of verified engineering and design discoveries. Re-verify against current upstream before implementation. |
| `05_V1_PRODUCT_SPEC.md` | The concise V1 product contract and the validated closure of each access, identity and moderation slice. Canon and Decision Log win when wording differs. |
| `06_MODERATION_TRUST_SAFETY_DRAFT.md` | HYPOTHESIS / internal draft of the native moderation operating model. Not canon and not production-approved. |
| `07_PRODUCTION_SECURITY_FOUNDATION_READINESS.md` | Validated readiness review (Task 27): production is not ready; the bootstrap gap, open gates and recommended direction. |

Each file header carries a document status: `CURRENT` files are maintained as the project moves; `SNAPSHOT` files are dated evidence that is not updated in place and must be re-verified before use.

## State vocabulary

| State | Meaning |
| --- | --- |
| DECIDED | Explicit, durable Founder/PM choice. Changing it requires a new Decision Log entry. |
| VALIDATED | Delivered and accepted by the official PM on evidence. |
| HYPOTHESIS | Plausible direction, not decided. Never implement it as if it were decided. |
| OPEN | A question that must be answered before dependent work. |
| PARKED | Deliberately deferred. Out of scope until explicitly reactivated. |
| SUPERSEDED | Replaced by a newer decision or state. Kept only as provenance. |

## Documentation law

- Canon is not a transcript. Record outcomes, not conversations.
- Never silently promote brainstorming into requirements. "We could…" stays HYPOTHESIS, "maybe later…" becomes PARKED, and only an explicit durable choice becomes DECIDED.
- When wording is ambiguous, keep it HYPOTHESIS or OPEN.
- Backlog items and discovery findings never authorize implementation by themselves.
- Change a decision by adding a new Decision Log entry that supersedes the old one. Do not rewrite history.

## Permanent operating law

**UPSTREAM-FIRST · REUSE BEFORE CUSTOM.** Before building anything, inspect the current Community implementation, Discourse core, bundled/official plugins, site settings, group/permission/moderation primitives, supported APIs, plugin APIs, plugin outlets, transformers and theme mechanisms. Only then consider custom infrastructure. See Product Canon §20 and `DEC-003`.
