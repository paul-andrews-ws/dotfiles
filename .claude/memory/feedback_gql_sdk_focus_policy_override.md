---
name: gql-sdk-core overrides fetchPolicy on re-focus
description: gql-sdk-core's internal useFocusEffect pauses queries on blur and restores fetchPolicy to cache-first on focus — overrides any user-specified policy
type: feedback
originSessionId: 9dace259-5aa8-4ddd-a9b9-56c5f2960633
---
`createQueryHook` in `@wealthsimple/gql-sdk-core` wires its own `useFocusEffect` that pauses the Apollo observable on blur (either via `pauseWatch` or `fetchPolicy: 'standby'`) and on re-focus **force-restores `fetchPolicy` to `cache-first`** — not to the policy the caller originally passed.

**Why:** Discovered while trying to fix stale data with `fetchPolicy: 'cache-and-network'`. After any blur/focus cycle, the option is silently overridden, so data still comes from the cache on return.

**How to apply:**
- Don't rely on `fetchPolicy: 'cache-and-network'` to survive focus cycles.
- For screens that stay mounted under modals/pushed screens (e.g. tab-hosted dashboards), use `refetch()` inside a `useFocusEffect` instead — `refetch` triggers a network request regardless of policy.
- Source: `libs/shared/packages/gql-sdk-core/src/create-query-hook.ts:361-386`.
