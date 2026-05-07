---
name: FEMR package structure — feature code organization
description: When to use libs/all/core, libs/all/web, libs/all/mobile, and when to keep code in a page/screen vs extracting to a package
type: reference
originSessionId: f737c373-296f-4a93-b42f-4ab9c619f367
---
## Primary Sources

- **Google Drive doc** "Front-End Monorepo Package Architecture": https://docs.google.com/document/d/1iGX8UViRCAQaefjpEOCi7MPfuz4cJayEsN8TvxFsN0g
- **Slack: sdavenport in #proj-automated-investing-eng, March 17 2026** — the canonical decision tree (direct quote below)
- **Slack: Vlad (volodymyr.dziubak) in #payments, March 27 2026** — no team-scoped catch-all packages

## Core Principle (from the architecture doc)

> "Resist the temptation to organize things by what files you happen to want to share, or by the type of construct, or by 'who owns it'. A package that's just 'types', 'services', or 'components' is going to become hard to manage. A package that is based on team ownership will become tech debt as soon as we reorg or the DRI quits. Instead, organize things by feature."

## The Decision Tree (sdavenport, March 17 2026, verbatim)

> "Are you making a one-off component for a single mobile screen? Just put it in the relevant mobile screen project.
> Are you making a one-off component for a single web page? Just put it in the relevant web page project.
> Are you making a component that's going to be used across many mobile screens? put it in libs/all/[feature]/mobile
> Are you making a component that's going to be used across many web screens? put it in libs/all/[feature]/web
> Are you making a utility function or other logic that needs to be the same across mobile and web apps? Put it in libs/all/[feature]/core"

## No Team-Scoped Catch-Alls (Vlad, March 27 2026)

> "we shouldn't have team-level shared packages, because what happens is that the package becomes a 'catch-all' place... payments-ui should not exist because it's team-scoped. If there are reusable pieces of UI, they should live in their own team/feature-agnostic packages (e.g. account-selector or recurrence-selector)."

## Directory → Scope Tag Mapping

| Directory | Nx scope tag | Contents |
|---|---|---|
| `libs/all/<feature>/core/` | `scope:shared-front-end` | Platform-agnostic: business logic, types, pure utils, GQL data transformations, hooks with no platform APIs |
| `libs/all/<feature>/web/` | `scope:web` | React web UI / hooks shared by multiple web pages |
| `libs/all/<feature>/mobile/` | `scope:mobile` | RN UI / hooks shared by multiple mobile screens |
| `libs/web/pages/<name>/` | `scope:web`, `type:page` | Router-mounted entry point; not imported by other packages |
| `libs/mobile/screens/<name>/` | `scope:mobile`, `type:screen` | Navigator-mounted entry point; not imported by other packages |

## Scope Boundary Rule

A `scope:shared-front-end` package cannot import from `scope:web` packages. If a hook needs a web-only dep (e.g. `useIdentityId` from `@wealthsimple/web-auth`), it belongs in `libs/all/<feature>/web/` not `core/`. Mobile has its own `useIdentityId` from `@wealthsimple/auth-info` (`scope:mobile`).

## Applied to business-dashboard (this PR)

- `libs/all/business-dashboard/core/` — `CorporationMemberEdge`, `groupMembers`, `getInitials`, `formatAddress`, `getDirectorSubtextKey` (platform-agnostic, mobile-reusable)
- `libs/all/business-dashboard/web/` — `useBusinessDashboardFeature` (web-only: needs `useIdentityId` from `web-auth`)
- `libs/web/pages/business-dashboard/` — page UI components (corporations list, details, cards)
