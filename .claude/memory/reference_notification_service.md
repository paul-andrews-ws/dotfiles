---
name: notification-service repo overview
description: Quick orientation for working in wealthsimple/notification-service — repo location, the 5-piece template pattern, and the non-obvious Braze allowlist gate
type: reference
originSessionId: 37a1669e-0201-4c05-ad45-fd6b68239b31
---
Business Banking team doesn't own this repo (growth-platform-eng does), but BB-913 has multiple sibling tickets that touch it.

- Local clone: `/Users/paul.andrews/Repos/notification-service`
- **Adding a template = 5 changes** (per README "ADDING A NEW NOTIFICATION" checklist):
  1. `app/lib/templates/<name>.rb` — DSL class (`codeowners`, `mute_notification_setting`, `attribute :foo, :required|:optional`)
  2. `fixtures/templates/<name>.json`
  3. `config/locales/notifications/{en,fr}.yml` — Braze and/or SendGrid IDs
  4. `spec/lib/templates/<name>_spec.rb`
  5. `bundle exec rake mappings:update` and commit the resulting `docs/en_setting_to_notification_mapping.yml` diff
- **Non-obvious gate**: for Braze emails, also add `<name>` to `EMAIL_MIGRATION_EXCEPTION_TEMPLATES` in `app/services/notification_delivery/email.rb`. Without it, the code falls through to deprecated SendWithUs and the email may not arrive. The list's name + comment are misleading legacy from the SendWithUs→Braze migration era — for new templates it's just "the Braze allowlist."
- For staging email testing + vendor routing reality, see the **Notion Gotchas page** ([Developer Learnings](https://www.notion.so/34541167bd968102bfd6e461f61de260)) — covers the README staleness around SendGrid-for-external and the staging Braze blank-email gotcha.
