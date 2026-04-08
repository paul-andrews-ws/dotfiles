---
name: Sweep all test files when changing locale strings
description: When changing locale string values, grep for the old string across ALL test files in the package (not just the obvious ones) before committing
type: feedback
---

When changing locale string values (e.g. copy updates), always grep for the old string value across ALL test files in the affected packages before committing. Component tests, screen tests, and integration tests may all assert against the rendered text.

**Why:** During BB-766, updating locale strings required 3 fix-up commits because test assertions were missed in sibling test files (screen test, component-level tests). Each missed test was only caught by CI.

**How to apply:** After changing a locale string, run: `grep -r "old string value" libs/<package>/` across test files to find every assertion that needs updating. Do this before the first commit, not after CI fails.
