# Payments Integration

## Host Setup

The package is a reusable payment module. The FlutterFlow application owns routing, generated app state, authentication, Stripe initialization and the actual card-entry surface.

Create an account-specific scope after authentication. Share the same `PaymentAttemptCoordinator` across checkout screens for that account. Close old controllers and gateways on logout. Use a separately scoped local store if pending-reference persistence is enabled.

`PaymentNativeSdk.initialize` applies the host's configuration. `present` receives a short-lived client secret and optional customer ephemeral key for the native SDK. These values must not be logged, serialized into analytics or put into app state. They are deliberately absent from the serializable payment models. Disposal drops this module's references; Dart strings and native SDK memory cannot be securely erased by this module.

The callback adapter avoids assuming a particular `flutter_stripe` release. The host must map its installed SDK's cancellation and completion results to `PaymentSdkOutcome` and pass customer identifiers from the allocation where required.

## Checkout Lifecycle

1. Load an authenticated backend order, fresh quote and merchant charge-currency rule. Use `PaymentOrders` to reconcile the displayed breakdown.
2. If the UI requires review, create and validate a `PaymentCheckoutReview`. The controller validates the quote itself; the host must enforce review acceptance in its button flow.
3. Call `prepare`. If configured, the pending store saves the request before the backend allocation begins.
4. Call `present` once the controller is ready. The native result always leads to a backend status check, including cancellation.
5. Render the returned verified payment state. A paid result alone is insufficient to show a booking confirmation unless `bookingConfirmed` is also true.
6. Use `refresh` for a known pending intent. Use `recover` after restarting with the saved request. Missing backend lookup remains uncertain.
7. `renew` is explicit and limited to a current retryable intent. It retains the attempt, idempotency key and intent. The backend must return newly usable SDK credentials for that same intent; its internal idempotency handling must distinguish safe credential refresh from creation of a new payment.
8. `resetCancelled` requires a current verified cancelled intent. A local SDK cancellation cannot reset an attempt.

An unresolved attempt must be resolved on the backend before creating another one. The client coordinator protects a running application; it cannot provide cross-device or cross-process transactional guarantees.

## Backend Contract

`PaymentBackendGateway` posts JSON to the following paths beneath its configured HTTPS base URI:

| Path | Purpose |
| --- | --- |
| `checkout/allocate` | Resolve or allocate the order's existing payment attempt and SDK credentials |
| `checkout/verify` | Read the authoritative current intent and order binding |
| `checkout/lookup` | Resolve an existing attempt after an uncertain response |
| `payments/read` | Read bounded intent, method, receipt, refund or currency records |

These paths have no deployed implementation in this repository. An existing backend can implement `PaymentBackend` directly instead.

The authenticated transport supplies session authorization. It must reject unauthorized orders and customer references. Scope hashes, request fingerprints, `serverVerified` fields and JSON digests are application contracts, not signatures. Only populate verified records from a trusted authenticated backend response.

The backend must:

- Calculate totals and validate quote versions independently of the mobile request.
- Bind each order and attempt to the authenticated customer and merchant environment.
- Deduplicate order allocation transactionally and map retry keys to the existing intent.
- Verify Stripe events on the server, reconcile current intent state, and fulfill bookings idempotently.
- Enforce charge-currency eligibility, limits and exceptional minor-unit rules.
- Return current expiry metadata and monotonically increasing intent revisions.
- Return an explicit booking reference when fulfillment has completed.
- Keep secret keys and webhook secrets on the server.

`checkout/allocate` returns an `allocation` canonical model plus a separate `sdkCredentials` object containing `clientSecret` and, for customer sessions, `ephemeralKey`. All other canonical responses reject unknown fields and sensitive credential keys.

Verification fingerprints include the minimum required intent revision. An older observation cannot overwrite a newer intent revision. The controller also rejects regression from a previously verified paid status.

HTTP authentication failures stop the operation. Rate limits and server failures may be retried by the read controller within its policy. Checkout allocation is never automatically retried by the gateway or checkout controller. A 404 attempt lookup means unresolved, not permission to allocate another intent.

## Reads and Presentation

`PaymentReadController` supports one current result with cancellation fences and bounded underlying requests. Cancellation prevents stale state updates; it does not claim to abort the host's HTTP request.

`PaymentReadCollector` bounds page count and total records, rejects repeated identifiers and cursor loops, and reports incomplete results. Use complete verified history before showing an authoritative remaining refundable amount. A receipt returned by a read is not itself proof of payment: validate it against the order's current verification with `PaymentPresentation.validateReceipt`.

Return-link policies require explicit schemes, hosts, paths and allowed query keys. Prefer state binding. Even an accepted success marker always requires backend verification. The legacy URL functions recognize navigation markers without an account-bound host policy; use `PaymentReturns` for the integrated flow.

## Local Storage

Pending persistence is opt-in and disabled by default. The storage port should use the host's appropriate protected storage and logout policy. Request records contain order metadata and opaque payment references; they contain no card data or SDK secrets.

Expired unresolved requests are retained for lookup instead of being silently removed. Account-data erasure and retention cleanup must first resolve active attempts on the backend. The current pending store serializes operations within its instance; storage coordination between isolates or application processes belongs to the host.

Preference persistence uses revision checks. Digests detect accidental corruption and are not tamper-proof authentication. Do not treat restored snapshots as current payment verification.

## Release Checks

The repository's tests use in-memory providers and fake SDK callbacks. No live charge, refund, Firebase write or production deployment is required by these checks.

Before releasing the host application, exercise real SDK test-mode flows for cancellation, authentication, delayed processing, network loss and application restart. Verify the backend contracts, entitlements, return routing, customer-session permissions and installed SDK signatures in the actual FlutterFlow export.
