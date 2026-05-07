---
name: Avoid skipToken in GQL SDK hooks
description: Per Vlad's guide — avoid skipToken by splitting into data-gate parent and content child that calls the hook unconditionally
type: feedback
---

Don't use `skipToken` with `useSuspended` or other GQL SDK hooks. Instead, split into a parent component that gates rendering (returns null while loading) and a child component that calls the hook unconditionally with guaranteed-available variables.

**Why:** Vlad's guide to writing React code (Notion) explicitly advises against skipToken. The pattern also avoids conditional hook complexity and keeps components focused.

**How to apply:** When a hook needs variables that aren't available on first render (e.g. payee data loading), create a parent that fetches the dependency and only renders the child once the data is ready. The child calls the hook unconditionally.
