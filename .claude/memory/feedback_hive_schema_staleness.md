---
name: GraphQL Hive schema staleness on long-lived branches
description: When wealthsimple-monolith Hive schema check fails on a branch with no GQL changes, the cause is usually staleness vs master — merge master to fix
type: feedback
originSessionId: 4f84d690-df7d-4949-9198-8a323dd8a58e
---
On the wealthsimple monolith, the `Publish Graphql Schema (wealthsimple) / Check and Publish GraphQL Schema` CI job validates the branch's schema against Hive. A long-lived branch can fail this check even when it makes **zero** GraphQL changes, because master has added GraphQL fields that the branch is "missing" → Hive treats the branch's schema as removing fields that exist in production.

**Why:** The annotation reads "Unhandled error: Schema validation failed" — misleadingly generic, doesn't say "stale vs master." Resolving by merge instead of re-running saved a debugging detour.

**How to apply:** When Hive flags a PR that didn't touch any `app/graphql/**` or `**/*.graphql` files:

1. Confirm `git diff origin/master -- spec/graphql/schema_snapshot.graphql` is empty (you didn't touch it)
2. Confirm a recent unrelated PR has the same job green (rules out infra-wide outages):
   ```bash
   gh pr view <recent-pr-num> --json statusCheckRollup --jq '.statusCheckRollup[] | select(.name | contains("Check and Publish GraphQL"))'
   ```
3. If both true, merge master into the branch. The merge brings in the new GraphQL types from master; CI re-runs and goes green.

A simple re-trigger of the job WITHOUT merging master will NOT fix this — it's a real (if weirdly framed) breaking-change signal, not a flake.

`gh run view --log-failed` truncates the failure log before the actual Hive output. Use the annotations API instead:
```bash
gh api repos/wealthsimple/wealthsimple/check-runs/<job_id>/annotations
```
