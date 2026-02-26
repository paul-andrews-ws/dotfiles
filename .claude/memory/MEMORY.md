# Memory

## Pre-Commit Checklist

Before committing any changes in the front-end-monorepo, always run lint and type checks on the affected project:

```bash
pnpm nx run <project>:lint
pnpm nx run <project>:check-types
```

Or for all affected projects:

```bash
pnpm nx affected --target=lint,check-types
```
