---
name: MSW GQL mocking in React Native test environment
description: MSW handlers don't intercept in RN jest environment — must use jsdom + @testing-library/react + getMockApolloProvider
type: feedback
originSessionId: c6ef43fa-023b-4684-b21e-097d12262e3e
---
MSW-based GQL mocking does not work in the default React Native jest environment (`mobile/jest.config`). Requests hit `POST https://localhost/graphql net::ERR_FAILED` and tests time out.

**Why:** The RN test environment doesn't have the fetch interceptor MSW needs. `getMockProviderStack` from `jstools-test-mobile` doesn't wire Apollo through MSW-interceptable fetch.

**How to apply:** For hook tests that need real GQL query mocking via MSW:
1. Add `/** @jest-environment jsdom */` at the top of the test file
2. Import from `@testing-library/react` (not `react-native`)
3. Use `getMockApolloProvider` from `@wealthsimple/gql-sdk-test-utils` (not `getMockProviderStack`)
4. Use `mockServer.use()` with the SDK test-utils mock handlers as normal

This matches the pattern used by the SDK packages' own tests (e.g., `banking-onboarding-checklist.query.hook.test.ts`).
