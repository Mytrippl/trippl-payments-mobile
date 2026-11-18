import 'dart:async';
import 'package:trippl_payments_mobile/trippl_payments_mobile.dart';

final now = DateTime.utc(2026, 11, 18, 12);
final expiry = now.add(const Duration(minutes: 10));
const scope = 'test-account';
final fingerprint = PaymentCodec.digest(scope);
final money = PaymentMoney(currency: 'GBP', amountMinor: 1250);
PaymentCurrencyRule currency({
  String code = 'GBP',
  int decimals = 2,
  int step = 1,
}) => PaymentCurrencyRule(
  currency: code,
  decimals: decimals,
  stepMinor: step,
  observedAt: now,
  expiresAt: expiry,
  serverVerified: true,
);
PaymentOrder order() => PaymentOrder(
  id: 'order-1',
  scopeFingerprint: fingerprint,
  serviceType: 'hotel',
  total: money,
  createdAt: now,
  updatedAt: now,
  revision: 1,
  lines: [PaymentOrderLine(id: 'line-1', label: 'Hotel', unitAmount: money)],
);
PaymentQuote quote(PaymentOrder o) => PaymentQuote(
  id: 'quote-1',
  orderId: o.id,
  orderRevision: o.revision,
  scopeFingerprint: fingerprint,
  orderFingerprint: PaymentOrders.fingerprint(o),
  total: o.total,
  observedAt: now,
  expiresAt: expiry,
  serverVerified: true,
);
PaymentAttempt attempt(PaymentOrder o) => PaymentAttempts.create(
  o,
  quote(o),
  scope: scope,
  environment: 'test',
  now: now,
  nonce: '0123456789abcdef0123456789abcdef',
);
PaymentRequests requests() =>
    PaymentRequests(scope: scope, environment: 'test', clock: () => now);
PaymentCheckoutRequest checkoutRequest() {
  final o = order();
  return requests().checkout(o, quote(o), attempt(o));
}

PaymentSdkConfiguration configuration() => PaymentSdkConfiguration(
  merchantName: 'Mytrippl',
  merchantCountry: 'GB',
  environment: 'test',
  returnUri: 'mytrippl://payments/return',
);
PaymentEnvironment sdkEnvironment() => PaymentConfiguration.configured(
  'pk_test_fixture',
  merchantCountry: 'GB',
  mode: 'test',
  now: now,
  sdkReady: true,
);
PaymentCredentialsReference credentialsReference() =>
    PaymentCredentialsReference(
      id: 'credentials-1',
      scopeFingerprint: fingerprint,
      orderId: 'order-1',
      intentId: 'pi_fixture',
      environment: 'test',
      createdAt: now,
      expiresAt: expiry,
    );
PaymentCheckoutEnvelope envelope(PaymentCheckoutRequest r) {
  final reference = credentialsReference();
  return PaymentCheckoutEnvelope(
    allocation: PaymentAllocation(
      id: 'allocation-1',
      scopeFingerprint: fingerprint,
      requestFingerprint: PaymentRequests.checkoutFingerprint(r),
      orderId: r.orderId,
      quoteId: r.quoteId,
      intentId: 'pi_fixture',
      total: r.total,
      credentials: reference,
      environment: 'test',
      observedAt: now,
      expiresAt: expiry,
      serverVerified: true,
    ),
    credentials: PaymentSdkCredentials(
      reference: reference,
      clientSecret: 'pi_fixture_secret_fixture',
    ),
  );
}

PaymentIntent intent({String status = 'succeeded', int revision = 1}) =>
    PaymentIntent(
      id: 'pi_fixture',
      scopeFingerprint: fingerprint,
      orderId: 'order-1',
      orderRevision: 1,
      total: money,
      status: status,
      environment: 'test',
      observedAt: now,
      expiresAt: expiry,
      serverVerified: true,
      revision: revision,
      amountReceived: status == 'succeeded' ? money : null,
    );
PaymentVerification verification(
  PaymentVerificationRequest r, {
  String status = 'succeeded',
  int revision = 1,
}) => PaymentVerification(
  id: 'verification-1',
  scopeFingerprint: fingerprint,
  requestFingerprint: PaymentRequests.verificationFingerprint(r),
  binding: PaymentOrderBinding(
    scopeFingerprint: fingerprint,
    orderId: r.orderId,
    orderRevision: 1,
    orderFingerprint: r.orderFingerprint,
    intentId: r.intentId,
    total: r.expectedTotal,
    environment: r.environment,
    observedAt: now,
    expiresAt: expiry,
    serverVerified: true,
  ),
  intent: intent(status: status, revision: revision),
  observedAt: now,
  expiresAt: expiry,
  serverVerified: true,
);
PaymentReadPage page(
  PaymentReadRequest r, {
  String? cursor,
  bool complete = true,
}) => PaymentReadPage(
  id: 'page-1',
  scopeFingerprint: fingerprint,
  requestFingerprint: PaymentRequests.readFingerprint(r),
  environment: 'test',
  observedAt: now,
  expiresAt: expiry,
  cursor: cursor,
  complete: complete,
  serverVerified: true,
);

class MemoryStorage implements PaymentLocalStorage {
  final values = <String, String>{};
  @override
  Future<String?> read(String key) async => values[key];
  @override
  Future<void> write(String key, String value) async {
    values[key] = value;
  }

  @override
  Future<void> remove(String key) async {
    values.remove(key);
  }
}

class FakeBackend implements PaymentBackend {
  int allocations = 0, verifications = 0, lookups = 0;
  String status = 'succeeded';
  bool failAllocation = false, failVerification = false, missingLookup = false;
  PaymentCheckoutRequest? lastRequest;
  PaymentCheckoutEnvelope? lastEnvelope;
  Completer<PaymentCheckoutEnvelope>? allocationGate;
  @override
  Future<PaymentCheckoutEnvelope> allocate(PaymentCheckoutRequest r) async {
    allocations++;
    lastRequest = r;
    if (failAllocation) throw StateError('simulated network failure');
    return lastEnvelope = allocationGate == null
        ? envelope(r)
        : await allocationGate!.future;
  }

  @override
  Future<PaymentVerification> verify(PaymentVerificationRequest r) async {
    verifications++;
    if (failVerification) throw StateError('simulated verification failure');
    return verification(r, status: status);
  }

  @override
  Future<PaymentVerification?> findAttempt(PaymentCheckoutRequest r) async {
    lookups++;
    if (missingLookup) return null;
    final o = order();
    return verification(
      requests().verification(o, attempt(o), 'pi_fixture'),
      status: status,
    );
  }

  @override
  Future<PaymentReadPage> read(PaymentReadRequest r) async => page(r);
}

class FakeSdk implements PaymentNativeSdk {
  int initializations = 0, presentations = 0;
  PaymentSdkOutcome outcome = PaymentSdkOutcome.completed;
  Completer<PaymentSdkOutcome>? gate;
  @override
  Future<void> initialize(PaymentSdkConfiguration c) async {
    initializations++;
  }

  @override
  Future<PaymentSdkOutcome> present(
    PaymentAllocation a,
    PaymentSdkConfiguration c,
    String secret,
    String? ephemeral,
  ) async {
    presentations++;
    return gate == null ? outcome : await gate!.future;
  }
}

PaymentCheckoutController controller(
  FakeBackend backend,
  FakeSdk native, {
  PaymentAttemptCoordinator? coordinator,
  PaymentPendingStore? store,
  String Function()? nonce,
}) => PaymentCheckoutController(
  backend,
  PaymentSdkAdapter(native, scope: scope, clock: () => now),
  scope: scope,
  environment: 'test',
  configuration: configuration(),
  sdkEnvironment: sdkEnvironment(),
  clock: () => now,
  coordinator: coordinator ?? PaymentAttemptCoordinator(),
  pendingStore: store,
  nonce: nonce ?? () => '0123456789abcdef0123456789abcdef',
);
