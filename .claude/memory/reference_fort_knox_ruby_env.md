---
name: Fort-knox Ruby environment for Claude Bash tool
description: How to get Ruby/bundler working in Claude's Bash tool for fort-knox commits and commands
type: reference
---

Fort-knox requires a specific Ruby version (check `.tool-versions`). Claude's Bash tool doesn't have mise activated by default.

**For Ruby commands**: Use mise shims path:
```bash
export PATH="/Users/paul.andrews/.local/share/mise/shims:$PATH"
```

**For git commits**: The `graphql-snapshot` lefthook pre-commit hook runs `bundle exec graphql_schema_snapshot_git_hook`. This requires:
1. The correct Ruby version installed via mise (`mise install` in fort-knox dir)
2. `mise trust` for the fort-knox `.tool-versions`
3. `bundle install` completed for that Ruby version

If `bundle install` hasn't been run for the current Ruby version, ask the user to run `! bundle install` from their terminal — it's too heavy to run in Claude's Bash tool from scratch.
