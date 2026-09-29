# CannLabs Community — Project State

Status: CURRENT
Date: 2026-09-29

Evidence was captured from the development machine when this baseline was written (2026-09-29).

## VALIDATED

### Repository bootstrap — VALIDATED

- Public, true GitHub fork `leo-even/CannLabs-Community` of `discourse/discourse`; default branch `main`.
- Remotes: `origin` = `https://github.com/leo-even/CannLabs-Community.git`; `upstream` = `https://github.com/discourse/discourse.git`.
- Isolated from FeedCheck, CannLabs Traceability and every other CannLabs product.

### Vanilla Discourse local start — VALIDATED

- Started with the official Discourse development image and upstream workflow, with no customization.
- Fresh, isolated database containing only upstream default data.

### Authoritative WSL development worktree — VALIDATED (Task 02)

- Active worktree: `/home/leo/source/repos/CannLabs-Community` (Ubuntu-24.04, ext4, not under `/mnt/c`).
- Community runtime: `http://localhost:3100`.
- FeedCheck, a separate product: `http://localhost:3000`.
- Upstream base when this baseline was written: `d8d59f720e4d9a2687a94984ed1c927f1ebd4933` ("FEATURE: Allow admins to test CAPTCHA keys (#44178)"). It was equal to `origin/main` and `upstream/main` before the commit that adds this directory.

### Durable product baseline — VALIDATED (Task 03 and 03A)

- `docs/cannlabs-community/` baseline (commit `e02f6d4c`) and its factual corrections (commit `0fcdc9bd`).

### Community agent/skill operating layer — VALIDATED (Task 04)

- Four Community-specific additive skills exist beside the upstream ones: `community-repo-audit`, `community-feature-planning`, `community-design-handoff` and `community-review` (commit `77c55b5d`).
- The upstream `discourse-*` skills remain intact.
- The Community operating contract lives at `.skills/community-repo-audit/references/operating-contract.md`.
- No upstream `AI-AGENTS.md`, `AGENTS.md`, `CLAUDE.md`, `.gitignore` or `discourse-*` skill was modified for this layer.
- The layer passed fresh-session acceptance in native WSL Claude Code.

### Design Director WSL rebind — VALIDATED (Task 04A / 04B)

- The permanent Design Director continuation operates from `/home/leo/source/repos/CannLabs-Community`.
- In that WSL-native session, the skill mechanism naturally discovered all 4 `community-*` skills and all 17 upstream `discourse-*` skills, and `community-repo-audit` loaded the Community operating contract.
- Old Windows Design Director chats are historical, read-only evidence.
- The Windows reference clone remains non-authoritative.

### Community design direction — VALIDATED (Task 05)

Only the design direction is validated; no theme exists and nothing was implemented.

- The permanent WSL Design Director completed read-only design discovery; the official PM reviewed the proposal and the Founder ratified the recommended decisions (`DEC-018` to `DEC-021`).
- Visual register "Arquivo em casca de Estufa": Estufa shell, Arquivo content.
- Structural base: a thin CannLabs adaptation on the Discourse core / Foundation structure; Horizon is reference only. Discussion is a list, not a card feed.
- Circular avatars are a formal Design System exception (circle = person).
- Intended language: pt-BR. `default_locale` is unchanged.
- The first visual prototype will be static / non-persistent. Theme packaging was left OPEN; it is now decided in `DEC-024`.
- The Design Director proposal is kept as evidence outside the repository; it is not canon.

### Community static visual prototype — VALIDATED (Task 06)

The visual direction is validated; no production theme exists, and fine polish is LATER (`DEC-023`).

- The Design Director built a static, non-persistent prototype of the shell, `/latest`, `/categories` and the mobile drawer, in light and dark, desktop and mobile, with fictional pt-BR fixture content. Task 06A replaced the typed stand-in with the real CannLabs wordmark from the Design System. Nothing was installed in Discourse and the runtime was unchanged.
- The Founder reviewed it visually and approved moving forward; the official PM set Task 06 VALIDATED (`DEC-022`).
- Shell: deep L-frame, with the paper CannLabs wordmark on the deep shell.
- Topic-list titles in Petrona remain a HYPOTHESIS until tested with the real font; Public Sans is the fallback.
- Letter-avatar colours stay native for the first implementation (`DEC-023`).
- The prototype, screenshots and measurements are kept as evidence outside the repository; they are not canon.

### Architecture / upstream reuse review — VALIDATED (Task 07)

- A fresh, read-only native-WSL reviewer compared the packaging options against the current fork and upstream. Nothing was implemented, installed or created.
- The official PM adopted the architecture: one full Discourse theme in a dedicated Community-owned theme repository, `leo-even/CannLabs-Community-Theme`, installed through the standard git-theme mechanism; the fork holds no theme code (`DEC-024`). The theme repository does not exist yet.
- Logo: the canonical Design System SVG, unchanged, through native `logo` / `mobile_logo` settings. Fonts: binary provenance is OPEN and required before bundling.
- The review is kept as evidence outside the repository; it is not canon.

### Discourse-native design handoff — VALIDATED (Task 08)

The implementation contract for Community Theme v0.1. Nothing was implemented in Task 08; the theme was built in Task 10 (below).

- The permanent Design Director produced the handoff through `community-design-handoff` and signed it off; the official PM validated it.
- **v0.1 scope:** header, desktop sidebar, mobile drawer, `/latest` and `/categories`, light and dark schemes, desktop and mobile. No JavaScript, plugins, theme components or core changes; no topic page (beyond inherited tokens), composer, profile, auth, verification, organization or payment work.
- **Typography:** Petrona topic titles remain HYPOTHESIS behind a single title-family variable. Fonts do not block v0.1, which runs on defined fallback stacks; font binaries still need recorded provenance before bundling (`DEC-024`).
- **Acceptance baseline for the first implementation:** the handoff's accessibility criteria A1–A11; native responsive geometry; 200% browser text; 320 CSS px reflow; 44px mobile targets; light and dark; anonymous and logged-in where they differ; the current modernize state plus one isolated modernize-OFF run with exact restoration; a rollback drill to Foundation. Fine visual polish stays LATER (`DEC-023`).
- The handoff (`community-theme-v0.1-handoff.md`) and its contrast measurements are kept as evidence outside the repository; they are not canon.

### Coder native-WSL rebind — VALIDATED (Task 09)

- The permanent Coder continuation is a native-WSL Claude Code session working from the authoritative worktree.
- It discovered the Community and upstream `discourse-*` skills naturally, ran `community-repo-audit`, and passed read-only readiness acceptance before it became a writer.
- The old Windows-hosted Coder context is historical / read-only.

### Community Theme v0.1 — VALIDATED (Task 10 / 10B)

- **Implementation:** the dedicated repository `leo-even/CannLabs-Community-Theme`, validated at commit `aeb3a9d9154f532064dcc24ac9e78cf587588d77`. A full Discourse theme installed through the standard git-theme mechanism, with two paired Community colour schemes; no custom JavaScript, plugin or core modification; fallback fonts only. The application fork contains no theme implementation code (`DEC-024`).
- **Validated surfaces:** header, desktop sidebar, mobile drawer, `/latest` and `/categories`, in light and dark, on desktop and mobile.
- **Evidence:** Design Director real-app QA PASS; 5 theme system specs with 0 failures; the restricted-category lock (B1-R) at 5.38:1 in light and 5.84:1 in dark; findings B1, H1 and H2 resolved; the Task 10 200% text / reflow evidence remains accepted; rollback to Foundation proven; the application repository stayed clean and isolated.
- **Task 10A — PARTIAL / SUPERSEDED by Task 10B.** Accepted evidence: the Community dev workers were restarted onto the current application HEAD, so the stale app-version cache workaround is no longer needed; the minimum Chromium runtime libraries were installed inside the Community dev container, and the theme system specs became executable and passed. Its B1-R code correction targeted the wrong variable; Task 10B supplied the validated correction.
- Kept LATER / OPEN (not solved by v0.1): the site-wide derived-colour / footer / focus pass (M1); category-square colours once categories are designed (M2); the `/categories` "Recentes" title weight (L1); the skip-link visual (L2); the mixed-language site title (L3); fine polish (`DEC-023`); real font binaries and their provenance, and the Petrona hypothesis (`DEC-022`, `DEC-024`); theme LICENSE attribution / copyright hygiene; `minimum_discourse_version`; the production deployment strategy. None blocks V1 product discovery.

### Founder local login — PENDING (Task 07B)

- The requested local admin test account was not created: native Discourse password policy rejected the requested password (minimum length; admin accounts need at least 15 characters). The policy was not weakened and no password was substituted or stored.
- Pending a new Founder-chosen password. It does not block V1 product discovery.

### Source-of-truth reconciliation

- **Current truth:** exactly one editable source copy exists, the WSL worktree. The development container bind-mounts it at `/src`. The Windows clone `C:\Users\Leo\source\repos\CannLabs-Community` is a bootstrap / reference clone only. The temporary Docker source volume used for the vanilla start (`cannlabs_community_src`) has been removed.
- **SUPERSEDED:** the pre-Task-02 observation of three source copies (Windows clone, Docker source volume and a planned WSL worktree). Task 02 resolved it.

## COMPLETED READ-ONLY DISCOVERY

This is research and discovery evidence, not product implementation.

- **Coder context load** — completed, read-only.
- **Design Director context load** — completed, read-only.

The durable findings are summarized in `04_DISCOVERY_BASELINE.md`.

## ACTIVE

- No implementation slice is active.
- Task 11 is READ-ONLY V1 capability / upstream reuse discovery; it has no writer.

## NOT AUTHORIZED

Nothing below is authorized. Presence in the backlog does not authorize work.

- product feature implementation;
- a custom roles system;
- a custom ACL system;
- category taxonomy implementation;
- payment implementation;
- authentication configuration or customization;
- professional verification implementation;
- association workflow implementation;
- company workflow implementation;
- private messaging changes;
- Design System import or integration;
- theme implementation beyond the validated v0.1;
- plugin implementation;
- a strain database;
- structured-post mechanics;
- production deployment.

## CURRENT RUNTIME NOTES

- Community runs at `http://localhost:3100` in the Docker container `cannlabs_community_dev` (official image `discourse/discourse_dev:20260812-0036`, database volume `cannlabs_community_pg`).
- FeedCheck runs at `http://localhost:3000`. It is a separate product; do not touch it.
- The WSL worktree is authoritative, and the container runs exactly its files.
- The Windows clone is reference-only; do not develop there.
- Native Claude Code is installed inside Ubuntu (WSL), under the user's home, for Community agent sessions started from the WSL worktree.
- A local development admin exists for authenticated QA. It was created with the upstream `bin/rake admin:create` task, and its credential is stored outside the repository, under `~/.config/cannlabs-community/` in the WSL user's home. Never commit credentials.
- The local preview configuration `.claude/launch.json` (ignored by the upstream `/.claude` rule) targets `http://localhost:3100`. Never start a second development server on port 3000.
- After a Docker engine restart the container comes back on its own, but the app server must be relaunched:

  ```bash
  docker exec -d -u discourse:discourse -w /src -e RUBY_GLOBAL_METHOD_CACHE_SIZE=131072 -e LD_PRELOAD=/usr/lib/libjemalloc.so cannlabs_community_dev bash -c "exec bin/dev >> /src/log/bin-dev.log 2>&1"
  ```

- Git state before this baseline commit: `main` = `origin/main` = `upstream/main` at `d8d59f72`; clean working tree.
- **`modernize_foundation_theme` (technical evidence, Tasks 07 / 07B / 08).** Source YAML default `false`, status `beta`; `promote_upcoming_changes_on_status` is `beta`; no database override for either. The current effective state is **ON for everyone**: the change is enabled site-wide and for logged-in users, and live anonymous pages also carry `body.uc-modernize-foundation-theme` (Task 08), which corrects the earlier note that anonymous visitors do not get the body class. The Task 05 description "off by default" is stale. Do not change either setting outside an authorized slice. Implementation QA covers the current state plus one isolated modernize-OFF run with exact restoration afterwards.
- **Local Community configuration (development only).** Community Theme v0.1 is installed and the default theme, pinned to a reviewed commit with manual updates only (no automatic updates). Local development uses the pt-BR locale, and the canonical CannLabs wordmark is configured through the native `logo` / `mobile_logo` settings. No production deployment exists.
- **Local test stack.** The Community dev container has the `discourse_test` database and the Playwright Chromium binary with its minimum runtime libraries, so theme system specs run inside the container.

## KNOWN ENVIRONMENT FOLLOW-UPS

None of these is solved in this slice.

- **Git author identity.** A repository-local identity derived from the authenticated GitHub account (profile name plus the account's GitHub no-reply address) was set for the baseline commit. The Founder should confirm or replace it before normal development commits.
- **lefthook / pre-commit.** The upstream `pnpm install` installs a lefthook `pre-commit` hook. The development image sets `LEFTHOOK=0`, so the hook is skipped inside the container, while a commit made directly from Ubuntu would need a Ruby and Node toolchain that the host does not have. Reconcile this with container-based development before the first code slice.
- **Push credentials from WSL.** No Git credential helper is configured in WSL. Decide a durable, least-privilege setup before routine pushes.
- **GitHub Actions on the fork — OPEN.** The workflow definitions contain push triggers that appear applicable to changes on `main` (including `Tests`, `Linting` and `Licenses`), but the baseline push `e02f6d4c` produced no GitHub Actions runs, no run IDs and no Actions status checks. The cause is unresolved. CI enablement and policy must be reviewed before the project relies on GitHub Actions as validation evidence (`04_DISCOVERY_BASELINE.md` §1.5 and §3).
- **Cloudflare GitHub integration — OPEN (Infrastructure / Security / Deployment).** The GitHub app `cloudflare-workers-and-pages` has access to this repository. The baseline push produced a Cloudflare-associated check suite, which was still queued when inspected; no deployment was observed. Review the integration's repository access and intended deployment role before production deployment. Its presence does not establish an active Community deployment.
- **Windows host clock — low priority.** SUPERSEDED: the earlier WSL clock-drift attribution was incorrect. A later comparison with GitHub server time showed the Windows host clock about 304 seconds (roughly five minutes) ahead, while WSL / container time was aligned within ordinary measurement latency. Windows time synchronization is a low-priority local-environment follow-up.
- **Passkeys on port 3100.** Upstream hardcodes the development WebAuthn origin to `http://localhost:3000` (`lib/discourse_webauthn.rb`), so passkeys do not work on the Community development port. Do not patch core for this.
- **Correction-loop rule — future operating-layer improvement.** Lesson from Tasks 10–10B: bound a correction loop by finding and scope, not by a fixed number of commits. For the same validated finding, with an evidenced root cause and a tightly bounded correction that expands no product or scope, the official PM may authorize further bounded correction until the acceptance criterion converges. This is not an unlimited fix loop: a materially new finding returns to normal readiness / scope arbitration. The operating skills are not changed yet.

## NEXT

1. V1 capability / upstream reuse discovery (Task 11, read-only).
2. V1 product-domain specification.
3. Founder / official PM decisions on unresolved V1 scope.
4. Legal / Trust & Safety review where required.
5. Bounded implementation briefs.
6. Implementation one slice at a time.

Visual polish is no longer the critical path. The Founder local login stays pending a new Founder-chosen password (Task 07B).

No implementation starts automatically; each step needs explicit official PM authorization.
