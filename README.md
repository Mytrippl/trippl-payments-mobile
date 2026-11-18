# Trippl Payments Mobile

Trippl Payments Mobile contains Mytrippl's mobile payment actions, card-entry widget and shared checkout logic. It connects service orders to the host application's payment backend and Stripe SDK integration.

The repository includes the original FlutterFlow custom-code interfaces alongside a standalone Dart payment core. The core coordinates checkout requests, exact amounts, saved payment references, payment verification and recovery. The host application supplies authentication, network transport, local storage and the installed Stripe SDK.

## Checkout

Checkout starts with an order and a current backend quote. The core checks the order revision, line totals, currency rules and account context before requesting an allocation.

Each attempt has an opaque identifier and idempotency key. A shared coordinator prevents simultaneous operations on the same order inside the application. An uncertain allocation remains unresolved until the backend identifies its outcome. A timeout, missing lookup result or expired local reference does not authorize another charge.

Payment Sheet completion returns control to the application, which then requests backend verification. Payment state distinguishes:

- A completed payment.
- A payment still processing.
- An authorized amount awaiting capture.
- Authentication or payment-method action.
- A cancelled intent.
- An unknown or unresolved outcome.

Payment completion and booking confirmation are separate fields. Return URLs are navigation signals and never establish payment success.

## Amounts and Orders

The Dart core uses integer minor units and explicit decimal strings. It rejects ambiguous formats, excess precision, mixed currencies, invalid quantities and amounts outside the supplied rules.

Merchant currency rules come from the backend catalogue. They include precision, charge increments, minimums, maximums and expiry. The module does not infer which currencies a merchant account currently supports.

Order calculations cover line quantities, taxes, fees, discounts and credits. Included adjustments must be confirmed. A review can be bound to the exact quote revision and its warning codes so a reprice requires another review.

`taxIncluded` on an item describes its displayed price. It does not split embedded tax out of that price. Separate tax lines and included adjustments contribute additional amounts; the backend must avoid representing the same tax twice.

## Payment Methods and Wallets

Saved-method references are checked against the current account, customer, environment and observation expiry. Presentation uses masked card summaries. Card numbers and security codes remain inside the host's native Stripe components.

Wallet availability combines merchant configuration with current capability records. Apple Pay and Google Pay still require host entitlements, device support and the installed SDK's setup.

## Verification and Recovery

Backend verification binds the intent to the order, order revision, customer where applicable, currency, total and environment. A succeeded intent must report the expected received amount. Capture authorization is presented separately from a paid result.

The optional pending-reference store saves the existing request before allocation. It stores references and request metadata, not SDK credentials. Its digest detects accidental modification; it is not an authentication mechanism or encrypted storage.

Expired unresolved references remain available for backend lookup. Retention expiry does not imply that the payment failed. The backend must enforce order-level deduplication across devices, restarts and installations, including when local persistence is disabled.

## Receipts and Refunds

Receipt validation checks the verified intent, order total and receipt lines. Receipt links can be restricted to exact approved hosts and path boundaries.

Refund records support read-only totals for completed, pending and remaining amounts. Incomplete history leaves the remaining amount unknown. This module does not create refunds or perform capture operations.

## Repository Structure

| Location | Contents |
| --- | --- |
| `lib/custom_code/actions` | Existing FlutterFlow payment actions |
| `lib/custom_code/functions` | Existing payment helpers and navigation markers |
| `lib/custom_code/widgets` | Stripe card-entry widget |
| `lib/payment_core` | Checkout, backend contracts, money, reads, recovery and presentation |
| `lib/payment_core/models` | Typed payment records |
| `lib/trippl_payments_mobile.dart` | Standalone Dart core exports |
| `test` | Contract, checkout, recovery and compatibility tests |
| `tool` | Model generation, verification, source inventory and packaging |

## Application Integration

Import the Dart core through `package:trippl_payments_mobile/trippl_payments_mobile.dart`.

Supply a `PaymentBackend` implementation or use `PaymentBackendGateway` with an authenticated `PaymentJsonEndpoint`. The included endpoint paths are integration contracts, not deployed services.

Supply `PaymentNativeSdk` or `PaymentCallbackSdk` callbacks connected to the host's pinned Stripe SDK. Inject a scope shared by the current authenticated account, an explicit test/live configuration and a clock. Share one `PaymentAttemptCoordinator` between checkout screens for that account.

The existing FlutterFlow actions and `StripeCardField` parameter interfaces are preserved. They remain legacy entry points and are not automatically rewired to the new controller. Their existing currency defaults, test/live flags and boolean return values must be reviewed when the host migrates to the core. Use backend currency rules and the verified controller result for new checkout flows.

See [integration notes](docs/INTEGRATION.md) for the request lifecycle and backend responsibilities.

## Development

The standalone core targets Dart 3.10 or later. Verification currently uses Dart 3.13.7.

```sh
dart pub get --enforce-lockfile
dart analyze
dart test
python3 tool/verify_generated.py
python3 tool/verify_host_interfaces.py
python3 tool/verify_legacy_helpers.py
python3 tool/source_inventory.py
```

Typed models are generated from `tool/payment_models.json` and `tool/payment_rules.json`. After changing definitions:

```sh
python3 tool/generate_payment_models.py
dart format --language-version=3.10 lib/payment_core/models
```

The browser smoke check compiles the pure Dart core to JavaScript and exercises fake checkout, exact amounts and local recovery. It does not exercise Payment Sheet, Apple Pay or Google Pay.

The standalone analyzer excludes FlutterFlow custom-code imports because the exported application, generated Firebase code and Flutter plugin dependencies are not bundled here. Compatibility checks preserve original parameter interfaces and the widget constructor, and tests compile extracted pure helper bodies. The full FlutterFlow application must be built and tested with its actual SDK versions before release.

## Source Package

After committing source changes:

```sh
python3 tool/package_source.py --output dist
```

The command creates a deterministic source archive, checksum and per-file manifest. The archive contains tracked source only. Credentials, dependency caches and build output are excluded.

## References

- [Stripe currencies and minor units](https://docs.stripe.com/currencies)
- [PaymentIntent status verification](https://docs.stripe.com/payments/payment-intents/verifying-status)
- [Stripe idempotent requests](https://docs.stripe.com/api/idempotent_requests)
