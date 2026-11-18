import '../trippl_payments_mobile.dart';

abstract interface class PaymentReviewProvider {
  Future<PaymentOperationResult> submit(
    PaymentOperationTicket ticket,
    Map<String, Object?> payload,
  );
  Future<PaymentOperationResult?> lookup(PaymentOperationTicket ticket);
}

class PaymentReviewOperations {
  PaymentReviewOperations(
    this.provider, {
    required this.sessions,
    required this.clock,
    PaymentReadPolicy? policy,
  }) : policy = policy ?? PaymentReadPolicy() {
    PaymentGuard.record(this.policy.validate());
  }
  final PaymentReviewProvider provider;
  final PaymentAccountSession sessions;
  final DateTime Function() clock;
  final PaymentReadPolicy policy;
  PaymentOperationTicket? _ticket;
  PaymentOperationResult? _result;
  Map<String, Object?>? _payload;
  bool _closed = false, _busy = false;
  int _generation = 0, _inflight = 0;
  bool get _hasCurrentOwner {
    if (_closed || _ticket == null) return false;
    try {
      final owner = sessions.current();
      return owner.id == _ticket!.sessionId &&
          owner.generation == _ticket!.sessionGeneration;
    } on StateError {
      return false;
    }
  }

  PaymentOperationTicket? get ticket => _hasCurrentOwner ? _ticket : null;
  PaymentOperationResult? get result => _hasCurrentOwner ? _result : null;
  bool get unresolved =>
      _ticket != null &&
      (_result == null || {'pending', 'unknown'}.contains(_result!.state));
  static String permission(String kind) => switch (kind) {
    'billingReview' => 'billing.review',
    'refundReview' => 'refunds.review',
    'planReview' => 'plans.review',
    'supportReview' => 'support.review',
    _ => throw StateError('Unknown payment review kind'),
  };
  PaymentOperationTicket prepare(
    Object draft,
    PaymentAccessPolicy access, {
    required String nonce,
  }) {
    if (_closed || _busy || _ticket != null)
      throw StateError('Resolve the current review before preparing another');
    final session = sessions.current();
    late final String kind, scopeFingerprint, environment;
    late final Map<String, Object?> payload;
    DateTime expires = clock().add(const Duration(minutes: 10));
    if (draft is PaymentBillingPatch) {
      PaymentGuard.record(draft.validate());
      kind = 'billingReview';
      scopeFingerprint = draft.scopeFingerprint;
      environment = draft.environment;
      payload = draft.toJson();
      if (draft.customerId != session.customerId ||
          draft.createdAt.isAfter(clock()))
        throw StateError('Billing review customer mismatch');
    } else if (draft is PaymentRefundSubmission) {
      PaymentGuard.record(draft.validate());
      kind = 'refundReview';
      scopeFingerprint = draft.scopeFingerprint;
      environment = draft.environment;
      payload = draft.toJson();
      if (!PaymentGuard.fresh(draft.createdAt, draft.expiresAt, clock()))
        throw StateError('Refund review expired');
      expires = draft.expiresAt;
    } else if (draft is PaymentPlanConsent) {
      PaymentGuard.record(draft.validate());
      kind = 'planReview';
      scopeFingerprint = draft.scopeFingerprint;
      environment = draft.environment;
      payload = draft.toJson();
      if (!PaymentGuard.fresh(draft.acceptedAt, draft.expiresAt, clock()))
        throw StateError('Plan consent expired');
      expires = draft.expiresAt;
    } else if (draft is PaymentPlanChange) {
      PaymentGuard.record(draft.validate());
      kind = 'planReview';
      scopeFingerprint = draft.scopeFingerprint;
      environment = draft.environment;
      payload = draft.toJson();
      if (draft.createdAt.isAfter(clock()))
        throw StateError('Plan review clock mismatch');
      expires = draft.replacement.expiresAt;
    } else if (draft is PaymentSupportHandoff) {
      PaymentGuard.record(draft.validate());
      kind = 'supportReview';
      scopeFingerprint = draft.scopeFingerprint;
      environment = draft.environment;
      payload = draft.toJson();
      if (!PaymentGuard.fresh(draft.createdAt, draft.expiresAt, clock()))
        throw StateError('Support review expired');
      expires = draft.expiresAt;
    } else {
      throw ArgumentError('Use a typed reviewed payment draft');
    }
    PaymentAccountGuard.context(
      scopeFingerprint,
      environment,
      scope: sessions.scope,
      environment: sessions.environment,
    );
    PaymentAccountGuard.access(
      session,
      access,
      permission(kind),
      scope: sessions.scope,
      environment: sessions.environment,
      now: clock(),
    );
    if (!RegExp(r'^[A-Za-z0-9_-]{16,120}$').hasMatch(nonce))
      throw const FormatException('Opaque review operation nonce required');
    final fingerprint = PaymentAccountGuard.fingerprint(payload);
    _payload = Map.unmodifiable(payload);
    return _ticket = PaymentOperationTicket(
      id: 'review-$nonce',
      scopeFingerprint: scopeFingerprint,
      environment: environment,
      sessionId: session.id,
      sessionGeneration: session.generation,
      kind: kind,
      payloadFingerprint: fingerprint,
      idempotencyKey: 'review-$nonce',
      createdAt: clock(),
      expiresAt: PaymentAccountGuard.earliest([
        expires,
        session.expiresAt,
        access.expiresAt,
        clock().add(const Duration(minutes: 10)),
      ]),
    );
  }

  void _validate(PaymentOperationResult result, PaymentOperationTicket ticket) {
    PaymentGuard.record(result.validate());
    PaymentAccountGuard.context(
      result.scopeFingerprint,
      result.environment,
      scope: sessions.scope,
      environment: sessions.environment,
    );
    PaymentAccountGuard.current(
      result.observedAt,
      result.expiresAt,
      result.serverVerified,
      clock(),
    );
    if (result.ticketId != ticket.id ||
        result.payloadFingerprint != ticket.payloadFingerprint ||
        result.paymentMutationPerformed)
      throw StateError('Review response context mismatch');
    final previous = _result;
    if (previous?.serverVerified == true &&
        (result.observedAt.isBefore(previous!.observedAt) ||
            {'acceptedForReview', 'rejected'}.contains(previous.state) &&
                (result.state != previous.state ||
                    previous.referenceId != result.referenceId))) {
      throw StateError(
        'Review outcome cannot regress or change its backend reference',
      );
    }
    if (result.state == 'acceptedForReview' && result.referenceId == null)
      throw StateError('Accepted review lacks backend reference');
  }

  Future<T> _call<T>(Future<T> Function() action) {
    if (_inflight >= policy.maximumInflight) {
      throw StateError('Payment review has unresolved underlying requests');
    }
    _inflight++;
    return Future<T>.sync(action).then(
      (value) {
        _inflight--;
        return value;
      },
      onError: (Object error, StackTrace trace) {
        _inflight--;
        Error.throwWithStackTrace(error, trace);
      },
    );
  }

  Future<PaymentOperationResult?> submit({required bool userApproved}) async {
    if (_closed ||
        _busy ||
        _ticket == null ||
        _payload == null ||
        _result != null)
      throw StateError('Payment review cannot be submitted');
    if (!userApproved)
      throw StateError('Explicit user review approval required');
    final ticket = _ticket!, session = sessions.current();
    if (ticket.sessionId != session.id ||
        ticket.sessionGeneration != session.generation ||
        !PaymentGuard.fresh(ticket.createdAt, ticket.expiresAt, clock()))
      throw StateError('Review session or expiry changed');
    final generation = ++_generation;
    _busy = true;
    // Submission is never automatically retried, including after a timeout.
    _result = PaymentOperationResult(
      ticketId: ticket.id,
      scopeFingerprint: ticket.scopeFingerprint,
      environment: ticket.environment,
      payloadFingerprint: ticket.payloadFingerprint,
      state: 'unknown',
      observedAt: clock(),
      expiresAt: ticket.expiresAt,
    );
    try {
      final result = await _call(
        () => provider.submit(ticket, _payload!),
      ).timeout(Duration(seconds: policy.timeoutSeconds));
      if (_closed || generation != _generation || !sessions.isCurrent(session))
        return null;
      _validate(result, ticket);
      return _result = result;
    } finally {
      _busy = false;
    }
  }

  Future<PaymentOperationResult?> refresh() async {
    if (_closed || _busy || _ticket == null)
      throw StateError('Payment review lookup unavailable');
    final ticket = _ticket!, session = sessions.current();
    if (ticket.sessionId != session.id ||
        ticket.sessionGeneration != session.generation)
      throw StateError('Review belongs to another session');
    final generation = ++_generation;
    _busy = true;
    try {
      final result = await _call(
        () => provider.lookup(ticket),
      ).timeout(Duration(seconds: policy.timeoutSeconds));
      if (_closed || generation != _generation || !sessions.isCurrent(session))
        return null;
      if (result == null) return _result;
      _validate(result, ticket);
      return _result = result;
    } finally {
      _busy = false;
    }
  }

  void close() {
    _closed = true;
    _generation++;
    _payload = null;
  }
}
