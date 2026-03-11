# Memory

## Projects

- **front-end-monorepo**: `/Users/paul.andrews/Repos/front-end-monorepo`
- **fort-knox**: `/Users/paul.andrews/Repos/fort-knox`
- **wealthsimple**: `/Users/paul.andrews/Repos/wealthsimple`

## front-end-monorepo: Git & Environment

### pnpm PATH for git hooks
The pre-commit hook requires `pnpm` but it's not on the default shell PATH when running `git commit` via Claude's Bash tool. The mise shims path has been unreliable — use the direct node bin path instead:
```bash
export PATH="/Users/paul.andrews/.local/share/mise/installs/node/24.11.1/bin:$PATH"
git commit ...
git push ...
```
(Update the node version in the path if needed.)

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

## DSChip icon color override (React Native design system)
DSChip uses `React.cloneElement(iconLeft, { color, size: 'small' })` which **silently overwrites** any `color` prop you pass to the icon. The chip's own state-computed color wins:
- `state="active"` → `soft-fg`
- `state="selected"` → `strong-fg-inverted`
- `state="inactive"` → `inactive-fg`

**Fix:** Don't use `iconLeft`/`iconRight` props if you need custom icon color. Instead, put the icon inside the chip's `children` (e.g. in a `DSBox stacked="row"`) — chip children are rendered as-is without color interference.

## front-end-monorepo: Home Screen Data Fetching Patterns

### useAllAccounts is fragment-based, not a query
`useAllAccounts` in `@wealthsimple/gql-sdk` reads from the Apollo `AllAccounts` fragment cache via `useFragment`/`useSuspenseFragment`. It does NOT fire a network request unless the fragment is incomplete. The `filter` option (e.g. `{ closed: false, archived: false }`) is applied **client-side** in JS, not as a GQL variable. All calls with the same `identityId` share the same fragment.

### Invest tab pattern for classification inside Suspense
To classify accounts (e.g. personal vs. business) without an eager query, follow the invest tab pattern (`invest-account-grouping.component.tsx`):
1. Use `AccountListDataContainer` with `dataTransformFlatlist` (exported from `@wealthsimple/account-grouping-mobile`)
2. Do classification inside the `children` render prop — this runs inside the Suspense boundary
3. `useAllAccounts.useSuspended` resolves synchronously when the `AllAccounts` fragment is already cached (which it is by the time home screen widgets render, since `useAllAccountIdsHome` runs at the top level)

### Performance registry parentView must be a navigation screen name
`SuspenseWithWidgetPerformance` / `AccountListDataContainer` register widgets via `parentView`. This value must be a registered **navigation screen** (e.g. `"Home"`, `"Invest"`, `"AccountsList"`). Using a widget name (e.g. `"AccountsList"`) as `parentView` for a nested widget will produce: `"Attempted to instrument widget (X), but the parent (Y) does not exist"`.

### Personal/business account classification
- `getGroupNameFromAccountType(datum.accountType) === 'corporate'` correctly identifies all business accounts (all corporate `UnifiedAccountType`s map to `'corporate'` group name, including `BUSINESS_CHEQUING`)
- `AccountGroupingCash` (cash tab) uses `isBusinessAccount` from `@wealthsimple/account-display-utils` — checks `account.type` field instead
- `dataTransformGroupedList` is NOT exported from `account-grouping-mobile`; use `dataTransformFlatlist` which gives `AccountGroupDatum[]`

### Heuristic: check the invest tab first for home screen patterns
When solving data-fetching or rendering architecture questions on the home screen, read `libs/mobile/screens/home/src/views/invest/components/tabs/account-group/invest-account-grouping.component.tsx` first — it consistently has the canonical pattern already implemented (Suspense boundaries, `AccountListDataContainer`, personal/business classification).

## front-end-monorepo: Cash Mobile Micro-UI Patterns

### useLocale mock in cash tests
The cash project has a global mock at `__mocks__/@wealthsimple/mobile-intl-ts/use-locale.hook.ts`
that makes `getMessage(key)` return the key string itself (not the translated value). All cash
tests must assert against locale **key strings** (e.g. `'business-chequing::onboarding::empty-states::pending-account-status-body'`), not translated text. Trying to pass real translated strings into the test provider will not work.

### Apollo fragment cache in mobile tests
`useAccountDetailsEmptyStatesFragment` reads from Apollo cache via `useFragment` — it makes no
network request. Tests must seed the cache with `apolloClient.writeFragment()` using
`InvestmentAccountDetailsEmptyStatesFragment` from `@wealthsimple/investing-network`. The
fragment variables include `accountId`, `clientId` (from `useInvestUserId()`), and `identityId`
(from `useIdentityId()`). The auth stub from `setupAuthInfoForTest()` sets
`identityId: 'identity-123'` and `clientId: 'user-123'`.

### Dead code detection
CI uses `pnpm unimported --quiet`. Run locally with the same command (with mise PATH set). Exit
code 0 = clean.

### EmptyStateContent MSW requirements
When `AccountDetailsEmptyState` (mobile AOSDK) is rendered in tests, the nested `EmptyStateContent`
component fires 5 GQL queries that must all be mocked:
- `mockUseAccountCombinedNLV`
- `mockUseActivityFeedItems`
- `mockUseFundingAccountApproved`
- `mockUseAccountCurrentFinancials`
- `mockUseIdentityPositions`

### respFacet in InvestmentAccountDetailsEmptyStatesFragment
`mockAccount()` doesn't include `respFacet`, but the fragment expects it. Add `respFacet: null`
explicitly when writing the fragment to the Apollo cache to avoid console.error warnings.

