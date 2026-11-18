import 'dart:convert';
import 'package:test/test.dart';
import 'package:trippl_payments_mobile/trippl_payments_mobile.dart';

void main() {
  test('PaymentMoney canonical contract round trip', () {
    final json = Map<String, Object?>.from(
      jsonDecode("{\"currency\": \"GBP\", \"amountMinor\": 1250}") as Map,
    );
    final value = PaymentMoney.fromJson(json);
    expect(value.validate(), isEmpty);
    final copy = PaymentMoney.fromJson(value.toJson());
    expect(copy, value);
    expect(copy.hashCode, value.hashCode);
    expect(value.toString(), 'PaymentMoney(redacted)');
    expect(
      () => PaymentMoney.fromJson({...json, 'unknownField': 'bad'}),
      throwsFormatException,
    );
  });
  test('PaymentCurrencyRule canonical contract round trip', () {
    final json = Map<String, Object?>.from(
      jsonDecode(
            "{\"currency\": \"GBP\", \"decimals\": 2, \"observedAt\": \"2026-11-18T12:00:00.000Z\", \"expiresAt\": \"2026-11-18T12:10:00.000Z\"}",
          )
          as Map,
    );
    final value = PaymentCurrencyRule.fromJson(json);
    expect(value.validate(), isEmpty);
    final copy = PaymentCurrencyRule.fromJson(value.toJson());
    expect(copy, value);
    expect(copy.hashCode, value.hashCode);
    expect(value.toString(), 'PaymentCurrencyRule(redacted)');
    expect(
      () => PaymentCurrencyRule.fromJson({...json, 'unknownField': 'bad'}),
      throwsFormatException,
    );
  });
  test('PaymentCurrencyCatalog canonical contract round trip', () {
    final json = Map<String, Object?>.from(
      jsonDecode(
            "{\"id\": \"id-fixture\", \"scopeFingerprint\": \"aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa\", \"merchantCountry\": \"GB\", \"observedAt\": \"2026-11-18T12:00:00.000Z\", \"expiresAt\": \"2026-11-18T12:10:00.000Z\"}",
          )
          as Map,
    );
    final value = PaymentCurrencyCatalog.fromJson(json);
    expect(value.validate(), isEmpty);
    final copy = PaymentCurrencyCatalog.fromJson(value.toJson());
    expect(copy, value);
    expect(copy.hashCode, value.hashCode);
    expect(value.toString(), 'PaymentCurrencyCatalog(redacted)');
    expect(
      () => PaymentCurrencyCatalog.fromJson({...json, 'unknownField': 'bad'}),
      throwsFormatException,
    );
  });
  test('PaymentOrderLine canonical contract round trip', () {
    final json = Map<String, Object?>.from(
      jsonDecode(
            "{\"id\": \"id-fixture\", \"label\": \"label-fixture\", \"unitAmount\": {\"currency\": \"GBP\", \"amountMinor\": 1250}}",
          )
          as Map,
    );
    final value = PaymentOrderLine.fromJson(json);
    expect(value.validate(), isEmpty);
    final copy = PaymentOrderLine.fromJson(value.toJson());
    expect(copy, value);
    expect(copy.hashCode, value.hashCode);
    expect(value.toString(), 'PaymentOrderLine(redacted)');
    expect(
      () => PaymentOrderLine.fromJson({...json, 'unknownField': 'bad'}),
      throwsFormatException,
    );
  });
  test('PaymentAdjustment canonical contract round trip', () {
    final json = Map<String, Object?>.from(
      jsonDecode(
            "{\"id\": \"id-fixture\", \"kind\": \"fee\", \"amount\": {\"currency\": \"GBP\", \"amountMinor\": 1250}}",
          )
          as Map,
    );
    final value = PaymentAdjustment.fromJson(json);
    expect(value.validate(), isEmpty);
    final copy = PaymentAdjustment.fromJson(value.toJson());
    expect(copy, value);
    expect(copy.hashCode, value.hashCode);
    expect(value.toString(), 'PaymentAdjustment(redacted)');
    expect(
      () => PaymentAdjustment.fromJson({...json, 'unknownField': 'bad'}),
      throwsFormatException,
    );
  });
  test('PaymentOrder canonical contract round trip', () {
    final json = Map<String, Object?>.from(
      jsonDecode(
            "{\"id\": \"id-fixture\", \"scopeFingerprint\": \"aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa\", \"serviceType\": \"serviceType-fixture\", \"total\": {\"currency\": \"GBP\", \"amountMinor\": 1250}, \"createdAt\": \"2026-11-18T12:00:00.000Z\", \"updatedAt\": \"2026-11-18T12:00:00.000Z\", \"revision\": 1}",
          )
          as Map,
    );
    final value = PaymentOrder.fromJson(json);
    expect(value.validate(), isEmpty);
    final copy = PaymentOrder.fromJson(value.toJson());
    expect(copy, value);
    expect(copy.hashCode, value.hashCode);
    expect(value.toString(), 'PaymentOrder(redacted)');
    expect(
      () => PaymentOrder.fromJson({...json, 'unknownField': 'bad'}),
      throwsFormatException,
    );
  });
  test('PaymentQuote canonical contract round trip', () {
    final json = Map<String, Object?>.from(
      jsonDecode(
            "{\"id\": \"id-fixture\", \"orderId\": \"orderId-fixture\", \"orderRevision\": 1, \"scopeFingerprint\": \"aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa\", \"orderFingerprint\": \"bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb\", \"total\": {\"currency\": \"GBP\", \"amountMinor\": 1250}, \"observedAt\": \"2026-11-18T12:00:00.000Z\", \"expiresAt\": \"2026-11-18T12:10:00.000Z\"}",
          )
          as Map,
    );
    final value = PaymentQuote.fromJson(json);
    expect(value.validate(), isEmpty);
    final copy = PaymentQuote.fromJson(value.toJson());
    expect(copy, value);
    expect(copy.hashCode, value.hashCode);
    expect(value.toString(), 'PaymentQuote(redacted)');
    expect(
      () => PaymentQuote.fromJson({...json, 'unknownField': 'bad'}),
      throwsFormatException,
    );
  });
  test('PaymentCustomerReference canonical contract round trip', () {
    final json = Map<String, Object?>.from(
      jsonDecode(
            "{\"id\": \"id-fixture\", \"scopeFingerprint\": \"aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa\", \"customerId\": \"customerId-fixture\", \"observedAt\": \"2026-11-18T12:00:00.000Z\", \"expiresAt\": \"2026-11-18T12:10:00.000Z\", \"environment\": \"test\"}",
          )
          as Map,
    );
    final value = PaymentCustomerReference.fromJson(json);
    expect(value.validate(), isEmpty);
    final copy = PaymentCustomerReference.fromJson(value.toJson());
    expect(copy, value);
    expect(copy.hashCode, value.hashCode);
    expect(value.toString(), 'PaymentCustomerReference(redacted)');
    expect(
      () => PaymentCustomerReference.fromJson({...json, 'unknownField': 'bad'}),
      throwsFormatException,
    );
  });
  test('PaymentBillingSummary canonical contract round trip', () {
    final json = Map<String, Object?>.from(jsonDecode("{}") as Map);
    final value = PaymentBillingSummary.fromJson(json);
    expect(value.validate(), isEmpty);
    final copy = PaymentBillingSummary.fromJson(value.toJson());
    expect(copy, value);
    expect(copy.hashCode, value.hashCode);
    expect(value.toString(), 'PaymentBillingSummary(redacted)');
    expect(
      () => PaymentBillingSummary.fromJson({...json, 'unknownField': 'bad'}),
      throwsFormatException,
    );
  });
  test('PaymentMethodReference canonical contract round trip', () {
    final json = Map<String, Object?>.from(
      jsonDecode(
            "{\"id\": \"id-fixture\", \"scopeFingerprint\": \"aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa\", \"customerId\": \"customerId-fixture\", \"methodId\": \"methodId-fixture\", \"type\": \"card\", \"observedAt\": \"2026-11-18T12:00:00.000Z\", \"expiresAt\": \"2026-11-18T12:10:00.000Z\", \"environment\": \"test\"}",
          )
          as Map,
    );
    final value = PaymentMethodReference.fromJson(json);
    expect(value.validate(), isEmpty);
    final copy = PaymentMethodReference.fromJson(value.toJson());
    expect(copy, value);
    expect(copy.hashCode, value.hashCode);
    expect(value.toString(), 'PaymentMethodReference(redacted)');
    expect(
      () => PaymentMethodReference.fromJson({...json, 'unknownField': 'bad'}),
      throwsFormatException,
    );
  });
  test('PaymentWalletCapability canonical contract round trip', () {
    final json = Map<String, Object?>.from(
      jsonDecode(
            "{\"kind\": \"card\", \"supported\": false, \"checkedAt\": \"2026-11-18T12:00:00.000Z\", \"expiresAt\": \"2026-11-18T12:10:00.000Z\", \"environment\": \"test\"}",
          )
          as Map,
    );
    final value = PaymentWalletCapability.fromJson(json);
    expect(value.validate(), isEmpty);
    final copy = PaymentWalletCapability.fromJson(value.toJson());
    expect(copy, value);
    expect(copy.hashCode, value.hashCode);
    expect(value.toString(), 'PaymentWalletCapability(redacted)');
    expect(
      () => PaymentWalletCapability.fromJson({...json, 'unknownField': 'bad'}),
      throwsFormatException,
    );
  });
  test('PaymentSdkConfiguration canonical contract round trip', () {
    final json = Map<String, Object?>.from(
      jsonDecode(
            "{\"merchantName\": \"merchantName-fixture\", \"merchantCountry\": \"GB\", \"environment\": \"test\", \"returnUri\": \"mytrippl://payments/return\"}",
          )
          as Map,
    );
    final value = PaymentSdkConfiguration.fromJson(json);
    expect(value.validate(), isEmpty);
    final copy = PaymentSdkConfiguration.fromJson(value.toJson());
    expect(copy, value);
    expect(copy.hashCode, value.hashCode);
    expect(value.toString(), 'PaymentSdkConfiguration(redacted)');
    expect(
      () => PaymentSdkConfiguration.fromJson({...json, 'unknownField': 'bad'}),
      throwsFormatException,
    );
  });
  test('PaymentCredentialsReference canonical contract round trip', () {
    final json = Map<String, Object?>.from(
      jsonDecode(
            "{\"id\": \"id-fixture\", \"scopeFingerprint\": \"aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa\", \"orderId\": \"orderId-fixture\", \"intentId\": \"intentId-fixture\", \"environment\": \"test\", \"createdAt\": \"2026-11-18T12:00:00.000Z\", \"expiresAt\": \"2026-11-18T12:10:00.000Z\"}",
          )
          as Map,
    );
    final value = PaymentCredentialsReference.fromJson(json);
    expect(value.validate(), isEmpty);
    final copy = PaymentCredentialsReference.fromJson(value.toJson());
    expect(copy, value);
    expect(copy.hashCode, value.hashCode);
    expect(value.toString(), 'PaymentCredentialsReference(redacted)');
    expect(
      () => PaymentCredentialsReference.fromJson({
        ...json,
        'unknownField': 'bad',
      }),
      throwsFormatException,
    );
  });
  test('PaymentCheckoutRequest canonical contract round trip', () {
    final json = Map<String, Object?>.from(
      jsonDecode(
            "{\"id\": \"id-fixture\", \"scopeFingerprint\": \"aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa\", \"orderId\": \"orderId-fixture\", \"orderRevision\": 1, \"orderFingerprint\": \"bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb\", \"quoteId\": \"quoteId-fixture\", \"total\": {\"currency\": \"GBP\", \"amountMinor\": 1250}, \"attemptId\": \"attemptId-fixture\", \"idempotencyKey\": \"idempotencyKey-fixture\", \"environment\": \"test\", \"createdAt\": \"2026-11-18T12:00:00.000Z\"}",
          )
          as Map,
    );
    final value = PaymentCheckoutRequest.fromJson(json);
    expect(value.validate(), isEmpty);
    final copy = PaymentCheckoutRequest.fromJson(value.toJson());
    expect(copy, value);
    expect(copy.hashCode, value.hashCode);
    expect(value.toString(), 'PaymentCheckoutRequest(redacted)');
    expect(
      () => PaymentCheckoutRequest.fromJson({...json, 'unknownField': 'bad'}),
      throwsFormatException,
    );
  });
  test('PaymentAllocation canonical contract round trip', () {
    final json = Map<String, Object?>.from(
      jsonDecode(
            "{\"id\": \"id-fixture\", \"scopeFingerprint\": \"aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa\", \"requestFingerprint\": \"cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc\", \"orderId\": \"orderId-fixture\", \"quoteId\": \"quoteId-fixture\", \"intentId\": \"intentId-fixture\", \"total\": {\"currency\": \"GBP\", \"amountMinor\": 1250}, \"credentials\": {\"id\": \"id-fixture\", \"scopeFingerprint\": \"aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa\", \"orderId\": \"orderId-fixture\", \"intentId\": \"intentId-fixture\", \"environment\": \"test\", \"createdAt\": \"2026-11-18T12:00:00.000Z\", \"expiresAt\": \"2026-11-18T12:10:00.000Z\"}, \"environment\": \"test\", \"observedAt\": \"2026-11-18T12:00:00.000Z\", \"expiresAt\": \"2026-11-18T12:10:00.000Z\"}",
          )
          as Map,
    );
    final value = PaymentAllocation.fromJson(json);
    expect(value.validate(), isEmpty);
    final copy = PaymentAllocation.fromJson(value.toJson());
    expect(copy, value);
    expect(copy.hashCode, value.hashCode);
    expect(value.toString(), 'PaymentAllocation(redacted)');
    expect(
      () => PaymentAllocation.fromJson({...json, 'unknownField': 'bad'}),
      throwsFormatException,
    );
  });
  test('PaymentAttempt canonical contract round trip', () {
    final json = Map<String, Object?>.from(
      jsonDecode(
            "{\"id\": \"id-fixture\", \"scopeFingerprint\": \"aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa\", \"orderId\": \"orderId-fixture\", \"orderFingerprint\": \"bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb\", \"quoteId\": \"quoteId-fixture\", \"idempotencyKey\": \"idempotencyKey-fixture\", \"environment\": \"test\", \"createdAt\": \"2026-11-18T12:00:00.000Z\", \"updatedAt\": \"2026-11-18T12:00:00.000Z\"}",
          )
          as Map,
    );
    final value = PaymentAttempt.fromJson(json);
    expect(value.validate(), isEmpty);
    final copy = PaymentAttempt.fromJson(value.toJson());
    expect(copy, value);
    expect(copy.hashCode, value.hashCode);
    expect(value.toString(), 'PaymentAttempt(redacted)');
    expect(
      () => PaymentAttempt.fromJson({...json, 'unknownField': 'bad'}),
      throwsFormatException,
    );
  });
  test('PaymentIntent canonical contract round trip', () {
    final json = Map<String, Object?>.from(
      jsonDecode(
            "{\"id\": \"id-fixture\", \"scopeFingerprint\": \"aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa\", \"orderId\": \"orderId-fixture\", \"orderRevision\": 1, \"total\": {\"currency\": \"GBP\", \"amountMinor\": 1250}, \"status\": \"unknown\", \"environment\": \"test\", \"observedAt\": \"2026-11-18T12:00:00.000Z\", \"expiresAt\": \"2026-11-18T12:10:00.000Z\"}",
          )
          as Map,
    );
    final value = PaymentIntent.fromJson(json);
    expect(value.validate(), isEmpty);
    final copy = PaymentIntent.fromJson(value.toJson());
    expect(copy, value);
    expect(copy.hashCode, value.hashCode);
    expect(value.toString(), 'PaymentIntent(redacted)');
    expect(
      () => PaymentIntent.fromJson({...json, 'unknownField': 'bad'}),
      throwsFormatException,
    );
  });
  test('PaymentIntentAssessment canonical contract round trip', () {
    final json = Map<String, Object?>.from(
      jsonDecode(
            "{\"intentId\": \"intentId-fixture\", \"orderId\": \"orderId-fixture\", \"evaluatedAt\": \"2026-11-18T12:00:00.000Z\", \"state\": \"unknown\"}",
          )
          as Map,
    );
    final value = PaymentIntentAssessment.fromJson(json);
    expect(value.validate(), isEmpty);
    final copy = PaymentIntentAssessment.fromJson(value.toJson());
    expect(copy, value);
    expect(copy.hashCode, value.hashCode);
    expect(value.toString(), 'PaymentIntentAssessment(redacted)');
    expect(
      () => PaymentIntentAssessment.fromJson({...json, 'unknownField': 'bad'}),
      throwsFormatException,
    );
  });
  test('PaymentVerificationRequest canonical contract round trip', () {
    final json = Map<String, Object?>.from(
      jsonDecode(
            "{\"id\": \"id-fixture\", \"scopeFingerprint\": \"aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa\", \"orderId\": \"orderId-fixture\", \"orderFingerprint\": \"bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb\", \"intentId\": \"intentId-fixture\", \"attemptId\": \"attemptId-fixture\", \"expectedTotal\": {\"currency\": \"GBP\", \"amountMinor\": 1250}, \"environment\": \"test\", \"createdAt\": \"2026-11-18T12:00:00.000Z\"}",
          )
          as Map,
    );
    final value = PaymentVerificationRequest.fromJson(json);
    expect(value.validate(), isEmpty);
    final copy = PaymentVerificationRequest.fromJson(value.toJson());
    expect(copy, value);
    expect(copy.hashCode, value.hashCode);
    expect(value.toString(), 'PaymentVerificationRequest(redacted)');
    expect(
      () =>
          PaymentVerificationRequest.fromJson({...json, 'unknownField': 'bad'}),
      throwsFormatException,
    );
  });
  test('PaymentWebhookAcknowledgement canonical contract round trip', () {
    final json = Map<String, Object?>.from(
      jsonDecode(
            "{\"id\": \"id-fixture\", \"scopeFingerprint\": \"aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa\", \"orderId\": \"orderId-fixture\", \"intentId\": \"intentId-fixture\", \"eventId\": \"eventId-fixture\", \"eventType\": \"eventType-fixture\", \"receivedAt\": \"2026-11-18T12:00:00.000Z\", \"verifiedAt\": \"2026-11-18T12:00:00.000Z\"}",
          )
          as Map,
    );
    final value = PaymentWebhookAcknowledgement.fromJson(json);
    expect(value.validate(), isEmpty);
    final copy = PaymentWebhookAcknowledgement.fromJson(value.toJson());
    expect(copy, value);
    expect(copy.hashCode, value.hashCode);
    expect(value.toString(), 'PaymentWebhookAcknowledgement(redacted)');
    expect(
      () => PaymentWebhookAcknowledgement.fromJson({
        ...json,
        'unknownField': 'bad',
      }),
      throwsFormatException,
    );
  });
  test('PaymentOrderBinding canonical contract round trip', () {
    final json = Map<String, Object?>.from(
      jsonDecode(
            "{\"scopeFingerprint\": \"aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa\", \"orderId\": \"orderId-fixture\", \"orderRevision\": 1, \"orderFingerprint\": \"bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb\", \"intentId\": \"intentId-fixture\", \"total\": {\"currency\": \"GBP\", \"amountMinor\": 1250}, \"environment\": \"test\", \"observedAt\": \"2026-11-18T12:00:00.000Z\", \"expiresAt\": \"2026-11-18T12:10:00.000Z\"}",
          )
          as Map,
    );
    final value = PaymentOrderBinding.fromJson(json);
    expect(value.validate(), isEmpty);
    final copy = PaymentOrderBinding.fromJson(value.toJson());
    expect(copy, value);
    expect(copy.hashCode, value.hashCode);
    expect(value.toString(), 'PaymentOrderBinding(redacted)');
    expect(
      () => PaymentOrderBinding.fromJson({...json, 'unknownField': 'bad'}),
      throwsFormatException,
    );
  });
  test('PaymentVerification canonical contract round trip', () {
    final json = Map<String, Object?>.from(
      jsonDecode(
            "{\"id\": \"id-fixture\", \"scopeFingerprint\": \"aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa\", \"requestFingerprint\": \"cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc\", \"binding\": {\"scopeFingerprint\": \"aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa\", \"orderId\": \"orderId-fixture\", \"orderRevision\": 1, \"orderFingerprint\": \"bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb\", \"intentId\": \"intentId-fixture\", \"total\": {\"currency\": \"GBP\", \"amountMinor\": 1250}, \"environment\": \"test\", \"observedAt\": \"2026-11-18T12:00:00.000Z\", \"expiresAt\": \"2026-11-18T12:10:00.000Z\"}, \"intent\": {\"id\": \"id-fixture\", \"scopeFingerprint\": \"aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa\", \"orderId\": \"orderId-fixture\", \"orderRevision\": 1, \"total\": {\"currency\": \"GBP\", \"amountMinor\": 1250}, \"status\": \"unknown\", \"environment\": \"test\", \"observedAt\": \"2026-11-18T12:00:00.000Z\", \"expiresAt\": \"2026-11-18T12:10:00.000Z\"}, \"observedAt\": \"2026-11-18T12:00:00.000Z\", \"expiresAt\": \"2026-11-18T12:10:00.000Z\"}",
          )
          as Map,
    );
    final value = PaymentVerification.fromJson(json);
    expect(value.validate(), isEmpty);
    final copy = PaymentVerification.fromJson(value.toJson());
    expect(copy, value);
    expect(copy.hashCode, value.hashCode);
    expect(value.toString(), 'PaymentVerification(redacted)');
    expect(
      () => PaymentVerification.fromJson({...json, 'unknownField': 'bad'}),
      throwsFormatException,
    );
  });
  test('PaymentNextAction canonical contract round trip', () {
    final json = Map<String, Object?>.from(
      jsonDecode(
            "{\"intentId\": \"intentId-fixture\", \"kind\": \"none\", \"observedAt\": \"2026-11-18T12:00:00.000Z\", \"expiresAt\": \"2026-11-18T12:10:00.000Z\"}",
          )
          as Map,
    );
    final value = PaymentNextAction.fromJson(json);
    expect(value.validate(), isEmpty);
    final copy = PaymentNextAction.fromJson(value.toJson());
    expect(copy, value);
    expect(copy.hashCode, value.hashCode);
    expect(value.toString(), 'PaymentNextAction(redacted)');
    expect(
      () => PaymentNextAction.fromJson({...json, 'unknownField': 'bad'}),
      throwsFormatException,
    );
  });
  test('PaymentReturnPolicy canonical contract round trip', () {
    final json = Map<String, Object?>.from(
      jsonDecode(
            "{\"allowedSchemes\": [\"https\"], \"allowedHosts\": [\"payments.mytrippl.com\"], \"allowedPaths\": [\"/return\"]}",
          )
          as Map,
    );
    final value = PaymentReturnPolicy.fromJson(json);
    expect(value.validate(), isEmpty);
    final copy = PaymentReturnPolicy.fromJson(value.toJson());
    expect(copy, value);
    expect(copy.hashCode, value.hashCode);
    expect(value.toString(), 'PaymentReturnPolicy(redacted)');
    expect(
      () => PaymentReturnPolicy.fromJson({...json, 'unknownField': 'bad'}),
      throwsFormatException,
    );
  });
  test('PaymentReturnSignal canonical contract round trip', () {
    final json = Map<String, Object?>.from(
      jsonDecode(
            "{\"receivedAt\": \"2026-11-18T12:00:00.000Z\", \"kind\": \"unknown\"}",
          )
          as Map,
    );
    final value = PaymentReturnSignal.fromJson(json);
    expect(value.validate(), isEmpty);
    final copy = PaymentReturnSignal.fromJson(value.toJson());
    expect(copy, value);
    expect(copy.hashCode, value.hashCode);
    expect(value.toString(), 'PaymentReturnSignal(redacted)');
    expect(
      () => PaymentReturnSignal.fromJson({...json, 'unknownField': 'bad'}),
      throwsFormatException,
    );
  });
  test('PaymentError canonical contract round trip', () {
    final json = Map<String, Object?>.from(
      jsonDecode(
            "{\"code\": \"code-fixture\", \"category\": \"unknown\", \"occurredAt\": \"2026-11-18T12:00:00.000Z\"}",
          )
          as Map,
    );
    final value = PaymentError.fromJson(json);
    expect(value.validate(), isEmpty);
    final copy = PaymentError.fromJson(value.toJson());
    expect(copy, value);
    expect(copy.hashCode, value.hashCode);
    expect(value.toString(), 'PaymentError(redacted)');
    expect(
      () => PaymentError.fromJson({...json, 'unknownField': 'bad'}),
      throwsFormatException,
    );
  });
  test('PaymentRetryPolicy canonical contract round trip', () {
    final json = Map<String, Object?>.from(jsonDecode("{}") as Map);
    final value = PaymentRetryPolicy.fromJson(json);
    expect(value.validate(), isEmpty);
    final copy = PaymentRetryPolicy.fromJson(value.toJson());
    expect(copy, value);
    expect(copy.hashCode, value.hashCode);
    expect(value.toString(), 'PaymentRetryPolicy(redacted)');
    expect(
      () => PaymentRetryPolicy.fromJson({...json, 'unknownField': 'bad'}),
      throwsFormatException,
    );
  });
  test('PaymentReadPolicy canonical contract round trip', () {
    final json = Map<String, Object?>.from(jsonDecode("{}") as Map);
    final value = PaymentReadPolicy.fromJson(json);
    expect(value.validate(), isEmpty);
    final copy = PaymentReadPolicy.fromJson(value.toJson());
    expect(copy, value);
    expect(copy.hashCode, value.hashCode);
    expect(value.toString(), 'PaymentReadPolicy(redacted)');
    expect(
      () => PaymentReadPolicy.fromJson({...json, 'unknownField': 'bad'}),
      throwsFormatException,
    );
  });
  test('PaymentReadRequest canonical contract round trip', () {
    final json = Map<String, Object?>.from(
      jsonDecode(
            "{\"id\": \"id-fixture\", \"scopeFingerprint\": \"aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa\", \"mode\": \"currencies\", \"environment\": \"test\", \"createdAt\": \"2026-11-18T12:00:00.000Z\"}",
          )
          as Map,
    );
    final value = PaymentReadRequest.fromJson(json);
    expect(value.validate(), isEmpty);
    final copy = PaymentReadRequest.fromJson(value.toJson());
    expect(copy, value);
    expect(copy.hashCode, value.hashCode);
    expect(value.toString(), 'PaymentReadRequest(redacted)');
    expect(
      () => PaymentReadRequest.fromJson({...json, 'unknownField': 'bad'}),
      throwsFormatException,
    );
  });
  test('PaymentReadPage canonical contract round trip', () {
    final json = Map<String, Object?>.from(
      jsonDecode(
            "{\"id\": \"id-fixture\", \"scopeFingerprint\": \"aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa\", \"requestFingerprint\": \"cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc\", \"environment\": \"test\", \"observedAt\": \"2026-11-18T12:00:00.000Z\", \"expiresAt\": \"2026-11-18T12:10:00.000Z\"}",
          )
          as Map,
    );
    final value = PaymentReadPage.fromJson(json);
    expect(value.validate(), isEmpty);
    final copy = PaymentReadPage.fromJson(value.toJson());
    expect(copy, value);
    expect(copy.hashCode, value.hashCode);
    expect(value.toString(), 'PaymentReadPage(redacted)');
    expect(
      () => PaymentReadPage.fromJson({...json, 'unknownField': 'bad'}),
      throwsFormatException,
    );
  });
  test('PaymentReadFailure canonical contract round trip', () {
    final json = Map<String, Object?>.from(
      jsonDecode(
            "{\"code\": \"code-fixture\", \"occurredAt\": \"2026-11-18T12:00:00.000Z\"}",
          )
          as Map,
    );
    final value = PaymentReadFailure.fromJson(json);
    expect(value.validate(), isEmpty);
    final copy = PaymentReadFailure.fromJson(value.toJson());
    expect(copy, value);
    expect(copy.hashCode, value.hashCode);
    expect(value.toString(), 'PaymentReadFailure(redacted)');
    expect(
      () => PaymentReadFailure.fromJson({...json, 'unknownField': 'bad'}),
      throwsFormatException,
    );
  });
  test('PaymentReadState canonical contract round trip', () {
    final json = Map<String, Object?>.from(
      jsonDecode(
            "{\"scopeFingerprint\": \"aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa\", \"requestFingerprint\": \"cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc\", \"updatedAt\": \"2026-11-18T12:00:00.000Z\", \"state\": \"loading\"}",
          )
          as Map,
    );
    final value = PaymentReadState.fromJson(json);
    expect(value.validate(), isEmpty);
    final copy = PaymentReadState.fromJson(value.toJson());
    expect(copy, value);
    expect(copy.hashCode, value.hashCode);
    expect(value.toString(), 'PaymentReadState(redacted)');
    expect(
      () => PaymentReadState.fromJson({...json, 'unknownField': 'bad'}),
      throwsFormatException,
    );
  });
  test('PaymentCheckoutState canonical contract round trip', () {
    final json = Map<String, Object?>.from(
      jsonDecode(
            "{\"scopeFingerprint\": \"aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa\", \"orderId\": \"orderId-fixture\", \"updatedAt\": \"2026-11-18T12:00:00.000Z\", \"state\": \"idle\"}",
          )
          as Map,
    );
    final value = PaymentCheckoutState.fromJson(json);
    expect(value.validate(), isEmpty);
    final copy = PaymentCheckoutState.fromJson(value.toJson());
    expect(copy, value);
    expect(copy.hashCode, value.hashCode);
    expect(value.toString(), 'PaymentCheckoutState(redacted)');
    expect(
      () => PaymentCheckoutState.fromJson({...json, 'unknownField': 'bad'}),
      throwsFormatException,
    );
  });
  test('PaymentCheckoutResult canonical contract round trip', () {
    final json = Map<String, Object?>.from(
      jsonDecode(
            "{\"orderId\": \"orderId-fixture\", \"attemptId\": \"attemptId-fixture\", \"evaluatedAt\": \"2026-11-18T12:00:00.000Z\", \"state\": \"unknown\"}",
          )
          as Map,
    );
    final value = PaymentCheckoutResult.fromJson(json);
    expect(value.validate(), isEmpty);
    final copy = PaymentCheckoutResult.fromJson(value.toJson());
    expect(copy, value);
    expect(copy.hashCode, value.hashCode);
    expect(value.toString(), 'PaymentCheckoutResult(redacted)');
    expect(
      () => PaymentCheckoutResult.fromJson({...json, 'unknownField': 'bad'}),
      throwsFormatException,
    );
  });
  test('PaymentReceiptLine canonical contract round trip', () {
    final json = Map<String, Object?>.from(
      jsonDecode(
            "{\"id\": \"id-fixture\", \"label\": \"label-fixture\", \"amount\": {\"currency\": \"GBP\", \"amountMinor\": 1250}}",
          )
          as Map,
    );
    final value = PaymentReceiptLine.fromJson(json);
    expect(value.validate(), isEmpty);
    final copy = PaymentReceiptLine.fromJson(value.toJson());
    expect(copy, value);
    expect(copy.hashCode, value.hashCode);
    expect(value.toString(), 'PaymentReceiptLine(redacted)');
    expect(
      () => PaymentReceiptLine.fromJson({...json, 'unknownField': 'bad'}),
      throwsFormatException,
    );
  });
  test('PaymentReceipt canonical contract round trip', () {
    final json = Map<String, Object?>.from(
      jsonDecode(
            "{\"id\": \"id-fixture\", \"scopeFingerprint\": \"aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa\", \"orderId\": \"orderId-fixture\", \"intentId\": \"intentId-fixture\", \"total\": {\"currency\": \"GBP\", \"amountMinor\": 1250}, \"issuedAt\": \"2026-11-18T12:00:00.000Z\", \"observedAt\": \"2026-11-18T12:00:00.000Z\", \"expiresAt\": \"2026-11-18T12:10:00.000Z\", \"environment\": \"test\"}",
          )
          as Map,
    );
    final value = PaymentReceipt.fromJson(json);
    expect(value.validate(), isEmpty);
    final copy = PaymentReceipt.fromJson(value.toJson());
    expect(copy, value);
    expect(copy.hashCode, value.hashCode);
    expect(value.toString(), 'PaymentReceipt(redacted)');
    expect(
      () => PaymentReceipt.fromJson({...json, 'unknownField': 'bad'}),
      throwsFormatException,
    );
  });
  test('PaymentRefundReference canonical contract round trip', () {
    final json = Map<String, Object?>.from(
      jsonDecode(
            "{\"id\": \"id-fixture\", \"scopeFingerprint\": \"aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa\", \"orderId\": \"orderId-fixture\", \"intentId\": \"intentId-fixture\", \"amount\": {\"currency\": \"GBP\", \"amountMinor\": 1250}, \"status\": \"unknown\", \"createdAt\": \"2026-11-18T12:00:00.000Z\", \"observedAt\": \"2026-11-18T12:00:00.000Z\", \"expiresAt\": \"2026-11-18T12:10:00.000Z\", \"environment\": \"test\"}",
          )
          as Map,
    );
    final value = PaymentRefundReference.fromJson(json);
    expect(value.validate(), isEmpty);
    final copy = PaymentRefundReference.fromJson(value.toJson());
    expect(copy, value);
    expect(copy.hashCode, value.hashCode);
    expect(value.toString(), 'PaymentRefundReference(redacted)');
    expect(
      () => PaymentRefundReference.fromJson({...json, 'unknownField': 'bad'}),
      throwsFormatException,
    );
  });
  test('PaymentRefundSummary canonical contract round trip', () {
    final json = Map<String, Object?>.from(
      jsonDecode(
            "{\"orderId\": \"orderId-fixture\", \"intentId\": \"intentId-fixture\", \"evaluatedAt\": \"2026-11-18T12:00:00.000Z\", \"paid\": {\"currency\": \"GBP\", \"amountMinor\": 1250}}",
          )
          as Map,
    );
    final value = PaymentRefundSummary.fromJson(json);
    expect(value.validate(), isEmpty);
    final copy = PaymentRefundSummary.fromJson(value.toJson());
    expect(copy, value);
    expect(copy.hashCode, value.hashCode);
    expect(value.toString(), 'PaymentRefundSummary(redacted)');
    expect(
      () => PaymentRefundSummary.fromJson({...json, 'unknownField': 'bad'}),
      throwsFormatException,
    );
  });
  test('PaymentAmountBreakdown canonical contract round trip', () {
    final json = Map<String, Object?>.from(
      jsonDecode(
            "{\"orderId\": \"orderId-fixture\", \"evaluatedAt\": \"2026-11-18T12:00:00.000Z\", \"subtotal\": {\"currency\": \"GBP\", \"amountMinor\": 1250}, \"tax\": {\"currency\": \"GBP\", \"amountMinor\": 1250}, \"fees\": {\"currency\": \"GBP\", \"amountMinor\": 1250}, \"discounts\": {\"currency\": \"GBP\", \"amountMinor\": 1250}, \"credits\": {\"currency\": \"GBP\", \"amountMinor\": 1250}, \"total\": {\"currency\": \"GBP\", \"amountMinor\": 1250}}",
          )
          as Map,
    );
    final value = PaymentAmountBreakdown.fromJson(json);
    expect(value.validate(), isEmpty);
    final copy = PaymentAmountBreakdown.fromJson(value.toJson());
    expect(copy, value);
    expect(copy.hashCode, value.hashCode);
    expect(value.toString(), 'PaymentAmountBreakdown(redacted)');
    expect(
      () => PaymentAmountBreakdown.fromJson({...json, 'unknownField': 'bad'}),
      throwsFormatException,
    );
  });
  test('PaymentAmountAssessment canonical contract round trip', () {
    final json = Map<String, Object?>.from(
      jsonDecode(
            "{\"orderId\": \"orderId-fixture\", \"evaluatedAt\": \"2026-11-18T12:00:00.000Z\"}",
          )
          as Map,
    );
    final value = PaymentAmountAssessment.fromJson(json);
    expect(value.validate(), isEmpty);
    final copy = PaymentAmountAssessment.fromJson(value.toJson());
    expect(copy, value);
    expect(copy.hashCode, value.hashCode);
    expect(value.toString(), 'PaymentAmountAssessment(redacted)');
    expect(
      () => PaymentAmountAssessment.fromJson({...json, 'unknownField': 'bad'}),
      throwsFormatException,
    );
  });
  test('PaymentMethodSelection canonical contract round trip', () {
    final json = Map<String, Object?>.from(
      jsonDecode(
            "{\"scopeFingerprint\": \"aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa\", \"customerId\": \"customerId-fixture\", \"updatedAt\": \"2026-11-18T12:00:00.000Z\", \"environment\": \"test\"}",
          )
          as Map,
    );
    final value = PaymentMethodSelection.fromJson(json);
    expect(value.validate(), isEmpty);
    final copy = PaymentMethodSelection.fromJson(value.toJson());
    expect(copy, value);
    expect(copy.hashCode, value.hashCode);
    expect(value.toString(), 'PaymentMethodSelection(redacted)');
    expect(
      () => PaymentMethodSelection.fromJson({...json, 'unknownField': 'bad'}),
      throwsFormatException,
    );
  });
  test('PaymentPendingReference canonical contract round trip', () {
    final json = Map<String, Object?>.from(
      jsonDecode(
            "{\"scopeFingerprint\": \"aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa\", \"orderId\": \"orderId-fixture\", \"orderFingerprint\": \"bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb\", \"attemptId\": \"attemptId-fixture\", \"intentId\": \"intentId-fixture\", \"environment\": \"test\", \"savedAt\": \"2026-11-18T12:00:00.000Z\", \"expiresAt\": \"2026-11-18T12:10:00.000Z\"}",
          )
          as Map,
    );
    final value = PaymentPendingReference.fromJson(json);
    expect(value.validate(), isEmpty);
    final copy = PaymentPendingReference.fromJson(value.toJson());
    expect(copy, value);
    expect(copy.hashCode, value.hashCode);
    expect(value.toString(), 'PaymentPendingReference(redacted)');
    expect(
      () => PaymentPendingReference.fromJson({...json, 'unknownField': 'bad'}),
      throwsFormatException,
    );
  });
  test('PaymentResumeRequest canonical contract round trip', () {
    final json = Map<String, Object?>.from(
      jsonDecode(
            "{\"id\": \"id-fixture\", \"scopeFingerprint\": \"aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa\", \"orderId\": \"orderId-fixture\", \"orderFingerprint\": \"bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb\", \"intentId\": \"intentId-fixture\", \"attemptId\": \"attemptId-fixture\", \"environment\": \"test\", \"createdAt\": \"2026-11-18T12:00:00.000Z\"}",
          )
          as Map,
    );
    final value = PaymentResumeRequest.fromJson(json);
    expect(value.validate(), isEmpty);
    final copy = PaymentResumeRequest.fromJson(value.toJson());
    expect(copy, value);
    expect(copy.hashCode, value.hashCode);
    expect(value.toString(), 'PaymentResumeRequest(redacted)');
    expect(
      () => PaymentResumeRequest.fromJson({...json, 'unknownField': 'bad'}),
      throwsFormatException,
    );
  });
  test('PaymentReconciliation canonical contract round trip', () {
    final json = Map<String, Object?>.from(
      jsonDecode(
            "{\"orderId\": \"orderId-fixture\", \"intentId\": \"intentId-fixture\", \"evaluatedAt\": \"2026-11-18T12:00:00.000Z\", \"state\": \"unknown\"}",
          )
          as Map,
    );
    final value = PaymentReconciliation.fromJson(json);
    expect(value.validate(), isEmpty);
    final copy = PaymentReconciliation.fromJson(value.toJson());
    expect(copy, value);
    expect(copy.hashCode, value.hashCode);
    expect(value.toString(), 'PaymentReconciliation(redacted)');
    expect(
      () => PaymentReconciliation.fromJson({...json, 'unknownField': 'bad'}),
      throwsFormatException,
    );
  });
  test('PaymentCheckoutSnapshot canonical contract round trip', () {
    final json = Map<String, Object?>.from(
      jsonDecode(
            "{\"scopeFingerprint\": \"aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa\", \"orderId\": \"orderId-fixture\", \"orderFingerprint\": \"bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb\", \"updatedAt\": \"2026-11-18T12:00:00.000Z\", \"state\": \"idle\"}",
          )
          as Map,
    );
    final value = PaymentCheckoutSnapshot.fromJson(json);
    expect(value.validate(), isEmpty);
    final copy = PaymentCheckoutSnapshot.fromJson(value.toJson());
    expect(copy, value);
    expect(copy.hashCode, value.hashCode);
    expect(value.toString(), 'PaymentCheckoutSnapshot(redacted)');
    expect(
      () => PaymentCheckoutSnapshot.fromJson({...json, 'unknownField': 'bad'}),
      throwsFormatException,
    );
  });
  test('PaymentPreferences canonical contract round trip', () {
    final json = Map<String, Object?>.from(
      jsonDecode(
            "{\"scopeFingerprint\": \"aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa\", \"updatedAt\": \"2026-11-18T12:00:00.000Z\"}",
          )
          as Map,
    );
    final value = PaymentPreferences.fromJson(json);
    expect(value.validate(), isEmpty);
    final copy = PaymentPreferences.fromJson(value.toJson());
    expect(copy, value);
    expect(copy.hashCode, value.hashCode);
    expect(value.toString(), 'PaymentPreferences(redacted)');
    expect(
      () => PaymentPreferences.fromJson({...json, 'unknownField': 'bad'}),
      throwsFormatException,
    );
  });
  test('PaymentPrivacyPolicy canonical contract round trip', () {
    final json = Map<String, Object?>.from(jsonDecode("{}") as Map);
    final value = PaymentPrivacyPolicy.fromJson(json);
    expect(value.validate(), isEmpty);
    final copy = PaymentPrivacyPolicy.fromJson(value.toJson());
    expect(copy, value);
    expect(copy.hashCode, value.hashCode);
    expect(value.toString(), 'PaymentPrivacyPolicy(redacted)');
    expect(
      () => PaymentPrivacyPolicy.fromJson({...json, 'unknownField': 'bad'}),
      throwsFormatException,
    );
  });
  test('PaymentAuditEvent canonical contract round trip', () {
    final json = Map<String, Object?>.from(
      jsonDecode(
            "{\"id\": \"id-fixture\", \"scopeFingerprint\": \"aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa\", \"orderId\": \"orderId-fixture\", \"operation\": \"charge\", \"occurredAt\": \"2026-11-18T12:00:00.000Z\", \"state\": \"unknown\"}",
          )
          as Map,
    );
    final value = PaymentAuditEvent.fromJson(json);
    expect(value.validate(), isEmpty);
    final copy = PaymentAuditEvent.fromJson(value.toJson());
    expect(copy, value);
    expect(copy.hashCode, value.hashCode);
    expect(value.toString(), 'PaymentAuditEvent(redacted)');
    expect(
      () => PaymentAuditEvent.fromJson({...json, 'unknownField': 'bad'}),
      throwsFormatException,
    );
  });
  test('PaymentCapabilities canonical contract round trip', () {
    final json = Map<String, Object?>.from(
      jsonDecode(
            "{\"scopeFingerprint\": \"aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa\", \"environment\": \"test\", \"observedAt\": \"2026-11-18T12:00:00.000Z\", \"expiresAt\": \"2026-11-18T12:10:00.000Z\"}",
          )
          as Map,
    );
    final value = PaymentCapabilities.fromJson(json);
    expect(value.validate(), isEmpty);
    final copy = PaymentCapabilities.fromJson(value.toJson());
    expect(copy, value);
    expect(copy.hashCode, value.hashCode);
    expect(value.toString(), 'PaymentCapabilities(redacted)');
    expect(
      () => PaymentCapabilities.fromJson({...json, 'unknownField': 'bad'}),
      throwsFormatException,
    );
  });
  test('PaymentEnvironment canonical contract round trip', () {
    final json = Map<String, Object?>.from(
      jsonDecode(
            "{\"mode\": \"test\", \"merchantCountry\": \"GB\", \"publishableKeyFingerprint\": \"aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa\", \"configuredAt\": \"2026-11-18T12:00:00.000Z\"}",
          )
          as Map,
    );
    final value = PaymentEnvironment.fromJson(json);
    expect(value.validate(), isEmpty);
    final copy = PaymentEnvironment.fromJson(value.toJson());
    expect(copy, value);
    expect(copy.hashCode, value.hashCode);
    expect(value.toString(), 'PaymentEnvironment(redacted)');
    expect(
      () => PaymentEnvironment.fromJson({...json, 'unknownField': 'bad'}),
      throwsFormatException,
    );
  });
  test('PaymentCheckoutReview canonical contract round trip', () {
    final json = Map<String, Object?>.from(
      jsonDecode(
            "{\"scopeFingerprint\": \"aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa\", \"orderId\": \"orderId-fixture\", \"orderFingerprint\": \"bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb\", \"quoteId\": \"quoteId-fixture\", \"quoteRevision\": 1, \"total\": {\"currency\": \"GBP\", \"amountMinor\": 1250}, \"reviewedAt\": \"2026-11-18T12:00:00.000Z\", \"expiresAt\": \"2026-11-18T12:10:00.000Z\"}",
          )
          as Map,
    );
    final value = PaymentCheckoutReview.fromJson(json);
    expect(value.validate(), isEmpty);
    final copy = PaymentCheckoutReview.fromJson(value.toJson());
    expect(copy, value);
    expect(copy.hashCode, value.hashCode);
    expect(value.toString(), 'PaymentCheckoutReview(redacted)');
    expect(
      () => PaymentCheckoutReview.fromJson({...json, 'unknownField': 'bad'}),
      throwsFormatException,
    );
  });
  test('PaymentReadCollection canonical contract round trip', () {
    final json = Map<String, Object?>.from(
      jsonDecode(
            "{\"scopeFingerprint\": \"aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa\", \"requestFingerprint\": \"cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc\", \"mode\": \"currencies\", \"environment\": \"test\", \"collectedAt\": \"2026-11-18T12:00:00.000Z\", \"expiresAt\": \"2026-11-18T12:10:00.000Z\"}",
          )
          as Map,
    );
    final value = PaymentReadCollection.fromJson(json);
    expect(value.validate(), isEmpty);
    final copy = PaymentReadCollection.fromJson(value.toJson());
    expect(copy, value);
    expect(copy.hashCode, value.hashCode);
    expect(value.toString(), 'PaymentReadCollection(redacted)');
    expect(
      () => PaymentReadCollection.fromJson({...json, 'unknownField': 'bad'}),
      throwsFormatException,
    );
  });
  test('PaymentReceiptPolicy canonical contract round trip', () {
    final json = Map<String, Object?>.from(
      jsonDecode("{\"allowedHosts\": [\"payments.mytrippl.com\"]}") as Map,
    );
    final value = PaymentReceiptPolicy.fromJson(json);
    expect(value.validate(), isEmpty);
    final copy = PaymentReceiptPolicy.fromJson(value.toJson());
    expect(copy, value);
    expect(copy.hashCode, value.hashCode);
    expect(value.toString(), 'PaymentReceiptPolicy(redacted)');
    expect(
      () => PaymentReceiptPolicy.fromJson({...json, 'unknownField': 'bad'}),
      throwsFormatException,
    );
  });
}
