---
name: open-pr
description: Use when the user has confirmed local QA and code review both passed and wants to commit, push, and open a draft PR. Trigger phrases "/open-pr", "open the PR", "open a draft PR", "ship it", "ready to open the PR".
---

# Open PR

Post-QA ship flow. Commits, pushes, and opens a **draft** PR. Does NOT re-run
lint / type-check / unit tests / unimported — those must already be green
before the user got to QA.

## Preflight gate

Before touching git, verify the user has explicitly confirmed:

1. Local QA testing passed
2. Code review passed

If the most recent user instruction doesn't make this clear, ask:

> Before I commit and open the PR — can you confirm your local QA testing and
> code review both passed?

Do not proceed on hedged answers.

## Flow

1. **Gather state** (parallel): `git status`, `git diff`, `git diff --cached`,
   `git log --oneline -20`, `git branch --show-current`. Read
   `.github/pull_request_template.md` if present.

2. **Safety**: STOP if on `main`/`master`, if there's nothing to ship, or if
   staging would sweep in files that look like secrets (`.env`,
   `credentials.*`, `*.pem`).

3. **front-end-monorepo pnpm hook PATH**: if repo path contains
   `front-end-monorepo`, export before committing (pre-commit hook needs
   `pnpm` on PATH):
   ```bash
   export PATH="/Users/paul.andrews/.local/share/mise/installs/node/24.11.1/bin:$PATH"
   ```
   Update the node version if the worktree's `mise.toml` pins a different one.

4. **Commit**: stage specific files by name (never `-A` or `.`). HEREDOC
   commit message matching the repo's recent style. If the pre-commit hook
   fails, fix the underlying issue and make a NEW commit — never `--amend`,
   never `--no-verify`.

5. **Push**: `git push -u origin <branch>` if no upstream, else plain
   `git push`. Never force-push.

6. **Create draft PR**: `gh pr create --draft` with title under 70 chars.
   Populate the repo's PR template from commit history + diff:
   - Extract the JIRA ticket from the branch name (front-end-monorepo
     convention: `BB-{ticket}/short-description`)
   - Fill **Summary** focused on *why*, not a restatement of the diff
   - Fill **Test plan** from the checks + QA the user confirmed
   - Leave `- [ ]` checklist boxes unchecked unless the user has said they
     did that specific item
   - Preserve template section headers and reviewer-facing comments verbatim
   - If no template exists, use `## Summary` + `## Test plan` and flag it to
     the user

7. **Return the PR URL**.

## Does NOT

- Re-run lint / type-check / tests / unimported
- Mark the PR ready for review (stays in draft)
- Merge, force-push, `--amend`, or use `--no-verify`
- Push to `main` / `master`

## Red flags — STOP

- User hasn't explicitly confirmed QA + review → ask, don't assume
- Pre-commit hook failed → fix + new commit, never bypass
- Branch is `main` / `master` → refuse
- Staging would include `.env` / secrets → refuse
