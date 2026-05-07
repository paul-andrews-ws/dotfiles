---
name: MMKV testing patterns in mobile
description: How to mock react-native-mmkv-storage in component vs hook tests — built-in mock vs manual mock tradeoffs
type: feedback
originSessionId: 39f014c0-303f-45c8-9e43-b67e4bb3ee12
---
The built-in MMKV mock (`react-native-mmkv-storage/jest/dist/jest/memoryStore.js`) provides a real in-memory implementation. Use it for `renderHook` tests where you drive state through `act()`.

For **component render tests** with deep dependency trees (where transitive deps like feature flags and auth also use MMKV at module level), the built-in mock doesn't work well for pre-seeding state — `initialize()` resets the store. Instead, mock the module directly:

```typescript
jest.mock('react-native-mmkv-storage', () => {
  const createMockStorage = () => ({
    getString: jest.fn(), setString: jest.fn(),
    getBool: jest.fn(), setBool: jest.fn(),
    // ... all methods used by transitive deps
  });
  const createMockBuilder = () => ({
    withInstanceID: jest.fn().mockReturnThis(),
    withEncryption: jest.fn().mockReturnThis(),
    initialize: jest.fn(createMockStorage),
  });
  return { MMKVLoader: jest.fn(createMockBuilder), useMMKVStorage: jest.fn() };
});
```

**Why:** `jest.mock('react-native-mmkv-storage')` replaces the module for ALL consumers in the dependency graph. Transitive deps (feature flags → `getString`, auth → `withEncryption`/`setString`) crash if the mock doesn't provide their methods.

**How to apply:** Use the comprehensive mock when testing components that render through `getMockProviderStack` or similar deep wrapper trees. Use the built-in mock for isolated hook tests.
