---
name: Avoid duplicate typename checks
description: When using GQL union results, extract the narrowed value once rather than repeating __typename checks
type: feedback
---

Extract GQL union type narrowing into a single variable rather than duplicating `__typename` checks across the component.

**Why:** User flagged duplicated `scheduleResult?.__typename === 'Success'` checks in the bulk bill pay confirmation component — the same narrowing was done in the title and in `onSubmit`.

**How to apply:** When a GQL result is a union type, narrow it once (e.g. `const schedule = result?.__typename === 'Success' ? result.schedule : []`) and reference the extracted value throughout.
