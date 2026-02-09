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

**Primary Reference:** [Architecture Overview: Business Chequing (Notion)](https://www.notion.so/wealthsimple/Architecture-Overview-Business-Chequing-2e641167bd968143bba5df0f97a16065)

When this skill is invoked, fetch the Notion document to get the latest architecture context:

```
mcp__notion__notion-fetch(id: "https://www.notion.so/wealthsimple/Architecture-Overview-Business-Chequing-2e641167bd968143bba5df0f97a16065")
```

The Notion document covers:
- Business Chequing account architecture & modelling
- Account type definition (BUSINESS_CHEQUING → ca_cash_corporate)
- Entity Graph & ownership configuration
- Money movement & payment rails (EFT, e-Transfer, wires, cheques, bill pay)
- Ledger sync & dual custodian posting flow
- Frontend architecture (FEMR folder organization)
- Build vs buy decision framework
- Key code references and file paths

## Codebase Context via Sourcegraph

After loading the Notion document, use the Sourcegraph MCP tools to search for additional context in the relevant repositories:

**Repositories to search:**
- `github.com/wealthsimple/front-end-monorepo` — React web + React Native mobile frontend
- `github.com/wealthsimple/fort-knox` — Core banking Rails monolith (payment rails, funding methods)
- `github.com/wealthsimple/wealthsimple` — WS monolith (accounts, permissions, requirements engine)

**Example searches depending on the task:**

```
# Find business chequing related code in fort-knox
mcp__sourcegraph__sg_keyword_search(query: "repo:^github.com/wealthsimple/fort-knox$ ca_cash_corporate")

# Find business chequing frontend packages
mcp__sourcegraph__sg_keyword_search(query: "repo:^github.com/wealthsimple/front-end-monorepo$ corporate-chequing")

# Find account type definition in monolith
mcp__sourcegraph__sg_keyword_search(query: "repo:^github.com/wealthsimple/wealthsimple$ BUSINESS_CHEQUING")

# Semantic search for business banking patterns
mcp__sourcegraph__sg_nls_search(query: "repo:^github.com/wealthsimple/fort-knox$ business chequing payment rail policy")

# Find specific symbol definitions
mcp__sourcegraph__sg_go_to_definition(repo: "github.com/wealthsimple/fort-knox", path: "...", symbol: "...")

# Find references to understand usage patterns
mcp__sourcegraph__sg_find_references(repo: "github.com/wealthsimple/wealthsimple", path: "...", symbol: "...")
```

Use Sourcegraph to:
- Look up current file paths and code when Notion references may be stale
- Find related code across repos when implementing new features
- Understand how existing payment rails are configured before adding new ones
- Trace code flow across services (e.g., fort-knox → kafka → wealthsimple)

## Key Architectural Facts

**Account Type:**
- Unified Type: `BUSINESS_CHEQUING`
- Legacy Type: `ca_cash_corporate`
- Product Line: `corporate`
- Owner: Corporation entity (not individual)
- Features: CASH (fundamental), SPEND (default)

**Primary Systems:**
- **Fort-Knox** (Rails modular monolith) - Core banking service, payment rails, funding methods
- **Wealthsimple Monolith** - Accounts, Permissions Engine, Requirements Engine, Entity Graph
- **Front-end-monorepo** (React web + React Native mobile) - Shared components with personal banking
- **Balance Service** (CASH capsule) - Business Chequing balances

**Payment Rails Supported:**
- EFT (deposits/withdrawals)
- Internal Transfers (personal <-> business)
- e-Transfer (including separate auto-deposit aliases per account)
- Bill Pay (including CRA corporate tax payments)
- Cheques & Bank Drafts (deposits and writing)
- Wires (to/from)

**Dual Custodian Architecture:**
- CH Branch (TRANSIT/PROCESSING) - Primary custodian, where client funds are held
- WS Branch (SETTLEMENT) - Settlement custodian for fund sweeping/clearing

**Adding a New Payment Rail (typical pattern):**
1. Fort-Knox: Add `ca_cash_corporate` to the rail's policy `supported_account_combinations`
2. WS Monolith: Add action to permissions config for `BUSINESS_CHEQUING` in `allowed_actions_config.yml`

## Critical Files to Know

**Account Definition:**
- `wealthsimple/components/accounts/data/account_types.yml` (BUSINESS_CHEQUING definition)

**Payment Rail Policies (Fort-Knox):**
- `components/funding_methods/app/payment_rails/eft_bank_account/domain/policies/*`
- `components/funding_methods/app/payment_rails/online_bill_pay/domain/policies/*`
- `components/funding_methods/app/payment_rails/ws_bank_account/cheque/domain/policies/*`

**Permissions:**
- `wealthsimple/components/permissions_engine/data/allowed_actions_config.yml`

**Requirements:**
- `wealthsimple/components/requirements_engine/app/domain/resolvers/business_risk_assessment_requirement_resolver.rb`
- `wealthsimple/components/requirements_engine/app/domain/resolvers/corporation_entity_relationship_requirement_resolver.rb`

**Frontend:**
- `front-end-monorepo/libs/shared/packages/account-types/`
- `front-end-monorepo/libs/shared/packages/corporate-chequing-utils/`
- `front-end-monorepo/libs/all/cross-platform-ui/xp-corporate-accounts/`

---

## Implementation Notes

This skill is designed to be:
- **Self-updating**: Fetches the Notion document at invocation time, so updates to the Notion page automatically update context
- **Sourcegraph-augmented**: Uses Sourcegraph MCP to search across front-end-monorepo, fort-knox, and wealthsimple repos for current code context
- **Lightweight**: Doesn't store the full documentation in the skill itself
- **Reference-based**: Points to the authoritative Notion page as the single source of truth

When invoked, always start by fetching the Notion document for the latest information, then use Sourcegraph searches as needed for the specific task.
