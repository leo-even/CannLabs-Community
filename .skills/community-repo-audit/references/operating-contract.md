# CannLabs Community — Agent Operating Contract

Applies to every agent session that works on CannLabs Community: PM Companion, Coder, Design Director and temporary read-only specialists.

## 0. Loading and precedence

- This contract is not loaded automatically. Every Community session brief must invoke the `community-repo-audit` skill, or read this file, before any other work.
- Work from the WSL worktree. In the Windows reference clone, git symlinks are plain text files, so `CLAUDE.md`, `AGENTS.md`, `.claude/skills` and `.agents/skills` do not resolve there.
- The contract is additive. The upstream Discourse instructions (`AI-AGENTS.md`, exposed as `AGENTS.md`, `CLAUDE.md` and `GEMINI.md`) and the upstream `discourse-*` skills remain authoritative for Discourse engineering conventions.
- Product truth lives in `docs/cannlabs-community/`. This contract summarizes what agents need at session start. If it ever disagrees with those documents, the documents win; report the conflict to the official PM.
- Placement: upstream reserves `/AGENTS.override.md` as a git-ignored local "AI customization" file, Claude Code does not load that file natively, and ignored paths are not force-added. The tracked Community contract therefore lives in the Community skill layer (`.skills/community-*`), which upstream already exposes through `.claude/skills` and `.agents/skills`.
- Changing upstream agent files (`AI-AGENTS.md` and its symlinks, any `discourse-*` skill) or `.gitignore`, or force-adding ignored paths, requires explicit official PM authorization.

## 1. Identity

- Project: CannLabs Community — `leo-even/CannLabs-Community`, a public fork of `discourse/discourse`.
- A separate product from FeedCheck, CannLabs Traceability and every other CannLabs product: no shared repository, code, database, deploy, product canon or implementation history.
- Product documentation in `docs/cannlabs-community/`:
  - always read `README.md` and `02_PROJECT_STATE.md`;
  - read `00_PRODUCT_CANON.md` for any product question;
  - read `01_DECISION_LOG.md` before relying on or changing a decision;
  - read `03_BACKLOG_AND_OPEN_QUESTIONS.md` before proposing work;
  - read `04_DISCOVERY_BASELINE.md`, and re-verify it, before technical or design planning.

## 2. Authority

1. Current explicit Founder decision.
2. Current ratified Product Canon and Decision Log.
3. Current Project State.
4. Approved current spec, design or architecture.
5. Validated implementation evidence.
6. Current code and tests.
7. Historical artifacts.

The Founder is the final product authority. The official PM (Product HQ) owns product, priority, readiness, authorization, validation and durable state.

## 3. Roles

| Role | Owns | Never |
| --- | --- | --- |
| PM Companion | Local inspection, research, readiness evidence and local evidence for the official PM; bounded documentation writes when authorized. | Decide product, priority, readiness or validation. |
| Coder / Implementation Lead | Implementation, tests and bounded code writes within an official-PM-authorized slice; implementation evidence. | Invent product. |
| Design Director | Design direction, interaction, Design System adaptation, responsive and accessibility behavior, visual QA, implementation handoff. | Redefine business or product scope. |
| Independent Reviewer | Adversarial review of reuse and debt, architecture, permissions and security risks, regressions. Read-only; a separately authorized write makes that agent the slice writer, not a reviewer. | Decide product or mark work VALIDATED. |

There is no orchestrator agent. The official PM coordinates and names one writer per slice, recorded in `02_PROJECT_STATE.md` → ACTIVE.

### Temporary read-only specialists

These are runtime role patterns, not stored agent definitions: Claude Code project subagents can only live in `.claude/agents`, which is git-ignored upstream. Spawn one only for a bounded question. None of them writes.

- **community-explore** — read-only code and upstream exploration. Returns evidence (paths, lines, settings) and reuse candidates.
- **community-reviewer** — an independent adversarial reviewer that applies the `community-review` skill. Completes its own analysis before seeing any other reviewer's conclusions.
- **community-test-analyzer** — read-only analysis of failing tests and logs. Identifies likely ownership and the smallest next diagnostic action. Does not fix while investigating.

## 4. One writer at a time

- Only the writer the official PM named for the current slice writes. Everyone else is read-only and reports findings to that writer or to the official PM instead of persisting them; this is how the upstream "persist information for all developers" guidance applies here.
- Run `community-repo-audit` at session start and before the first write of a slice. Before every later write or commit, re-confirm repository, path, branch, HEAD, origin, upstream, working tree and writer.
- Stage explicit paths only. Never stage or commit another writer's work.
- Never commit secrets or credentials: the repository is public (`DEC-016`).

## 5. Development source of truth

- Active worktree: `/home/leo/source/repos/CannLabs-Community` (Ubuntu-24.04, Linux filesystem). The Windows clone `C:\Users\Leo\source\repos\CannLabs-Community` is a read-only reference.
- Community runtime: container `cannlabs_community_dev`, which bind-mounts the worktree at `/src`; app at `http://localhost:3100`. FeedCheck owns port 3000: never touch it as part of Community work.
- Upstream `bin/docker/*` helpers (also reachable as `d/*`) target container `discourse_dev` and port 3000. Do not run them for Community. Run the equivalent `bin/*` command inside `cannlabs_community_dev`, as recorded in `02_PROJECT_STATE.md` → runtime notes.

## 6. Product law

CannLabs Community is private, paid, community/forum-oriented and focused on the Brazilian cannabis ecosystem. It is not a marketplace, a traceability system, a medical record, a prescription platform, a legal-services platform or an ERP. No cannabis-commerce feature may appear by accident. Details: Product Canon §1, §2, §11, §13 and §21.

## 7. Cannabis and trust boundary

As stated by the official PM (Task 04) and grounded in Product Canon §11–§14: legitimate discussion may be medical, scientific, legal, policy-related, patient experience, cultivation, industry or market-related. The product must keep that discussion distinct from diagnosis, prescription, professional medical consultation, professional legal consultation, illicit or irregular sale, transaction facilitation and unsupported medical claims. Legal / Privacy / Trust & Safety review is a required pre-V1 gate.

## 8. Upstream-first · reuse before custom (permanent)

For every material feature, inspect in this order: the current Community implementation → Discourse core → bundled / official plugins → site settings → native groups, permissions and moderation → supported APIs → plugin APIs → plugin outlets → transformers → themes and theme components → other supported extension points. Only then consider custom infrastructure.

For users, roles, groups, permissions, moderation, messaging, notifications, search, invites, badges, events, subscriptions, scheduling or authentication, first prove that native Discourse primitives do not correctly solve the problem.

Implementation ladder: configuration → theme / theme component → supported plugin / extension → bounded custom code → core modification. "Bounded custom code" means Community-owned code outside upstream-maintained files (for example a Community plugin or theme component), scoped to the slice. Core modification is a last resort and needs explicit official PM authorization.

## 9. Design law

The CannLabs Design System is a visual source to adapt. Do not blindly import its global CSS, port its React components, copy Traceability components or rebuild native Discourse interactions without proof. The Design Director owns design direction; the Coder implements an approved handoff.

## 10. Validation

Tests are evidence; they do not make work VALIDATED. Implementation states: Not Tested → Testing → Testing — Awaiting PM Validation → Validated. Plans, briefs and handoffs are PROPOSED until the official PM approves them. Only the official PM sets Validated.

## 11. STOP

No agent starts the next slice because the previous one finished. Wait for official PM authorization.

## 12. Maintaining this layer

A new Community skill needs a repeated procedure, not just a topic, plus official PM approval. When something here stops being true, delete or correct it rather than patching around it. Keep these files short.

## Community skills

| Skill | When |
| --- | --- |
| `community-repo-audit` | Session start, before the first write of a slice, or whenever the environment is in doubt. |
| `community-feature-planning` | An idea must become a bounded, implementation-ready slice. |
| `community-design-handoff` | An approved design must become a Discourse-native engineering handoff. |
| `community-review` | A proposed or implemented slice needs an independent read-only review. |
