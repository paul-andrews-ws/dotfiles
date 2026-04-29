---
name: front-end-monorepo git & environment setup
description: pnpm PATH for git hooks, worktree naming + setup, branch naming convention, dead-code detection — for /Users/paul.andrews/Repos/front-end-monorepo
type: reference
originSessionId: 4f84d690-df7d-4949-9198-8a323dd8a58e
---
## pnpm PATH for git hooks

The pre-commit hook requires `pnpm` but it's not on the default shell PATH when running `git commit` via Claude's Bash tool. The mise shims path has been unreliable — use the direct node bin path instead:

```bash
export PATH="/Users/paul.andrews/.local/share/mise/installs/node/24.11.1/bin:$PATH"
git commit ...
git push ...
```

Update the node version in the path if `mise.toml` changes.

## Worktree naming convention

Worktrees live as **sibling directories** to the main repo, named `front-end-monorepo-BB-{ticket-number}`. Example: `/Users/paul.andrews/Repos/front-end-monorepo-BB-693`. Do NOT use `.worktrees/` inside the repo.

**Always run `git worktree list` first** before applying the using-git-worktrees skill's directory-detection logic — existing worktrees reveal the naming convention in use.

After `git worktree add`, run `mise trust <worktree>/mise.toml` before attempting any `pnpm` or `node` commands — otherwise mise refuses to activate and shell builtins like `grep`/`tail` become unreachable.

## Branch naming convention

`BB-{ticket-number}/short-description` — e.g. `BB-649/personal-business-account-owner-toggle-poc`. Same convention is used in the wealthsimple monolith for BB-prefixed tickets.

## Worktree setup for mobile builds

After `git worktree add`, the new worktree is missing gitignored files. Steps to get a mobile build running:

**1. Merge main first**
```bash
cd <new-worktree> && git merge main
```

**2. Run pnpm install** (fast — uses local pnpm content-addressable store, no downloads):
```bash
export PATH="/Users/paul.andrews/.local/share/mise/installs/node/24.11.1/bin:$PATH"
pnpm install --frozen-lockfile
```
Do NOT symlink `node_modules` — Metro (via `withNxMetro`) cannot resolve modules through symlinked `node_modules` due to watchman not following symlinks outside the watch root. Always use a real `node_modules` from `pnpm install`.

**3. Symlink other gitignored files**
```bash
MAIN=/Users/paul.andrews/Repos/front-end-monorepo
NEW=<path-to-new-worktree>
ln -s $MAIN/build $NEW/build
ln -s $MAIN/apps/mobile/retail/package.json $NEW/apps/mobile/retail/package.json
ln -s $MAIN/apps/mobile/retail/pnpm-lock.yaml $NEW/apps/mobile/retail/pnpm-lock.yaml
```

If a `ConfigError: expected package.json path does not exist` surfaces for other packages, apply the same symlink pattern.

**4. Start with cache cleared**
```bash
pnpm nx run mobile-retail:start --reset-cache
```

## Dead code detection

CI uses `pnpm unimported --quiet`. Run locally with the same command (with mise PATH set). Exit code 0 = clean.
