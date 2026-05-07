---
name: PR Takeover Intake Process
description: How to approach taking over an existing PR (especially AI-generated ones) — review-first before acting
type: feedback
originSessionId: f737c373-296f-4a93-b42f-4ab9c619f367
---
Do a full intake review before touching any code. This PR (corporation-dash / #69601) was a lesson: we jumped into resolving existing reviewer comments without first doing our own independent code review, which meant we missed improvements that reviewers caught in subsequent rounds.

**Why:** AI-generated PRs often have valid logic but miss repo conventions, architectural patterns, unnecessary abstractions, and duplication. Reviewer comments are also usually batched — missing the first pass leads to multiple costly iteration rounds.

**How to apply:** When taking over any PR that has AI-authorship or was developed without you:

1. **Read the PR description and all existing review comments first** — understand what reviewers already flagged and what's in-flight.
2. **Do your own independent code review pass** before addressing any comments:
   - Check for module boundary violations (`scope:web` in `scope:shared-front-end` packages, page importing from page, etc.)
   - Look for duplicated utilities or types that belong in a shared package
   - Check for unnecessary abstractions, prop drilling the full object when only fields are needed
   - Verify test coverage, lint, types, dead code detection
   - Assess whether the PR should be killed/rebased vs. iterated on
3. **Propose a plan to the user** before starting work: list the improvements you'd make beyond just addressing existing comments, and flag anything structurally wrong.
4. **If the branch is stale**: merge main first before touching code — resolve conflicts, verify CI, then iterate.
5. **If the PR is very large**: consider whether to break it into independent commits or PRs, or whether the scope should be narrowed before merging.

**Key signal for "needs structural review":** If the PR was opened by AI (Claude co-author) with little human review, treat the whole codebase as a first draft. Common issues: over-engineering, missing shared package extraction, wrong module boundary, test helpers hand-rolled instead of using SDK mocks.
