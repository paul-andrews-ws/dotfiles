---
name: Mobile testing patterns in front-end-monorepo
description: Jest mock patterns, feature flag testing, and lint rules for mobile tests in cash-dashboard-components and similar packages
type: feedback
---

Never mock `useRolloutFlag` directly — use `FeatureFlag.initialize({ 'flag-name': true })` in beforeEach/per-test. The lint rule `@nx/workspace/no-mock-feature-flag` enforces this.

**Why:** The feature flag SDK has its own test infrastructure. Mocking the hook bypasses it and can hide bugs.

**How to apply:** Import `FeatureFlag` from `@wealthsimple/feature-flag-ts`, call `FeatureFlag.initialize({})` in afterEach to reset.

---

Never mock gql-sdk hooks directly — use `mockServer.use(mockUseAllAccounts(() => [...]))` from MSW test utils. The lint rule `@nx/workspace/no-mock-gql-sdk` enforces this.

**Why:** Generated MSW mock helpers ensure the mock data matches the GQL schema.

**How to apply:** Import `mockServer` from `@wealthsimple/jest-msw` and generated mocks from `@wealthsimple/gql-sdk-test-utils`. Use `renderHookAsync` with `getMockProviderStack()` wrapper for async hook tests.

---

Components using DS components that call `useLocale` internally (like `DSButtonClose`, `DSCardButtonClose`) need `getMockProviderStack()` wrapper in tests. Without it, you'll get "useLocale must be used with a single InjectIntlContext" errors.

---

Don't use `jest.requireActual('react')` + `createElement` patterns for mock components. Use `mock`-prefixed variables with JSX, or mock to return `null` and assert via testID presence/absence.

**Why:** The `mockReact.createElement` pattern is unfamiliar in the codebase. Simpler mocks are preferred.
