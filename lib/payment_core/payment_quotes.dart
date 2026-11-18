import '../trippl_payments_mobile.dart';

class PaymentQuotes {
  static void validate(
    PaymentQuote quote,
    PaymentOrder order,
    PaymentCurrencyRule rule, {
    required String scope,
    required DateTime now,
  }) {
    PaymentGuard.record(quote.validate());
    PaymentOrders.validate(order, scope: scope, now: now);
    PaymentGuard.scope(quote.scopeFingerprint, scope);
    PaymentGuard.fingerprintValue(quote.orderFingerprint);
    if (!quote.serverVerified ||
        quote.orderId != order.id ||
        quote.orderRevision != order.revision ||
        quote.orderFingerprint != PaymentOrders.fingerprint(order) ||
        quote.total != order.total ||
        !PaymentGuard.fresh(quote.observedAt, quote.expiresAt, now))
      throw StateError(
        'Payment quote is stale or not bound to the current server order',
      );
    PaymentAmounts.validate(quote.total, rule, now: now);
    if (!PaymentOrders.assess(order, scope: scope, now: now).valid)
      throw StateError('Payment order totals do not reconcile');
  }

  static Map<String, Object?> review(
    PaymentQuote quote,
    PaymentOrder order,
    PaymentCurrencyRule rule, {
    required String scope,
    required DateTime now,
    String language = 'en',
  }) {
    validate(quote, order, rule, scope: scope, now: now);
    final b = PaymentOrders.breakdown(order, scope: scope, now: now);
    return Map.unmodifiable({
      'orderId': order.id,
      'quoteId': quote.id,
      'orderRevision': order.revision,
      'totalLabel': PaymentAmounts.format(quote.total, language: language),
      'amount': quote.total.toJson(),
      'subtotal': b.subtotal.toJson(),
      'tax': b.tax.toJson(),
      'fees': b.fees.toJson(),
      'discounts': b.discounts.toJson(),
      'credits': b.credits.toJson(),
      'expiresAt': quote.expiresAt.toUtc().toIso8601String(),
      'serverVerified': true,
      'paymentInitiated': false,
    });
  }

  static bool same(PaymentQuote a, PaymentQuote b) {
    PaymentGuard.record(a.validate());
    PaymentGuard.record(b.validate());
    return a.id == b.id &&
        a.orderFingerprint == b.orderFingerprint &&
        a.total == b.total &&
        a.orderRevision == b.orderRevision;
  }
}

/// The user's review is bound to the exact quote. A reprice or account switch
/// invalidates it, including changes that keep the same numeric total.
class PaymentReviews {
  static PaymentCheckoutReview acknowledge(
    PaymentOrder order,
    PaymentQuote quote,
    PaymentCurrencyRule rule, {
    required String scope,
    required DateTime now,
    required List<String> warningCodes,
  }) {
    PaymentQuotes.validate(quote, order, rule, scope: scope, now: now);
    PaymentGuard.distinct(warningCodes);
    if (warningCodes
            .toSet()
            .difference(quote.warningCodes.toSet())
            .isNotEmpty ||
        quote.warningCodes
            .toSet()
            .difference(warningCodes.toSet())
            .isNotEmpty) {
      throw StateError('Review every warning on the current quote');
    }
    final expiry = quote.expiresAt.isBefore(rule.expiresAt)
        ? quote.expiresAt
        : rule.expiresAt;
    return PaymentCheckoutReview(
      scopeFingerprint: order.scopeFingerprint,
      orderId: order.id,
      orderFingerprint: PaymentOrders.fingerprint(order),
      quoteId: quote.id,
      quoteRevision: quote.revision,
      total: quote.total,
      reviewedAt: now,
      expiresAt: expiry,
      acknowledgedWarningCodes: warningCodes,
    );
  }

  static void validate(
    PaymentCheckoutReview review,
    PaymentOrder order,
    PaymentQuote quote,
    PaymentCurrencyRule rule, {
    required String scope,
    required DateTime now,
  }) {
    PaymentGuard.record(review.validate());
    PaymentGuard.scope(review.scopeFingerprint, scope);
    PaymentQuotes.validate(quote, order, rule, scope: scope, now: now);
    if (review.orderId != order.id ||
        review.orderFingerprint != PaymentOrders.fingerprint(order) ||
        review.quoteId != quote.id ||
        review.quoteRevision != quote.revision ||
        review.total != quote.total ||
        !PaymentGuard.fresh(review.reviewedAt, review.expiresAt, now) ||
        review.acknowledgedWarningCodes
            .toSet()
            .difference(quote.warningCodes.toSet())
            .isNotEmpty ||
        quote.warningCodes
            .toSet()
            .difference(review.acknowledgedWarningCodes.toSet())
            .isNotEmpty) {
      throw StateError('Checkout review no longer matches the current quote');
    }
  }
}
