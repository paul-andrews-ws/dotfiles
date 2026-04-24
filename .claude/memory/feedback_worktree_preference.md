---
name: Worktree preference for front-end-monorepo
description: User skips worktrees for single-task work on FEM — only uses them when parallel tasks share the same repo
type: feedback
originSessionId: dc2f991d-4b13-4da9-9cac-35e5ca51b589
---
For front-end-monorepo, do NOT default to creating a worktree before implementation. Check in first — ask whether this task is parallel to other FEM work, or use prior conversation context to tell. If it's the only active task on FEM, check out the branch directly in the main repo.

**Why:** Worktree setup has non-trivial overhead on FEM (mise trust, symlinks to gitignored files, full pnpm install). That cost is worth paying when isolation is needed for parallel work, but wasteful for a single active task. User made this explicit after I tried to auto-create a worktree for BB-794.

**How to apply:** When kicking off implementation of a FEM ticket, default to `git checkout -b <branch>` in the main repo. Only use the worktree skill (per MEMORY's FEM worktree conventions) when the user has other active FEM branches that would be disrupted, or when the user explicitly asks for a worktree.
