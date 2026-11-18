import 'dart:convert';
import 'package:test/test.dart';
import 'package:trippl_payments_mobile/trippl_payments_mobile.dart';

void main() {
  test('PaymentCountryAddressRule canonical contract round trip', () {
    final json = Map<String, Object?>.from(
      jsonDecode(
            "{\"countryCode\": \"GB\", \"observedAt\": \"2026-11-18T12:00:00.000Z\", \"expiresAt\": \"2026-11-18T12:10:00.000Z\"}",
          )
          as Map,
    );
    final value = PaymentCountryAddressRule.fromJson(json);
    expect(value.validate(), isEmpty);
    final copy = PaymentCountryAddressRule.fromJson(value.toJson());
    expect(copy, value);
    expect(copy.hashCode, value.hashCode);
    expect(value.toString(), 'PaymentCountryAddressRule(redacted)');
    expect(
      () =>
          PaymentCountryAddressRule.fromJson({...json, 'unknownField': 'bad'}),
      throwsFormatException,
    );
  });
  test('PaymentBillingAddress canonical contract round trip', () {
    final json = Map<String, Object?>.from(
      jsonDecode(
            "{\"id\": \"id-fixture\", \"countryCode\": \"GB\", \"line1\": \"line1-fixture\", \"city\": \"city-fixture\", \"updatedAt\": \"2026-11-18T12:00:00.000Z\"}",
          )
          as Map,
    );
    final value = PaymentBillingAddress.fromJson(json);
    expect(value.validate(), isEmpty);
    final copy = PaymentBillingAddress.fromJson(value.toJson());
    expect(copy, value);
    expect(copy.hashCode, value.hashCode);
    expect(value.toString(), 'PaymentBillingAddress(redacted)');
    expect(
      () => PaymentBillingAddress.fromJson({...json, 'unknownField': 'bad'}),
      throwsFormatException,
    );
  });
  test('PaymentBillingProfile canonical contract round trip', () {
    final json = Map<String, Object?>.from(
      jsonDecode(
            "{\"id\": \"id-fixture\", \"scopeFingerprint\": \"aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa\", \"environment\": \"test\", \"customerId\": \"customerId-fixture\", \"address\": {\"id\": \"id-fixture\", \"countryCode\": \"GB\", \"line1\": \"line1-fixture\", \"city\": \"city-fixture\", \"updatedAt\": \"2026-11-18T12:00:00.000Z\"}, \"observedAt\": \"2026-11-18T12:00:00.000Z\", \"expiresAt\": \"2026-11-18T12:10:00.000Z\"}",
          )
          as Map,
    );
    final value = PaymentBillingProfile.fromJson(json);
    expect(value.validate(), isEmpty);
    final copy = PaymentBillingProfile.fromJson(value.toJson());
    expect(copy, value);
    expect(copy.hashCode, value.hashCode);
    expect(value.toString(), 'PaymentBillingProfile(redacted)');
    expect(
      () => PaymentBillingProfile.fromJson({...json, 'unknownField': 'bad'}),
      throwsFormatException,
    );
  });
  test('PaymentBillingValidation canonical contract round trip', () {
    final json = Map<String, Object?>.from(
      jsonDecode(
            "{\"addressId\": \"addressId-fixture\", \"evaluatedAt\": \"2026-11-18T12:00:00.000Z\", \"ruleRevision\": 1, \"valid\": false}",
          )
          as Map,
    );
    final value = PaymentBillingValidation.fromJson(json);
    expect(value.validate(), isEmpty);
    final copy = PaymentBillingValidation.fromJson(value.toJson());
    expect(copy, value);
    expect(copy.hashCode, value.hashCode);
    expect(value.toString(), 'PaymentBillingValidation(redacted)');
    expect(
      () => PaymentBillingValidation.fromJson({...json, 'unknownField': 'bad'}),
      throwsFormatException,
    );
  });
  test('PaymentBillingPatch canonical contract round trip', () {
    final json = Map<String, Object?>.from(
      jsonDecode(
            "{\"id\": \"id-fixture\", \"scopeFingerprint\": \"aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa\", \"environment\": \"test\", \"profileId\": \"profileId-fixture\", \"customerId\": \"customerId-fixture\", \"expectedRevision\": 1, \"address\": {\"id\": \"id-fixture\", \"countryCode\": \"GB\", \"line1\": \"line1-fixture\", \"city\": \"city-fixture\", \"updatedAt\": \"2026-11-18T12:00:00.000Z\"}, \"createdAt\": \"2026-11-18T12:00:00.000Z\"}",
          )
          as Map,
    );
    final value = PaymentBillingPatch.fromJson(json);
    expect(value.validate(), isEmpty);
    final copy = PaymentBillingPatch.fromJson(value.toJson());
    expect(copy, value);
    expect(copy.hashCode, value.hashCode);
    expect(value.toString(), 'PaymentBillingPatch(redacted)');
    expect(
      () => PaymentBillingPatch.fromJson({...json, 'unknownField': 'bad'}),
      throwsFormatException,
    );
  });
  test('PaymentTaxIdentity canonical contract round trip', () {
    final json = Map<String, Object?>.from(
      jsonDecode(
            "{\"id\": \"id-fixture\", \"scopeFingerprint\": \"aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa\", \"environment\": \"test\", \"customerId\": \"customerId-fixture\", \"countryCode\": \"GB\", \"type\": \"card\", \"maskedValue\": \"maskedValue-fixture\", \"status\": \"pending\", \"observedAt\": \"2026-11-18T12:00:00.000Z\", \"expiresAt\": \"2026-11-18T12:10:00.000Z\"}",
          )
          as Map,
    );
    final value = PaymentTaxIdentity.fromJson(json);
    expect(value.validate(), isEmpty);
    final copy = PaymentTaxIdentity.fromJson(value.toJson());
    expect(copy, value);
    expect(copy.hashCode, value.hashCode);
    expect(value.toString(), 'PaymentTaxIdentity(redacted)');
    expect(
      () => PaymentTaxIdentity.fromJson({...json, 'unknownField': 'bad'}),
      throwsFormatException,
    );
  });
  test('PaymentTaxAssessment canonical contract round trip', () {
    final json = Map<String, Object?>.from(
      jsonDecode(
            "{\"orderId\": \"orderId-fixture\", \"scopeFingerprint\": \"aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa\", \"environment\": \"test\", \"subtotal\": {\"currency\": \"GBP\", \"amountMinor\": 1250}, \"tax\": {\"currency\": \"GBP\", \"amountMinor\": 1250}, \"total\": {\"currency\": \"GBP\", \"amountMinor\": 1250}, \"observedAt\": \"2026-11-18T12:00:00.000Z\", \"expiresAt\": \"2026-11-18T12:10:00.000Z\"}",
          )
          as Map,
    );
    final value = PaymentTaxAssessment.fromJson(json);
    expect(value.validate(), isEmpty);
    final copy = PaymentTaxAssessment.fromJson(value.toJson());
    expect(copy, value);
    expect(copy.hashCode, value.hashCode);
    expect(value.toString(), 'PaymentTaxAssessment(redacted)');
    expect(
      () => PaymentTaxAssessment.fromJson({...json, 'unknownField': 'bad'}),
      throwsFormatException,
    );
  });
  test('PaymentInvoiceLine canonical contract round trip', () {
    final json = Map<String, Object?>.from(
      jsonDecode(
            "{\"id\": \"id-fixture\", \"description\": \"description-fixture\", \"quantity\": 1, \"unitAmount\": {\"currency\": \"GBP\", \"amountMinor\": 1250}, \"netAmount\": {\"currency\": \"GBP\", \"amountMinor\": 1250}, \"taxAmount\": {\"currency\": \"GBP\", \"amountMinor\": 1250}, \"total\": {\"currency\": \"GBP\", \"amountMinor\": 1250}}",
          )
          as Map,
    );
    final value = PaymentInvoiceLine.fromJson(json);
    expect(value.validate(), isEmpty);
    final copy = PaymentInvoiceLine.fromJson(value.toJson());
    expect(copy, value);
    expect(copy.hashCode, value.hashCode);
    expect(value.toString(), 'PaymentInvoiceLine(redacted)');
    expect(
      () => PaymentInvoiceLine.fromJson({...json, 'unknownField': 'bad'}),
      throwsFormatException,
    );
  });
  test('PaymentInvoiceTax canonical contract round trip', () {
    final json = Map<String, Object?>.from(
      jsonDecode(
            "{\"id\": \"id-fixture\", \"label\": \"label-fixture\", \"jurisdictionCode\": \"jurisdictionCode-fixture\", \"taxableAmount\": {\"currency\": \"GBP\", \"amountMinor\": 1250}, \"amount\": {\"currency\": \"GBP\", \"amountMinor\": 1250}, \"rateBasisPoints\": 1}",
          )
          as Map,
    );
    final value = PaymentInvoiceTax.fromJson(json);
    expect(value.validate(), isEmpty);
    final copy = PaymentInvoiceTax.fromJson(value.toJson());
    expect(copy, value);
    expect(copy.hashCode, value.hashCode);
    expect(value.toString(), 'PaymentInvoiceTax(redacted)');
    expect(
      () => PaymentInvoiceTax.fromJson({...json, 'unknownField': 'bad'}),
      throwsFormatException,
    );
  });
  test('PaymentInvoice canonical contract round trip', () {
    final json = Map<String, Object?>.from(
      jsonDecode(
            "{\"id\": \"id-fixture\", \"scopeFingerprint\": \"aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa\", \"environment\": \"test\", \"customerId\": \"customerId-fixture\", \"orderId\": \"orderId-fixture\", \"number\": \"number-fixture\", \"status\": \"unknown\", \"total\": {\"currency\": \"GBP\", \"amountMinor\": 1250}, \"paid\": {\"currency\": \"GBP\", \"amountMinor\": 1250}, \"remaining\": {\"currency\": \"GBP\", \"amountMinor\": 1250}, \"issuedAt\": \"2026-11-18T12:00:00.000Z\", \"observedAt\": \"2026-11-18T12:00:00.000Z\", \"expiresAt\": \"2026-11-18T12:10:00.000Z\"}",
          )
          as Map,
    );
    final value = PaymentInvoice.fromJson(json);
    expect(value.validate(), isEmpty);
    final copy = PaymentInvoice.fromJson(value.toJson());
    expect(copy, value);
    expect(copy.hashCode, value.hashCode);
    expect(value.toString(), 'PaymentInvoice(redacted)');
    expect(
      () => PaymentInvoice.fromJson({...json, 'unknownField': 'bad'}),
      throwsFormatException,
    );
  });
  test('PaymentInvoiceDocument canonical contract round trip', () {
    final json = Map<String, Object?>.from(
      jsonDecode(
            "{\"id\": \"id-fixture\", \"scopeFingerprint\": \"aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa\", \"environment\": \"test\", \"invoiceId\": \"invoiceId-fixture\", \"uri\": \"uri-fixture\", \"mediaType\": \"application/pdf\", \"byteCount\": 1, \"checksum\": \"aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa\", \"issuedAt\": \"2026-11-18T12:00:00.000Z\", \"observedAt\": \"2026-11-18T12:00:00.000Z\", \"expiresAt\": \"2026-11-18T12:10:00.000Z\"}",
          )
          as Map,
    );
    final value = PaymentInvoiceDocument.fromJson(json);
    expect(value.validate(), isEmpty);
    final copy = PaymentInvoiceDocument.fromJson(value.toJson());
    expect(copy, value);
    expect(copy.hashCode, value.hashCode);
    expect(value.toString(), 'PaymentInvoiceDocument(redacted)');
    expect(
      () => PaymentInvoiceDocument.fromJson({...json, 'unknownField': 'bad'}),
      throwsFormatException,
    );
  });
  test('PaymentInvoiceFilter canonical contract round trip', () {
    final json = Map<String, Object?>.from(
      jsonDecode("{\"customerId\": \"customerId-fixture\"}") as Map,
    );
    final value = PaymentInvoiceFilter.fromJson(json);
    expect(value.validate(), isEmpty);
    final copy = PaymentInvoiceFilter.fromJson(value.toJson());
    expect(copy, value);
    expect(copy.hashCode, value.hashCode);
    expect(value.toString(), 'PaymentInvoiceFilter(redacted)');
    expect(
      () => PaymentInvoiceFilter.fromJson({...json, 'unknownField': 'bad'}),
      throwsFormatException,
    );
  });
  test('PaymentInvoicePage canonical contract round trip', () {
    final json = Map<String, Object?>.from(
      jsonDecode(
            "{\"id\": \"id-fixture\", \"scopeFingerprint\": \"aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa\", \"environment\": \"test\", \"requestFingerprint\": \"cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc\", \"observedAt\": \"2026-11-18T12:00:00.000Z\", \"expiresAt\": \"2026-11-18T12:10:00.000Z\"}",
          )
          as Map,
    );
    final value = PaymentInvoicePage.fromJson(json);
    expect(value.validate(), isEmpty);
    final copy = PaymentInvoicePage.fromJson(value.toJson());
    expect(copy, value);
    expect(copy.hashCode, value.hashCode);
    expect(value.toString(), 'PaymentInvoicePage(redacted)');
    expect(
      () => PaymentInvoicePage.fromJson({...json, 'unknownField': 'bad'}),
      throwsFormatException,
    );
  });
  test('PaymentInvoiceSummary canonical contract round trip', () {
    final json = Map<String, Object?>.from(
      jsonDecode(
            "{\"customerId\": \"customerId-fixture\", \"currency\": \"GBP\", \"evaluatedAt\": \"2026-11-18T12:00:00.000Z\", \"total\": {\"currency\": \"GBP\", \"amountMinor\": 1250}, \"paid\": {\"currency\": \"GBP\", \"amountMinor\": 1250}, \"remaining\": {\"currency\": \"GBP\", \"amountMinor\": 1250}, \"count\": 1}",
          )
          as Map,
    );
    final value = PaymentInvoiceSummary.fromJson(json);
    expect(value.validate(), isEmpty);
    final copy = PaymentInvoiceSummary.fromJson(value.toJson());
    expect(copy, value);
    expect(copy.hashCode, value.hashCode);
    expect(value.toString(), 'PaymentInvoiceSummary(redacted)');
    expect(
      () => PaymentInvoiceSummary.fromJson({...json, 'unknownField': 'bad'}),
      throwsFormatException,
    );
  });
  test('PaymentStatementEntry canonical contract round trip', () {
    final json = Map<String, Object?>.from(
      jsonDecode(
            "{\"id\": \"id-fixture\", \"orderId\": \"orderId-fixture\", \"occurredAt\": \"2026-11-18T12:00:00.000Z\", \"kind\": \"charge\", \"amount\": {\"currency\": \"GBP\", \"amountMinor\": 1250}, \"status\": \"unknown\"}",
          )
          as Map,
    );
    final value = PaymentStatementEntry.fromJson(json);
    expect(value.validate(), isEmpty);
    final copy = PaymentStatementEntry.fromJson(value.toJson());
    expect(copy, value);
    expect(copy.hashCode, value.hashCode);
    expect(value.toString(), 'PaymentStatementEntry(redacted)');
    expect(
      () => PaymentStatementEntry.fromJson({...json, 'unknownField': 'bad'}),
      throwsFormatException,
    );
  });
  test('PaymentStatement canonical contract round trip', () {
    final json = Map<String, Object?>.from(
      jsonDecode(
            "{\"id\": \"id-fixture\", \"scopeFingerprint\": \"aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa\", \"environment\": \"test\", \"customerId\": \"customerId-fixture\", \"currency\": \"GBP\", \"periodStart\": \"2026-11-18T12:00:00.000Z\", \"periodEnd\": \"2026-11-18T12:00:00.000Z\", \"observedAt\": \"2026-11-18T12:00:00.000Z\", \"expiresAt\": \"2026-11-18T12:10:00.000Z\"}",
          )
          as Map,
    );
    final value = PaymentStatement.fromJson(json);
    expect(value.validate(), isEmpty);
    final copy = PaymentStatement.fromJson(value.toJson());
    expect(copy, value);
    expect(copy.hashCode, value.hashCode);
    expect(value.toString(), 'PaymentStatement(redacted)');
    expect(
      () => PaymentStatement.fromJson({...json, 'unknownField': 'bad'}),
      throwsFormatException,
    );
  });
  test('PaymentStatementQuery canonical contract round trip', () {
    final json = Map<String, Object?>.from(
      jsonDecode(
            "{\"customerId\": \"customerId-fixture\", \"currency\": \"GBP\", \"periodStart\": \"2026-11-18T12:00:00.000Z\", \"periodEnd\": \"2026-11-18T12:00:00.000Z\"}",
          )
          as Map,
    );
    final value = PaymentStatementQuery.fromJson(json);
    expect(value.validate(), isEmpty);
    final copy = PaymentStatementQuery.fromJson(value.toJson());
    expect(copy, value);
    expect(copy.hashCode, value.hashCode);
    expect(value.toString(), 'PaymentStatementQuery(redacted)');
    expect(
      () => PaymentStatementQuery.fromJson({...json, 'unknownField': 'bad'}),
      throwsFormatException,
    );
  });
  test('PaymentStatementExport canonical contract round trip', () {
    final json = Map<String, Object?>.from(
      jsonDecode(
            "{\"id\": \"id-fixture\", \"scopeFingerprint\": \"aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa\", \"environment\": \"test\", \"statementId\": \"statementId-fixture\", \"createdAt\": \"2026-11-18T12:00:00.000Z\", \"expiresAt\": \"2026-11-18T12:10:00.000Z\", \"contentFingerprint\": \"contentFingerprint-fixture\", \"rowCount\": 1}",
          )
          as Map,
    );
    final value = PaymentStatementExport.fromJson(json);
    expect(value.validate(), isEmpty);
    final copy = PaymentStatementExport.fromJson(value.toJson());
    expect(copy, value);
    expect(copy.hashCode, value.hashCode);
    expect(value.toString(), 'PaymentStatementExport(redacted)');
    expect(
      () => PaymentStatementExport.fromJson({...json, 'unknownField': 'bad'}),
      throwsFormatException,
    );
  });
  test('PaymentFxRate canonical contract round trip', () {
    final json = Map<String, Object?>.from(
      jsonDecode(
            "{\"id\": \"id-fixture\", \"baseCurrency\": \"baseCurrency-fixture\", \"quoteCurrency\": \"quoteCurrency-fixture\", \"numerator\": 1, \"denominator\": 1, \"source\": \"source-fixture\", \"observedAt\": \"2026-11-18T12:00:00.000Z\", \"expiresAt\": \"2026-11-18T12:10:00.000Z\"}",
          )
          as Map,
    );
    final value = PaymentFxRate.fromJson(json);
    expect(value.validate(), isEmpty);
    final copy = PaymentFxRate.fromJson(value.toJson());
    expect(copy, value);
    expect(copy.hashCode, value.hashCode);
    expect(value.toString(), 'PaymentFxRate(redacted)');
    expect(
      () => PaymentFxRate.fromJson({...json, 'unknownField': 'bad'}),
      throwsFormatException,
    );
  });
  test('PaymentFxQuote canonical contract round trip', () {
    final json = Map<String, Object?>.from(
      jsonDecode(
            "{\"id\": \"id-fixture\", \"scopeFingerprint\": \"aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa\", \"environment\": \"test\", \"orderId\": \"orderId-fixture\", \"sourceAmount\": {\"currency\": \"GBP\", \"amountMinor\": 1250}, \"targetAmount\": {\"currency\": \"GBP\", \"amountMinor\": 1250}, \"rate\": {\"id\": \"id-fixture\", \"baseCurrency\": \"baseCurrency-fixture\", \"quoteCurrency\": \"quoteCurrency-fixture\", \"numerator\": 1, \"denominator\": 1, \"source\": \"source-fixture\", \"observedAt\": \"2026-11-18T12:00:00.000Z\", \"expiresAt\": \"2026-11-18T12:10:00.000Z\"}, \"fee\": {\"currency\": \"GBP\", \"amountMinor\": 1250}, \"observedAt\": \"2026-11-18T12:00:00.000Z\", \"expiresAt\": \"2026-11-18T12:10:00.000Z\"}",
          )
          as Map,
    );
    final value = PaymentFxQuote.fromJson(json);
    expect(value.validate(), isEmpty);
    final copy = PaymentFxQuote.fromJson(value.toJson());
    expect(copy, value);
    expect(copy.hashCode, value.hashCode);
    expect(value.toString(), 'PaymentFxQuote(redacted)');
    expect(
      () => PaymentFxQuote.fromJson({...json, 'unknownField': 'bad'}),
      throwsFormatException,
    );
  });
  test('PaymentFxDisclosure canonical contract round trip', () {
    final json = Map<String, Object?>.from(
      jsonDecode(
            "{\"quoteId\": \"quoteId-fixture\", \"orderId\": \"orderId-fixture\", \"sourceAmount\": {\"currency\": \"GBP\", \"amountMinor\": 1250}, \"displayAmount\": {\"currency\": \"GBP\", \"amountMinor\": 1250}, \"fee\": {\"currency\": \"GBP\", \"amountMinor\": 1250}, \"expiresAt\": \"2026-11-18T12:10:00.000Z\", \"label\": \"label-fixture\"}",
          )
          as Map,
    );
    final value = PaymentFxDisclosure.fromJson(json);
    expect(value.validate(), isEmpty);
    final copy = PaymentFxDisclosure.fromJson(value.toJson());
    expect(copy, value);
    expect(copy.hashCode, value.hashCode);
    expect(value.toString(), 'PaymentFxDisclosure(redacted)');
    expect(
      () => PaymentFxDisclosure.fromJson({...json, 'unknownField': 'bad'}),
      throwsFormatException,
    );
  });
  test('PaymentDepositTerms canonical contract round trip', () {
    final json = Map<String, Object?>.from(
      jsonDecode(
            "{\"id\": \"id-fixture\", \"scopeFingerprint\": \"aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa\", \"environment\": \"test\", \"serviceType\": \"serviceType-fixture\", \"depositBasisPoints\": 1, \"minimumDeposit\": {\"currency\": \"GBP\", \"amountMinor\": 1250}, \"balanceDueAt\": \"2026-11-18T12:00:00.000Z\", \"observedAt\": \"2026-11-18T12:00:00.000Z\", \"expiresAt\": \"2026-11-18T12:10:00.000Z\"}",
          )
          as Map,
    );
    final value = PaymentDepositTerms.fromJson(json);
    expect(value.validate(), isEmpty);
    final copy = PaymentDepositTerms.fromJson(value.toJson());
    expect(copy, value);
    expect(copy.hashCode, value.hashCode);
    expect(value.toString(), 'PaymentDepositTerms(redacted)');
    expect(
      () => PaymentDepositTerms.fromJson({...json, 'unknownField': 'bad'}),
      throwsFormatException,
    );
  });
  test('PaymentDepositQuote canonical contract round trip', () {
    final json = Map<String, Object?>.from(
      jsonDecode(
            "{\"id\": \"id-fixture\", \"scopeFingerprint\": \"aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa\", \"environment\": \"test\", \"orderId\": \"orderId-fixture\", \"orderFingerprint\": \"bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb\", \"termsId\": \"termsId-fixture\", \"total\": {\"currency\": \"GBP\", \"amountMinor\": 1250}, \"deposit\": {\"currency\": \"GBP\", \"amountMinor\": 1250}, \"balance\": {\"currency\": \"GBP\", \"amountMinor\": 1250}, \"balanceDueAt\": \"2026-11-18T12:00:00.000Z\", \"observedAt\": \"2026-11-18T12:00:00.000Z\", \"expiresAt\": \"2026-11-18T12:10:00.000Z\"}",
          )
          as Map,
    );
    final value = PaymentDepositQuote.fromJson(json);
    expect(value.validate(), isEmpty);
    final copy = PaymentDepositQuote.fromJson(value.toJson());
    expect(copy, value);
    expect(copy.hashCode, value.hashCode);
    expect(value.toString(), 'PaymentDepositQuote(redacted)');
    expect(
      () => PaymentDepositQuote.fromJson({...json, 'unknownField': 'bad'}),
      throwsFormatException,
    );
  });
  test('PaymentInstallment canonical contract round trip', () {
    final json = Map<String, Object?>.from(
      jsonDecode(
            "{\"id\": \"id-fixture\", \"sequence\": 1, \"amount\": {\"currency\": \"GBP\", \"amountMinor\": 1250}, \"dueAt\": \"2026-11-18T12:00:00.000Z\", \"status\": \"unknown\"}",
          )
          as Map,
    );
    final value = PaymentInstallment.fromJson(json);
    expect(value.validate(), isEmpty);
    final copy = PaymentInstallment.fromJson(value.toJson());
    expect(copy, value);
    expect(copy.hashCode, value.hashCode);
    expect(value.toString(), 'PaymentInstallment(redacted)');
    expect(
      () => PaymentInstallment.fromJson({...json, 'unknownField': 'bad'}),
      throwsFormatException,
    );
  });
  test('PaymentInstallmentPlan canonical contract round trip', () {
    final json = Map<String, Object?>.from(
      jsonDecode(
            "{\"id\": \"id-fixture\", \"scopeFingerprint\": \"aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa\", \"environment\": \"test\", \"orderId\": \"orderId-fixture\", \"orderFingerprint\": \"bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb\", \"total\": {\"currency\": \"GBP\", \"amountMinor\": 1250}, \"status\": \"unknown\", \"termsRevision\": 1, \"installments\": [{\"id\": \"id-fixture\", \"sequence\": 1, \"amount\": {\"currency\": \"GBP\", \"amountMinor\": 1250}, \"dueAt\": \"2026-11-18T12:00:00.000Z\", \"status\": \"unknown\"}], \"observedAt\": \"2026-11-18T12:00:00.000Z\", \"expiresAt\": \"2026-11-18T12:10:00.000Z\"}",
          )
          as Map,
    );
    final value = PaymentInstallmentPlan.fromJson(json);
    expect(value.validate(), isEmpty);
    final copy = PaymentInstallmentPlan.fromJson(value.toJson());
    expect(copy, value);
    expect(copy.hashCode, value.hashCode);
    expect(value.toString(), 'PaymentInstallmentPlan(redacted)');
    expect(
      () => PaymentInstallmentPlan.fromJson({...json, 'unknownField': 'bad'}),
      throwsFormatException,
    );
  });
  test('PaymentPlanAssessment canonical contract round trip', () {
    final json = Map<String, Object?>.from(
      jsonDecode(
            "{\"planId\": \"planId-fixture\", \"orderId\": \"orderId-fixture\", \"evaluatedAt\": \"2026-11-18T12:00:00.000Z\", \"paid\": {\"currency\": \"GBP\", \"amountMinor\": 1250}, \"pending\": {\"currency\": \"GBP\", \"amountMinor\": 1250}, \"remaining\": {\"currency\": \"GBP\", \"amountMinor\": 1250}}",
          )
          as Map,
    );
    final value = PaymentPlanAssessment.fromJson(json);
    expect(value.validate(), isEmpty);
    final copy = PaymentPlanAssessment.fromJson(value.toJson());
    expect(copy, value);
    expect(copy.hashCode, value.hashCode);
    expect(value.toString(), 'PaymentPlanAssessment(redacted)');
    expect(
      () => PaymentPlanAssessment.fromJson({...json, 'unknownField': 'bad'}),
      throwsFormatException,
    );
  });
  test('PaymentPlanConsent canonical contract round trip', () {
    final json = Map<String, Object?>.from(
      jsonDecode(
            "{\"id\": \"id-fixture\", \"scopeFingerprint\": \"aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa\", \"environment\": \"test\", \"planId\": \"planId-fixture\", \"planFingerprint\": \"planFingerprint-fixture\", \"termsRevision\": 1, \"acceptedAt\": \"2026-11-18T12:00:00.000Z\", \"expiresAt\": \"2026-11-18T12:10:00.000Z\"}",
          )
          as Map,
    );
    final value = PaymentPlanConsent.fromJson(json);
    expect(value.validate(), isEmpty);
    final copy = PaymentPlanConsent.fromJson(value.toJson());
    expect(copy, value);
    expect(copy.hashCode, value.hashCode);
    expect(value.toString(), 'PaymentPlanConsent(redacted)');
    expect(
      () => PaymentPlanConsent.fromJson({...json, 'unknownField': 'bad'}),
      throwsFormatException,
    );
  });
  test('PaymentPlanSchedule canonical contract round trip', () {
    final json = Map<String, Object?>.from(
      jsonDecode(
            "{\"planId\": \"planId-fixture\", \"orderId\": \"orderId-fixture\", \"generatedAt\": \"2026-11-18T12:00:00.000Z\", \"expiresAt\": \"2026-11-18T12:10:00.000Z\"}",
          )
          as Map,
    );
    final value = PaymentPlanSchedule.fromJson(json);
    expect(value.validate(), isEmpty);
    final copy = PaymentPlanSchedule.fromJson(value.toJson());
    expect(copy, value);
    expect(copy.hashCode, value.hashCode);
    expect(value.toString(), 'PaymentPlanSchedule(redacted)');
    expect(
      () => PaymentPlanSchedule.fromJson({...json, 'unknownField': 'bad'}),
      throwsFormatException,
    );
  });
  test('PaymentPlanChange canonical contract round trip', () {
    final json = Map<String, Object?>.from(
      jsonDecode(
            "{\"id\": \"id-fixture\", \"scopeFingerprint\": \"aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa\", \"environment\": \"test\", \"planId\": \"planId-fixture\", \"expectedRevision\": 1, \"replacement\": {\"id\": \"id-fixture\", \"scopeFingerprint\": \"aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa\", \"environment\": \"test\", \"orderId\": \"orderId-fixture\", \"orderFingerprint\": \"bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb\", \"total\": {\"currency\": \"GBP\", \"amountMinor\": 1250}, \"status\": \"unknown\", \"termsRevision\": 1, \"installments\": [{\"id\": \"id-fixture\", \"sequence\": 1, \"amount\": {\"currency\": \"GBP\", \"amountMinor\": 1250}, \"dueAt\": \"2026-11-18T12:00:00.000Z\", \"status\": \"unknown\"}], \"observedAt\": \"2026-11-18T12:00:00.000Z\", \"expiresAt\": \"2026-11-18T12:10:00.000Z\"}, \"reasonCode\": \"reasonCode-fixture\", \"createdAt\": \"2026-11-18T12:00:00.000Z\"}",
          )
          as Map,
    );
    final value = PaymentPlanChange.fromJson(json);
    expect(value.validate(), isEmpty);
    final copy = PaymentPlanChange.fromJson(value.toJson());
    expect(copy, value);
    expect(copy.hashCode, value.hashCode);
    expect(value.toString(), 'PaymentPlanChange(redacted)');
    expect(
      () => PaymentPlanChange.fromJson({...json, 'unknownField': 'bad'}),
      throwsFormatException,
    );
  });
  test('PaymentPlanHistory canonical contract round trip', () {
    final json = Map<String, Object?>.from(
      jsonDecode(
            "{\"planId\": \"planId-fixture\", \"scopeFingerprint\": \"aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa\", \"environment\": \"test\", \"orderId\": \"orderId-fixture\", \"observedAt\": \"2026-11-18T12:00:00.000Z\", \"expiresAt\": \"2026-11-18T12:10:00.000Z\"}",
          )
          as Map,
    );
    final value = PaymentPlanHistory.fromJson(json);
    expect(value.validate(), isEmpty);
    final copy = PaymentPlanHistory.fromJson(value.toJson());
    expect(copy, value);
    expect(copy.hashCode, value.hashCode);
    expect(value.toString(), 'PaymentPlanHistory(redacted)');
    expect(
      () => PaymentPlanHistory.fromJson({...json, 'unknownField': 'bad'}),
      throwsFormatException,
    );
  });
  test('PaymentRefundRequestDraft canonical contract round trip', () {
    final json = Map<String, Object?>.from(
      jsonDecode(
            "{\"id\": \"id-fixture\", \"scopeFingerprint\": \"aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa\", \"environment\": \"test\", \"orderId\": \"orderId-fixture\", \"intentId\": \"intentId-fixture\", \"amount\": {\"currency\": \"GBP\", \"amountMinor\": 1250}, \"reasonCode\": \"reasonCode-fixture\", \"createdAt\": \"2026-11-18T12:00:00.000Z\", \"expectedOrderRevision\": 1}",
          )
          as Map,
    );
    final value = PaymentRefundRequestDraft.fromJson(json);
    expect(value.validate(), isEmpty);
    final copy = PaymentRefundRequestDraft.fromJson(value.toJson());
    expect(copy, value);
    expect(copy.hashCode, value.hashCode);
    expect(value.toString(), 'PaymentRefundRequestDraft(redacted)');
    expect(
      () =>
          PaymentRefundRequestDraft.fromJson({...json, 'unknownField': 'bad'}),
      throwsFormatException,
    );
  });
  test('PaymentRefundReason canonical contract round trip', () {
    final json = Map<String, Object?>.from(
      jsonDecode(
            "{\"code\": \"code-fixture\", \"label\": \"label-fixture\", \"observedAt\": \"2026-11-18T12:00:00.000Z\", \"expiresAt\": \"2026-11-18T12:10:00.000Z\"}",
          )
          as Map,
    );
    final value = PaymentRefundReason.fromJson(json);
    expect(value.validate(), isEmpty);
    final copy = PaymentRefundReason.fromJson(value.toJson());
    expect(copy, value);
    expect(copy.hashCode, value.hashCode);
    expect(value.toString(), 'PaymentRefundReason(redacted)');
    expect(
      () => PaymentRefundReason.fromJson({...json, 'unknownField': 'bad'}),
      throwsFormatException,
    );
  });
  test('PaymentRefundEligibility canonical contract round trip', () {
    final json = Map<String, Object?>.from(
      jsonDecode(
            "{\"id\": \"id-fixture\", \"scopeFingerprint\": \"aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa\", \"environment\": \"test\", \"orderId\": \"orderId-fixture\", \"intentId\": \"intentId-fixture\", \"available\": {\"currency\": \"GBP\", \"amountMinor\": 1250}, \"maximumRequest\": {\"currency\": \"GBP\", \"amountMinor\": 1250}, \"eligible\": false, \"observedAt\": \"2026-11-18T12:00:00.000Z\", \"expiresAt\": \"2026-11-18T12:10:00.000Z\"}",
          )
          as Map,
    );
    final value = PaymentRefundEligibility.fromJson(json);
    expect(value.validate(), isEmpty);
    final copy = PaymentRefundEligibility.fromJson(value.toJson());
    expect(copy, value);
    expect(copy.hashCode, value.hashCode);
    expect(value.toString(), 'PaymentRefundEligibility(redacted)');
    expect(
      () => PaymentRefundEligibility.fromJson({...json, 'unknownField': 'bad'}),
      throwsFormatException,
    );
  });
  test('PaymentRefundPreview canonical contract round trip', () {
    final json = Map<String, Object?>.from(
      jsonDecode(
            "{\"id\": \"id-fixture\", \"scopeFingerprint\": \"aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa\", \"environment\": \"test\", \"draftFingerprint\": \"draftFingerprint-fixture\", \"orderId\": \"orderId-fixture\", \"intentId\": \"intentId-fixture\", \"requested\": {\"currency\": \"GBP\", \"amountMinor\": 1250}, \"fee\": {\"currency\": \"GBP\", \"amountMinor\": 1250}, \"net\": {\"currency\": \"GBP\", \"amountMinor\": 1250}, \"status\": \"unknown\", \"observedAt\": \"2026-11-18T12:00:00.000Z\", \"expiresAt\": \"2026-11-18T12:10:00.000Z\"}",
          )
          as Map,
    );
    final value = PaymentRefundPreview.fromJson(json);
    expect(value.validate(), isEmpty);
    final copy = PaymentRefundPreview.fromJson(value.toJson());
    expect(copy, value);
    expect(copy.hashCode, value.hashCode);
    expect(value.toString(), 'PaymentRefundPreview(redacted)');
    expect(
      () => PaymentRefundPreview.fromJson({...json, 'unknownField': 'bad'}),
      throwsFormatException,
    );
  });
  test('PaymentRefundSubmission canonical contract round trip', () {
    final json = Map<String, Object?>.from(
      jsonDecode(
            "{\"id\": \"id-fixture\", \"scopeFingerprint\": \"aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa\", \"environment\": \"test\", \"draftId\": \"draftId-fixture\", \"draftFingerprint\": \"draftFingerprint-fixture\", \"previewId\": \"previewId-fixture\", \"orderId\": \"orderId-fixture\", \"intentId\": \"intentId-fixture\", \"createdAt\": \"2026-11-18T12:00:00.000Z\", \"expiresAt\": \"2026-11-18T12:10:00.000Z\"}",
          )
          as Map,
    );
    final value = PaymentRefundSubmission.fromJson(json);
    expect(value.validate(), isEmpty);
    final copy = PaymentRefundSubmission.fromJson(value.toJson());
    expect(copy, value);
    expect(copy.hashCode, value.hashCode);
    expect(value.toString(), 'PaymentRefundSubmission(redacted)');
    expect(
      () => PaymentRefundSubmission.fromJson({...json, 'unknownField': 'bad'}),
      throwsFormatException,
    );
  });
  test('PaymentRefundTimelineEntry canonical contract round trip', () {
    final json = Map<String, Object?>.from(
      jsonDecode(
            "{\"id\": \"id-fixture\", \"refundId\": \"refundId-fixture\", \"occurredAt\": \"2026-11-18T12:00:00.000Z\", \"state\": \"unknown\", \"label\": \"label-fixture\"}",
          )
          as Map,
    );
    final value = PaymentRefundTimelineEntry.fromJson(json);
    expect(value.validate(), isEmpty);
    final copy = PaymentRefundTimelineEntry.fromJson(value.toJson());
    expect(copy, value);
    expect(copy.hashCode, value.hashCode);
    expect(value.toString(), 'PaymentRefundTimelineEntry(redacted)');
    expect(
      () =>
          PaymentRefundTimelineEntry.fromJson({...json, 'unknownField': 'bad'}),
      throwsFormatException,
    );
  });
  test('PaymentRefundTimeline canonical contract round trip', () {
    final json = Map<String, Object?>.from(
      jsonDecode(
            "{\"id\": \"id-fixture\", \"scopeFingerprint\": \"aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa\", \"environment\": \"test\", \"orderId\": \"orderId-fixture\", \"intentId\": \"intentId-fixture\", \"refundId\": \"refundId-fixture\", \"observedAt\": \"2026-11-18T12:00:00.000Z\", \"expiresAt\": \"2026-11-18T12:10:00.000Z\"}",
          )
          as Map,
    );
    final value = PaymentRefundTimeline.fromJson(json);
    expect(value.validate(), isEmpty);
    final copy = PaymentRefundTimeline.fromJson(value.toJson());
    expect(copy, value);
    expect(copy.hashCode, value.hashCode);
    expect(value.toString(), 'PaymentRefundTimeline(redacted)');
    expect(
      () => PaymentRefundTimeline.fromJson({...json, 'unknownField': 'bad'}),
      throwsFormatException,
    );
  });
  test('PaymentDispute canonical contract round trip', () {
    final json = Map<String, Object?>.from(
      jsonDecode(
            "{\"id\": \"id-fixture\", \"scopeFingerprint\": \"aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa\", \"environment\": \"test\", \"orderId\": \"orderId-fixture\", \"intentId\": \"intentId-fixture\", \"amount\": {\"currency\": \"GBP\", \"amountMinor\": 1250}, \"reasonCode\": \"reasonCode-fixture\", \"status\": \"unknown\", \"openedAt\": \"2026-11-18T12:00:00.000Z\", \"observedAt\": \"2026-11-18T12:00:00.000Z\", \"expiresAt\": \"2026-11-18T12:10:00.000Z\"}",
          )
          as Map,
    );
    final value = PaymentDispute.fromJson(json);
    expect(value.validate(), isEmpty);
    final copy = PaymentDispute.fromJson(value.toJson());
    expect(copy, value);
    expect(copy.hashCode, value.hashCode);
    expect(value.toString(), 'PaymentDispute(redacted)');
    expect(
      () => PaymentDispute.fromJson({...json, 'unknownField': 'bad'}),
      throwsFormatException,
    );
  });
  test('PaymentDisputeEvent canonical contract round trip', () {
    final json = Map<String, Object?>.from(
      jsonDecode(
            "{\"id\": \"id-fixture\", \"disputeId\": \"disputeId-fixture\", \"occurredAt\": \"2026-11-18T12:00:00.000Z\", \"status\": \"unknown\", \"sequence\": 1, \"label\": \"label-fixture\"}",
          )
          as Map,
    );
    final value = PaymentDisputeEvent.fromJson(json);
    expect(value.validate(), isEmpty);
    final copy = PaymentDisputeEvent.fromJson(value.toJson());
    expect(copy, value);
    expect(copy.hashCode, value.hashCode);
    expect(value.toString(), 'PaymentDisputeEvent(redacted)');
    expect(
      () => PaymentDisputeEvent.fromJson({...json, 'unknownField': 'bad'}),
      throwsFormatException,
    );
  });
  test('PaymentDisputeEvidenceReference canonical contract round trip', () {
    final json = Map<String, Object?>.from(
      jsonDecode(
            "{\"id\": \"id-fixture\", \"scopeFingerprint\": \"aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa\", \"environment\": \"test\", \"disputeId\": \"disputeId-fixture\", \"category\": \"receipt\", \"fileReference\": \"fileReference-fixture\", \"mediaType\": \"application/pdf\", \"byteCount\": 1, \"checksum\": \"aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa\", \"createdAt\": \"2026-11-18T12:00:00.000Z\"}",
          )
          as Map,
    );
    final value = PaymentDisputeEvidenceReference.fromJson(json);
    expect(value.validate(), isEmpty);
    final copy = PaymentDisputeEvidenceReference.fromJson(value.toJson());
    expect(copy, value);
    expect(copy.hashCode, value.hashCode);
    expect(value.toString(), 'PaymentDisputeEvidenceReference(redacted)');
    expect(
      () => PaymentDisputeEvidenceReference.fromJson({
        ...json,
        'unknownField': 'bad',
      }),
      throwsFormatException,
    );
  });
  test('PaymentDisputeSummary canonical contract round trip', () {
    final json = Map<String, Object?>.from(
      jsonDecode(
            "{\"orderId\": \"orderId-fixture\", \"evaluatedAt\": \"2026-11-18T12:00:00.000Z\"}",
          )
          as Map,
    );
    final value = PaymentDisputeSummary.fromJson(json);
    expect(value.validate(), isEmpty);
    final copy = PaymentDisputeSummary.fromJson(value.toJson());
    expect(copy, value);
    expect(copy.hashCode, value.hashCode);
    expect(value.toString(), 'PaymentDisputeSummary(redacted)');
    expect(
      () => PaymentDisputeSummary.fromJson({...json, 'unknownField': 'bad'}),
      throwsFormatException,
    );
  });
  test('PaymentSupportContext canonical contract round trip', () {
    final json = Map<String, Object?>.from(
      jsonDecode(
            "{\"id\": \"id-fixture\", \"scopeFingerprint\": \"aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa\", \"environment\": \"test\", \"orderId\": \"orderId-fixture\", \"topic\": \"payment\", \"createdAt\": \"2026-11-18T12:00:00.000Z\"}",
          )
          as Map,
    );
    final value = PaymentSupportContext.fromJson(json);
    expect(value.validate(), isEmpty);
    final copy = PaymentSupportContext.fromJson(value.toJson());
    expect(copy, value);
    expect(copy.hashCode, value.hashCode);
    expect(value.toString(), 'PaymentSupportContext(redacted)');
    expect(
      () => PaymentSupportContext.fromJson({...json, 'unknownField': 'bad'}),
      throwsFormatException,
    );
  });
  test('PaymentSupportHandoff canonical contract round trip', () {
    final json = Map<String, Object?>.from(
      jsonDecode(
            "{\"id\": \"id-fixture\", \"scopeFingerprint\": \"aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa\", \"environment\": \"test\", \"contextFingerprint\": \"contextFingerprint-fixture\", \"orderId\": \"orderId-fixture\", \"destination\": \"destination-fixture\", \"createdAt\": \"2026-11-18T12:00:00.000Z\", \"expiresAt\": \"2026-11-18T12:10:00.000Z\"}",
          )
          as Map,
    );
    final value = PaymentSupportHandoff.fromJson(json);
    expect(value.validate(), isEmpty);
    final copy = PaymentSupportHandoff.fromJson(value.toJson());
    expect(copy, value);
    expect(copy.hashCode, value.hashCode);
    expect(value.toString(), 'PaymentSupportHandoff(redacted)');
    expect(
      () => PaymentSupportHandoff.fromJson({...json, 'unknownField': 'bad'}),
      throwsFormatException,
    );
  });
  test('PaymentActivityEntry canonical contract round trip', () {
    final json = Map<String, Object?>.from(
      jsonDecode(
            "{\"id\": \"id-fixture\", \"scopeFingerprint\": \"aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa\", \"environment\": \"test\", \"orderId\": \"orderId-fixture\", \"kind\": \"payment\", \"status\": \"unknown\", \"occurredAt\": \"2026-11-18T12:00:00.000Z\", \"observedAt\": \"2026-11-18T12:00:00.000Z\", \"expiresAt\": \"2026-11-18T12:10:00.000Z\"}",
          )
          as Map,
    );
    final value = PaymentActivityEntry.fromJson(json);
    expect(value.validate(), isEmpty);
    final copy = PaymentActivityEntry.fromJson(value.toJson());
    expect(copy, value);
    expect(copy.hashCode, value.hashCode);
    expect(value.toString(), 'PaymentActivityEntry(redacted)');
    expect(
      () => PaymentActivityEntry.fromJson({...json, 'unknownField': 'bad'}),
      throwsFormatException,
    );
  });
  test('PaymentActivityFilter canonical contract round trip', () {
    final json = Map<String, Object?>.from(jsonDecode("{}") as Map);
    final value = PaymentActivityFilter.fromJson(json);
    expect(value.validate(), isEmpty);
    final copy = PaymentActivityFilter.fromJson(value.toJson());
    expect(copy, value);
    expect(copy.hashCode, value.hashCode);
    expect(value.toString(), 'PaymentActivityFilter(redacted)');
    expect(
      () => PaymentActivityFilter.fromJson({...json, 'unknownField': 'bad'}),
      throwsFormatException,
    );
  });
  test('PaymentActivityPage canonical contract round trip', () {
    final json = Map<String, Object?>.from(
      jsonDecode(
            "{\"id\": \"id-fixture\", \"scopeFingerprint\": \"aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa\", \"environment\": \"test\", \"requestFingerprint\": \"cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc\", \"observedAt\": \"2026-11-18T12:00:00.000Z\", \"expiresAt\": \"2026-11-18T12:10:00.000Z\"}",
          )
          as Map,
    );
    final value = PaymentActivityPage.fromJson(json);
    expect(value.validate(), isEmpty);
    final copy = PaymentActivityPage.fromJson(value.toJson());
    expect(copy, value);
    expect(copy.hashCode, value.hashCode);
    expect(value.toString(), 'PaymentActivityPage(redacted)');
    expect(
      () => PaymentActivityPage.fromJson({...json, 'unknownField': 'bad'}),
      throwsFormatException,
    );
  });
  test('PaymentActivitySummary canonical contract round trip', () {
    final json = Map<String, Object?>.from(
      jsonDecode(
            "{\"evaluatedAt\": \"2026-11-18T12:00:00.000Z\", \"currency\": \"GBP\", \"charges\": {\"currency\": \"GBP\", \"amountMinor\": 1250}, \"refunds\": {\"currency\": \"GBP\", \"amountMinor\": 1250}, \"count\": 1}",
          )
          as Map,
    );
    final value = PaymentActivitySummary.fromJson(json);
    expect(value.validate(), isEmpty);
    final copy = PaymentActivitySummary.fromJson(value.toJson());
    expect(copy, value);
    expect(copy.hashCode, value.hashCode);
    expect(value.toString(), 'PaymentActivitySummary(redacted)');
    expect(
      () => PaymentActivitySummary.fromJson({...json, 'unknownField': 'bad'}),
      throwsFormatException,
    );
  });
  test('PaymentLedgerEntry canonical contract round trip', () {
    final json = Map<String, Object?>.from(
      jsonDecode(
            "{\"id\": \"id-fixture\", \"scopeFingerprint\": \"aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa\", \"environment\": \"test\", \"orderId\": \"orderId-fixture\", \"occurredAt\": \"2026-11-18T12:00:00.000Z\", \"kind\": \"charge\", \"direction\": \"debit\", \"amount\": {\"currency\": \"GBP\", \"amountMinor\": 1250}, \"referenceId\": \"referenceId-fixture\", \"sequence\": 1}",
          )
          as Map,
    );
    final value = PaymentLedgerEntry.fromJson(json);
    expect(value.validate(), isEmpty);
    final copy = PaymentLedgerEntry.fromJson(value.toJson());
    expect(copy, value);
    expect(copy.hashCode, value.hashCode);
    expect(value.toString(), 'PaymentLedgerEntry(redacted)');
    expect(
      () => PaymentLedgerEntry.fromJson({...json, 'unknownField': 'bad'}),
      throwsFormatException,
    );
  });
  test('PaymentLedgerBalance canonical contract round trip', () {
    final json = Map<String, Object?>.from(
      jsonDecode(
            "{\"currency\": \"GBP\", \"openingMinor\": 1, \"closingMinor\": 1, \"debit\": {\"currency\": \"GBP\", \"amountMinor\": 1250}, \"credit\": {\"currency\": \"GBP\", \"amountMinor\": 1250}, \"calculatedAt\": \"2026-11-18T12:00:00.000Z\"}",
          )
          as Map,
    );
    final value = PaymentLedgerBalance.fromJson(json);
    expect(value.validate(), isEmpty);
    final copy = PaymentLedgerBalance.fromJson(value.toJson());
    expect(copy, value);
    expect(copy.hashCode, value.hashCode);
    expect(value.toString(), 'PaymentLedgerBalance(redacted)');
    expect(
      () => PaymentLedgerBalance.fromJson({...json, 'unknownField': 'bad'}),
      throwsFormatException,
    );
  });
  test('PaymentLedgerStatement canonical contract round trip', () {
    final json = Map<String, Object?>.from(
      jsonDecode(
            "{\"id\": \"id-fixture\", \"scopeFingerprint\": \"aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa\", \"environment\": \"test\", \"customerId\": \"customerId-fixture\", \"currency\": \"GBP\", \"periodStart\": \"2026-11-18T12:00:00.000Z\", \"periodEnd\": \"2026-11-18T12:00:00.000Z\", \"openingMinor\": 1, \"closingMinor\": 1, \"observedAt\": \"2026-11-18T12:00:00.000Z\", \"expiresAt\": \"2026-11-18T12:10:00.000Z\"}",
          )
          as Map,
    );
    final value = PaymentLedgerStatement.fromJson(json);
    expect(value.validate(), isEmpty);
    final copy = PaymentLedgerStatement.fromJson(value.toJson());
    expect(copy, value);
    expect(copy.hashCode, value.hashCode);
    expect(value.toString(), 'PaymentLedgerStatement(redacted)');
    expect(
      () => PaymentLedgerStatement.fromJson({...json, 'unknownField': 'bad'}),
      throwsFormatException,
    );
  });
  test('PaymentLedgerReconciliation canonical contract round trip', () {
    final json = Map<String, Object?>.from(
      jsonDecode(
            "{\"statementId\": \"statementId-fixture\", \"orderId\": \"orderId-fixture\", \"evaluatedAt\": \"2026-11-18T12:00:00.000Z\", \"expected\": {\"currency\": \"GBP\", \"amountMinor\": 1250}, \"posted\": {\"currency\": \"GBP\", \"amountMinor\": 1250}, \"matched\": false}",
          )
          as Map,
    );
    final value = PaymentLedgerReconciliation.fromJson(json);
    expect(value.validate(), isEmpty);
    final copy = PaymentLedgerReconciliation.fromJson(value.toJson());
    expect(copy, value);
    expect(copy.hashCode, value.hashCode);
    expect(value.toString(), 'PaymentLedgerReconciliation(redacted)');
    expect(
      () => PaymentLedgerReconciliation.fromJson({
        ...json,
        'unknownField': 'bad',
      }),
      throwsFormatException,
    );
  });
  test('PaymentAccountSnapshot canonical contract round trip', () {
    final json = Map<String, Object?>.from(
      jsonDecode(
            "{\"id\": \"id-fixture\", \"scopeFingerprint\": \"aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa\", \"environment\": \"test\", \"customerId\": \"customerId-fixture\", \"observedAt\": \"2026-11-18T12:00:00.000Z\", \"expiresAt\": \"2026-11-18T12:10:00.000Z\"}",
          )
          as Map,
    );
    final value = PaymentAccountSnapshot.fromJson(json);
    expect(value.validate(), isEmpty);
    final copy = PaymentAccountSnapshot.fromJson(value.toJson());
    expect(copy, value);
    expect(copy.hashCode, value.hashCode);
    expect(value.toString(), 'PaymentAccountSnapshot(redacted)');
    expect(
      () => PaymentAccountSnapshot.fromJson({...json, 'unknownField': 'bad'}),
      throwsFormatException,
    );
  });
  test('PaymentCachePolicy canonical contract round trip', () {
    final json = Map<String, Object?>.from(jsonDecode("{}") as Map);
    final value = PaymentCachePolicy.fromJson(json);
    expect(value.validate(), isEmpty);
    final copy = PaymentCachePolicy.fromJson(value.toJson());
    expect(copy, value);
    expect(copy.hashCode, value.hashCode);
    expect(value.toString(), 'PaymentCachePolicy(redacted)');
    expect(
      () => PaymentCachePolicy.fromJson({...json, 'unknownField': 'bad'}),
      throwsFormatException,
    );
  });
  test('PaymentCacheEnvelope canonical contract round trip', () {
    final json = Map<String, Object?>.from(
      jsonDecode(
            "{\"keyFingerprint\": \"keyFingerprint-fixture\", \"scopeFingerprint\": \"aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa\", \"environment\": \"test\", \"snapshot\": {\"id\": \"id-fixture\", \"scopeFingerprint\": \"aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa\", \"environment\": \"test\", \"customerId\": \"customerId-fixture\", \"observedAt\": \"2026-11-18T12:00:00.000Z\", \"expiresAt\": \"2026-11-18T12:10:00.000Z\"}, \"storedAt\": \"2026-11-18T12:00:00.000Z\", \"expiresAt\": \"2026-11-18T12:10:00.000Z\", \"digest\": \"digest-fixture\"}",
          )
          as Map,
    );
    final value = PaymentCacheEnvelope.fromJson(json);
    expect(value.validate(), isEmpty);
    final copy = PaymentCacheEnvelope.fromJson(value.toJson());
    expect(copy, value);
    expect(copy.hashCode, value.hashCode);
    expect(value.toString(), 'PaymentCacheEnvelope(redacted)');
    expect(
      () => PaymentCacheEnvelope.fromJson({...json, 'unknownField': 'bad'}),
      throwsFormatException,
    );
  });
  test('PaymentSessionContext canonical contract round trip', () {
    final json = Map<String, Object?>.from(
      jsonDecode(
            "{\"id\": \"id-fixture\", \"scopeFingerprint\": \"aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa\", \"environment\": \"test\", \"customerId\": \"customerId-fixture\", \"authenticatedAt\": \"2026-11-18T12:00:00.000Z\", \"expiresAt\": \"2026-11-18T12:10:00.000Z\", \"generation\": 1}",
          )
          as Map,
    );
    final value = PaymentSessionContext.fromJson(json);
    expect(value.validate(), isEmpty);
    final copy = PaymentSessionContext.fromJson(value.toJson());
    expect(copy, value);
    expect(copy.hashCode, value.hashCode);
    expect(value.toString(), 'PaymentSessionContext(redacted)');
    expect(
      () => PaymentSessionContext.fromJson({...json, 'unknownField': 'bad'}),
      throwsFormatException,
    );
  });
  test('PaymentAccessPolicy canonical contract round trip', () {
    final json = Map<String, Object?>.from(
      jsonDecode(
            "{\"scopeFingerprint\": \"aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa\", \"customerId\": \"customerId-fixture\", \"observedAt\": \"2026-11-18T12:00:00.000Z\", \"expiresAt\": \"2026-11-18T12:10:00.000Z\"}",
          )
          as Map,
    );
    final value = PaymentAccessPolicy.fromJson(json);
    expect(value.validate(), isEmpty);
    final copy = PaymentAccessPolicy.fromJson(value.toJson());
    expect(copy, value);
    expect(copy.hashCode, value.hashCode);
    expect(value.toString(), 'PaymentAccessPolicy(redacted)');
    expect(
      () => PaymentAccessPolicy.fromJson({...json, 'unknownField': 'bad'}),
      throwsFormatException,
    );
  });
  test('PaymentOperationTicket canonical contract round trip', () {
    final json = Map<String, Object?>.from(
      jsonDecode(
            "{\"id\": \"id-fixture\", \"scopeFingerprint\": \"aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa\", \"environment\": \"test\", \"sessionId\": \"sessionId-fixture\", \"sessionGeneration\": 1, \"kind\": \"billingReview\", \"payloadFingerprint\": \"payloadFingerprint-fixture\", \"idempotencyKey\": \"idempotencyKey-fixture\", \"createdAt\": \"2026-11-18T12:00:00.000Z\", \"expiresAt\": \"2026-11-18T12:10:00.000Z\"}",
          )
          as Map,
    );
    final value = PaymentOperationTicket.fromJson(json);
    expect(value.validate(), isEmpty);
    final copy = PaymentOperationTicket.fromJson(value.toJson());
    expect(copy, value);
    expect(copy.hashCode, value.hashCode);
    expect(value.toString(), 'PaymentOperationTicket(redacted)');
    expect(
      () => PaymentOperationTicket.fromJson({...json, 'unknownField': 'bad'}),
      throwsFormatException,
    );
  });
  test('PaymentOperationResult canonical contract round trip', () {
    final json = Map<String, Object?>.from(
      jsonDecode(
            "{\"ticketId\": \"ticketId-fixture\", \"scopeFingerprint\": \"aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa\", \"environment\": \"test\", \"payloadFingerprint\": \"payloadFingerprint-fixture\", \"state\": \"unknown\", \"observedAt\": \"2026-11-18T12:00:00.000Z\", \"expiresAt\": \"2026-11-18T12:10:00.000Z\"}",
          )
          as Map,
    );
    final value = PaymentOperationResult.fromJson(json);
    expect(value.validate(), isEmpty);
    final copy = PaymentOperationResult.fromJson(value.toJson());
    expect(copy, value);
    expect(copy.hashCode, value.hashCode);
    expect(value.toString(), 'PaymentOperationResult(redacted)');
    expect(
      () => PaymentOperationResult.fromJson({...json, 'unknownField': 'bad'}),
      throwsFormatException,
    );
  });
  test('PaymentNotificationPreference canonical contract round trip', () {
    final json = Map<String, Object?>.from(
      jsonDecode(
            "{\"scopeFingerprint\": \"aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa\", \"updatedAt\": \"2026-11-18T12:00:00.000Z\"}",
          )
          as Map,
    );
    final value = PaymentNotificationPreference.fromJson(json);
    expect(value.validate(), isEmpty);
    final copy = PaymentNotificationPreference.fromJson(value.toJson());
    expect(copy, value);
    expect(copy.hashCode, value.hashCode);
    expect(value.toString(), 'PaymentNotificationPreference(redacted)');
    expect(
      () => PaymentNotificationPreference.fromJson({
        ...json,
        'unknownField': 'bad',
      }),
      throwsFormatException,
    );
  });
  test('PaymentNotificationEvent canonical contract round trip', () {
    final json = Map<String, Object?>.from(
      jsonDecode(
            "{\"id\": \"id-fixture\", \"scopeFingerprint\": \"aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa\", \"environment\": \"test\", \"orderId\": \"orderId-fixture\", \"kind\": \"payment\", \"status\": \"unknown\", \"occurredAt\": \"2026-11-18T12:00:00.000Z\", \"expiresAt\": \"2026-11-18T12:10:00.000Z\", \"sourceReference\": \"sourceReference-fixture\"}",
          )
          as Map,
    );
    final value = PaymentNotificationEvent.fromJson(json);
    expect(value.validate(), isEmpty);
    final copy = PaymentNotificationEvent.fromJson(value.toJson());
    expect(copy, value);
    expect(copy.hashCode, value.hashCode);
    expect(value.toString(), 'PaymentNotificationEvent(redacted)');
    expect(
      () => PaymentNotificationEvent.fromJson({...json, 'unknownField': 'bad'}),
      throwsFormatException,
    );
  });
}
