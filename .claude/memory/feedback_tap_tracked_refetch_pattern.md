---
name: Tap-tracked refetch pattern for surgical refresh on return
description: Refetch GQL data only when the user returned from a specific interaction, not on every focus event — use a ref flipped in the action's onPress
type: feedback
originSessionId: 9dace259-5aa8-4ddd-a9b9-56c5f2960633
---
When a screen stays mounted under modals/pushed screens and you only want to refetch after the user returned from *specific* interactions on that screen (not tab switches, cold focus, or unrelated re-focuses), use a tap-tracked ref: flip it in the action's `onPress`, check + reset it in `useFocusEffect`.

**Why:** `useFocusEffect` fires on every focus event. Refetching on all of them is wasteful for tab-hosted dashboards. Screen-lifecycle guessing (blur/focus cycles, initial-mount skips) is imprecise because tab switches produce the same lifecycle signals as task-return. Ref-tracking ties refresh semantics directly to the user interaction that warrants a refresh.

**How to apply:**
```ts
const hasPendingReturnRef = useRef(false);

useFocusEffect(
  useCallback(() => {
    if (hasPendingReturnRef.current) {
      refetch();
      hasPendingReturnRef.current = false;
    }
  }, [refetch]),
);

// wrap action handlers centrally:
const items = data.map((item) => ({
  ...item,
  onPress: () => {
    hasPendingReturnRef.current = true;
    item.originalOnPress();
  },
}));
```

Wrap the handlers at a single `.map()` step so the tracking is DRY across all tracked actions. Also note: Apollo's `refetch()` keeps `loading: false` and reuses the observable, so a silent refetch does NOT re-trigger a `loading` branch in the UI — the data just updates in place.
