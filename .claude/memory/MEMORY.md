# Memory

## Workflow
- Wait for explicit user approval before commit/push; user QAs local web first
- [Worktree preference for FEM](feedback_worktree_preference.md) — skip worktree for single-task FEM; branch in main repo
- [PR takeover intake](feedback_pr_takeover_intake.md) — review-first; own code-review pass, check modules/duplication, plan before code
- [Branch off origin/main in stacked worktrees](feedback_stacked_worktree_branch_origin.md) — "pull latest main" is literal; local branch may carry pre-squash commits from merged ancestor

## Coding & Architecture
- [Feature-flagged widget patterns](feedback_onboarding_checklist_patterns.md) — V0/V1 wrappers, gate hooks behind flags, generic via props
- [Code style from PR reviews](feedback_code_review_patterns.md) — inline values over constants; FR locale: literal accented chars but apostrophes as ’ escape
- [React hooks style](feedback_react_hooks_style.md) — no superfluous try/catch; no premature useCallback/useMemo
- [Avoid skipToken](feedback_avoid_skiptoken.md) — split into data-gate parent + unconditional hook child (Vlad's guide)
- [Avoid duplicate typename checks](feedback_avoid_duplicate_typename_checks.md) — extract GQL union narrowing once
- [Throw guards over silent fallbacks](feedback_throw_guards_over_silent_fallbacks.md) — throw on unexpected GQL union, don't default
- [Agnostic components](feedback_agnostic_components.md) — shared UI inputs take value/onChange; caller wraps in Controller
- [Tap-tracked refetch on return](feedback_tap_tracked_refetch_pattern.md) — gate refetch on action `onPress` ref, not focus event

## Testing
- [Mobile testing patterns](feedback_testing_patterns_mobile.md) — FeatureFlag.initialize, MSW over gql-sdk mocks, getMockProviderStack
- [MSW in RN test env](feedback_msw_rn_test_environment.md) — broken in RN jest; use jsdom + getMockApolloProvider
- [MMKV testing](feedback_mmkv_testing_patterns.md) — built-in mock for renderHook; full module mock for deep dep trees
- [Mobile analytics mocking](feedback_mobile_analytics_mocking.md) — jest.mock `@wealthsimple/mobile-analytics`; no MSW equivalent
- [Locale string test sweep](feedback_locale_string_test_sweep.md) — grep old values across ALL test files before copy updates
- [useFocusEffect mocking](feedback_use_focus_effect_test_mocking.md) — also mock `@react-navigation/core`; useNavigation mock alone leaks

## FEM: Architecture
- [FEMR package structure](reference_femr_package_structure.md) — libs/all/{core,web,mobile}; extract at 2+ consumers; pages never import pages

## FEM: Tooling
- [Nx project naming + coverage gotcha](feedback_fem_nx_project_naming.md) — `-mobile` vs `-mobile-screen`; single-file test trips coverage
- [FEM git & env](reference_fem_git_env.md) — pnpm PATH for hooks, worktree+mobile-build setup, branch naming, dead-code
- [FEM Hive token in 1Password](reference_fem_hive_token.md) — use `[hive] Org-level Token | Staging + Production`, NOT the deprecated "Read-only Org-level token" entry

## FEM: GQL SDK
- [New package gotchas](feedback_gql_sdk_new_package_gotchas.md) — CODEOWNERS prefix bug, unimported allowlist, union mock __typename, Nx daemon
- [gql-generated scope creep](feedback_gql_generated_scope_creep.md) — regen pulls unrelated schema; revert unless new base types
- [gql-config: never regen for additive work](feedback_fem_gql_config_no_regen.md) — produces 100k+ lines of unrelated churn; skip the generator's "next step" hint
- [SDK test-utils MSW v2 regen](feedback_sdk_test_utils_msw_regen.md) — new SDKs may ship stale MSW v1 test-utils; regen
- [gql-sdk-core fetchPolicy on focus](feedback_gql_sdk_focus_policy_override.md) — internal useFocusEffect resets to cache-first on re-focus
- [Schema publish chain](feedback_schema_publish_chain.md) — fort-knox → invest-graphql-api bump → FEM gql-generated; gateway-mismatch=500
- [IGQL gateway allow-list](reference_igql_gateway_allow_list.md) — wealthsimple subgraph fields/mutations filtered by allow-lists in invest-graphql-api; pair BE PR with gateway allow-list PR
- [IGQL npm dist-tags](reference_igql_npm_dist_tags.md) — `@master` is the gateway-current tag; `@latest` is unreliable. Manual master-unpack when Hive falls through.
- [Cross-type cache.modify in mutation hook](feedback_fem_cross_type_cache_modify_in_hook.md) — bake into hook, not call site, when BE returns primitives or modifies sibling entities

## Repos
- front-end-monorepo: `~/Repos/front-end-monorepo` · fort-knox: `~/Repos/fort-knox` · wealthsimple: `~/Repos/wealthsimple`

## fort-knox
- [Ruby env for Bash](reference_fort_knox_ruby_env.md) — mise shims, bundle install, graphql-snapshot hook, DB setup

## wealthsimple monolith
- [Env for Bash](reference_wealthsimple_monolith_env.md) — ruby PATH + .env.development sourcing for every bundle/rails/rubocop
- [Maintenance tasks](reference_wealthsimple_maintenance_tasks.md) — gem setup, staging/prod URLs, Sidekiq, Datadog, update_columns
- [Strong Migrations + change_table](feedback_strong_migrations_change_table.md) — use add_column; SM refuses change_table blocks
- [GraphQL Hive schema staleness](feedback_hive_schema_staleness.md) — long branches w/o GQL changes still fail; merge master to fix
- [Monolith → fort-knox event chain](reference_monolith_to_fort_knox_event_chain.md) — Pheme→EventBus→worker→use case; trace SG first

## notification-service
- [Repo overview](reference_notification_service.md) — 5-piece template, Braze/SendGrid routing, EMAIL_MIGRATION_EXCEPTION_TEMPLATES, Taxi
- [Dispatch chain](reference_notification_service_dispatch.md) — template_name→YAML→Braze UUID; Taxi exports manually, no code sync
- [Required-metadata validation gap](reference_notification_service_required_metadata.md) — Kafka skips form.valid?; missing required → DLQ

## Tools & Integrations
- [JIRA ticket creation](reference_jira_ticket_creation.md) — mcplocker auth, BB template, custom field IDs
- [Parallel SG subagents](feedback_sourcegraph_parallel_research.md) — split into facets, dispatch parallel, load deferred schemas first
- [gh CLI log truncation](feedback_gh_log_truncation.md) — when --log-failed cuts off, use check-run annotations API

## Wealthsimple Cash
- [Limits & allowances tri-service](reference_limits_allowances_architecture.md) — fort-knox enforces, risk-service writes, decision-platform Flink decides
