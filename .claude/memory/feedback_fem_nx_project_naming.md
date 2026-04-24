---
name: FEM Nx project naming conventions
description: Project names for libs under screens/ vs packages/, and the single-file-coverage false-fail
type: feedback
originSessionId: dc2f991d-4b13-4da9-9cac-35e5ca51b589
---
**Project name suffixes differ by directory:**

- `libs/mobile/packages/<name>/` → project name `<name>-mobile` (e.g. `cash-dashboard-components-mobile`, `stack-params-mobile`, `unified-limit-management-mobile`)
- `libs/mobile/screens/<name>/` → project name `<name>-mobile-screen` (e.g. `unified-limit-management-mobile-screen`, `deposit-automations-mobile-screen`)

**Why this matters:** The same display name can exist in both `packages/` and `screens/`. Running `pnpm nx run <name>-mobile:test` when your code change is in `screens/` will execute a totally different test suite and silently pass. Always confirm by reading the `project.json` for the directory you touched.

**How to apply:** Before running `nx` commands, check `head -3 libs/mobile/<packages|screens>/<dir>/project.json` to confirm the project name.

---

**Single-file test runs trip the coverage threshold:**

`pnpm nx run <project>:test --test-file=<path>` may FAIL with `Insufficient test coverage` / `global coverage threshold for lines (60%) not met` even when every test passes. This is because coverage is calculated across the whole project but only one file is being exercised.

**How to apply:** When running a single file, treat `Tests: N passed, N total` as the source of truth and ignore the coverage FAIL. To confirm nothing else broke, re-run the full project test suite without `--test-file`.
