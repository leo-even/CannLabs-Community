---
name: community-feature-planning
description: Use when the Founder or the official PM brings a CannLabs Community product idea or feature request that must become a bounded, implementation-ready slice. Produces a PROPOSED slice brief — problem, decided vs open items, upstream/reuse review, recommended smallest solution, scope, contracts, acceptance criteria and implementation layer — for official PM approval, and stops before implementation. Not for implementing and not for generating designs.
---

# CannLabs Community — Feature Planning

Turns an idea into one bounded, proposed slice without letting anyone invent product. Run by the PM Companion, or by another agent the official PM designates.

## Authority

- Community operating contract: `.skills/community-repo-audit/references/operating-contract.md`.
- Product truth: `docs/cannlabs-community/00_PRODUCT_CANON.md`, `01_DECISION_LOG.md`, `02_PROJECT_STATE.md`, `03_BACKLOG_AND_OPEN_QUESTIONS.md`.
- Technical mechanics: the upstream `discourse-*` skills (for example `discourse-site-settings`, `discourse-acl-authoring`, `discourse-admin-ui`, `discourse-service-authoring`, `discourse-migration`). Reference them; do not restate them.

## Inputs

- The idea, as stated by the Founder or the official PM.
- Current repository evidence: run `community-repo-audit` first.

## Procedure

1. Read the Product Canon, Decision Log and Project State. Check the NOT AUTHORIZED list and the idea's backlog status.
2. State the user and the problem, one short paragraph each. No solution yet.
3. Classify every relevant statement as DECIDED, HYPOTHESIS, OPEN or PARKED, citing the canon section or decision ID. Anything not DECIDED is not a requirement. New Founder statements are routed to the official PM; never classify them as DECIDED yourself.
4. Inspect the current Community implementation: what already exists in this fork.
5. Upstream / reuse review in the order of contract §8. For each candidate, record evidence (file path, setting or plugin name) and why it fits or does not. Temporary `community-explore` specialists may help, read-only.
6. Recommend the smallest valid solution that satisfies the DECIDED contract.
7. Write the slice brief:
   - in scope, out of scope, non-goals;
   - proposed UX / product contract;
   - permission and privacy implications (groups, Guardian, category access, personal or sensitive data);
   - cannabis / trust boundary check;
   - validation contract and acceptance criteria, including real-app checks on port 3100;
   - risks;
   - unresolved decisions, each routed to the official PM.
8. Declare the implementation layer using the ladder in contract §8. Core modification only with explicit official PM approval and a stated reason why every lower layer fails.

## Output

One slice brief with the sections above, plus the evidence list, the unresolved decisions, and the recommended writer and file scope. Status: **PROPOSED — awaiting official PM approval**. Readiness: either ready for PM approval or blocked on the listed decisions. The brief is returned to the official PM; writing it into the repository needs writer authorization.

## Hard non-goals

- "Build the whole feature family": split it and plan one slice.
- Speculative future-proofing.
- Silent business-rule invention: every rule traces to a DECIDED item or is listed as unresolved.
- Copying abstractions, schemas or rules from FeedCheck or any other product.
- Promoting HYPOTHESIS or PARKED items into scope.

## STOP

Stop at the brief. Two separate official PM gates follow: approval of the brief, then authorization of a writer. Implementation never starts from the brief alone.
