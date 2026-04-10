# Memory

## Workflow Feedback

- Always wait for explicit user approval before committing and pushing. User QA tests changes on their local web build first.

## Architecture & UI Feedback

- [Onboarding checklist patterns](feedback_onboarding_checklist_patterns.md) — V0/V1 wrapper ownership, config-driven extensibility, flag-gated items

## Coding Style Feedback

- [React hooks style](feedback_react_hooks_style.md) — no superfluous try/catch, no premature useCallback/useMemo memoization
- [Sweep tests on locale changes](feedback_locale_string_test_sweep.md) — grep old string values across ALL test files before committing copy updates
- [Avoid skipToken](feedback_avoid_skiptoken.md) — split into data-gate parent + unconditional hook child per Vlad's guide
- [Avoid duplicate typename checks](feedback_avoid_duplicate_typename_checks.md) — extract GQL union narrowing once, don't repeat __typename checks
- [Throw guards over silent fallbacks](feedback_throw_guards_over_silent_fallbacks.md) — throw on unexpected GQL union results, don't silently fall back to defaults
- [Tophat vault-service CSP](feedback_tophat_vault_service_csp.md) — tophat builds can't load vault-service frames; *.builds.wealthsimple.com not in frame-ancestors allowlist
- [Agnostic components](feedback_agnostic_components.md) — shared UI inputs must not depend on form context; accept value/onChange props, caller wraps in Controller
- [Schedule vs frequency naming](feedback_schedule_vs_frequency_naming.md) — "frequency" = interval (FrequencyOption, FrequencyInput); "schedule" = overall plan (ScheduleFrequency, getMaxEndDate)

## front-end-monorepo: GQL SDK

- [New package gotchas](feedback_gql_sdk_new_package_gotchas.md) — CODEOWNERS prefix bug, unimported allowlist, union mock __typename, Nx daemon cache reset
- [gql-generated scope creep](feedback_gql_generated_scope_creep.md) — regenerating gql-generated picks up unrelated schema changes; revert unless new base types are needed

## Projects

- **front-end-monorepo**: `/Users/paul.andrews/Repos/front-end-monorepo`
- **fort-knox**: `/Users/paul.andrews/Repos/fort-knox`
- **wealthsimple**: `/Users/paul.andrews/Repos/wealthsimple`

## fort-knox: Environment

- [Ruby env for Claude Bash tool](reference_fort_knox_ruby_env.md) — mise shims, bundle install, graphql-snapshot hook requirements, DB setup

## Tools & Integrations

- [JIRA ticket creation via MCP Locker](reference_jira_ticket_creation.md) — mcplocker auth, BB project template with info panels, custom field IDs

## front-end-monorepo: Git & Environment

### pnpm PATH for git hooks
The pre-commit hook requires `pnpm` but it's not on the default shell PATH when running `git commit` via Claude's Bash tool. The mise shims path has been unreliable — use the direct node bin path instead:
```bash
export PATH="/Users/paul.andrews/.local/share/mise/installs/node/24.11.1/bin:$PATH"
git commit ...
git push ...
```
(Update the node version in the path if needed.)

### Worktree naming convention
Worktrees for front-end-monorepo live as **sibling directories** to the main repo, named `front-end-monorepo-BB-{ticket-number}`. Example: `/Users/paul.andrews/Repos/front-end-monorepo-BB-693`. Do NOT use `.worktrees/` inside the repo.

**Always run `git worktree list` first** before applying the using-git-worktrees skill's directory-detection logic — existing worktrees reveal the naming convention in use.

After `git worktree add`, run `mise trust <worktree>/mise.toml` before attempting any `pnpm` or `node` commands — otherwise mise refuses to activate and shell builtins like `grep`/`tail` become unreachable.

### Branch naming convention
`BB-{ticket-number}/short-description` — e.g. `BB-649/personal-business-account-owner-toggle-poc`

### Worktree setup for mobile builds
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

## front-end-monorepo: Mobile Navigation — Modal vs Stack Screen

### Two-tier navigation: modal screens vs feature navigators
Root-level modal screens (slide-up drawer) must live in `modalScreens` in `apps/mobile/retail/src/micro-uis/<package>.ts`, NOT as a `Stack.Screen` inside a feature navigator. Feature navigators use JS stacks (push transition, fullscreen).

- `modalScreens` → processed by `NavigationBuilder.processModals` in `libs/mobile/packages/navigation/src/navigation.builder.tsx` → applies `{ animation: 'slide_from_bottom', presentation: 'modal', headerShown: false, freezeOnBlur: true }`
- Feature `Stack.Screen` → push transition, fullscreen

**When moving a screen to `modalScreens`:**
1. Remove it from the feature navigator's `<Stack.Screen>` registration
2. Remove its barrel export from `screens/index.ts` (becomes dead code — `pnpm unimported --quiet` will catch this)
3. Add/keep its export in the package's `src/index.ts` (required for the cross-package lazy import)
4. Change navigation prop type to `StackScreenProps<ReactNavigation.RootParamList, 'ScreenName'>`
5. Add the lazy import entry to `modalScreens` in the micro-ui config file

### Dead code detection
CI uses `pnpm unimported --quiet`. Run locally with the same command (with mise PATH set). Exit code 0 = clean.
