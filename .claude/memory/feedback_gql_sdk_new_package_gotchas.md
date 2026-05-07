---
name: GQL SDK new package gotchas
description: Known issues and fixes when scaffolding a new gql-sdk-operation package in front-end-monorepo
type: feedback
---

When running `pnpm nx generate @wealthsimple/ws-nx:gql-sdk-operation`, several post-scaffold fixes are always needed:

**1. CODEOWNERS missing `@wealthsimple/` prefix**
The generator writes `business-banking-eng` (or any team slug) without the org prefix. The codeowners-check CI job will fail with "invalid owner format". Always fix to `@wealthsimple/business-banking-eng`.

**2. Dead code detection requires allowlist entry**
New GQL SDK packages with no consumers yet will fail `pnpm unimported --quiet` CI. Add the package to the allowlist in `scripts/unimported/constants.ts` under "GraphQL operations that are allowed to have unimported exports":
```ts
'libs/shared/gql-operations/queries/your-new-package/**',
```

**3. Union type mocks require `__typename` in resolver**
`mockFetchXxxQueryResult` uses `__typename` to determine which union variant to produce. If the resolver returns `{ schedule: [...] }` without `__typename`, it falls through to the last else branch (wrong variant). Always include `__typename` in mock resolvers for union result queries:
```ts
mockUseXxx(() => ({
  __typename: 'OnlineBillPayCalculateBillPaymentScheduleSuccess',
  schedule: [...],
}))
```

**4. Nx daemon cache causes lint "Could not find project"**
After generating a new package, the Nx daemon may have a stale project graph. `check-types` still works (uses `nx:run-commands`) but `lint` fails with "Could not find project". Fix: `pnpm nx reset`.

**Why:** These are all generator bugs / CI conventions not encoded in the generator itself.

**How to apply:** Run through this checklist after every `gql-sdk-operation` scaffold before pushing.
