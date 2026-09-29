---
name: community-repo-audit
description: Use at the start of every CannLabs Community session, before the first write of a slice, and whenever the repository, environment or writer ownership is in doubt. Read-only check that the agent is in the authoritative Linux worktree (not the Windows reference clone, not FeedCheck), that the runtime on port 3100 serves that worktree, that no other writer is active, and that current truth comes from docs/cannlabs-community rather than old reports. Loads the Community operating contract.
---

# CannLabs Community — Repo Audit

Read-only. Establishes where you are and which rules apply before you do anything else.

## Authority

- Community operating contract: [references/operating-contract.md](references/operating-contract.md). Read it first.
- Product truth: `docs/cannlabs-community/` (authority order in its `README.md`; current state and runtime notes in `02_PROJECT_STATE.md`).
- Upstream Discourse conventions: `AI-AGENTS.md` and the `discourse-*` skills. This skill does not replace them.

## Inputs

- The slice or question you were given, who authorized it, and whether you are its designated writer.
- The environment you are running in.

## Procedure

1. Read the operating contract.
2. Repository identity: `pwd`, `git rev-parse --show-toplevel`, `git remote -v` (origin `leo-even/CannLabs-Community`, upstream `discourse/discourse`), `git branch --show-current`, `git rev-parse HEAD`, `git --no-optional-locks status --branch --short`.
3. Location: the authoritative worktree is `/home/leo/source/repos/CannLabs-Community` on a Linux filesystem (not under `/mnt/c`). A Windows path means the read-only reference clone, where symlinked instructions and skills do not resolve: any write there is a BLOCKER; move to the WSL worktree.
4. Remote state, read-only: `git ls-remote origin refs/heads/main` and `git ls-remote upstream refs/heads/main`; compare with the local branch.
5. Working tree: modified, staged or untracked non-ignored files; `.git/*.lock`; running git processes. Unexplained changes are a BLOCKER. Never clean, reset, stash, check out over or delete them.
6. Writer: find the writer the official PM named for the current slice (`02_PROJECT_STATE.md` → ACTIVE, or the slice brief). If it is not you, stay read-only.
7. Runtime, read-only: container `cannlabs_community_dev` is running; `docker inspect` shows `/src` as a bind mount of the WSL worktree; `http://localhost:3100/srv/status` returns 200. Compare with `02_PROJECT_STATE.md` → runtime notes.
8. FeedCheck isolation: port 3000 belongs to FeedCheck. At most observe that its listener exists; never touch its container, repository or volumes.
9. Product truth: read `02_PROJECT_STATE.md` (ACTIVE, NOT AUTHORIZED, runtime notes). List Community-specific history with `git log --oneline -- docs/cannlabs-community .skills/community-*`.
10. Stale claims: compare what you were told (old reports, chat, handoffs) with the evidence above. Repository and runtime evidence wins.

## Output

A short table — check, evidence, classification — using:

- **PASS**
- **BLOCKER** — stop and report.
- **PRODUCT DECISION REQUIRED** — route to the official PM.
- **IMPLEMENTATION DETAIL**
- **STALE / SUPERSEDED STATE** — a claim contradicted by current evidence.

## Hard non-goals

- No writes and no cleanup: no `git reset`, `git clean`, `git stash` or `git checkout -- .`; no deleting files, containers or volumes.
- Never touch FeedCheck, CannLabs Traceability or any other repository.
- Never infer current state from old reports when repository or runtime evidence is available.

## STOP

Stop after reporting. A BLOCKER or PRODUCT DECISION REQUIRED goes to the official PM before work continues. A passing audit does not authorize the next slice.
