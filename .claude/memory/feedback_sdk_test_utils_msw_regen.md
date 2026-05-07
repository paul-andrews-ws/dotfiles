---
name: Regenerate SDK test-utils for MSW v2 compatibility
description: Newly created GQL SDK packages may have MSW v1 generated test-utils that fail at runtime — regenerate to fix
type: feedback
---

When a new GQL SDK package is created, the generated `test-utils/generated.ts` may use stale MSW v1 APIs (`ResponseResolver`, `GraphQLRequest`, `GraphQLContext`) while the hand-written mock uses MSW v2 (`HttpResponse`). This causes runtime failures: "Cannot read properties of undefined (reading 'method')".

**Why:** The codegen plugin version at generation time may have been older, or the schema wasn't available when the package was first scaffolded.

**How to apply:** Fix by regenerating:
1. Ensure `.ws-schemas/` has the latest schema (see `reference_ws_schemas_update.md`)
2. Run `pnpm nx run <gql-sdk-package>:gql-generate`
3. Verify the SDK's own test passes: `pnpm nx run <gql-sdk-package>:test`

Signs of the issue: MSW v1 imports (`ResponseResolver`, `GraphQLRequest`, `GraphQLContext`) in `test-utils/generated.ts` alongside MSW v2 usage (`HttpResponse`) in the hand-written mock file.
