import 'dart:math';
import '../trippl_payments_mobile.dart';

class PaymentAttemptLease {
  PaymentAttemptLease._(this.key);
  final String key;
  @override
  String toString() => 'PaymentAttemptLease(redacted)';
}

class PaymentAttemptCoordinator {
  final _active = <String, PaymentAttemptLease>{},
      _attempts = <String, PaymentAttempt>{};
  String _key(String scope, String orderId, String environment) {
    PaymentGuard.identity(scope);
    PaymentGuard.identity(orderId);
    PaymentGuard.environment(environment);
    return PaymentCodec.digest({
      'scope': scope,
      'orderId': orderId,
      'environment': environment,
    });
  }

  PaymentAttemptLease acquire(
    String scope,
    String orderId,
    String environment,
  ) {
    final key = _key(scope, orderId, environment);
    if (_active.containsKey(key))
      throw StateError('Another checkout operation is active for this order');
    final lease = PaymentAttemptLease._(key);
    _active[key] = lease;
    return lease;
  }

  void release(PaymentAttemptLease lease) {
    if (identical(_active[lease.key], lease)) _active.remove(lease.key);
  }

  PaymentAttempt? current(String scope, String orderId, String environment) =>
      _attempts[_key(scope, orderId, environment)];
  void remember(PaymentAttempt attempt, {required String scope}) {
    PaymentGuard.record(attempt.validate());
    PaymentGuard.scope(attempt.scopeFingerprint, scope);
    final key = _key(scope, attempt.orderId, attempt.environment),
        old = _attempts[key];
    if (old != null && old.id != attempt.id)
      throw StateError('Resolve the existing payment attempt first');
    _attempts[key] = attempt;
  }

  void clearCancelled(
    PaymentAttempt attempt,
    PaymentIntentAssessment assessment, {
    required String scope,
  }) {
    PaymentGuard.record(attempt.validate());
    PaymentGuard.record(assessment.validate());
    if (!assessment.serverVerified ||
        assessment.state != 'cancelled' ||
        assessment.orderId != attempt.orderId ||
        assessment.intentId != attempt.intentId)
      throw StateError(
        'Backend cancellation proof required before discarding an attempt',
      );
    PaymentGuard.scope(attempt.scopeFingerprint, scope);
    final key = _key(scope, attempt.orderId, attempt.environment);
    if (_attempts[key]?.id != attempt.id ||
        _attempts[key]?.intentId != attempt.intentId) {
      throw StateError('Cannot clear a different current checkout attempt');
    }
    _attempts.remove(key);
  }
}

class PaymentAttempts {
  static String token() {
    final random = Random.secure();
    return List.generate(
      24,
      (_) => random.nextInt(256).toRadixString(16).padLeft(2, '0'),
    ).join();
  }

  static PaymentAttempt create(
    PaymentOrder order,
    PaymentQuote quote, {
    required String scope,
    required String environment,
    required DateTime now,
    required String nonce,
  }) {
    PaymentOrders.validate(order, scope: scope, now: now);
    PaymentGuard.record(quote.validate());
    PaymentGuard.environment(environment);
    if (!RegExp(r'^[A-Za-z0-9_-]{16,120}$').hasMatch(nonce))
      throw const FormatException(
        'Use an opaque high-entropy checkout attempt token',
      );
    return PaymentAttempt(
      id: 'attempt-$nonce',
      scopeFingerprint: PaymentCodec.digest(scope),
      orderId: order.id,
      orderFingerprint: PaymentOrders.fingerprint(order),
      quoteId: quote.id,
      idempotencyKey: 'trippl-$nonce',
      environment: environment,
      createdAt: now,
      updatedAt: now,
    );
  }

  static PaymentAttempt transition(
    PaymentAttempt attempt,
    String state, {
    required DateTime now,
    String? intentId,
    PaymentIntentAssessment? assessment,
  }) {
    PaymentGuard.record(attempt.validate());
    if (now.isBefore(attempt.updatedAt))
      throw StateError('Payment attempt clock regressed');
    if (state == 'completed' &&
            (assessment?.paid != true || assessment?.serverVerified != true) ||
        state == 'cancelled' &&
            (assessment?.state != 'cancelled' ||
                assessment?.serverVerified != true))
      throw StateError(
        'Terminal payment attempt requires current backend verification',
      );
    if (assessment != null &&
        (assessment.orderId != attempt.orderId ||
            attempt.intentId != null &&
                assessment.intentId != attempt.intentId))
      throw StateError('Payment assessment belongs to another attempt');
    if (intentId != null) {
      PaymentGuard.objectId(intentId, 'pi');
      if (attempt.intentId != null && attempt.intentId != intentId)
        throw StateError(
          'An attempt cannot change its allocated PaymentIntent',
        );
    }
    final next = attempt.copyWith(
      state: state,
      intentId: intentId,
      updatedAt: now,
      revision: attempt.revision + 1,
    );
    PaymentGuard.record(next.validate());
    return next;
  }
}
