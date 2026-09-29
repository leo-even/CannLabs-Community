---
name: community-design-handoff
description: Use when an APPROVED Design Director result for CannLabs Community must be translated into an engineering-ready, Discourse-native handoff for the Coder. Maps the approved design to reuse / adapt / keep-native / avoid decisions, tokens, states, responsive, light/dark and accessibility requirements, and the exact supported Discourse implementation layer. Not a design-generation skill.
---

# CannLabs Community — Design Handoff

Translates an approved design into something the Coder can implement without rebuilding Discourse.

## Authority

- Community operating contract, especially the design law (§9) and the implementation ladder (§8): `.skills/community-repo-audit/references/operating-contract.md`.
- Product Canon §19 and `docs/cannlabs-community/04_DISCOVERY_BASELINE.md` §2 (dated design discovery; re-verify before use).
- Upstream mechanics: `discourse-writing-html-css` (BEM, color palette, theming, dark mode, responsive layout, CSS repair), `discourse-frontend-conventions`, `discourse-screenshots` (Foundation / Horizon × light / dark captures) and the test skills for theme tests; string and copy conventions come from `AI-AGENTS.md`. Reference them; do not restate them.

## Inputs (required)

- The approved design direction or artifact, and who approved it. Without Design Director approval, STOP.
- The approved slice brief it serves (from `community-feature-planning`).

## Procedure

1. Confirm the approval and the slice it belongs to.
2. List the target user flow and surfaces.
3. Classify each surface: direct reuse, adapt, keep Discourse native, or avoid. Start from the discovery baseline map and re-verify it.
4. Specify tokens (color, spacing, radius, elevation), typography, spacing, responsive behavior (breakpoints, touch targets), light / dark behavior, accessibility (contrast, focus, keyboard, semantics, reduced motion), states (empty, loading, error, disabled, hover, focus, active), interaction behavior and copy requirements.
5. Choose the exact supported implementation layer following contract §8, in design terms: theme settings and color schemes, then theme or theme-component CSS on Discourse custom properties, then named plugin outlets, transformers or plugin API calls, then bounded plugin code. Avoid core template overrides; any exception needs explicit official PM approval.
6. Define QA surfaces and the desktop / mobile × light / dark validation matrix.
7. List non-goals.
8. Obtain Design Director signoff on the handoff.

## Output

A handoff with these sections: target flow / surface; approved artifact / source; direct reuse; adapt; keep Discourse native; avoid; tokens; typography; spacing; responsive behavior; light / dark behavior; accessibility; states; interaction behavior; copy requirements; implementation layer (outlets, transformers, theme settings); QA surfaces; desktop / mobile validation; non-goals; Design Director signoff.

## Hard non-goals

- Nothing beyond the approved slice brief.
- Do not generate new design direction here.
- Do not import the Design System global CSS.
- Do not port React components blindly.
- Do not rebuild the Discourse header, sidebar, topic stream or composer without proven need.
- Do not introduce Traceability UI.
- Prefer tokens and supported theme APIs; minimize `!important`; avoid core template overrides.
- Treat accessibility regressions as blockers.

## STOP

Stop at the signed-off handoff. The Coder implements only after a separate writer authorization from the official PM.
