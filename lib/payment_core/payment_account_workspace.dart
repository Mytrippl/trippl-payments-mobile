import '../trippl_payments_mobile.dart';

abstract interface class PaymentAccountProvider {
  Future<PaymentAccountSnapshot> account(PaymentSessionContext session);
}

class PaymentAccountView {
  PaymentAccountView(this.snapshot, {required this.current});
  final PaymentAccountSnapshot snapshot;
  final bool current;
  bool get offline => !current;
  bool get paymentProof => false;
  Map<String, Object?> get counts => Map.unmodifiable({
    'invoices': snapshot.invoices.length,
    'plans': snapshot.plans.length,
    'disputes': snapshot.disputes.length,
    'activity': snapshot.activity.length,
    'complete': snapshot.complete,
    'current': current,
  });
  @override
  String toString() => 'PaymentAccountView(redacted)';
}

class PaymentAccountWorkspace {
  PaymentAccountWorkspace(
    this.provider, {
    required this.sessions,
    required this.clock,
    this.cache,
    PaymentReadPolicy? policy,
  }) : policy = policy ?? PaymentReadPolicy() {
    PaymentGuard.record(this.policy.validate());
    if (cache != null &&
        (cache!.scope != sessions.scope ||
            cache!.environment != sessions.environment))
      throw StateError('Workspace cache context mismatch');
  }
  final PaymentAccountProvider provider;
  final PaymentAccountSession sessions;
  final DateTime Function() clock;
  final PaymentAccountCache? cache;
  final PaymentReadPolicy policy;
  int _generation = 0, _inflight = 0;
  bool _closed = false;
  PaymentAccountView? _view;
  PaymentSessionContext? _owner;
  PaymentAccountView? get view {
    if (_owner == null || !sessions.isCurrent(_owner!)) return null;
    final value = _view;
    if (value == null) return null;
    return PaymentAccountView(
      value.snapshot,
      current:
          value.current &&
          PaymentGuard.fresh(
            value.snapshot.observedAt,
            value.snapshot.expiresAt,
            clock(),
          ),
    );
  }

  static void validate(
    PaymentAccountSnapshot snapshot,
    PaymentSessionContext session,
    PaymentAccessPolicy access,
    List<PaymentOrder> orders, {
    required String scope,
    required String environment,
    required DateTime now,
  }) {
    PaymentGuard.record(snapshot.validate());
    PaymentGuard.record(session.validate());
    PaymentGuard.record(access.validate());
    PaymentAccountGuard.context(
      session.scopeFingerprint,
      session.environment,
      scope: scope,
      environment: environment,
    );
    PaymentGuard.scope(access.scopeFingerprint, scope);
    PaymentAccountGuard.customer(session.customerId, access.customerId);
    PaymentAccountGuard.current(
      access.observedAt,
      access.expiresAt,
      access.serverVerified,
      now,
    );
    if (!session.active ||
        !PaymentGuard.fresh(session.authenticatedAt, session.expiresAt, now)) {
      throw StateError('Payment account session expired');
    }

    PaymentAccountGuard.context(
      snapshot.scopeFingerprint,
      snapshot.environment,
      scope: scope,
      environment: environment,
    );
    PaymentAccountGuard.customer(snapshot.customerId, session.customerId);
    PaymentAccountGuard.current(
      snapshot.observedAt,
      snapshot.expiresAt,
      snapshot.serverVerified,
      now,
    );
    PaymentGuard.distinct(orders.map((o) => o.id));
    PaymentGuard.distinct(snapshot.invoices.map((i) => i.id));
    PaymentGuard.distinct(snapshot.plans.map((p) => p.id));
    PaymentGuard.distinct(snapshot.disputes.map((d) => d.id));
    PaymentGuard.distinct(snapshot.activity.map((a) => a.id));
    final byId = {for (final order in orders) order.id: order};
    for (final permission in [
      if (snapshot.invoices.isNotEmpty) 'invoices.read',
      if (snapshot.plans.isNotEmpty) 'plans.read',
      if (snapshot.disputes.isNotEmpty) 'disputes.read',
      if (snapshot.activity.isNotEmpty) 'activity.read',
    ]) {
      PaymentAccountGuard.access(
        session,
        access,
        permission,
        scope: scope,
        environment: environment,
        now: now,
      );
    }
    for (final invoice in snapshot.invoices)
      PaymentInvoices.validate(
        invoice,
        scope: scope,
        environment: environment,
        customerId: session.customerId,
        now: now,
      );
    for (final plan in snapshot.plans) {
      final order =
          byId[plan.orderId] ??
          (throw StateError('Plan order context missing'));
      PaymentInstallments.validate(
        plan,
        order,
        scope: scope,
        environment: environment,
        now: now,
      );
    }
    for (final dispute in snapshot.disputes) {
      final order =
          byId[dispute.orderId] ??
          (throw StateError('Dispute order context missing'));
      PaymentDisputes.validate(
        dispute,
        order,
        scope: scope,
        environment: environment,
        now: now,
      );
    }
    for (final activity in snapshot.activity)
      PaymentActivity.validateEntry(
        activity,
        scope: scope,
        environment: environment,
        now: now,
      );
  }

  Future<PaymentAccountView?> load(
    PaymentAccessPolicy access,
    List<PaymentOrder> orders,
  ) async {
    if (_closed || _inflight >= policy.maximumInflight)
      throw StateError('Payment account workspace unavailable');
    final session = sessions.current(), generation = ++_generation;
    _view = null;
    _owner = null;
    _inflight++;
    try {
      final future =
          Future<PaymentAccountSnapshot>.sync(
            () => provider.account(session),
          ).then(
            (s) {
              _inflight--;
              return s;
            },
            onError: (Object e, StackTrace s) {
              _inflight--;
              Error.throwWithStackTrace(e, s);
            },
          );
      final snapshot = await future.timeout(
        Duration(seconds: policy.timeoutSeconds),
      );
      if (_closed || generation != _generation || !sessions.isCurrent(session))
        return null;
      validate(
        snapshot,
        session,
        access,
        orders,
        scope: sessions.scope,
        environment: sessions.environment,
        now: clock(),
      );
      if (clock().difference(snapshot.observedAt).inSeconds >
          policy.maximumAgeSeconds)
        throw StateError('Account snapshot exceeds observation age');
      if (cache != null) {
        if (cache!.customerId != session.customerId)
          throw StateError('Cache belongs to another customer');
        await cache!.save(snapshot);
        if (_closed ||
            generation != _generation ||
            !sessions.isCurrent(session))
          return null;
      }
      final expiry = PaymentAccountGuard.earliest([
        snapshot.expiresAt,
        session.expiresAt,
        access.expiresAt,
        ...snapshot.invoices.map((i) => i.expiresAt),
        ...snapshot.plans.map((p) => p.expiresAt),
        ...snapshot.disputes.map((d) => d.expiresAt),
        ...snapshot.activity.map((a) => a.expiresAt),
      ]);
      _owner = session;
      return _view = PaymentAccountView(
        snapshot.copyWith(expiresAt: expiry),
        current: true,
      );
    } catch (_) {
      if (!_closed &&
          generation == _generation &&
          sessions.isCurrent(session)) {
        _view = null;
        _owner = null;
      }
      rethrow;
    }
  }

  Future<PaymentAccountView?> restoreOffline(PaymentAccessPolicy access) async {
    if (_closed) throw StateError('Payment account workspace closed');
    final session = sessions.current(), generation = ++_generation;
    _view = null;
    _owner = null;
    if (cache == null) return null;
    if (cache!.customerId != session.customerId)
      throw StateError('Cache belongs to another customer');
    final cached = await cache!.load();
    if (_closed ||
        generation != _generation ||
        !sessions.isCurrent(session) ||
        cached == null)
      return null;
    for (final permission in [
      if (cached.snapshot.invoices.isNotEmpty) 'invoices.read',
      if (cached.snapshot.plans.isNotEmpty) 'plans.read',
      if (cached.snapshot.disputes.isNotEmpty) 'disputes.read',
      if (cached.snapshot.activity.isNotEmpty) 'activity.read',
    ]) {
      PaymentAccountGuard.access(
        session,
        access,
        permission,
        scope: sessions.scope,
        environment: sessions.environment,
        now: clock(),
      );
    }
    _owner = session;
    return _view = PaymentAccountView(cached.snapshot, current: false);
  }

  void cancel() {
    _generation++;
  }

  void close() {
    _closed = true;
    cancel();
    _view = null;
    _owner = null;
  }
}
