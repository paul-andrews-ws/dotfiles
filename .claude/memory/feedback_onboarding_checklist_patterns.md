---
name: Feature-flagged widget patterns
description: V0/V1 wrappers, gate hooks behind flags at component boundaries, generic components via props, entrypoint nav pattern
type: feedback
originSessionId: 39f014c0-303f-45c8-9e43-b67e4bb3ee12
---
When building UI that replaces or extends an existing widget (V0→V1), wrap both in a decision component in the package we own. The parent layout file imports only the wrapper.

**Why:** Keeps decision logic in our codebase. Easy to clean up when the old version is removed.

---

Gate expensive hooks (GQL queries) behind feature flags at the component boundary. The flag check renders a child component that contains the hooks — don't put both in the same component.

**Why:** Hooks run unconditionally in a component. If the flag check and hooks share a component, the query fires for all users regardless of flag state.

---

Generic UI components should accept data as props, not call account-specific hooks internally. Keep components reusable across account types.

**Why:** The wrapper is the account-specific piece. Generic components should have no knowledge of any particular account type.

---

For cross-package navigation, pass intent (entrypoint string) not internal enum values. The receiving screen owns the mapping from entrypoint to its internal behavior.

**Why:** PR feedback — the onboarding checklist shouldn't know about bill pay category enums. Follows the established `entrypoint` param pattern used across the mobile app.

---

Per-item analytics property names belong on each item's config in the hook, not hardcoded in the generic component. Add `analyticsKey: string` to the item type; in the component, build the payload via `items.reduce((acc, item) => { acc[item.analyticsKey] = ...; return acc }, {})` and spread into the event.

**Why:** Hardcoding task-specific keys (e.g. `completedAddCraPayee`) in a generic list/carousel component couples it to one task set. Same principle as "generic components accept data as props" — just applied to analytics.
