---
name: Limits & allowances architecture (Wealthsimple Cash)
description: Tri-service pattern for any per-client limit, eligibility, or allowance at Wealthsimple — applies to e-transfer, withdrawals, deposits, etc.
type: reference
originSessionId: 61947b33-d8bf-4a17-945e-1b45af3422c0
---
Any time a Wealthsimple Cash feature asks "what's this client's limit / eligibility / allowance?", three repos collaborate:

1. **fort-knox** — *enforcement*. Owns the policy class (e.g. `ETransferCustomerPushTransactionPolicy`) and the per-identity DB row (e.g. `funding_methods_transaction_dynamic_limits`). Defaults live in `components/funding_methods/app/services/dynamic_limits/limit_types/transaction/public/constants.rb`. The checklist/policy consults `DynamicLimits::Transaction::LimitsApi#fetch_limits` at request time.

2. **risk-service** — *writer + eligibility registry*. Owns `limit_allowance_eligibilities`. Exposes GraphQL mutations (`FindOrCreateAllowanceEligibilities`, `TransactionAllowanceEligibilitiesEnforce`) consumed by the mobile client. Kafka consumer `DecisionMadeProcessor` turns decision-platform batch events into eligibility rows. Resolvers under `components/limit_allowance/app/domain/use_cases/resolvers/`.

3. **ws-decision-platform** — *decider*. Flink scenarios at `flink/core/src/main/resources/manifests/scenarios/` compute who qualifies. Each scenario has a `manifest.yaml` + `10-rules.sql`. Scenario manifests set the dollar amounts as templated env vars (`$ETRANSFER_SEND_DAILY_LIMIT`). **This is the only place the business rule for "who gets raised" actually lives** — not in Ruby.

**How to trace a limit end-to-end:**
- Find the fort-knox policy (search `Policies::*TransactionPolicy`).
- Find the risk-service resolver that writes it (`*AllowanceResolver`).
- Find the Flink scenario that decides eligibility (grep manifests for the relevant name).

**Key gotcha:** `create_real_time_assessment` in `*AllowanceResolver` often hardcodes the *default* limit and writes a row with `eligible: true`. That row passes the mobile eligibility check (`allowances.find(a => a.eligible)`) but doesn't actually raise anything. Only the weekly Flink batch writes raised amounts.

**Key gotcha:** Limits are keyed on `identity_canonical_id` + `fundable_type` + `direction`, not on account. If an identity owns both a personal and business Cash account, they share one pool.
