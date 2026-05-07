---
name: useFocusEffect test mocking gotcha
description: When a hook/component uses useFocusEffect, mocking only useNavigation in @react-navigation/native is insufficient — useFocusEffect internally imports useNavigation from @react-navigation/core
type: feedback
originSessionId: 9dace259-5aa8-4ddd-a9b9-56c5f2960633
---
When testing a hook or component that calls `useFocusEffect` from `@react-navigation/native`, jest-mocking only `useNavigation` in that module is NOT enough. `useFocusEffect`'s implementation internally imports `useNavigation` from `@react-navigation/core`, which bypasses the `@react-navigation/native` mock — causing "Couldn't find a navigation object. Is your component inside NavigationContainer?" errors.

**Why:** Discovered while adding refetch-on-focus to a hook — existing tests mocked `useNavigation` only, but crashed once the hook added `useFocusEffect`. `@react-navigation/core` is a separate module so jest's mock scoping doesn't propagate.

**How to apply:**
- Either: mock `useFocusEffect` too in the `jest.mock('@react-navigation/native', ...)` block (`useFocusEffect: jest.fn()` for a no-op, or a capture-callback variant for tests that want to drive focus manually).
- Or: wrap the test tree in a real `NavigationContainer` (e.g. `getMockProviderStack({ realNavigator: true })`).
- **Capture pattern** for tests that need to invoke focus events without a real navigator:
  ```ts
  let mockFocusCallback: (() => void) | undefined;
  jest.mock('@react-navigation/native', () => ({
    ...jest.requireActual('@react-navigation/native'),
    useNavigation: jest.fn(),
    useFocusEffect: (callback: () => void) => {
      mockFocusCallback = callback;
    },
  }));
  // In tests: act(() => mockFocusCallback?.());
  ```
  The `mock` prefix is required for jest.mock-factory access to out-of-scope variables.
