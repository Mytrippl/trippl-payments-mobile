import 'dart:async';
import 'package:test/test.dart';
import 'package:trippl_payments_mobile/trippl_payments_mobile.dart';
import 'fixtures.dart';

class ReadProvider implements PaymentReadProvider {
  ReadProvider(this.callback);
  final Future<PaymentReadPage> Function(PaymentReadRequest) callback;
  @override
  Future<PaymentReadPage> read(PaymentReadRequest r) => callback(r);
}

class Endpoint implements PaymentJsonEndpoint {
  Endpoint(this.callback);
  final Future<PaymentJsonResponse> Function(Uri, Map<String, Object?>)
  callback;
  @override
  Future<PaymentJsonResponse> post(Uri uri, Map<String, Object?> body) =>
      callback(uri, body);
}

void main() {
  test('latest read wins despite reversed response order', () async {
    final first = Completer<PaymentReadPage>(),
        second = Completer<PaymentReadPage>();
    var calls = 0;
    final c = PaymentReadController(
      ReadProvider((r) => ++calls == 1 ? first.future : second.future),
      scope: scope,
      environment: 'test',
      clock: () => now,
    );
    final r = requests().read('currencies');
    final a = c.load(r, wait: (_) async {}), b = c.load(r, wait: (_) async {});
    second.complete(page(r));
    expect((await b)!.state, 'ready');
    first.complete(page(r));
    expect(await a, isNull);
    expect(c.state!.generation, 2);
    c.close();
  });
  test(
    'cancel fences a late page without implying network cancellation',
    () async {
      final gate = Completer<PaymentReadPage>(),
          r = requests().read('currencies');
      final c = PaymentReadController(
        ReadProvider((r) => gate.future),
        scope: scope,
        environment: 'test',
        clock: () => now,
      );
      final future = c.load(r, wait: (_) async {});
      c.cancel();
      gate.complete(page(r));
      expect(await future, isNull);
      expect(c.state!.state, 'cancelled');
      c.close();
    },
  );
  test('inflight bound counts unresolved underlying calls', () async {
    final gate = Completer<PaymentReadPage>(),
        r = requests().read('currencies');
    var calls = 0;
    final c = PaymentReadController(
      ReadProvider((r) {
        calls++;
        return gate.future;
      }),
      scope: scope,
      environment: 'test',
      clock: () => now,
      policy: PaymentReadPolicy(maximumInflight: 1),
      retryPolicy: PaymentRetryPolicy(maximumReadAttempts: 1),
    );
    final a = c.load(r, wait: (_) async {});
    c.cancel();
    expect((await c.load(r, wait: (_) async {}))!.failure!.code, 'readBusy');
    expect(calls, 1);
    gate.complete(page(r));
    await a;
    c.close();
  });
  test('reads retry only within explicit policy', () async {
    var calls = 0, waits = 0;
    final r = requests().read('currencies');
    final c = PaymentReadController(
      ReadProvider((r) async {
        if (++calls == 1)
          throw const PaymentBackendException(
            'backendUnavailable',
            retryable: true,
          );
        return page(r);
      }),
      scope: scope,
      environment: 'test',
      clock: () => now,
    );
    expect(
      (await c.load(
        r,
        wait: (_) async {
          waits++;
        },
      ))!.state,
      'ready',
    );
    expect(calls, 2);
    expect(waits, 1);
    c.close();
  });
  test('page context and unrelated data are rejected', () {
    final r = requests().read('currencies');
    for (final altered in [
      page(r).copyWith(serverVerified: false),
      page(r).copyWith(environment: 'live'),
      page(r).copyWith(intents: [intent()]),
      page(r).copyWith(requestFingerprint: '0' * 64),
    ]) {
      expect(
        () =>
            PaymentReadController.validate(r, altered, scope: scope, now: now),
        throwsStateError,
      );
    }
  });
  test('collector bounds incomplete history', () async {
    final r = requests().read(
      'refunds',
      orderId: 'order-1',
      intentId: 'pi_fixture',
    );
    var calls = 0;
    final c = PaymentReadCollector(
      ReadProvider(
        (r) async => page(r, cursor: 'cursor-${++calls}', complete: false),
      ),
      scope: scope,
      environment: 'test',
      clock: () => now,
      policy: PaymentReadPolicy(maximumPages: 2),
    );
    final result = await c.collect(r);
    expect(result!.complete, isFalse);
    expect(result.pages, 2);
    expect(result.reasonCodes, ['pageLimitReached']);
    c.close();
  });
  test('collector rejects cursor loops', () async {
    final r = requests().read('currencies');
    final c = PaymentReadCollector(
      ReadProvider((r) async => page(r, cursor: 'repeated', complete: false)),
      scope: scope,
      environment: 'test',
      clock: () => now,
    );
    await expectLater(c.collect(r), throwsStateError);
    c.close();
  });
  test(
    'gateway authenticates through host port and sends no amount authority',
    () async {
      var calls = 0;
      final request = checkoutRequest(), env = envelope(checkoutRequest());
      final gateway = PaymentBackendGateway(
        Endpoint((uri, body) async {
          calls++;
          expect(
            uri.toString(),
            'https://api.mytrippl.example/v1/checkout/allocate',
          );
          expect(body.containsKey('total'), isFalse);
          return PaymentJsonResponse(
            statusCode: 200,
            body: {
              'allocation': env.allocation.toJson(),
              'sdkCredentials': {'clientSecret': 'pi_fixture_secret_fixture'},
            },
          );
        }),
        baseUri: 'https://api.mytrippl.example/v1',
        scope: scope,
        environment: 'test',
        clock: () => now,
      );
      final result = await gateway.allocate(request);
      expect(result.allocation.orderId, 'order-1');
      expect(calls, 1);
      result.dispose();
      env.dispose();
      gateway.close();
    },
  );
  for (final status in [401, 403, 429, 500, 503]) {
    test('gateway $status never automatically retries allocation', () async {
      var calls = 0;
      final g = PaymentBackendGateway(
        Endpoint((u, b) async {
          calls++;
          return PaymentJsonResponse(statusCode: status, body: null);
        }),
        baseUri: 'https://api.mytrippl.example',
        scope: scope,
        environment: 'test',
        clock: () => now,
      );
      await expectLater(
        g.allocate(checkoutRequest()),
        throwsA(isA<PaymentBackendException>()),
      );
      expect(calls, 1);
      g.close();
    });
  }
  test('lookup absence cannot be mistaken for a successful payment', () async {
    final g = PaymentBackendGateway(
      Endpoint(
        (u, b) async => PaymentJsonResponse(statusCode: 404, body: null),
      ),
      baseUri: 'https://api.mytrippl.example',
      scope: scope,
      environment: 'test',
      clock: () => now,
    );
    expect(await g.findAttempt(checkoutRequest()), isNull);
    g.close();
  });
  test('pending storage integrity and account partition', () async {
    final memory = MemoryStorage(),
        store = PaymentPendingStore(
          memory,
          scope: scope,
          environment: 'test',
          clock: () => now,
          policy: PaymentPrivacyPolicy(persistPendingReferences: true),
        );
    await store.save(checkoutRequest());
    expect(await store.load('order-1'), checkoutRequest());
    final other = PaymentPendingStore(
      memory,
      scope: 'other',
      environment: 'test',
      clock: () => now,
      policy: PaymentPrivacyPolicy(persistPendingReferences: true),
    );
    expect(await other.load('order-1'), isNull);
    final key = store.key('order-1');
    memory.values[key] = memory.values[key]!.replaceFirst('order-1', 'order-2');
    await expectLater(store.load('order-1'), throwsFormatException);
    await store.close();
    await other.close();
  });
  test('expired retention never permits another charge', () async {
    final memory = MemoryStorage(),
        policy = PaymentPrivacyPolicy(
          persistPendingReferences: true,
          maximumAgeHours: 1,
        );
    final store = PaymentPendingStore(
      memory,
      scope: scope,
      environment: 'test',
      clock: () => now,
      policy: policy,
    );
    await store.save(checkoutRequest());
    await store.close();
    final later = PaymentPendingStore(
      memory,
      scope: scope,
      environment: 'test',
      clock: () => now.add(const Duration(days: 2)),
      policy: policy,
    );
    expect(await later.load('order-1'), isNotNull);
    await later.close();
  });
  test('preference saves use expected revision', () async {
    final store = PaymentPreferenceStore(
          MemoryStorage(),
          scope: scope,
          clock: () => now,
        ),
        value = PaymentPreferences(
          scopeFingerprint: fingerprint,
          updatedAt: now,
        );
    await store.save(value, expectedRevision: 0);
    await expectLater(store.save(value, expectedRevision: 0), throwsStateError);
    expect((await store.load())!.revision, 1);
    await store.close();
  });
  test(
    'receipt link allowlist rejects a neighboring path and deceptive host',
    () {
      final policy = PaymentReceiptPolicy(
        allowedHosts: ['receipts.mytrippl.com'],
        allowedPathPrefixes: ['/receipts'],
      );
      PaymentReceipt receipt(String uri) => PaymentReceipt(
        id: 'r1',
        scopeFingerprint: fingerprint,
        orderId: 'order-1',
        intentId: 'pi_fixture',
        total: money,
        issuedAt: now,
        observedAt: now,
        expiresAt: expiry,
        serverVerified: true,
        environment: 'test',
        receiptUri: uri,
      );
      expect(
        PaymentReceiptLinks.openable(
          receipt('https://receipts.mytrippl.com/receipts/r1'),
          policy,
          scope: scope,
          now: now,
        ).host,
        'receipts.mytrippl.com',
      );
      for (final url in [
        'https://receipts.mytrippl.com.evil/receipts/r1',
        'https://receipts.mytrippl.com/receipts-evil/r1',
        'https://receipts.mytrippl.com/receipts/r1?token=secret',
      ]) {
        expect(
          () => PaymentReceiptLinks.openable(
            receipt(url),
            policy,
            scope: scope,
            now: now,
          ),
          throwsA(anything),
        );
      }
    },
  );
  test(
    'refund aggregation never initiates refunds or treats incomplete pages as balance authority',
    () {
      final refund = PaymentRefundReference(
        id: 're_1',
        scopeFingerprint: fingerprint,
        orderId: 'order-1',
        intentId: 'pi_fixture',
        amount: money.copyWith(amountMinor: 250),
        status: 'succeeded',
        createdAt: now,
        observedAt: now,
        expiresAt: expiry,
        serverVerified: true,
        environment: 'test',
      );
      final incomplete = PaymentPresentation.refunds(
        order(),
        intent(),
        [refund],
        scope: scope,
        now: now,
      );
      expect(incomplete.remaining, isNull);
      expect(incomplete.refundInitiated, isFalse);
      final complete = PaymentPresentation.refunds(
        order(),
        intent(),
        [refund],
        scope: scope,
        now: now,
        complete: true,
      );
      expect(complete.remaining!.amountMinor, 1000);
      expect(
        () => PaymentPresentation.refunds(
          order(),
          intent(),
          [refund, refund.copyWith(id: 're_2', amount: money)],
          scope: scope,
          now: now,
          complete: true,
        ),
        throwsStateError,
      );
    },
  );
}
