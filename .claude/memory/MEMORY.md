# Memory

## Workflow Feedback

- Always wait for explicit user approval before committing and pushing. User QA tests changes on their local web build first.
- [Worktree preference for FEM](feedback_worktree_preference.md) — skip worktree for single-task FEM work; check out branch in main repo directly

## Coding & Architecture Feedback

- [Feature-flagged widget patterns](feedback_onboarding_checklist_patterns.md) — V0/V1 wrappers, gate hooks behind flags, generic components via props, entrypoint nav pattern
- [Code style from PR reviews](feedback_code_review_patterns.md) — inline values over constants files, FR locale literal chars (except ')
- [React hooks style](feedback_react_hooks_style.md) — no superfluous try/catch, no premature useCallback/useMemo memoization
- [Avoid skipToken](feedback_avoid_skiptoken.md) — split into data-gate parent + unconditional hook child per Vlad's guide
- [Avoid duplicate typename checks](feedback_avoid_duplicate_typename_checks.md) — extract GQL union narrowing once, don't repeat __typename checks
- [Throw guards over silent fallbacks](feedback_throw_guards_over_silent_fallbacks.md) — throw on unexpected GQL union results, don't silently fall back to defaults
- [Agnostic components](feedback_agnostic_components.md) — shared UI inputs must not depend on form context; accept value/onChange props, caller wraps in Controller
- [Tap-tracked refetch on return](feedback_tap_tracked_refetch_pattern.md) — for screens that stay mounted under modals/pushed screens, gate refetch on a ref flipped in action `onPress` rather than refetching on every focus

## Testing Feedback

- [Mobile testing patterns](feedback_testing_patterns_mobile.md) — FeatureFlag.initialize over mocking, MSW over gql-sdk mocks, getMockProviderStack for DS components
- [MSW in RN test environment](feedback_msw_rn_test_environment.md) — MSW doesn't work in RN jest env; use jsdom + @testing-library/react + getMockApolloProvider
- [MMKV testing patterns](feedback_mmkv_testing_patterns.md) — built-in mock for renderHook, comprehensive module mock for component tests with deep dep trees
- [Mobile analytics SDK mocking](feedback_mobile_analytics_mocking.md) — jest.mock `@wealthsimple/mobile-analytics` is the accepted pattern; no MSW equivalent
- [Sweep tests on locale changes](feedback_locale_string_test_sweep.md) — grep old string values across ALL test files before committing copy updates
- [useFocusEffect test mocking](feedback_use_focus_effect_test_mocking.md) — mocking `useNavigation` alone isn't enough; `useFocusEffect` internally calls `useNavigation` from `@react-navigation/core` and bypasses the mock

## front-end-monorepo: Tooling & Environment

- [Nx project naming + single-file coverage gotcha](feedback_fem_nx_project_naming.md) — `-mobile` (packages/) vs `-mobile-screen` (screens/) suffixes; single-file test runs trip coverage threshold
- [FEM git & environment setup](reference_fem_git_env.md) — pnpm PATH for git hooks, worktree naming + mobile-build setup, branch naming, dead-code detection

## front-end-monorepo: GQL SDK

- [New package gotchas](feedback_gql_sdk_new_package_gotchas.md) — CODEOWNERS prefix bug, unimported allowlist, union mock __typename, Nx daemon cache reset
- [gql-generated scope creep](feedback_gql_generated_scope_creep.md) — regenerating gql-generated picks up unrelated schema changes; revert unless new base types are needed
- [SDK test-utils MSW v2 regen](feedback_sdk_test_utils_msw_regen.md) — newly created SDK packages may have stale MSW v1 test-utils; regenerate with gql-generate
- [gql-sdk-core fetchPolicy override on focus](feedback_gql_sdk_focus_policy_override.md) — internal useFocusEffect force-restores fetchPolicy to cache-first on re-focus; cache-and-network won't survive a blur/focus cycle
- [Schema publish chain to FEM](feedback_schema_publish_chain.md) — fort-knox → invest-graphql-api bump PR → FEM gql-generated bump; channel & PR queue refs; gateway-mismatch INTERNAL_SERVER_ERROR symptom

## Projects

- **front-end-monorepo**: `/Users/paul.andrews/Repos/front-end-monorepo`
- **fort-knox**: `/Users/paul.andrews/Repos/fort-knox`
- **wealthsimple**: `/Users/paul.andrews/Repos/wealthsimple`

## fort-knox: Environment

- [Ruby env for Claude Bash tool](reference_fort_knox_ruby_env.md) — mise shims, bundle install, graphql-snapshot hook requirements, DB setup

## wealthsimple monolith: Environment & Tooling

- [Wealthsimple monolith env for Bash tool](reference_wealthsimple_monolith_env.md) — ruby PATH + .env.development sourcing required for every bundle/rails/rubocop call
- [Maintenance task system](reference_wealthsimple_maintenance_tasks.md) — gem setup, staging/prod UI URLs, Sidekiq execution, Datadog log search, update_columns backfill convention
- [Strong Migrations + change_table](feedback_strong_migrations_change_table.md) — use add_column not change_table; SM refuses to introspect change_table blocks
- [GraphQL Hive schema staleness](feedback_hive_schema_staleness.md) — long-lived branches with no GQL changes can still fail Hive; merge master to bring in new fields, re-run alone won't fix
- [Monolith → fort-knox event chain](reference_monolith_to_fort_knox_event_chain.md) — Pheme handler → EventBus listener → worker → use case; trace via Sourcegraph before claiming an event publisher is "no consumers"

## notification-service

- [Repo overview](reference_notification_service.md) — 5-piece template pattern, Braze-vs-SendGrid routing, EMAIL_MIGRATION_EXCEPTION_TEMPLATES gate, staging maintenance task, Taxi quick ref

## Tools & Integrations

- [JIRA ticket creation via MCP Locker](reference_jira_ticket_creation.md) — mcplocker auth, BB project template with info panels, custom field IDs
- [Parallel Sourcegraph subagents for cross-repo research](feedback_sourcegraph_parallel_research.md) — split question into facets, dispatch parallel agents with SG MCP, load deferred schemas via ToolSearch first
- [gh CLI log truncation workaround](feedback_gh_log_truncation.md) — when gh run view --log-failed cuts off before the real CI error, use check-run annotations API instead

## Wealthsimple Cash: Architecture

- [Limits & allowances tri-service pattern](reference_limits_allowances_architecture.md) — fort-knox enforces, risk-service writes eligibility rows, ws-decision-platform Flink decides who qualifies

