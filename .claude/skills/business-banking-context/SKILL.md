---
name: business-banking-context
description: Use when working on Business Banking, Business Chequing, Fort-Knox, or corporate account features at Wealthsimple
---

# Business Banking Context

## Overview

This skill loads comprehensive Business Banking architecture context when working on Business Banking features, including Business Chequing accounts, Fort-Knox integration, payment rails, and corporate account functionality.

## When to Use

**Automatically invoke this skill when:**
- User mentions "Business Banking" or "Business Chequing"
- Working in Fort-Knox repository
- Working on corporate account features
- Discussing payment rails for business accounts
- Questions about Business Banking architecture

## Architecture Documentation

**Primary Reference:** `~/Repos/Sandbox/READMEs/BUSINESS_BANKING_ARCHITECTURE.md`

This comprehensive document includes:
- Business Chequing account architecture
- Account modeling (BUSINESS_CHEQUING → ca_cash_corporate)
- Frontend architecture (React web + React Native mobile)
- Backend services (Fort-Knox, Balance Service, microservices)
- Database architecture (multi-capsule PostgreSQL)
- Money movement & payment rails
- Communication patterns (REST, GraphQL, Kafka)
- Code references and file paths

**Diagrams:** `~/Repos/Sandbox/Diagrams/BUSINESS_BANKING_DIAGRAMS.md`

10 Mermaid diagrams covering:
- Complete system architecture
- Frontend architecture
- Backend services
- Database architecture
- Data flow examples (deposits, balance queries)
- Service communication patterns
- Fort-Knox internal architecture
- Event-driven architecture
- Authentication flows
- Multi-capsule Balance Service

## Quick Context Loading

When this skill is invoked, read the architecture documentation:

```
Read ~/Repos/Sandbox/READMEs/BUSINESS_BANKING_ARCHITECTURE.md
```

If diagrams are relevant to the conversation:

```
Read ~/Repos/Sandbox/Diagrams/BUSINESS_BANKING_DIAGRAMS.md
```

## Key Architectural Facts

**Current Status (as of Jan 2026):**
- 15 production clients in closed beta
- ~$1.8MM AUM
- Team: @wealthsimple/business-banking-eng

**Primary Systems:**
- **Fort-Knox** (Rails 8.0 modular monolith) - Core banking service
- **Balance Service** (4 capsules: MAIN, INVEST, CRYPTO, **CASH** - Business Chequing uses CASH)
- **Front-end-monorepo** (React web + React Native mobile)
- **Wealthsimple Monolith** (Accounts, Permissions, Requirements)

**Account Type:**
- Unified Type: `BUSINESS_CHEQUING`
- Legacy Type: `ca_cash_corporate`
- Product Line: `corporate`
- Owner: Corporation entity (not individual)

**Payment Rails Supported:**
- ✅ EFT (deposits/withdrawals) - $1M limits
- ✅ Internal Transfers (personal ↔ business)
- ✅ e-Transfer (auto-deposit for receiving)
- ✅ Bill Pay (including CRA corporate tax) - $250K limit
- ✅ Cheques & Bank Drafts
- ✅ Wires (to/from)

## Updating Documentation Workflow

When Business Banking architecture changes:

1. **Update the source documentation:**
   ```bash
   # Edit the markdown files
   code ~/Repos/Sandbox/READMEs/BUSINESS_BANKING_ARCHITECTURE.md
   code ~/Repos/Sandbox/Diagrams/BUSINESS_BANKING_DIAGRAMS.md
   ```

2. **Commit and push changes:**
   ```bash
   cd ~/Repos/Sandbox
   git add READMEs/ Diagrams/
   git commit -m "Update Business Banking architecture: [description]"
   git push
   ```

3. **Context automatically updated** - Next time this skill loads, it will read the updated files

## Integration with Repos

**Recommended:** Create CLAUDE.md files in working repositories:

**For `front-end-monorepo`:**
```markdown
# Business Banking Frontend

See comprehensive architecture docs:
~/Repos/Sandbox/READMEs/BUSINESS_BANKING_ARCHITECTURE.md

Key Business Banking packages:
- libs/all/business-banking-prepaid-card/
- libs/shared/packages/corporate-chequing-utils/
- libs/all/cross-platform-ui/xp-corporate-accounts/
```

**For `fort-knox`:**
```markdown
# Fort-Knox Business Banking

See comprehensive architecture docs:
~/Repos/Sandbox/READMEs/BUSINESS_BANKING_ARCHITECTURE.md

Business Chequing account type: ca_cash_corporate
Payment rail policies: components/funding_methods/app/payment_rails/
```

**For `wealthsimple` (monolith):**
```markdown
# Business Banking Accounts & Permissions

See comprehensive architecture docs:
~/Repos/Sandbox/READMEs/BUSINESS_BANKING_ARCHITECTURE.md

Key files:
- components/accounts/data/account_types.yml (BUSINESS_CHEQUING definition)
- components/permissions_engine/data/allowed_actions_config.yml
```

## Common Questions & Quick Answers

**Q: What account type does Business Chequing use?**
A: Unified type `BUSINESS_CHEQUING`, legacy type `ca_cash_corporate`, product line `corporate`

**Q: Which Balance Service capsule stores Business Chequing balances?**
A: The **CASH capsule** (`balance_service_cash`)

**Q: How do I add support for a new payment rail?**
A:
1. Add `ca_cash_corporate` to the rail's policy `supported_account_combinations`
2. Add action to permissions config for `BUSINESS_CHEQUING`
3. That's it! Most rails work without custom logic.

**Q: What's special about CRA corporate tax payments?**
A: They ONLY work with `ca_cash_corporate` accounts and require additional metadata (phone_number, pertinent_date)

**Q: Where is the Business Chequing frontend code?**
A:
- Web: `front-end-monorepo/apps/web/retail/`
- Mobile: `front-end-monorepo/apps/mobile/retail/`
- Shared: `front-end-monorepo/libs/all/business-banking-*/`

## Usage Examples

**Example 1: Working on Fort-Knox payment rail**
```
User: "I need to add wire transfer support for Business Chequing"
Assistant: [Loads this skill → Reads architecture docs]
"Based on the Business Banking architecture, here's how to add wire support..."
[References specific file paths and code examples from documentation]
```

**Example 2: Frontend work**
```
User: "Where should I add a new Business Chequing feature in the web app?"
Assistant: [Loads this skill → Reads architecture docs]
"Business Banking web features go in front-end-monorepo. Here's the structure..."
[Shows FEMR folder organization from docs]
```

**Example 3: Monthly update**
```
User: "We just shipped USD accounts for Business Chequing. Update the docs."
Assistant: [Loads this skill]
"Let me read the current documentation and update it with USD account support..."
[Reads docs → Makes updates → Commits to Sandbox repo]
```

## Critical Files to Know

**Account Definition:**
- `wealthsimple/components/accounts/data/account_types.yml:839`

**Payment Rail Policies (Fort-Knox):**
- `components/funding_methods/app/payment_rails/eft_bank_account/domain/policies/*`
- `components/funding_methods/app/payment_rails/online_bill_pay/domain/policies/*`
- `components/funding_methods/app/payment_rails/ws_bank_account/cheque/domain/policies/*`

**Permissions:**
- `wealthsimple/components/permissions_engine/data/allowed_actions_config.yml`

**Frontend:**
- `front-end-monorepo/libs/shared/packages/account-types/`
- `front-end-monorepo/libs/shared/packages/corporate-chequing-utils/`

---

## Implementation Notes

This skill is designed to be:
- **Self-updating**: Reads from documentation files, so updates to docs automatically update context
- **Lightweight**: Doesn't store the full documentation in the skill itself
- **Reference-based**: Points to the authoritative documentation source
- **Workflow-enabled**: Includes instructions for updating documentation

When invoked, always start by reading the latest documentation to ensure current information.