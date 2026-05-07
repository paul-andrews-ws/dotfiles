---
name: Throw guards over silent fallbacks
description: Prefer throwing on invalid GQL union results during render rather than silently falling back to empty arrays or default values
type: feedback
---

When a GQL union result hits an unexpected typename, throw an error rather than silently falling back to a default (e.g. empty array). This surfaces failures clearly via error boundaries instead of letting the UI render in a broken-but-silent state.

**Why:** User flagged that falling back to `[]` when schedule calculation fails would let the component render with no payments and a disabled button — confusing UX. A throw matches the existing guard pattern in the component (e.g. `!scheduleFrequency`) and makes failures observable.

**How to apply:** After fetching a GQL union result, check the `__typename` and throw if it's not the expected success type. Then destructure from the narrowed result. This also gives TypeScript automatic type narrowing.
