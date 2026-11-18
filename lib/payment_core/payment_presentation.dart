import '../trippl_payments_mobile.dart';

class PaymentPresentation {
  static Map<String, Object?> checkout(
    PaymentCheckoutState state, {
    String language = 'en',
  }) {
    PaymentGuard.record(state.validate());
    PaymentGuard.language(language);
    return Map.unmodifiable({
      'orderId': state.orderId,
      'state': state.state,
      'busy': state.busy,
      'label': PaymentStatuses.label(state.state, language: language),
      'errorLabel': state.error == null
          ? null
          : PaymentErrors.label(state.error!, language: language),
      'paymentVerified':
          state.verification?.serverVerified == true && state.state == 'paid',
      'bookingConfirmed': state.verification?.bookingConfirmed ?? false,
      'needsStatusCheck': {
        'pending',
        'uncertain',
        'verifying',
        'authorized',
      }.contains(state.state),
    });
  }

  static void validateReceipt(
    PaymentReceipt receipt,
    PaymentVerification verification,
    PaymentVerificationRequest request,
    PaymentOrder order, {
    required String scope,
    required DateTime now,
  }) {
    PaymentGuard.record(receipt.validate());
    final assessed = PaymentVerifications.validate(
      verification,
      request,
      order,
      scope: scope,
      now: now,
    );
    PaymentGuard.scope(receipt.scopeFingerprint, scope);
    if (!assessed.paid ||
        !receipt.serverVerified ||
        receipt.orderId != order.id ||
        receipt.intentId != verification.intent.id ||
        receipt.environment != verification.intent.environment ||
        receipt.total != order.total ||
        verification.receiptId != receipt.id ||
        !PaymentGuard.fresh(receipt.observedAt, receipt.expiresAt, now))
      throw StateError(
        'Receipt lacks matching current backend payment verification',
      );
    if (receipt.receiptUri != null) PaymentGuard.https(receipt.receiptUri!);
    PaymentGuard.distinct(receipt.lines.map((l) => l.id));
    if (receipt.lines.isNotEmpty) {
      var positive = receipt.total.copyWith(amountMinor: 0),
          negative = positive;
      for (final line in receipt.lines) {
        final amount = PaymentAmounts.multiply(line.amount, line.quantity);
        PaymentAmounts.compatible(receipt.total, amount);
        if ({'discount', 'credit'}.contains(line.kind))
          negative = PaymentAmounts.add(negative, amount);
        else
          positive = PaymentAmounts.add(positive, amount);
      }
      if (PaymentAmounts.subtract(positive, negative) != receipt.total)
        throw StateError('Receipt lines do not reconcile');
    }
  }

  static Map<String, Object?> receipt(
    PaymentReceipt receipt, {
    String language = 'en',
  }) {
    PaymentGuard.record(receipt.validate());
    PaymentGuard.language(language);
    return Map.unmodifiable({
      'receiptId': receipt.id,
      'orderId': receipt.orderId,
      'total': PaymentAmounts.format(receipt.total, language: language),
      'issuedAt': receipt.issuedAt.toUtc().toIso8601String(),
      'lines': receipt.lines
          .map(
            (l) => {
              'label': l.label,
              'quantity': l.quantity,
              'amount': PaymentAmounts.format(
                PaymentAmounts.multiply(l.amount, l.quantity),
                language: language,
              ),
            },
          )
          .toList(),
      'serverVerified': receipt.serverVerified,
      'paymentProofMustBeRevalidated': true,
    });
  }

  static PaymentRefundSummary refunds(
    PaymentOrder order,
    PaymentIntent intent,
    List<PaymentRefundReference> refunds, {
    required String scope,
    required DateTime now,
    bool complete = false,
  }) {
    PaymentOrders.validate(order, scope: scope, now: now);
    PaymentGuard.record(intent.validate());
    PaymentGuard.scope(intent.scopeFingerprint, scope);
    PaymentGuard.distinct(refunds.map((r) => r.id));
    if (!PaymentStatuses.assess(intent, now: now).paid ||
        intent.orderId != order.id ||
        intent.total != order.total ||
        intent.amountReceived != order.total)
      throw StateError(
        'Refund display requires a verified matching paid intent',
      );
    var refunded = order.total.copyWith(amountMinor: 0), pending = refunded;
    final reasons = <String>[];
    for (final refund in refunds) {
      PaymentGuard.record(refund.validate());
      PaymentGuard.scope(refund.scopeFingerprint, scope);
      if (refund.orderId != order.id ||
          refund.intentId != intent.id ||
          refund.environment != intent.environment ||
          !refund.serverVerified ||
          !PaymentGuard.fresh(refund.observedAt, refund.expiresAt, now))
        throw StateError('Refund reference does not match payment context');
      if (refund.status == 'succeeded')
        refunded = PaymentAmounts.add(refunded, refund.amount);
      else if ({'pending', 'requires_action'}.contains(refund.status))
        pending = PaymentAmounts.add(pending, refund.amount);
      else if (refund.status == 'unknown')
        reasons.add('refundStatusUnknown');
    }
    final reserved = PaymentAmounts.add(refunded, pending);
    if (reserved.amountMinor > order.total.amountMinor)
      throw StateError('Refund totals exceed verified payment');
    if (!complete) reasons.add('refundHistoryIncomplete');
    return PaymentRefundSummary(
      orderId: order.id,
      intentId: intent.id,
      evaluatedAt: now,
      paid: order.total,
      refunded: refunded,
      pending: pending,
      remaining: complete && reasons.isEmpty
          ? PaymentAmounts.subtract(order.total, reserved)
          : null,
      refundIds: refunds.map((r) => r.id).toList(),
      complete: complete && reasons.isEmpty,
      reasonCodes: reasons,
      refundInitiated: false,
    );
  }
}

class PaymentReceiptLinks {
  /// Call only after validateReceipt. This adds a merchant-owned destination
  /// policy; HTTPS alone is insufficient authorization to open a remote link.
  static Uri openable(
    PaymentReceipt receipt,
    PaymentReceiptPolicy policy, {
    required String scope,
    required DateTime now,
  }) {
    PaymentGuard.record(receipt.validate());
    PaymentGuard.record(policy.validate());
    PaymentGuard.scope(receipt.scopeFingerprint, scope);
    if (!receipt.serverVerified ||
        !PaymentGuard.fresh(receipt.observedAt, receipt.expiresAt, now) ||
        now.difference(receipt.observedAt).inSeconds >
            policy.maximumAgeSeconds ||
        receipt.receiptUri == null) {
      throw StateError('Receipt link requires a current backend receipt');
    }
    final uri = PaymentGuard.https(receipt.receiptUri!);
    if (!policy.allowedHosts.contains(uri.host) ||
        !policy.allowQuery && uri.hasQuery ||
        uri.pathSegments.any((s) => s == '..' || s == '.' || s.contains('/')) ||
        policy.allowedPathPrefixes.isNotEmpty &&
            !policy.allowedPathPrefixes.any(
              (prefix) =>
                  uri.path == prefix ||
                  uri.path.startsWith(
                    prefix.endsWith('/') ? prefix : '$prefix/',
                  ),
            )) {
      throw StateError('Receipt link destination not allowed');
    }
    return uri;
  }
}
