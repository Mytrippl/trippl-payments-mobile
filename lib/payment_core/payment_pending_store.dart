import 'dart:convert';
import '../trippl_payments_mobile.dart';

abstract interface class PaymentLocalStorage {
  Future<String?> read(String key);
  Future<void> write(String key, String value);
  Future<void> remove(String key);
}

class PaymentPendingStore {
  PaymentPendingStore(
    this.storage, {
    required this.scope,
    required this.environment,
    required this.clock,
    PaymentPrivacyPolicy? policy,
  }) : policy = policy ?? PaymentPrivacyPolicy() {
    PaymentGuard.identity(scope);
    PaymentGuard.environment(environment);
    PaymentGuard.record(this.policy.validate());
  }
  final PaymentLocalStorage storage;
  final String scope, environment;
  final DateTime Function() clock;
  final PaymentPrivacyPolicy policy;
  Future<void> _pending = Future.value();
  bool _closed = false;
  String key(String orderId) =>
      'tripplpayments.pending.v1.${PaymentCodec.digest({'scope': scope, 'environment': environment, 'orderId': PaymentGuard.identity(orderId)})}';
  Future<T> _serial<T>(Future<T> Function() action) {
    if (_closed) throw StateError('Payment pending store closed');
    final future = _pending.then((_) => action());
    _pending = future.then<void>((_) {}, onError: (Object _, StackTrace __) {});
    return future;
  }

  void _validate(PaymentCheckoutRequest request) {
    PaymentGuard.record(request.validate());
    PaymentGuard.noSensitiveKeys(request.toJson());
    PaymentGuard.scope(request.scopeFingerprint, scope);
    if (request.environment != environment ||
        request.createdAt.isAfter(clock()))
      throw StateError('Pending payment request context mismatch');
  }

  Future<PaymentCheckoutRequest?> _read(String orderId) async {
    final text = await storage.read(key(orderId));
    if (text == null) return null;
    final raw = PaymentCodec.decode(text, maximumBytes: 32000);
    PaymentCodec.keys(raw, {
      'schemaVersion',
      'scope',
      'environment',
      'savedAt',
      'expiresAt',
      'request',
      'digest',
    });
    if (raw['schemaVersion'] != 1 ||
        raw['scope'] != PaymentCodec.digest(scope) ||
        raw['environment'] != environment ||
        raw['digest'] != PaymentCodec.digest(raw['request']))
      throw const FormatException('Pending payment storage integrity mismatch');
    final saved = PaymentCodec.date(raw, 'savedAt', required: true)!,
        expires = PaymentCodec.date(raw, 'expiresAt', required: true)!;
    if (saved.isAfter(clock()) ||
        !expires.isAfter(saved) ||
        expires.difference(saved) > const Duration(days: 7))
      throw StateError('Pending payment retention metadata invalid');
    final request = PaymentCheckoutRequest.fromJson(
      PaymentGuard.object(raw['request']),
    );
    _validate(request);
    if (request.orderId != orderId)
      throw StateError('Pending payment stored order mismatch');
    // Expiry never means it is safe to charge again: retain the reference for lookup.
    return request;
  }

  Future<PaymentCheckoutRequest?> load(String orderId) {
    if (!policy.persistPendingReferences) return Future.value(null);
    return _serial(() => _read(orderId));
  }

  Future<void> save(PaymentCheckoutRequest request) {
    _validate(request);
    if (!policy.persistPendingReferences) return Future.value();
    return _serial(() async {
      final old = await _read(request.orderId);
      if (old != null &&
          PaymentRequests.checkoutFingerprint(old) !=
              PaymentRequests.checkoutFingerprint(request))
        throw StateError(
          'Resolve the saved payment attempt before replacing it',
        );
      final json = request.toJson(),
          now = clock(),
          text = jsonEncode({
            'schemaVersion': 1,
            'scope': PaymentCodec.digest(scope),
            'environment': environment,
            'savedAt': now.toUtc().toIso8601String(),
            'expiresAt': now
                .add(Duration(hours: policy.maximumAgeHours))
                .toUtc()
                .toIso8601String(),
            'request': json,
            'digest': PaymentCodec.digest(json),
          });
      if (utf8.encode(text).length > 32000)
        throw const FormatException('Pending reference exceeds byte capacity');
      await storage.write(key(request.orderId), text);
    });
  }

  Future<void> clearCancelled(
    PaymentCheckoutRequest request,
    PaymentIntentAssessment assessment,
  ) {
    _validate(request);
    PaymentGuard.record(assessment.validate());
    if (!assessment.serverVerified ||
        assessment.state != 'cancelled' ||
        assessment.orderId != request.orderId)
      throw StateError(
        'Backend cancellation required before clearing pending checkout',
      );
    return _serial(() async {
      final old = await _read(request.orderId);
      if (old != null && old.attemptId != request.attemptId)
        throw StateError('Pending attempt changed');
      await storage.remove(key(request.orderId));
    });
  }

  Future<void> close() async {
    if (_closed) return;
    _closed = true;
    await _pending;
  }
}

class PaymentPreferenceStore {
  PaymentPreferenceStore(
    this.storage, {
    required this.scope,
    required this.clock,
  });
  final PaymentLocalStorage storage;
  final String scope;
  final DateTime Function() clock;
  Future<void> _pending = Future.value();
  bool _closed = false;
  String get key =>
      'tripplpayments.preferences.v1.${PaymentCodec.digest(scope)}';
  Future<T> _serial<T>(Future<T> Function() action) {
    if (_closed) throw StateError('Payment preference store closed');
    final f = _pending.then((_) => action());
    _pending = f.then<void>((_) {}, onError: (Object _, StackTrace __) {});
    return f;
  }

  Future<PaymentPreferences?> _read() async {
    final text = await storage.read(key);
    if (text == null) return null;
    final raw = PaymentCodec.decode(text, maximumBytes: 12000);
    PaymentCodec.keys(raw, {'schemaVersion', 'value', 'digest'});
    if (raw['schemaVersion'] != 1 ||
        raw['digest'] != PaymentCodec.digest(raw['value']))
      throw const FormatException('Payment preference integrity mismatch');
    final p = PaymentPreferences.fromJson(PaymentGuard.object(raw['value']));
    PaymentGuard.scope(p.scopeFingerprint, scope);
    PaymentGuard.language(p.language);
    if (p.updatedAt.isAfter(clock()))
      throw StateError('Payment preference clock mismatch');
    return p;
  }

  Future<PaymentPreferences?> load() => _serial(_read);
  Future<void> save(
    PaymentPreferences preferences, {
    required int expectedRevision,
  }) {
    PaymentGuard.record(preferences.validate());
    PaymentGuard.scope(preferences.scopeFingerprint, scope);
    PaymentGuard.language(preferences.language);
    if (preferences.updatedAt.isAfter(clock()))
      throw StateError('Payment preference clock mismatch');
    return _serial(() async {
      final old = await _read();
      PaymentGuard.revision(old?.revision ?? 0, expectedRevision);
      if (preferences.revision != expectedRevision + 1 ||
          old != null && preferences.updatedAt.isBefore(old.updatedAt))
        throw StateError('Payment preference revision mismatch');
      final value = preferences.toJson();
      await storage.write(
        key,
        jsonEncode({
          'schemaVersion': 1,
          'value': value,
          'digest': PaymentCodec.digest(value),
        }),
      );
    });
  }

  Future<void> close() async {
    if (_closed) return;
    _closed = true;
    await _pending;
  }
}
