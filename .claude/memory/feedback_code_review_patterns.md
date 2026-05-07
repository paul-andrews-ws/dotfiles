---
name: Code style preferences from PR reviews
description: Inline values over constants files, FR locale character encoding rules
type: feedback
originSessionId: fac40444-eb9b-4ae0-8f56-3d0dd512a45f
---
Don't create constants files for values only used in 1-2 places. Inline feature flag names, locale keys, and simple values at the call site.

**Why:** Constants files add indirection without benefit when the value isn't shared widely.

**How to apply:** Only extract to a constants file if the same value is used in 3+ unrelated places.

---

In French locale JSON files, use literal accented characters (é, à, ô, etc.) — not Unicode escapes. The one exception is \u2019 (curly apostrophe) which should remain as an escape.

**Why:** Matches existing codebase style. Literal characters are more readable.
