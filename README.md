# Trippl Payments Mobile

Mobile-side payment initialization, Stripe integration, payment confirmation, Payment Sheet, Apple Pay capability, amount processing, and card-entry components used within Mytrippl.

This repository contains the custom Dart layer supporting Mytrippl's mobile payment experience. It initializes Stripe payment services, creates payment methods, confirms transactions, presents native payment flows, processes payment amounts and completion states, and provides the custom card-entry interface used across supported Mytrippl booking experiences.

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

This separates payment-method creation from service-specific booking flows and allows the resulting payment information to be passed into later confirmation stages.

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

Payment values are converted into formats expected by payment services.

Supporting utilities include:

- Stripe amount conversion
- Retail-price conversion
- Minor-unit amount preparation
- Consistent payment amount handling

This keeps display prices separate from the integer-based values required by payment processing APIs.

### Payment Result Handling

The repository contains utilities for interpreting payment completion and cancellation states.

This includes:

- Successful payment detection
- Payment success URL handling
- Payment cancellation URL handling
- Returning normalized payment states to the application

### Custom Card Entry

The custom Stripe card-field widget provides card entry within the Flutter mobile interface.

It forms the UI layer between payment details entered by the user and the payment-method creation and confirmation logic maintained by the surrounding actions.

## Repository Structure

```text
lib/
└── custom_code/
    ├── actions/
    │   └── Stripe initialization, payment methods, confirmation, and Payment Sheet actions
    ├── functions/
    │   └── Payment amount conversion and result-processing utilities
    └── widgets/
        └── Custom Stripe card-entry field
```

## Technology

The implementation is written in Dart for the Flutter-based Mytrippl mobile application and integrates with Stripe's mobile payment infrastructure.

The custom-code layer works with Mytrippl's application state, booking flows, payment data, generated Flutter components, and backend payment services.

## Architecture

This repository represents the client-side payment layer rather than the complete payment system.

Sensitive transaction creation, server-side payment processing, booking confirmation, and provider-specific payment operations are handled separately by Mytrippl's backend services. The mobile layer focuses on securely initiating and presenting supported payment flows and interpreting their results.

## Project Context

Mytrippl supports multiple travel services with different booking flows while maintaining a shared payment experience.

This repository isolates the reusable mobile payment engineering from individual flight, hotel, eSIM, and other service modules, allowing those experiences to use a common Stripe-based payment layer without embedding payment implementation details throughout the application.
