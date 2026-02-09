---
name: typescript-best-practices
description: Use when writing TypeScript code - applies team conventions for types, exports, and code organization
---

# TypeScript Best Practices

Team conventions for all TypeScript repos (web, mobile, Node). Only covers where our standards diverge from defaults.

## Type System

- `interface` over `type` for object shapes; `type` for unions and non-object typedefs
- Union types over enums — no compiled output, better interop across boundaries
- `undefined` over `null` — exceptions: API contracts requiring explicit `null`, React component returns
- `== null` / `!= null` (double equals) for nullish checks — catches both `undefined` and `null`
- `unknown` over `any` — define an interface or cast to `unknown` first, then to specific type
- No `@ts-ignore` or `@ts-expect-error` — request removal in code review
- Always type exported function params, return values, and `Promise<T>` returns
- Always type uninitialized variables and void returns (`void` / `Promise<void>`)
- Type guards over type casting outside of tests
- API response types from `@wealthsimple/gql-generated` — never manually type API responses

## Code Organization

- File names: `lower-kebab-case` (e.g., `name-displayer.component.tsx`)
- No `export default` — named exports prevent accidental renames
- No `export *` — explicit exports only for CI performance
- No deep imports from packages — import from package path only (`@wealthsimple/example`, not `@wealthsimple/example/src/whatever`)
- Prefer functions over classes; if classes needed, max one level of inheritance
- Prefer pure functions — encapsulate business logic separate from UI for testability
