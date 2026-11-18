import 'dart:convert';
import '../trippl_payments_mobile.dart';

class PaymentCachedAccount {
  PaymentCachedAccount(this.snapshot, {required this.expired});
  final PaymentAccountSnapshot snapshot;
  final bool expired;
  bool get offline => true;
  bool get needsBackendVerification => true;
  @override
  String toString() => 'PaymentCachedAccount(redacted)';
}

class PaymentAccountCache {
  PaymentAccountCache(
    this.storage, {
    required this.scope,
    required this.environment,
    required this.customerId,
    required this.clock,
    PaymentCachePolicy? policy,
  }) : policy = policy ?? PaymentCachePolicy() {
    PaymentGuard.record(this.policy.validate());
    PaymentGuard.identity(scope);
    PaymentGuard.environment(environment);
    PaymentGuard.objectId(customerId, 'cus');
  }
  final PaymentLocalStorage storage;
  final String scope, environment, customerId;
  final DateTime Function() clock;
  final PaymentCachePolicy policy;
  Future<void> _pending = Future.value();
  bool _closed = false;
  String get key =>
      'tripplpayments.account.v1.${PaymentCodec.digest({'scope': scope, 'environment': environment, 'customer': customerId})}';
  Future<T> _serial<T>(Future<T> Function() action) {
    if (_closed) throw StateError('Account cache closed');
    final f = _pending.then((_) => action());
    _pending = f.then<void>((_) {}, onError: (Object _, StackTrace __) {});
    return f;
  }

  Future<void> save(PaymentAccountSnapshot snapshot) {
    if (!policy.enabled) return Future.value();
    return _serial(() async {
      PaymentGuard.record(snapshot.validate());
      PaymentGuard.noSensitiveKeys(snapshot.toJson());
      PaymentAccountGuard.context(
        snapshot.scopeFingerprint,
        snapshot.environment,
        scope: scope,
        environment: environment,
      );
      PaymentAccountGuard.customer(snapshot.customerId, customerId);
      PaymentAccountGuard.current(
        snapshot.observedAt,
        snapshot.expiresAt,
        snapshot.serverVerified,
        clock(),
      );
      final now = clock(),
          expires = PaymentAccountGuard.earliest([
            snapshot.expiresAt,
            now.add(Duration(seconds: policy.maximumAgeSeconds)),
          ]);
      final envelope = PaymentCacheEnvelope(
        keyFingerprint: PaymentCodec.digest(key),
        scopeFingerprint: snapshot.scopeFingerprint,
        environment: environment,
        snapshot: snapshot,
        storedAt: now,
        expiresAt: expires,
        digest: PaymentCodec.digest(snapshot.toJson()),
      );
      final text = jsonEncode(envelope.toJson());
      if (utf8.encode(text).length > policy.maximumBytes)
        throw StateError('Account cache exceeds byte capacity');
      await storage.write(key, text);
    });
  }

  Future<PaymentCachedAccount?> load() {
    if (!policy.enabled || !policy.allowOfflineDisplay)
      return Future.value(null);
    return _serial(() async {
      final text = await storage.read(key);
      if (text == null) return null;
      final envelope = PaymentCacheEnvelope.fromJson(
        PaymentCodec.decode(text, maximumBytes: policy.maximumBytes),
      );
      PaymentAccountGuard.context(
        envelope.scopeFingerprint,
        envelope.environment,
        scope: scope,
        environment: environment,
      );
      final snapshot = envelope.snapshot;
      PaymentAccountGuard.context(
        snapshot.scopeFingerprint,
        snapshot.environment,
        scope: scope,
        environment: environment,
      );
      PaymentAccountGuard.customer(snapshot.customerId, customerId);
      if (envelope.keyFingerprint != PaymentCodec.digest(key) ||
          envelope.digest != PaymentCodec.digest(snapshot.toJson()) ||
          envelope.storedAt.isAfter(clock()) ||
          envelope.expiresAt.difference(envelope.storedAt).inSeconds >
              policy.maximumAgeSeconds)
        throw StateError('Account cache integrity or retention mismatch');
      final detached = snapshot.copyWith(
        serverVerified: false,
        invoices: snapshot.invoices
            .map((i) => i.copyWith(serverVerified: false))
            .toList(),
        plans: snapshot.plans
            .map((p) => p.copyWith(serverVerified: false))
            .toList(),
        disputes: snapshot.disputes
            .map((d) => d.copyWith(serverVerified: false))
            .toList(),
        activity: snapshot.activity
            .map((a) => a.copyWith(serverVerified: false))
            .toList(),
      );
      return PaymentCachedAccount(
        detached,
        expired: !envelope.expiresAt.isAfter(clock()),
      );
    });
  }

  Future<void> clear() => _serial(() => storage.remove(key));
  Future<void> close() async {
    if (_closed) return;
    _closed = true;
    await _pending;
  }
}
