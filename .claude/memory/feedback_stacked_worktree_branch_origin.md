---
name: branch-off-origin-main-in-stacked-worktree
description: "When user says \"pull latest main and branch off X,\" interpret literally — branch off origin/main, not the worktree's current local branch which may carry pre-squash commits from a merged ancestor"
metadata: 
  node_type: memory
  type: feedback
  originSessionId: 570c811a-0442-4324-9194-45bcda0d34ab
---

When the user says "pull latest main and checkout to a new branch with prefix X" while in a worktree whose current branch is a now-merged ancestor, branch off `origin/main` literally:

```bash
git fetch origin main
git checkout -b BB-XXXX/<short-desc> origin/main
```

Do NOT branch off the worktree's local current branch even if it looks like the right parent.

**Why:** Discovered in BB-1068 (2026-05-19). The worktree `front-end-monorepo-BB-1023-stack` was on `BB-1029/business-dashboard-mobile-add-email`, which had been squash-merged to main via PR #72751. I created BB-1068 by `git checkout -b BB-1068/...` from the worktree's current HEAD, which inherited ~20 pre-squash commits that aren't on `origin/main` (only their squashed-flat content is). When opening the PR, `git rebase origin/main` conflicted across 6+ files because each pre-squash commit tried to replay onto already-squashed content. Recovery required deleting the remote branch, resetting locally (`git checkout origin/main -B <branch>`), and cherry-picking just the new ticket's commit.

**How to apply:** Any new ticket started from a worktree that previously hosted a now-merged ticket. Before branching, check whether the current local branch is already merged via squash on `origin/main`:

```bash
gh pr list --search "<ancestor-branch>" --state merged --json url,title,state
```

When in doubt, branch fresh from `origin/main`. Related: [[reference_fem_git_env]] covers the worktree+pnpm setup; this memory covers the branch-creation gotcha that follows.
