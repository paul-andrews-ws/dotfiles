---
name: Mobile analytics SDK mocking in tests
description: How to mock @wealthsimple/mobile-analytics in jest tests, and why it's an exception to the "don't mock @wealthsimple packages" guideline
type: feedback
originSessionId: dc2f991d-4b13-4da9-9cac-35e5ca51b589
---
To assert analytics events fire, mock the SDK at the top of the test file:

```ts
import { trackEventWithMixpanel } from '@wealthsimple/mobile-analytics';

jest.mock('@wealthsimple/mobile-analytics', () => ({
  ...jest.requireActual('@wealthsimple/mobile-analytics'),
  trackEventWithMixpanel: jest.fn(), // or trackEvent, depending on the SDK function used
}));

const mockTrackEvent = jest.mocked(trackEventWithMixpanel);
```

**Why this is OK even though mocking `@wealthsimple/*` packages is generally discouraged:** Analytics has no MSW equivalent (Mixpanel isn't a GraphQL call), and we're asserting a side effect, not the thing under test. Widely used across the monorepo.
