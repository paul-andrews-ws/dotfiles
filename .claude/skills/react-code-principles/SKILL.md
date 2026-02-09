---
name: react-code-principles
description: Use when implementing React or React Native components to follow team conventions for state management, component structure, and code organization
---

# React Code Principles

Write for future contributors with no context about your feature. These are our team's opinionated stances — apply them in all React and React Native code.

## Conventions

**State & data flow:**
- No `useEffect` for business logic — all logic in event handlers, not side effects
- No `useMemo`/`useCallback`/`React.memo` — fix component hierarchy instead (last resort only for proven perf issues)
- No shared state via Context — use route params (mobile), URL params (web), Apollo cache, or React Hook Form
- No skip tokens — use conditional components instead (skip still subscribes to the query)
- Derive data in leaf components with pure functions, not custom hooks that bundle derivations
- Delegate initialization, limits, and business rules to BE — FE renders what BE provides

**Component structure:**
- Composition over configuration — expose composable sub-components, not prop explosions
- Feature flags at top of component tree — branch into separate components, accept duplication
- Features as isolated systems — single entry point, internal routing logic
- Flat code structure — duplication is safer than nested shared abstractions
- Shared code must be atomic (one responsibility) and feature-agnostic; prefer duplication over wrong abstractions

**Types:**
- Union types for valid prop/return combinations — enforce with TypeScript narrowing, not optional fields
- Distinct values for distinct outcomes — never overload `null` to mean two things

**Working with existing code:**
- Don't add to bloated code — extract what you need into focused utilities, leave `@deprecated` on the old code
- Don't refactor bloated shared code (risk breaking consumers) — create new lean alternatives alongside it
