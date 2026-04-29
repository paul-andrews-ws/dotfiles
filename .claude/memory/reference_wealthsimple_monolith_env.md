---
name: Wealthsimple monolith env for Bash tool
description: Ruby PATH + .env.development sourcing required for any bundle/rails/rubocop command via Claude's Bash tool in /Users/paul.andrews/Repos/wealthsimple
type: reference
originSessionId: 4f84d690-df7d-4949-9198-8a323dd8a58e
---
The wealthsimple monolith uses mise + direnv. Direnv auto-loads `.env.development` in the user's shell, but the Bash tool inherits neither mise's shims nor direnv's env vars. Every Ruby/Rails/RuboCop command needs both manually:

```bash
export PATH="/Users/paul.andrews/.local/share/mise/installs/ruby/3.3.9/bin:$PATH"
set -a
source /Users/paul.andrews/Repos/wealthsimple/.env.development
set +a
bundle exec rails db:migrate    # or rubocop, rspec, etc.
```

(Update the ruby version in the path if `mise.toml` changes — check `cat mise.toml`.)

Without the PATH export, system Ruby 2.6 gets used and bundler fails immediately. Without the env sourcing, `KeyError: key not found: "APP_ENV"` aborts before any work happens.

When master adds new gems (frequent), `bundle install` is needed before the next `db:migrate` or `bundle exec` call — error is `Bundler::GemNotFound`.

Pre-commit hooks (gitleaks, optionally graphql_schema_snapshot_git_hook) need ruby on PATH for `git commit` too. The graphql snapshot hook only triggers on `**/graphql/**.rb` glob — pure migration commits skip it.

Mirror of the same pattern in `reference_fort_knox_ruby_env.md`. The wealthsimple-specific differences: ruby version, lefthook (not git-hooks-via-husky), `.env.development` instead of `.envrc.private`.
