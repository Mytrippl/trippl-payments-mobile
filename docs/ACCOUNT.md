# Payment Account Integration

## Account Boundary

Create `PaymentAccountSession` after the host has authenticated the user and resolved the backend customer identifier. `begin` creates a new generation. Logging out, switching accounts or beginning another session invalidates captured contexts.

`PaymentAccessPolicy` is a current authenticated backend assertion. Its permission list and the session's permission list must both allow an operation. Client scope hashes are not authorization tokens. The backend must enforce the same ownership and permission checks independently.

The available permissions are:

| Area | Permissions |
| --- | --- |
| Billing | `billing.read`, `billing.review` |
| Invoices | `invoices.read` |
| Installments | `plans.read`, `plans.review` |
| Refunds | `refunds.read`, `refunds.review` |
| Disputes | `disputes.read` |
| Support | `support.review` |
| Activity | `activity.read` |
| Ledger | `ledger.read` |

The host decides which screens and export actions are available. Local validation does not replace backend authorization or identify a user by itself.

## Provider Interfaces

The account features use host-supplied interfaces. They do not assume deployed account endpoints or a particular HTTP client.

| Interface | Responsibility |
| --- | --- |
| `PaymentInvoiceProvider` | Read invoices matching a filter and opaque continuation cursor |
| `PaymentAccountProvider` | Read a customer-bound aggregate account snapshot |
| `PaymentReviewProvider` | Submit one explicitly approved review request and look up its existing outcome |
| `PaymentLocalStorage` | Provide account-scoped local persistence when enabled |

Invoice pages bind their filter through `PaymentInvoiceReader.fingerprint`. Activity pages use `PaymentActivity.fingerprint`. Backend responses must use the canonical typed model shape, including account scope, environment, verification and expiry metadata.

Never populate `serverVerified` from an untrusted deep link, restored JSON or native SDK completion callback. The flag records the source of an authenticated backend assertion; it is not a cryptographic signature.

## Billing and Tax

`PaymentBillingAddresses` normalizes supported postal formats and checks backend country rules. Postal validation checks format only. It does not establish deliverability, identity or tax eligibility.

`PaymentBillingProfiles.patch` prepares a replacement address tied to the current profile revision. Clearing an optional field is included in `changedFields`; the backend should apply the complete replacement address with the expected revision. No profile is updated by preparing the draft.

Billing addresses are personal data. Keep them out of analytics and debug output. Canonical billing models are serializable for the host's authenticated transport; redacted `toString` output does not make arbitrary JSON logging safe.

Tax identity records carry masked display values. Tax assessments and exemptions must come from the backend. The module reconciles the declared amounts and never determines a customer's legal tax treatment.

## Invoices, Statements and Ledger

Validate an invoice before presenting totals or downloading documents. Invoice lines reconcile unit amounts, quantities, tax and totals. Settlement values reconcile paid and remaining amounts. A paid invoice is an account document and does not replace the order's booking verification.

`PaymentInvoiceReader` bounds pages and records, rejects duplicate identifiers and cursor loops, and fences cancelled results. Use `requireComplete: true` when the screen needs a full result. A list returned with completeness optional must not be presented as exhaustive.

`PaymentStatements.validate` binds a statement to its customer, currency, time range and requested order filters. `PaymentLedger.balance` checks posting directions, duplicate references and closing balances. `PaymentLedger.reconcile` compares the relevant posted charge with a matching verified intent. Ledger reconciliation does not establish booking completion.

`PaymentAccountExports.csv` produces an in-memory CSV with quoted cells and formula-prefix escaping. `manifest` records a canonical content fingerprint and marks that account data is present. The host owns download approval, file saving and retention. Exported order and payment references must be handled as account data.

Invoice PDF links require a matching current invoice and an approved exact host and path policy. Link validation does not download a document or verify its bytes. If the host downloads a PDF, it must enforce the declared byte limit, expected content type and checksum itself.

## Display FX

`PaymentForeignExchange` uses bounded rational rates and explicit floor, half-up or ceiling rounding. It performs intermediate calculations with `BigInt` to avoid native integer overflow and JavaScript precision loss.

A display quote reconciles the converted amount and declared fee. Its source amount remains the order's charge amount. It does not provide merchant currency eligibility, currency conversion execution or a guarantee that a card issuer will use the same rate.

## Deposits and Installment Review

Validate a deposit quote against its terms, service type, order fingerprint and due date before displaying it. Deposit percentage calculations truncate fractional minor units; the declared minimum then applies. The backend must use the same declared rule.

`PaymentInstallments` checks that plan amounts sum to the order total and that settled installments have intent references and timestamps. `PaymentPlanConsents` binds the current plan fingerprint and required acknowledgements. `PaymentPlanChanges` prevents rewriting settled installments and requires advancing revisions.

Plan status is an authenticated backend account record. It does not independently verify each Stripe intent or fulfill a booking. An installment needs the normal verified checkout path when the customer chooses to pay it. Connecting that installment to a backend order quote belongs to the host and backend.

Plan schedules use UTC instants. They categorize due and upcoming items without scheduling jobs or automatic collections. These records do not represent a mandate or permission to charge a stored method.

## Refund Review

Use the following sequence:

1. Prepare a `PaymentRefundRequestDraft` from a matching verified paid order and an enabled refund reason.
2. Validate fresh backend eligibility against a complete matching refund summary.
3. Validate the backend preview's draft fingerprint, fee, net amount and warnings.
4. Acknowledge the current warnings to create `PaymentRefundSubmission`.
5. Prepare a review operation with the current access policy and an opaque stable nonce.
6. Submit only after the user approves the review. Resolve an uncertain response through lookup.

The review provider must accept requests for review only. Its response cannot report a performed payment mutation. A backend workflow may later approve or reject a refund under its own authorization and policy; the mobile review response is not the resulting refund record.

The backend must calculate refund eligibility and amounts independently, bind ownership to the authenticated customer, reject stale order revisions and deduplicate review submission. Do not trust the mobile request as authority to refund an amount.

Review tickets bind the session generation and payload fingerprint. They expire with the earliest relevant policy, session or draft deadline. Automatic submission retry is disabled. Lookup remains available to resolve the same ticket after a submission becomes uncertain; ticket expiry does not prove that submission failed.

Review coordination is local to its controller. The host must preserve the stable ticket/idempotency reference when implementing recovery across application restarts, and the backend must deduplicate across devices. This repository does not persist review payloads or billing addresses for that purpose.

## Dispute and Support Context

Dispute history and response deadlines are read-only backend observations. Evidence checks accept bounded metadata and an opaque host file reference. The host is responsible for actual file selection, permission checks, scanning, upload and server-side dispute handling.

A support handoff uses an approved destination and carries a context fingerprint. The destination URL contains no account-context query payload. Preparing or reviewing a handoff does not send a message. The host must let the user complete the intended support action.

## Offline Account History

`PaymentAccountCache` stores one aggregate snapshot per account, environment and customer key. It is disabled by default. Enable it only with an appropriate host storage and retention policy.

Cache digests detect accidental corruption and do not provide encryption or authentication. Cached invoice descriptions, references and amounts are account data even though raw card credentials and billing addresses are not part of the aggregate snapshot.

Every restored aggregate and nested record is marked unverified. Expired history can be displayed only as offline information when enabled. It cannot authorize payment, refund review or booking fulfillment. Recheck backend data before preparing an operation.

The workspace checks current permissions before restoring an offline section. Its visible view is cleared when an authorization attempt fails. Account changes hide prior views and discard late responses. On logout, the host should invalidate the session, close controllers and apply its account-cache clearing policy.

Storage serialization applies within a cache instance. The host must coordinate shared storage across isolates or application processes. There is one stored snapshot per customer key, which stays within the configured entry bound.

## Notification Presentation

Notification events come from the authenticated backend. The host supplies the user's current wall-clock time for quiet-hour evaluation and remembers already-presented event identifiers. Equal quiet-hour endpoints disable quiet hours.

The module filters and prepares local presentation data. It does not schedule reminders, register push tokens, send notifications or treat a success notification as payment proof.

## Validation

The account tests cover typed contracts, customer and environment boundaries, expiry, invoice arithmetic, rational FX rounding, installment reviews, refund ceilings, ledger references, session fencing, offline flags and uncertain review recovery.

The JavaScript smoke check exercises these pure Dart paths with fake providers. The host still needs integration tests for real authenticated endpoints, storage behavior, file downloads, native SDK versions, device entitlements and FlutterFlow page wiring.
