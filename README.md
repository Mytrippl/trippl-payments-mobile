# Trippl Payments Mobile

Mobile-side payment initialization, Stripe integration, payment confirmation, transaction-state processing, amount and currency handling, refunds, receipts, validation, and card-entry components used within Mytrippl.

This repository contains the custom Dart layer supporting Mytrippl's mobile payment experience. It initializes Stripe payment services, creates payment methods, confirms transactions, presents native payment flows, processes payment amounts and currencies, normalizes PaymentIntent states, interprets payment errors, prepares receipt and refund data, validates payment requests, and provides the custom card-entry interface used across supported Mytrippl booking experiences.

## Core Capabilities

### Payment Initialization

Custom actions prepare the payment environment before a transaction begins.

The module includes:

- Stripe initialization
- Payment-flow initialization
- Payment configuration
- Mobile payment setup
- Payment state preparation

This provides a shared payment layer that can be used by different Mytrippl travel services without duplicating payment initialization logic.

### Stripe Payment Methods

The repository contains mobile-side logic for creating Stripe payment methods from payment information collected within the application.

Payment-method processing includes:

- Stripe payment-method creation
- Card metadata normalization
- Card-brand presentation
- Masked card information
- Card expiry information
- Wallet identification
- Apple Pay and Google Pay identification
- Billing-detail extraction

This separates payment-method processing from service-specific booking flows and provides consistent payment-method information throughout the application.

### Payment Confirmation

Custom actions handle the client-side portion of Stripe payment confirmation.

Responsibilities include:

- Payment confirmation
- Payment state handling
- Stripe confirmation flow integration
- Processing confirmation results
- Connecting payment completion with the surrounding booking experience

### Payment Sheet

The module integrates Stripe's mobile Payment Sheet into Mytrippl's payment flow.

Custom actions handle:

- Payment Sheet initialization
- Payment Sheet presentation
- Payment completion states
- User cancellation states
- Returning control to the appropriate application flow

### Apple Pay Capability

Before presenting supported wallet options, the mobile layer can determine whether Apple Pay is available on the current device.

This allows Mytrippl to adapt the available payment experience according to device capability rather than presenting unsupported payment methods.

### Payment Amount Processing

Payment values are converted between application prices and the formats expected by payment services.

Supporting utilities include:

- Stripe amount conversion
- Retail-price conversion
- Subtotal processing
- Tax processing
- Service and processing fees
- Discounts
- Credits
- Final payable amount calculation
- Minor-unit amount preparation
- Payment adjustment calculation

The amount-processing layer keeps displayed prices separate from the values required by payment processing APIs while providing a consistent representation of transaction totals.

### Currency Processing

Currency-specific payment rules are maintained separately from individual checkout flows.

The module handles:

- Currency-code normalization
- Supported-currency validation
- Zero-decimal currencies
- Minor-unit multipliers
- Major-to-minor unit conversion
- Minor-to-major unit conversion
- Currency symbols
- Payment amount formatting

This prevents individual booking services from implementing their own currency conversion rules.

### PaymentIntent Status Processing

Stripe PaymentIntent states are converted into application-level payment states that can be consumed consistently by Mytrippl booking flows.

The status layer handles states including:

- Successful payments
- Processing payments
- Required authentication
- Required confirmation
- Required payment methods
- Authorized payments awaiting capture
- Cancelled payments
- Unknown payment states

Additional status metadata identifies whether a payment is complete, pending, failed, retryable, or requires user action.

### Payment Error Processing

Payment and Stripe errors are converted into structured application errors.

Error processing covers:

- Card declines
- Insufficient funds
- Expired cards
- Incorrect security codes
- Authentication requirements
- Network failures
- Processing failures
- User cancellation
- Payment configuration errors

The resulting structure identifies the error category, normalized error code, retryability, and the next action that can be presented to the surrounding payment flow.

### Payment Result Handling

The repository contains utilities for interpreting payment completion and cancellation states.

This includes:

- Successful payment detection
- Payment success URL handling
- Payment cancellation URL handling
- PaymentIntent status interpretation
- Returning normalized payment states to the application

### Payment Receipts

Completed payment information can be converted into structured receipt data for use by booking and transaction interfaces.

Receipt processing includes:

- Payment identifiers
- Booking references
- Service types
- Payment status
- Subtotals
- Taxes
- Fees
- Discounts
- Credits
- Final totals
- Payment-method information
- Transaction date and time
- Receipt line items

This provides a reusable receipt representation independent of the individual travel service that initiated the payment.

### Refund Processing

The mobile payment layer contains utilities for interpreting refund information and calculating refundable balances.

Refund processing includes:

- Original payment amount
- Refunded amount
- Remaining payment amount
- Partial refunds
- Full refunds
- Pending refunds
- Failed refunds
- Refund percentages
- Refund reasons
- Refund eligibility
- Available refundable balance

This allows refund states to be represented consistently across different Mytrippl booking services.

### Payment Validation

Payment requests are validated before their values are consumed by later transaction stages.

Validation covers:

- Payment amounts
- Currency codes
- PaymentIntent client secrets
- Payment-method identifiers
- Booking references
- Service types
- Payment completion states
- Received and expected amounts
- Card expiry values

Validation results provide structured error information so invalid payment data can be handled before progressing through the payment flow.

### Custom Card Entry

The custom Stripe card-field widget provides card entry within the Flutter mobile interface.

It forms the UI layer between payment details entered by the user and the payment-method creation and confirmation logic maintained by the surrounding actions.

## Payment Processing Flow

The mobile payment layer follows a staged processing model:

```text
Booking Payment Request
        │
        ▼
Payment Validation
        │
        ▼
Amount & Currency Processing
        │
        ▼
Stripe Initialization
        │
        ▼
Payment Method / Payment Sheet
        │
        ▼
Payment Confirmation
        │
        ▼
PaymentIntent Status
        │
        ├── Successful ──► Receipt Processing
        │
        ├── Processing ──► Pending State
        │
        ├── Action Required ──► User Authentication
        │
        └── Failed ──► Error Processing
                              │
                              ▼
                         Retry Decision

Completed Payment
        │
        ▼
Refund Processing
        │
        ├── Partial Refund
        └── Full Refund
```

This separates payment preparation, Stripe interaction, result interpretation, and post-payment processing into focused components.

## Repository Structure

```text
lib/
└── custom_code/
    ├── actions/
    │   ├── confirm_stripe_payment.dart
    │   ├── create_stripe_payment_method.dart
    │   ├── init_payment.dart
    │   ├── init_stripe.dart
    │   ├── initialize_stripe.dart
    │   ├── is_apple_pay_supported.dart
    │   └── present_stripe_payment_sheet.dart
    │
    ├── functions/
    │   ├── convert_to_stripe_amount.dart
    │   ├── is_stripe_payment_cancel_u_r_l.dart
    │   ├── is_stripe_payment_success.dart
    │   ├── is_stripe_payment_success_u_r_l.dart
    │   ├── stripe_amount_from_retail.dart
    │   ├── payment_amount_breakdown.dart
    │   ├── payment_currency_rules.dart
    │   ├── payment_intent_status.dart
    │   ├── payment_error_parser.dart
    │   ├── payment_method_summary.dart
    │   ├── payment_receipt_builder.dart
    │   ├── payment_refund_summary.dart
    │   └── payment_validation.dart
    │
    └── widgets/
        └── stripe_card_field.dart
```

## Function Responsibilities

### Amount and Currency

#### `payment_amount_breakdown.dart`

Builds structured payment totals from subtotals, taxes, service fees, processing fees, discounts, and credits. It also calculates payable totals, minor-unit amounts, and transaction adjustments.

#### `payment_currency_rules.dart`

Maintains currency-specific payment behavior including supported currencies, zero-decimal currencies, minor-unit conversion, currency symbols, amount validation, and display formatting.

### Transaction State

#### `payment_intent_status.dart`

Converts Stripe PaymentIntent statuses into reusable Mytrippl payment states and identifies successful, pending, retryable, authentication-required, and terminal transaction states.

#### `payment_error_parser.dart`

Normalizes Stripe and payment errors into structured error categories with retry information and recommended application actions.

### Payment Methods

#### `payment_method_summary.dart`

Converts payment-method information into a consistent representation containing card brand, masked number, expiry information, wallet type, billing information, and payment-method presentation data.

### Receipts

#### `payment_receipt_builder.dart`

Builds structured payment receipt information and receipt line items from completed transaction data.

### Refunds

#### `payment_refund_summary.dart`

Processes full and partial refund states, calculates remaining refundable amounts, evaluates refund eligibility, and produces normalized refund information.

### Validation

#### `payment_validation.dart`

Validates payment requests, completed transaction information, Stripe identifiers, payment amounts, currencies, and card expiry values before they are used by later payment stages.

## Technology

The implementation is written in Dart for the Flutter-based Mytrippl mobile application and integrates with Stripe's mobile payment infrastructure.

The custom-code layer works with Mytrippl's application state, booking flows, payment data, generated Flutter components, and backend payment services.

## Architecture

This repository represents the client-side payment processing and interpretation layer rather than the complete payment system.

The implementation separates payment responsibilities into several areas:

1. Payment requests are validated before processing.
2. Amounts and currencies are converted into consistent transaction values.
3. Stripe services and native payment interfaces are initialized.
4. Payment methods are created or selected.
5. Transactions are confirmed.
6. PaymentIntent results are normalized into application states.
7. Payment errors are interpreted into actionable results.
8. Successful transactions can be represented as structured receipts.
9. Subsequent refund information can be normalized and evaluated.

This prevents payment-specific rules from being distributed throughout individual flight, hotel, activity, transport, eSIM, and other booking interfaces.

## Security and Separation of Responsibilities

This repository does not contain Mytrippl's complete server-side payment implementation.

Sensitive transaction creation, server-side payment processing, booking confirmation, provider-specific operations, and protected Stripe credentials are maintained separately by Mytrippl's backend services.

The mobile layer focuses on:

- Preparing payment requests
- Validating client-side payment information
- Presenting supported payment interfaces
- Interacting with Stripe's mobile payment flow
- Interpreting transaction results
- Preparing application-level receipt and refund states

This separation keeps sensitive backend payment responsibilities outside the mobile processing layer.

## Project Context

Mytrippl supports multiple travel services with different booking flows while maintaining a shared payment experience.

This repository isolates reusable mobile payment engineering from individual flight, hotel, activity, transport, eSIM, visa, and other service modules. Those experiences can use a common Stripe-based payment layer without embedding payment implementation details throughout the application.

The result is a shared client-side payment architecture covering transaction preparation, amount and currency processing, payment-method handling, confirmation, status interpretation, error processing, receipts, refunds, validation, and card entry.
