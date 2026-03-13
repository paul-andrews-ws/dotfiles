---
name: React hooks style preferences
description: Coding style rules for React hooks — no superfluous try/catch, no premature useCallback memoization
type: feedback
---

**No superfluous try/catch blocks.** If the catch clause does nothing (empty or comment-only), remove the entire try/catch and let the call be direct.

**Why:** Empty catches hide errors and add noise without providing value. The code should be honest about what can fail.

**How to apply:** Only use try/catch when the error is meaningfully handled (logged, fallback applied, user notified). Don't wrap calls "just in case."

---

**No premature `useCallback` memoization.** Don't wrap setter functions or inexpensive logic in `useCallback` unless there's a demonstrated performance reason (e.g. the function is a dep of a `useEffect`, or is passed to a `React.memo` component that would otherwise re-render unnecessarily).

**Why:** `useCallback` adds complexity and cognitive overhead. For cheap logic like setState wrappers, React's own reconciliation is sufficient. Over-memoization gets in the way.

**How to apply:** Default to plain `function` declarations inside hooks. Add `useCallback` only when profiling or a concrete re-render problem warrants it.
