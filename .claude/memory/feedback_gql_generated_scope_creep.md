---
name: gql-generated regeneration scope creep risk
description: Running gql-generated:gql-generate picks up ALL schema changes, not just the ones relevant to your PR — revert unless you need new base types
type: feedback
---

Running `pnpm nx run gql-generated:gql-generate` regenerates `libs/shared/packages/gql-generated/src/index.ts` against the full downloaded schema. It will pick up every schema addition from other teams since the last time it was regenerated in main — new enum values, new input types, etc.

**Why this matters:** New enum values on existing enums (e.g. `OrderServiceOrderClass`, `PositionSecurityType`) can break type checks in packages that do exhaustive switch statements. You'd be responsible for fixing those in your PR.

**How to apply:**
- After running `gql-generated:gql-generate`, check `git diff --stat` to see how many lines changed
- If the diff is large (hundreds of lines) and contains changes unrelated to your feature, revert: `git checkout -- libs/shared/packages/gql-generated/src/index.ts`
- The automated `update-gql-generated-types` GitHub Action handles syncing gql-generated on its own schedule
- Only keep the changes if your query requires new base types (enums/scalars/inputs) that aren't in gql-generated yet — verify by checking if your codegen errors without them
