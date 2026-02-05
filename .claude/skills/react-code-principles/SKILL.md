---
name: react-code-principles
description: Use when implementing React or React Native components to write maintainable, contributor-friendly code following established patterns for state management, component structure, and TypeScript usage
---

# React Code Principles

## Overview

**Write code for future contributors, not just for yourself.**

All code will be modified by someone with little context about your feature. They won't have time to learn undocumented abstractions, trace state through multiple files, or search for hidden side effects. If we don't write code with future contributors in mind, we'll slow them down and make it easy to introduce bugs.

**Core principle:** Code is for the company, not just your team. It will outlast the current org structure. Write code to be understood and modified - not just merged.

**Applies to:** Both React (web) and React Native (mobile) unless specifically noted.

## When to Use

Use this skill when:
- Implementing new React/React Native components
- Refactoring existing components
- Reviewing React code
- Designing component architecture

## Key Principles

### 1. Avoid Side Effects

**Problem:** Side effects spread business logic across components, making it hard to find and modify behavior.

Every piece of business logic links to an event (click, load, API response). Logic contained directly in the event listener is easy to find. Side effects with `useEffect` hide logic in other components, making changes risky and harder to test.

```typescript
// ❌ BAD - side effect hides mutation
function ComponentA() {
  const [state, setState] = useState();

  const handleClick = () => {
    sendMutationA();
    setState('sent'); // triggers side effect in ComponentB
  }

  return (
    <>
      <Button onClick={handleClick} />
      <ComponentB state={state} />
    </>
  );
}

function ComponentB({state}) {
  // Side effect - easy to miss when changing button behavior
  useEffect(() => {
    if (state === 'sent') {
      sendMutationB();
    }
  }, [state])

  return <Text>{state}</Text>
}

// ✅ GOOD - all logic in one place
function ComponentA() {
  const [state, setState] = useState();

  const handleClick = () => {
    sendMutationA();
    sendMutationB(); // explicit, easy to find
    setState('sent');
  }

  return (
    <>
      <Button onClick={handleClick} />
      <ComponentB state={state} />
    </>
  );
}
```

### 2. Reduce Data Abstraction Layers

**Problem:** Custom data types force contributors to understand multiple layers before making changes. Modifying shared abstractions risks breaking unrelated components.

Work directly with API models when possible. Push data derivation to leaf components.

```typescript
// ❌ BAD - tests for Child won't cover data derivation
function useDerivedData(id) {
  const {data} = useApiData(id);
  const {data2} = useApiData2(id);

  return {
    nickname: computeNickname(data, data2),
    hasBadge: computeBadge(data, data2)
  };
}

function Parent({id}){
  const derived = useDerivedData(id);
  return <Child data={derived} />;
}

// ✅ GOOD - atomic derivation in leaf
function Parent({id}) {
  return <Child id={id} />;
}

function Child({id}) {
  const {data} = useApiData(id);
  const {data2} = useApiData2(id);

  const nickname = deriveNickname(data, data2); // pure function
  const hasBadge = deriveHasBadge(data, data2); // pure function

  return (
    <>
      <Text>{nickname}</Text>
      {hasBadge && <Badge />}
    </>
  );
}

// ✅ BEST - BE does derivation
function Child({id}) {
  const {data} = useApiData(id); // data.nickname, data.hasBadge from API

  return (
    <>
      <Text>{data.nickname}</Text>
      {data.hasBadge && <Badge />}
    </>
  );
}
```

### 3. Keep Code Structure Flat

**Problem:** Nested layers of utilities/components require jumping between files to understand behavior. Changes to nested code risk breaking all consumers.

Keep structure flat even if it creates duplication. Duplication is safer than nested dependencies.

```typescript
// ❌ BAD - nested utilities spread logic
function getFormattedUserData(user) {
  return {
    ...user,
    displayName: formatDisplayName(user), // calls another utility
    status: deriveStatus(user), // calls another utility
  };
}

// ✅ GOOD - flat, explicit
function Component({user}) {
  const displayName = formatDisplayName(user);
  const status = deriveStatus(user);

  return (
    <>
      <Text>{displayName}</Text>
      <Badge>{status}</Badge>
    </>
  );
}
```

### 4. Minimize Blast Radius of Shared Code

**Problem:** Shared functions with many responsibilities have many consumers. A bug breaks all consumers, even those not using the changed functionality.

Create small, atomic utilities that do one thing. Avoid bundling multiple responsibilities.

```typescript
// ❌ BAD - function bundles multiple computations
function getDerivedData(data1, data2) {
  return {
    nickname: computeNickname(data1, data2),
    hasBadge: computeBadge(data1, data2),
    score: computeScore(data1, data2),
  };
}

// ✅ GOOD - separate functions for each concern
function getNickname(data1, data2) {
  return computeNickname(data1, data2);
}

function getHasBadge(data1, data2) {
  return computeBadge(data1, data2);
}

function getScore(data1, data2) {
  return computeScore(data1, data2);
}
```

### 5. Composition Over Configuration

**Problem:** Single components with extensive props become spaghetti of boolean flags and conditional logic.

Expose smaller components that compose into the desired result.

```typescript
// ❌ BAD - configuration explosion
<SharedSuccessScreen
  hideBackButton={true}
  hideCloseButton={false}
  title="Success"
  descriptionStyle="condensed"
  hideImage={true}
  hidePrimaryCta={true}
  activityTrackerId="id"
  activityTrackerStyle="primary"
  secondaryCtaText="See activity"
  onSecondaryCtaPress={() => {...}}
/>

// ✅ GOOD - composition
<SuccessScreen back={true} close={false}>
  <SuccessScreen.Title>Success</SuccessScreen.Title>
  <SuccessScreen.Description>Your withdrawal is in progress</SuccessScreen.Description>
  <SuccessScreen.ActivityTracker id="id" style="primary" />
  <SuccessScreen.Cta style="secondary" label="See activity" onPress={() => {...}} />
</SuccessScreen>
```

### 6. Write Code That's Easy to Delete

**Problem:** Feature flags/experiments placed low in the tree create complex components that mix old and new logic. Cleanup is hard, and new logic risks breaking original code.

Place feature flags/stranglers high in the component tree. Accept duplication to keep flows separate.

```typescript
// ❌ BAD - mixed logic, hard to clean up
function Component() {
  const useNewDesign = useFeatureFlag('some-flag');
  const newData = useNewQuery(); // executes even when flag is off!

  return (
    <Box>
      <Text>{title}</Text>
      {useNewDesign ? <ImageNew /> : <ImageOld />}
      {useNewDesign ? <DescriptionNew /> : <DescriptionOld />}
      {/* more mixed markup */}
    </Box>
  );
}

// ✅ GOOD - strangler at top, easy to delete
function Component() {
  const useNewDesign = useFeatureFlag('some-flag');

  if (useNewDesign) {
    return <ComponentNewDesign />;
  }

  return <ComponentOldDesign />;
}
// ComponentNew and ComponentOld may duplicate code,
// but it's easier to maintain two simple components
// than one overloaded with conditions
```

### 7. Avoid Implicit Parameters

**Problem:** Closures and dependency arrays make code hard to understand, debug, and test. They encourage bloated components that keep all logic in one spot.

Use explicit parameters via props and function arguments.

```typescript
// ❌ BAD - IIFE with closure
function Component({entitlements}) {
  const isActive = entitlements
    ? (() => {
        const ent = entitlements.find(
          (e) => e.feature === 'usd_accounts'
        );
        return ent?.access ?? false;
      })()
    : false;
}

// ✅ GOOD - pure function with explicit parameters
function Component({entitlements}) {
  const isActive = getUSDEntitlement(entitlements);
}

function getUSDEntitlement(entitlements) {
  const ent = entitlements?.find(
    (e) => e.feature === 'usd_accounts'
  );
  return ent?.access ?? false;
}
```

### 8. Avoid Memoization

**Problem:** Memoization is a band-aid for poor component hierarchy. It bypasses how React works and will conflict with React Compiler.

Rethink component structure instead of reaching for `useMemo`, `useCallback`, or `React.memo`.

```typescript
// ❌ BAD - unnecessary memoization
function Parent() {
  const [state, setState] = useState('string');

  const derived = useMemo(() => {
    return `derived ${state}`;
  }, [state]);

  const onClick = useCallback(() => {
    trackAnalytics();
    navigate('NextScreen');
  }, [navigate]);

  return <Child derived={derived} onClick={onClick} />;
}

// ✅ GOOD - let React do its thing
function Parent() {
  const [state, setState] = useState('string');

  const derived = `derived ${state}`;

  function onClick() {
    trackAnalytics();
    navigate('NextScreen');
  }

  return <Child derived={derived} onClick={onClick} />;
}
```

**When memoization is okay:** As a last resort for proven performance issues after exhausting other options (usually component hierarchy fixes).

### 9. Don't Define Components Inside Components

**Problem:** Component definitions inside components get recreated on every render. Memoizing them creates cognitive load and implicit coupling via dependency arrays.

Define components as proper components, not functions inside components.

```typescript
// ❌ BAD - component inside component
function Parent() {
  const [state, setState] = useState();

  function ChildOne() {
    const derived = derive(state); // implicit dependency
    return <Text>Child: {derived}</Text>;
  }

  // Also bad: memoized component
  const ChildTwo = useCallback(() => {
    const derived = derive(state);
    return <Text>Child: {derived}</Text>;
  }, [state]);

  return (
    <>
      <ChildOne />
      <ChildTwo />
    </>
  );
}

// ✅ GOOD - proper component with explicit props
function Parent() {
  const [state, setState] = useState();
  return <Child state={state} />;
}

function Child({state}) {
  const derived = derive(state);
  return <Text>Child: {derived}</Text>;
}
```

### 10. Render Components as Components

**Problem:** Rendering components as functions is confusing and may bypass React lifecycle.

Always render components as JSX components, not function calls.

```typescript
function Child({state}) {
  const derived = derive(state);
  return <Text>Child: {derived}</Text>;
}

function Parent() {
  const [state, setState] = useState();

  return (
    <>
      {/* ❌ BAD - rendered as function */}
      {Child({state})}

      {/* ✅ GOOD - rendered as component */}
      <Child state={state} />
    </>
  );
}
```

### 11. Avoid Shared State

**Problem:** State at the top of the render tree triggers re-renders of everything underneath. Shared context wrapping multiple screens re-renders all screens.

Avoid state in favor of alternatives:
- Route params (mobile) or URL (web)
- React Hook Form for inputs (performance optimized)
- Apollo cache as data store (not just fetching mechanism)

```typescript
// ❌ BAD - shared state causes re-renders
const StateContext = createContext();

function AppWrapper() {
  const [sharedState, setSharedState] = useState();

  return (
    <StateContext.Provider value={{sharedState, setSharedState}}>
      <Screen1 />
      <Screen2 />
      <Screen3 /> {/* all re-render when sharedState changes */}
    </StateContext.Provider>
  );
}

// ✅ GOOD - use route params instead
function Screen1({navigation}) {
  function navigate() {
    navigation.navigate('Screen2', {
      userId: user.id,
      context: 'from_screen1'
    });
  }
}
```

### 12. Avoid Skip Tokens

**Problem:** Skip tokens subscribe to queries without executing them. When other consumers refetch, your code may break unexpectedly.

Use conditional components instead of skip tokens.

```typescript
// ❌ BAD - skip token can blow up
function Component() {
  const {data: account} = useAccount({...});
  const isCorporate = isCorporateAccount(account);

  const {data: corporation} = useCorporation({
    variables: {accountId: account.id},
    skip: !isCorporate // still subscribed!
  });

  return <Content account={account} corporation={corporation} />;
}

// ✅ GOOD - conditional component
function Component() {
  const {data: account} = useAccount({...});

  if (isCorporateAccount(account)) {
    return <CorporateContent account={account} />;
  }

  return <Content account={account} />;
}

function CorporateContent({account}) {
  const {data: corporation} = useCorporation({
    variables: {accountId: account.id}
  });

  return <Content account={account} corporation={corporation} />;
}
```

### 13. Use Union Types for Better Typing

**Problem:** Unstructured types require extra checks and don't leverage TypeScript's type narrowing.

Use union types to represent valid combinations explicitly.

```typescript
// ❌ BAD - unclear return type
function validateAmount(amount: string): {
  valid: boolean;
  error?: string;
} {
  // ...
}

const result = validateAmount(amount);
if (result.valid === true) {
  handleSuccess();
} else {
  // result.error not guaranteed by type
  if (!result.error) {
    // what do we do here?
  }
  handleError(result.error);
}

// ✅ GOOD - union types enforce valid combinations
function validateAmount(amount: string):
  | {valid: true}
  | {valid: false; error: string}
{
  // ...
}

const result = validateAmount(amount);
if (result.valid === true) {
  handleSuccess();
} else {
  // result.error is guaranteed by type
  handleError(result.error);
}
```

**For props:**

```typescript
// ❌ BAD - props don't enforce valid combinations
function Label(props: {
  account: Account | CorporateAccount;
  corporation?: Corporation;
}) {
  if (account.__typename === "CorporateAccount") {
    // props.corporation not guaranteed
  }
}

// ✅ GOOD - union enforces valid combinations
function Label(props:
  | {account: Account}
  | {account: CorporateAccount; corporation: Corporation}
) {
  if (props.account.__typename === "CorporateAccount") {
    // props.corporation is guaranteed
  }
}
```

### 14. "Why" Comments Over "What" Comments

**Problem:** Code shows what it does, but never why it needs to exist. Future contributors need context about edge cases and business requirements.

Document *why* the code exists, not what it does.

```typescript
function Component() {
  // ❌ BAD - useless comment
  // fetch account from API
  const {data: account} = useAccount(...);

  // ✅ GOOD - useful context
  // If an account is not corporate, fetching corporation will
  // throw an error, so we need to hide it behind a conditional component
  if (isCorporateAccount(account)) {
    return <CorporateContent account={account} />;
  }

  return <PersonalContent account={account} />;
}
```

### 15. Don't Represent Different Outcomes with the Same Value

**Problem:** One value representing multiple outcomes requires extra logic and builds assumptions that can be missed during refactoring.

Use distinct values for distinct outcomes.

```typescript
// ❌ BAD - null means two different things
interface TransactionConstraints {
  // `null` can mean "not applicable" AND "no limit"
  incomeFundsLimit: string | null;
}

// ✅ GOOD - no overlap in values
interface TransactionConstraints {
  incomeFundsLimit: null | {
    type: "infinite"
  } | {
    type: "quantity";
    amount: Money;
  };
}
```

### 16. Don't Add Bloat to Bloated Code

**Problem:** Bloated code is full of conditional logic serving too many consumers. Every change risks breaking all consumers.

Extract what you need into smaller, focused utilities. Don't refactor the bloated code (might break features). Leave a deprecation comment pointing to the new leaner code.

```typescript
// Existing bloated utility
function getBloatedUserData(user, options) {
  // 200 lines of conditional logic
  if (options.includeX) { /* ... */ }
  if (options.format === 'Y') { /* ... */ }
  // etc.
}

// ✅ GOOD - extract what you need, leave comment
/**
 * @deprecated Use getUserDisplayName() instead for display name formatting.
 * See libs/user-utils/display-name.ts
 */
function getBloatedUserData(user, options) {
  // ... existing bloated logic
}

// New focused utility in new file
export function getUserDisplayName(user: User): string {
  return user.firstName + ' ' + user.lastName;
}
```

### 17. Be Cautious Sharing Code Between Features

**Problem:** Shared code between features creates large blast radius. Requirements diverge, leading to bloated interfaces with boolean flags. Large shared libraries impact bundle splitting.

Prefer feature-specific duplicates over wrong abstractions. If sharing, keep it atomic (one responsibility) and feature-agnostic.

**When to duplicate:**
- Logic specific to feature requirements
- Components with UI that will diverge
- Code that changes frequently for one feature

**When to share:**
- Truly generic components (button, input, badge)
- Pure utility functions (formatting, validation)
- Feature-agnostic domain logic

```typescript
// ❌ BAD - monolithic shared library
// libs/banking-ui/src/index.ts - bloated with feature-specific logic
export { TransferScreen } from './transfer-screen'; // has feature-specific flags
export { WithdrawalScreen } from './withdrawal-screen'; // different requirements
export { BankingUtils } from './utils'; // mixed concerns

// ✅ GOOD - atomic shared libraries
// libs/account-selector/src/index.ts - one responsibility
export { AccountSelector } from './account-selector';

// libs/amount-input/src/index.ts - one responsibility
export { AmountInput } from './amount-input';

// Feature-specific code duplicated in each feature
// apps/feature-a/transfer/transfer-screen.tsx
// apps/feature-b/withdrawal/withdrawal-screen.tsx
```

### 18. Treat Features as Isolated Systems

**Problem:** Features can be entered from unexpected places (experiments, deep links, emails). They need well-defined entry points.

Build features with clear external APIs. Logic for determining starting screens lives inside the feature.

```typescript
// ✅ GOOD - single entry point with internal routing
function FeatureEntry({route}) {
  const {userId, context} = route.params;

  // Internal logic determines starting screen
  const startScreen = determineStartScreen(userId, context);

  if (startScreen === 'setup') {
    return <FeatureSetupScreen userId={userId} />;
  }

  return <FeatureMainScreen userId={userId} context={context} />;
}

// External consumers only know about entry point
navigation.navigate('FeatureEntry', {
  userId: 'user-123',
  context: 'from_email'
});
```

### 19. Delegate Feature Initialization to BE

**Problem:** FE initialization logic is harder to ship due to app versioning. Bugs take longer to fix.

Let BE provide initialization values, limitations, and business logic.

```typescript
// ❌ BAD - FE calculates limits
function WithdrawalScreen() {
  const maxAmount = calculateMaxWithdrawal(account, balance); // FE logic
  const fee = calculateFee(amount, account.type); // FE logic
  // ...
}

// ✅ GOOD - BE provides limits
function WithdrawalScreen() {
  const {data} = useWithdrawalLimits({accountId});

  // data.maxAmount from BE
  // data.fee from BE
  // data.availableReasons from BE
}
```

## React-Specific vs React Native

**Most principles apply equally to both.** Platform-specific notes:

| Principle | React (Web) | React Native (Mobile) |
|-----------|-------------|----------------------|
| Avoid shared state | Use URL/query params | Use route params |
| Skip tokens | Same - use conditional components | Same - use conditional components |
| Composition | Same pattern | Same pattern with native components |
| Feature initialization | Same - delegate to BE | Same - delegate to BE |

## Common Mistakes

| Mistake | Why It Happens | Fix |
|---------|---------------|-----|
| Using useEffect for initialization | "Need to fetch on mount" | Move data fetching up the tree or use suspense |
| Creating custom data types | "Want to DRY up derivation" | Derive in leaf components with pure functions |
| Heavy use of useMemo/useCallback | "Optimizing performance" | Rethink component hierarchy instead |
| Skip tokens in queries | "Conditional fetching" | Use conditional components |
| Shared context for everything | "Need global state" | Use route params, Apollo cache, or React Hook Form |
| Deep nesting of utilities | "Following DRY principle" | Keep it flat, accept some duplication |
| Single component with many props | "Reusable component" | Use composition with smaller components |

## Checklist for Good React Code

**When implementing components:**
- [ ] No side effects in useEffect (logic in event handlers)
- [ ] Data derivation in leaf components (not custom abstractions)
- [ ] Flat structure (not deeply nested utilities/components)
- [ ] Small, atomic shared utilities (not bundled)
- [ ] Composition for UI flexibility (not configuration props)
- [ ] Feature flags at top of tree (easy to delete)
- [ ] Explicit parameters (not closures)
- [ ] No unnecessary memoization
- [ ] Components defined as components (not functions inside functions)
- [ ] Components rendered as JSX (not function calls)
- [ ] Minimal shared state (use route params, Apollo cache, forms)
- [ ] Conditional components (not skip tokens)
- [ ] Union types for valid combinations
- [ ] "Why" comments for business logic

**When refactoring:**
- [ ] Check if bloated code can be extracted (leave deprecation comment)
- [ ] Verify shared code has minimal blast radius
- [ ] Consider duplicating cross-feature code instead of sharing

## Real-World Impact

**Following these principles:**
- Contributors can modify code quickly without breaking things
- PR reviews can assess impact without deep historical knowledge
- Tests cover actual behavior (not just abstractions)
- Feature flags are easy to add and remove
- Bugs are caught in review, not production

**Ignoring these principles:**
- Contributors introduce bugs when modifying code
- PRs require extensive context to review properly
- Tests pass but behavior is wrong
- Technical debt accumulates quickly
- Refactoring becomes risky
