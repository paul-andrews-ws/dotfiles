---
name: monolith → fort-knox event chain for clients/ events
description: Event subscriber wiring in fort-knox for monolith clients/ events — use when assessing prod impact of new SNS event publishers
type: reference
originSessionId: e8dc3d92-6d5f-4ac7-9686-679fc7b4d094
---
When the monolith's `clients/` component emits an SNS event for a Corporation
or Person change, the fort-knox subscriber side typically follows this chain:

1. `Pheme::MessageHandler` subclass in `app/message_handlers/client_service/`
   subscribes to one or more `event_type` strings and re-publishes onto an
   internal Wisper EventBus.
2. A listener registered in `components/funding_methods/app/public/listener_catalog.rb`
   picks up the EventBus event and enqueues a Sidekiq worker.
3. The worker delegates to a `UseCases::*` class that does the actual work.

Concrete example for corp data: `CorporationDataChangedHandler` is the
single subscriber for both `corporation-legal-name-changed` and
`corporation-contact-email-changed`. It fans out to
`FundingMethods::CorporationDataChangedEventListener` →
`UpdateCorporateETransferCustomerWorker` →
`FundingMethods::ETransfer::UseCases::UpdateCorporateETransferCustomer`.

When assessing prod risk for a new monolith-side event publisher, trace this
chain via Sourcegraph (`keyword_search` on the event_type string) before
declaring readiness — don't trust PR "next steps" lists, since downstream
subscribers may already be deployed and waiting.
