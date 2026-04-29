---
name: gh CLI run-view truncation — use check-run annotations instead
description: When gh run view --log-failed cuts off before showing the real CI error, fetch the check-run annotations API for the actual failure detail
type: feedback
originSessionId: 4f84d690-df7d-4949-9198-8a323dd8a58e
---
`gh run view <run_id> --log-failed` and `gh run view --job <job_id> --log-failed` sometimes truncate output before the actual error appears (observed when investigating GraphQL Hive failures — the log ended at `yarn info @graphql-hive/cli versions --json` with no further output, but the real failure was downstream).

**Why:** Burned time grepping for errors that weren't in the truncated log. The annotations API has them.

**How to apply:** When `gh run view --log-failed` doesn't show a clear cause, pivot to:

```bash
# Get the check-run id from gh pr checks (the URL has /job/<id> at the end)
gh api repos/<owner>/<repo>/check-runs/<job_id>/annotations \
  --jq '.[] | {level: .annotation_level, message}'
```

Annotations carry the actual failure messages, including ones that link to external systems (Hive, Sentry, etc.) where the full detail lives.

For just the summary (no per-line annotations):
```bash
gh api repos/<owner>/<repo>/check-runs/<job_id> --jq '.output | {title, summary, text}'
```

This pattern applies to any wealthsimple repo using GitHub Checks API — fort-knox, monolith, FEM all work the same way.
