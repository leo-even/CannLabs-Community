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
- The first visual prototype will be static / non-persistent. Theme packaging remains OPEN.
- The Design Director proposal is kept as evidence outside the repository; it is not canon.

### Community static visual prototype — VALIDATED (Task 06)

The visual direction is validated; no production theme exists, and fine polish is LATER (`DEC-023`).

- The Design Director built a static, non-persistent prototype of the shell, `/latest`, `/categories` and the mobile drawer, in light and dark, desktop and mobile, with fictional pt-BR fixture content. Task 06A replaced the typed stand-in with the real CannLabs wordmark from the Design System. Nothing was installed in Discourse and the runtime was unchanged.
- The Founder reviewed it visually and approved moving forward; the official PM set Task 06 VALIDATED (`DEC-022`).
- Shell: deep L-frame, with the paper CannLabs wordmark on the deep shell.
- Topic-list titles in Petrona remain a HYPOTHESIS until tested with the real font; Public Sans is the fallback.
- Letter-avatar colours stay native for the first implementation (`DEC-023`).
- The prototype, screenshots and measurements are kept as evidence outside the repository; they are not canon.

### Source-of-truth reconciliation

- **Current truth:** exactly one editable source copy exists, the WSL worktree. The development container bind-mounts it at `/src`. The Windows clone `C:\Users\Leo\source\repos\CannLabs-Community` is a bootstrap / reference clone only. The temporary Docker source volume used for the vanilla start (`cannlabs_community_src`) has been removed.
- **SUPERSEDED:** the pre-Task-02 observation of three source copies (Windows clone, Docker source volume and a planned WSL worktree). Task 02 resolved it.

## COMPLETED READ-ONLY DISCOVERY

This is research and discovery evidence, not product implementation.

- **Coder context load** — completed, read-only.
- **Design Director context load** — completed, read-only.

The durable findings are summarized in `04_DISCOVERY_BASELINE.md`.

## ACTIVE

- No production implementation is active. Task 07 is a read-only architecture / reuse review; it has no writer.

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
- theme implementation;
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

## KNOWN ENVIRONMENT FOLLOW-UPS

None of these is solved in this slice.

- **Git author identity.** A repository-local identity derived from the authenticated GitHub account (profile name plus the account's GitHub no-reply address) was set for the baseline commit. The Founder should confirm or replace it before normal development commits.
- **lefthook / pre-commit.** The upstream `pnpm install` installs a lefthook `pre-commit` hook. The development image sets `LEFTHOOK=0`, so the hook is skipped inside the container, while a commit made directly from Ubuntu would need a Ruby and Node toolchain that the host does not have. Reconcile this with container-based development before the first code slice.
- **Push credentials from WSL.** No Git credential helper is configured in WSL. Decide a durable, least-privilege setup before routine pushes.
- **GitHub Actions on the fork — OPEN.** The workflow definitions contain push triggers that appear applicable to changes on `main` (including `Tests`, `Linting` and `Licenses`), but the baseline push `e02f6d4c` produced no GitHub Actions runs, no run IDs and no Actions status checks. The cause is unresolved. CI enablement and policy must be reviewed before the project relies on GitHub Actions as validation evidence (`04_DISCOVERY_BASELINE.md` §1.5 and §3).
- **Cloudflare GitHub integration — OPEN (Infrastructure / Security / Deployment).** The GitHub app `cloudflare-workers-and-pages` has access to this repository. The baseline push produced a Cloudflare-associated check suite, which was still queued when inspected; no deployment was observed. Review the integration's repository access and intended deployment role before production deployment. Its presence does not establish an active Community deployment.
- **Windows host clock — low priority.** SUPERSEDED: the earlier WSL clock-drift attribution was incorrect. A later comparison with GitHub server time showed the Windows host clock about 304 seconds (roughly five minutes) ahead, while WSL / container time was aligned within ordinary measurement latency. Windows time synchronization is a low-priority local-environment follow-up.
- **Passkeys on port 3100.** Upstream hardcodes the development WebAuthn origin to `http://localhost:3000` (`lib/discourse_webauthn.rb`), so passkeys do not work on the Community development port. Do not patch core for this.

## NEXT

1. Architecture / reuse review for theme packaging and the supported Discourse implementation path (Task 07).
2. Official PM architecture decision.
3. Coder WSL rebind / readiness, if needed.
4. First bounded implementation slice: shell + `/latest` + `/categories`.
5. Real-app regression and visual QA.
6. Later polish (`DEC-023`).

V1 capability and specification discovery remains pending (`03_BACKLOG_AND_OPEN_QUESTIONS.md`).

No implementation starts automatically; each step needs explicit official PM authorization.
