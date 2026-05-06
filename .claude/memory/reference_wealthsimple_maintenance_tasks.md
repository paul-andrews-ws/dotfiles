---
name: Wealthsimple maintenance task system
description: How maintenance_tasks gem works end-to-end in the monolith — UI URLs, Sidekiq execution, Datadog log search, update_columns backfill convention
type: reference
originSessionId: 929f6984-b50a-4986-b0cc-5507a4e1f7cf
---
## Gem & Location

- Shopify `maintenance_tasks` gem (~> 2.14)
- Task files: `app/tasks/maintenance/` — inherit from `MaintenanceTasks::Task`, namespaced under `module Maintenance`
- Spec files: `spec/tasks/maintenance/` (mirror source structure)
- Mounted at `/maintenance_tasks`, gated by `Routing::AdminConstraint`

## UI URLs

- Staging: `staging.wealthsimple.com/maintenance_tasks`
- Production: `my.wealthsimple.com/maintenance_tasks`

## How Tasks Run

Tasks execute as **Sidekiq jobs** (not in the web process). The UI shows progress count and status. `Rails.logger` output does NOT appear in the UI — it goes to Datadog only.

## Datadog Log Search

Search by class name: `@class:"Maintenance::YourTaskName" env:production`

- Staging service: `wealthsimple-sidekiq-within-1-second`
- Production service: `wealthsimple`

## Task Shapes

- `collection` + `process(record)` — iterates AR scope; per-record progress, resume on failure, idempotent
- `csv_collection` + `process(row)` — admin uploads CSV
- `no_collection` + `process` — single-shot

## update_columns for Backfills

Use `update_columns` instead of `update!` in backfill tasks. `update_columns` bypasses:
- Model validations
- All callbacks (before_save, after_update_commit, etc.)
- PaperTrail versioning
- `updated_at` bump

Trade-off: no audit trail, no timestamp update. CDC/WAL streams still see the SQL UPDATE.
`update!` runs all of the above — risky in backfills if other fields have stale data that fails validation.

## One-Off Task Convention

1. Write task + spec, open PR, merge, deploy
2. Dry-run on staging (check Datadog for log entries confirming scope)
3. Run for real on staging
4. Dry-run on production, then run for real
5. Open follow-up PR to delete the task file and spec
