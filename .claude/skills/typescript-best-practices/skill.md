---
name: typescript-best-practices
description: Use when writing TypeScript code - applies company-wide best practices for types, patterns, and code organization
---

# TypeScript Best Practices

Company-wide standards for all TypeScript repos (Web, Mobile, and Node/CLI stacks).

## Core Philosophy

### Keep it Simple
Code you write today will likely be managed by an entirely separate group of people in a year. They will have none of your context, and the feature will be split across different repos and packages. Write for this reality.

### Leave it Better Than You Found It
Readability > cleverness. Prioritize accessibility and maintainability even if it means repeating yourself or writing more verbose implementations. When working in files that don't conform to these practices, improve them incrementally.

## Code Patterns

### Prefer Functions over Classes
Use functional patterns and duck types over OOP patterns and nominal types. If you must use classes:
- Don't inherit more than one level deep
- Separate state from behavior

### Prefer Composition over Inheritance
Combine simple functions and objects rather than building complex inheritance hierarchies.

### Prefer Pure Functions
Small, single-responsibility pure functions are easier to test without mocking. Encapsulate business logic in pure functions rather than custom hooks - separating from the UI layer improves testability.

## Type System Rules

### Write Types First
Don't leave type errors to the end. Types make you think things through upfront to reduce bugs later.

### Never Use `@ts-ignore` or `@ts-expect-error`
These suppress type errors. No net-new code should suppress type checking. Request removal in code review.

### Prefer `unknown` over `any`
If tempted to use `any`, define an interface or cast to `unknown` first, then to the specific type.

### Be Explicit with Type Annotations
Don't over-rely on type inference. When inference fails, error messages describe what TS thinks, not what you intended.

- **Always type** uninitialized variables
- **Always type** exported function parameters and return values
- **Always type** functions that "don't return anything" as `void` or `Promise<void>`
- **Exception:** React component return types (not idiomatic), but still type props

**Pro tip:** If you get an incomprehensible error, add type annotations until the error makes sense.

### Be Explicit About Promise Returns
Any awaitable function should advertise it returns a Promise:

```typescript
// Explicit promise return
function getOneLater(): Promise<number> {
  return Promise.resolve(1);
}

// Async functions implicitly wrap returns in promises
async function getOneAsync(): Promise<number> {
  return 1;
}

async function noReturnValue(): Promise<void> {
  console.log('Returns promise resolving to undefined');
}
```

### Prefer `interface` over `type` for Object Shapes

```typescript
// Preferred - better error messages, detects collisions
interface Foo {
  foo: string;
}

interface Bar {
  bar: string;
}

interface FooAndBar extends Foo, Bar {}
```

Use `type` for unions and other non-object typedefs.

### Use `Record` for Object Keys

```typescript
// Preferred
Record<KeyType, ValueType>
```

### Prefer Union Types over Enums

```typescript
// Avoid
enum AccountType { RRSP = 'RRSP' }

// Preferred
type AccountType = 'RRSP' | 'TFSA' | 'NON_REGISTERED';
```

**Why:**
- Enums generate additional compiled code
- Enums interoperate poorly with matching string values
- Enums don't work well across library boundaries

### Prefer `undefined` over `null`
JavaScript uses `undefined` for uninitialized variables and void returns. Use `undefined` as the natural nullish value; `null` is superfluous.

**Exceptions:**
- API requests requiring explicit `null`
- React components returning nothing (must return `null`)

### Check Nullishness Defensively
Use `== null` and `!= null` (double equals) to catch both `undefined` and `null`:

```typescript
// Catches both undefined and null
if (value != null) {
  // value is defined
}
```

### Prefer Type Guards over Type Casting (Outside Tests)
Casting makes types less safe. Use type guards to assert expected types at runtime.

### Don't Manually Type API Responses
Use generated types for GraphQL responses. Always use the generated types from `@wealthsimple/gql-generated`.

## Code Organization

### File Naming: `lower-kebab-case`
Mixed-case filenames cause debugging pain on Linux.

```
Avoid:  NameDisplayer.tsx
Prefer: name-displayer.component.tsx
```

### Avoid `export default`
Non-default exports prevent accidental renames on import:

```typescript
// Avoid
export default NameDisplayer;

// Preferred - typos fail the build
export const NameDisplayer = ({ props }) => <p>Hi, {props.name}</p>;
```

### Avoid `export *`
For CI performance, index files should only export what's strictly needed:

```typescript
// Avoid
export * from './widget.component';

// Preferred
export { WidgetComponent, WidgetComponentProps } from './widget.component';
```

### Never Deep Import from Packages
All imports from packages must come from the package path:

```typescript
// Correct
import { x } from '@wealthsimple/example';

// Never do this - breaks package API
import { x } from '@wealthsimple/example/src/whatever';
```

If you need internal code, edit the package to expose it properly.

### Avoid Declaration Merging
TypeScript's declaration merging (defining an entity across multiple declarations) complicates understanding. Avoid it.

### Don't Overdo Generics
Generics are useful, but complex multi-parameter generic systems become incomprehensible. Simple is more important than DRY.

## Checklist

When writing TypeScript:
- [ ] Types written first, not "sorted out later"
- [ ] No `any` - use `unknown` or specific types
- [ ] No `@ts-ignore` or `@ts-expect-error`
- [ ] Exported functions have typed parameters and return values
- [ ] Async functions explicitly return `Promise<T>`
- [ ] Object shapes use `interface`, not `type`
- [ ] Union types used instead of enums
- [ ] `undefined` used instead of `null` (where possible)
- [ ] No deep imports from packages
- [ ] No `export default`
- [ ] No `export *` - explicit exports only
- [ ] File names are `lower-kebab-case`
