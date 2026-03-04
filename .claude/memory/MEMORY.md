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

## DSChip icon color override (React Native design system)
DSChip uses `React.cloneElement(iconLeft, { color, size: 'small' })` which **silently overwrites** any `color` prop you pass to the icon. The chip's own state-computed color wins:
- `state="active"` → `soft-fg`
- `state="selected"` → `strong-fg-inverted`
- `state="inactive"` → `inactive-fg`

**Fix:** Don't use `iconLeft`/`iconRight` props if you need custom icon color. Instead, put the icon inside the chip's `children` (e.g. in a `DSBox stacked="row"`) — chip children are rendered as-is without color interference.

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

## Pre-Commit Checklist

Before committing any changes in the front-end-monorepo, always run lint and type checks on the affected project:

```bash
pnpm nx run <project>:lint
pnpm nx run <project>:check-types
```

Or for all affected projects:

```bash
pnpm nx affected --target=lint,check-types
```
