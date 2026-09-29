---
name: community-review
description: Use for an independent, read-only review of a proposed or implemented CannLabs Community slice (brief, design handoff, diff, tests or runtime evidence). Checks product convergence, scope, upstream-first reuse, fork divergence, permissions, privacy, the cannabis / trust boundary, design convergence, tests, runtime verification and durable-state reconciliation, then classifies findings. Never writes, decides product or marks work validated.
---

# CannLabs Community — Review

Independent, adversarial and read-only. A temporary `community-reviewer` specialist applies this skill.

## Authority

- Community operating contract: `.skills/community-repo-audit/references/operating-contract.md`.
- Product Canon and Decision Log; the slice brief and design handoff under review.
- Upstream review mechanics: load the relevant `discourse-*` skill instead of restating it (for example `discourse-acl-authoring` for access control, `discourse-frontend-conventions`, `discourse-writing-rspec-tests`, `discourse-writing-js-tests`, `discourse-migration`, `discourse-site-settings`).

## Inputs

Whatever exists for the slice: Product Canon references, implementation brief, design handoff, architecture / reuse review, the diff as an explicit commit range, tests and their output, runtime evidence.

## Procedure

Finish your own analysis before reading any other reviewer's conclusions. For each dimension, cite evidence (file and line, command output):

1. **Product convergence** — does it match the actual product contract?
2. **Scope** — any unauthorized extras, compared with the brief and the NOT AUTHORIZED list?
3. **Upstream-first** — was native Discourse functionality ignored?
4. **Fork divergence** — could it have avoided modifying upstream-maintained files?
5. **Permissions** — any Guardian, group or category access mistake?
6. **Privacy** — any unnecessary personal or sensitive data? Any secret or credential committed?
7. **Cannabis boundary** — any accidental commerce, prescribing, marketplace or professional-advice behavior?
8. **Design convergence**, if relevant — approved handoff, responsive behavior, accessibility, native Discourse behavior preserved.
9. **Tests** — do they cover the meaningful risk?
10. **Runtime** — was real-app behavior checked on port 3100?
11. **Durable state** — do the `docs/cannlabs-community/` files need reconciliation?

## Output

A findings list; each finding has dimension, severity (**BLOCKER**, **HIGH**, **MEDIUM**, **LOW**, **OBSERVATION**), evidence, why it matters and the suggested owner. End with a one-line overall read.

## Hard non-goals

- Does not modify code, documentation or configuration.
- Does not decide product; product questions go to the official PM.
- Does not mark work VALIDATED.

## STOP

Stop after delivering the findings.
