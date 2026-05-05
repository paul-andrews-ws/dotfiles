---
name: Schema publish chain — fort-knox → invest-graphql-api → FEM
description: Multi-hop sequence + monitoring channels for schema bumps reaching FEM
type: reference
originSessionId: 577d935d-64b7-4b06-99b2-668de970dc1b
---
When a backend schema change in fort-knox needs to reach FEM consumers, the
chain has 4 hops, each gated on the previous:

1. **fort-knox merge** → `Publish Graphql Schema` workflow publishes
   `@wealthsimple/ws-schemas-graphql-fort-knox@<new-version>` to npm. Watch
   `#deploys-fort-knox` for the deploy itself.
2. **`ws-graphql-schema-updater` opens a "Bump fort-knox to vX.Y.Z" PR in
   `wealthsimple/invest-graphql-api`** (branch:
   `update-ws-schemas-fort-knox-X.Y.Z`). This is where blockers live — the
   bump PR's Hive check validates the **whole federated schema**, so unrelated
   breaking changes from sibling subgraphs (account-services, crypto-service,
   etc.) appear and must be approved by their owning teams before this PR can
   merge.
3. **PR merge** → invest-graphql-api republishes
   `@wealthsimple/ws-schemas-graphql-invest-graphql-api@<...-update-ws-schemas-fort-knox-X-Y-Z-NNNNN>`.
   Watch `#deploys-edge` for invest-graphql-api staging+prod deploys (~5–10
   min each).
4. **Wolfbot opens an "Update GraphQL Shared Types" PR in FEM** that bumps
   `@wealthsimple/ws-schemas-graphql-invest-graphql-api` and regenerates
   `gql-generated`. Will fail CI until consumer code in FEM is updated to
   reference the new enum/types. Either bundle the consumer fix into that PR
   directly, or land a coordinated FEM PR alongside.

**Symptom of stale gateway during the gap**: client query returns
`INTERNAL_SERVER_ERROR` with `path: ["...", N, "<leaf>"]` pointing at the
specific field. Gateway has the old schema and coerces unknown enum values
to null, then fails non-null contract. Distinctive: it's NOT logged in
fort-knox Sentry — the gateway logs it (search `service:invest-graphql-api-web`
spans in Datadog instead).

**How to find the queue of pending bumps**:
- invest-graphql-api side: `gh pr list --repo wealthsimple/invest-graphql-api
  --state open --search "head:update-ws-schemas-fort-knox"`
- FEM side: `gh pr list --repo wealthsimple/front-end-monorepo --state open
  --author ws-wolfbot` (filter for "Update GraphQL Shared Types")

**Channel monitoring pointers**:
- `#deploys-fort-knox` — fort-knox staging/prod deploys
- `#deploys-edge` — invest-graphql-api + other edge-team service deploys
- `#edge-prs` — schema publish workflow owners (Kathryn) post here; ping when
  a bump PR is stuck
