---
name: Keep reusable components agnostic from form context
description: Shared UI components (like ScheduleInput) should not depend on react-hook-form useFormContext — accept value/onChange as props instead
type: feedback
---

Reusable input components should not hook into form context (react-hook-form's `useFormContext`, `Controller`, etc.). Instead, make them controlled components that accept `value` and `onChange` as props. The caller wraps in `Controller` at the call site.

**Why:** Form-aware components are coupled to a specific form library and can't be reused across different form contexts or outside forms entirely.

**How to apply:** When creating shared input components in schedule-inputs, money-movement, or similar packages, always use the controlled component pattern. Only hook into form context in the consuming component (e.g. the bill-pay form itself).
