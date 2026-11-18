import 'dart:async';
import 'package:test/test.dart';
import 'package:trippl_payments_mobile/trippl_payments_mobile.dart';
import 'fixtures.dart';

void main() {
  group('exact charge amounts', () {
    for (final decimals in [0, 1, 2, 3, 4]) {
      for (final whole in [0, 1, 12, 999, 900000]) {
        test(
          '$whole with $decimals decimals round trips exact minor units',
          () {
            final text = decimals == 0
                ? '${whole + 1}'
                : '$whole.${'1'.padRight(decimals, '0')}';
            final amount = PaymentAmounts.parse(
              text,
              currency(decimals: decimals),
              now: now,
            );
            expect(
              amount.amountMinor,
              (decimals == 0 ? whole + 1 : whole) *
                      PaymentAmounts.scale(decimals) +
                  (decimals == 0 ? 0 : PaymentAmounts.scale(decimals) ~/ 10),
            );
          },
        );
      }
    }
    for (final text in [
      'NaN',
      'Infinity',
      '-1',
      '1,50',
      ' 1',
      '1 ',
      '1e3',
      '1.001',
      '',
      '9000000000000000000',
    ]) {
      test(
        'rejects ambiguous or overflowing input $text',
        () => expect(
          () => PaymentAmounts.parse(text, currency(), now: now),
          throwsA(anything),
        ),
      );
    }
    for (final code in ['ISK', 'UGX']) {
      test('$code whole major units use a hundred-minor-unit step', () {
        final rule = currency(code: code, step: 100);
        expect(PaymentAmounts.parse('12.00', rule, now: now).amountMinor, 1200);
        expect(
          () => PaymentAmounts.parse('12.01', rule, now: now),
          throwsFormatException,
        );
      });
    }
    for (var parts = 1; parts <= 100; parts++) {
      test('split $parts conserves the total', () {
        final split = PaymentAmounts.split(money, parts);
        expect(
          split.fold<int>(0, (a, b) => a + b.amountMinor),
          money.amountMinor,
        );
        expect(
          split.map((m) => m.amountMinor).reduce((a, b) => a > b ? a : b) -
              split.map((m) => m.amountMinor).reduce((a, b) => a < b ? a : b),
          lessThanOrEqualTo(1),
        );
      });
    }
    test(
      'cross-currency arithmetic fails',
      () => expect(
        () => PaymentAmounts.add(money, money.copyWith(currency: 'EUR')),
        throwsFormatException,
      ),
    );
    test('unverified and expired currency rules fail', () {
      expect(
        () => PaymentAmounts.parse(
          '12',
          currency().copyWith(serverVerified: false),
          now: now,
        ),
        throwsStateError,
      );
      expect(
        () => PaymentAmounts.parse('12', currency(), now: expiry),
        throwsStateError,
      );
    });
  });
  group('bound order and quote', () {
    test('line totals reconcile and revisions invalidate review', () {
      final o = order(), q = quote(order());
      expect(PaymentOrders.assess(o, scope: scope, now: now).valid, isTrue);
      final review = PaymentReviews.acknowledge(
        o,
        q,
        currency(),
        scope: scope,
        now: now,
        warningCodes: [],
      );
      PaymentReviews.validate(review, o, q, currency(), scope: scope, now: now);
      expect(
        () => PaymentReviews.validate(
          review,
          o,
          q.copyWith(revision: 2),
          currency(),
          scope: scope,
          now: now,
        ),
        throwsStateError,
      );
    });
    test('changed order and wrong account reject the quote', () {
      final o = order();
      expect(
        () => PaymentQuotes.validate(
          quote(o),
          o.copyWith(revision: 2),
          currency(),
          scope: scope,
          now: now,
        ),
        throwsStateError,
      );
      expect(
        () => PaymentQuotes.validate(
          quote(o),
          o,
          currency(),
          scope: 'other-account',
          now: now,
        ),
        throwsStateError,
      );
    });
    test('unconfirmed adjustments are rejected', () {
      final o = order().copyWith(
        adjustments: [PaymentAdjustment(id: 'fee', kind: 'fee', amount: money)],
      );
      expect(
        () => PaymentOrders.breakdown(o, scope: scope, now: now),
        throwsStateError,
      );
    });
    test('checkout payload excludes client amount authority', () {
      final payload = PaymentRequests.checkoutPayload(checkoutRequest());
      expect(payload.containsKey('total'), isFalse);
      expect(payload.containsKey('scopeFingerprint'), isFalse);
      expect(payload['idempotencyKey'], checkoutRequest().idempotencyKey);
    });
  });
  group('backend verification', () {
    for (final status in [
      'succeeded',
      'processing',
      'requires_capture',
      'requires_action',
      'requires_payment_method',
      'requires_confirmation',
      'canceled',
      'unknown',
    ]) {
      test('assesses $status without conflating booking completion', () {
        final o = order(),
            r = requests().verification(
              order(),
              attempt(order()),
              'pi_fixture',
            );
        final result = PaymentVerifications.validate(
          verification(r, status: status),
          r,
          o,
          scope: scope,
          now: now,
        );
        expect(result.paid, status == 'succeeded');
        expect(result.bookingConfirmed, isFalse);
        expect(result.authorized, status == 'requires_capture');
      });
    }
    test('amount received and revision must match', () {
      final r = requests().verification(
        order(),
        attempt(order()),
        'pi_fixture',
      );
      final v = verification(r);
      expect(
        () => PaymentVerifications.validate(
          v.copyWith(
            intent: v.intent.copyWith(
              amountReceived: money.copyWith(amountMinor: 1),
            ),
          ),
          r,
          order(),
          scope: scope,
          now: now,
        ),
        throwsStateError,
      );
      expect(
        () => PaymentVerifications.validate(
          v,
          r.copyWith(minimumRevision: 2),
          order(),
          scope: scope,
          now: now,
        ),
        throwsStateError,
      );
    });
    test('booking requires its own confirmed backend reference', () {
      final r = requests().verification(
        order(),
        attempt(order()),
        'pi_fixture',
      );
      expect(
        () => PaymentVerifications.validate(
          verification(r).copyWith(bookingConfirmed: true),
          r,
          order(),
          scope: scope,
          now: now,
        ),
        throwsStateError,
      );
    });
    test('mismatched backend identity and unverified envelopes fail', () {
      final r = requests().verification(
            order(),
            attempt(order()),
            'pi_fixture',
          ),
          v = verification(
            requests().verification(order(), attempt(order()), 'pi_fixture'),
          );
      for (final altered in [
        v.copyWith(serverVerified: false),
        v.copyWith(intent: v.intent.copyWith(environment: 'live')),
        v.copyWith(binding: v.binding.copyWith(orderRevision: 2)),
        v.copyWith(requestFingerprint: '0' * 64),
      ]) {
        expect(
          () => PaymentVerifications.validate(
            altered,
            r,
            order(),
            scope: scope,
            now: now,
          ),
          throwsA(anything),
        );
      }
    });
  });
  group('checkout coordination', () {
    test('SDK completion is followed by backend verification', () async {
      final backend = FakeBackend(),
          sdk = FakeSdk(),
          c = controller(FakeBackend(), FakeSdk());
      await c.close();
      final checkout = controller(backend, sdk);
      await checkout.prepare(order(), quote(order()), currency());
      expect(checkout.state!.state, 'ready');
      final result = await checkout.present();
      expect(result!.paid, isTrue);
      expect(result.bookingConfirmed, isFalse);
      expect(backend.allocations, 1);
      expect(backend.verifications, 1);
      expect(sdk.presentations, 1);
      expect(backend.lastEnvelope!.credentials.disposed, isTrue);
      await checkout.close();
    });
    for (final state in [
      'processing',
      'requires_capture',
      'requires_action',
      'canceled',
    ]) {
      test('SDK success with backend $state is not paid', () async {
        final b = FakeBackend()..status = state, c = controller(b, FakeSdk());
        await c.prepare(order(), quote(order()), currency());
        expect((await c.present())!.paid, isFalse);
        await c.close();
      });
    }
    test(
      'SDK cancellation still verifies and does not start another charge',
      () async {
        final b = FakeBackend()..status = 'processing',
            sdk = FakeSdk()..outcome = PaymentSdkOutcome.cancelled,
            c = controller(b, sdk);
        await c.prepare(order(), quote(order()), currency());
        expect((await c.present())!.state, 'pending');
        expect(b.verifications, 1);
        await expectLater(
          c.prepare(order(), quote(order()), currency()),
          throwsStateError,
        );
        expect(b.allocations, 1);
        await c.close();
      },
    );
    test('uncertain allocation cannot be retried as a new charge', () async {
      final b = FakeBackend()..failAllocation = true,
          c = controller(b, FakeSdk());
      await expectLater(
        c.prepare(order(), quote(order()), currency()),
        throwsStateError,
      );
      expect(c.state!.state, 'uncertain');
      await expectLater(
        c.prepare(order(), quote(order()), currency()),
        throwsStateError,
      );
      expect(b.allocations, 1);
      await c.close();
    });
    test('failed verification preserves uncertainty', () async {
      final b = FakeBackend()..failVerification = true,
          c = controller(b, FakeSdk());
      await c.prepare(order(), quote(order()), currency());
      await expectLater(c.present(), throwsStateError);
      expect(c.state!.state, 'uncertain');
      expect(c.state!.busy, isFalse);
      await c.close();
    });
    test('double taps cannot allocate twice', () async {
      final gate = Completer<PaymentCheckoutEnvelope>(),
          b = FakeBackend()..allocationGate = gate,
          c = controller(b, FakeSdk());
      final first = c.prepare(order(), quote(order()), currency());
      await expectLater(
        c.prepare(order(), quote(order()), currency()),
        throwsStateError,
      );
      gate.complete(envelope(b.lastRequest!));
      await first;
      expect(b.allocations, 1);
      await c.close();
    });
    test('closing discards late credentials', () async {
      final gate = Completer<PaymentCheckoutEnvelope>(),
          b = FakeBackend()..allocationGate = gate,
          c = controller(b, FakeSdk());
      final first = c.prepare(order(), quote(order()), currency());
      await c.close();
      final value = envelope(b.lastRequest!);
      gate.complete(value);
      expect(await first, isNull);
      expect(value.credentials.disposed, isTrue);
    });
    test('invalid nonce does not lock the order', () async {
      var nonce = 'bad';
      final c = controller(FakeBackend(), FakeSdk(), nonce: () => nonce);
      await expectLater(
        c.prepare(order(), quote(order()), currency()),
        throwsFormatException,
      );
      nonce = '0123456789abcdef0123456789abcdef';
      expect(await c.prepare(order(), quote(order()), currency()), isNotNull);
      await c.close();
    });
    test(
      'pending request survives restart and missing lookup blocks new charge',
      () async {
        final storage = MemoryStorage(),
            store = PaymentPendingStore(
              storage,
              scope: scope,
              environment: 'test',
              clock: () => now,
              policy: PaymentPrivacyPolicy(persistPendingReferences: true),
            );
        final b = FakeBackend()..failAllocation = true,
            first = controller(b, FakeSdk(), store: store);
        await expectLater(
          first.prepare(order(), quote(order()), currency()),
          throwsStateError,
        );
        await first.close();
        final nextBackend = FakeBackend()..missingLookup = true,
            next = controller(nextBackend, FakeSdk(), store: store);
        expect((await next.recover(order()))!.state, 'uncertain');
        await expectLater(
          next.prepare(order(), quote(order()), currency()),
          throwsStateError,
        );
        expect(nextBackend.allocations, 0);
        await next.close();
        await store.close();
      },
    );
    test('renew reuses key and PaymentIntent', () async {
      final b = FakeBackend()..status = 'requires_payment_method',
          c = controller(b, FakeSdk());
      await c.prepare(order(), quote(order()), currency());
      final key = b.lastRequest!.idempotencyKey;
      await c.present();
      await c.renew();
      expect(b.lastRequest!.idempotencyKey, key);
      expect(b.allocations, 2);
      expect(c.state!.allocation!.intentId, 'pi_fixture');
      await c.close();
    });
    test('only verified cancellation permits reset', () async {
      final b = FakeBackend()..status = 'canceled',
          c = controller(b, FakeSdk());
      await c.prepare(order(), quote(order()), currency());
      await expectLater(c.resetCancelled(), throwsStateError);
      await c.present();
      await c.resetCancelled();
      expect(c.state!.state, 'idle');
      await c.close();
    });
  });
  group('credential and navigation boundaries', () {
    test('credentials are single-use and redacted', () async {
      final value = envelope(checkoutRequest()).credentials;
      expect(value.toString(), isNot(contains('secret_fixture')));
      await value.use(
        (secret, ephemeral) async {
          expect(secret, 'pi_fixture_secret_fixture');
        },
        scope: scope,
        now: now,
      );
      expect(value.disposed, isTrue);
      await expectLater(
        value.use((a, b) async {}, scope: scope, now: now),
        throwsStateError,
      );
    });
    test('credential disposal occurs when SDK callback fails', () async {
      final value = envelope(checkoutRequest()).credentials;
      await expectLater(
        value.use(
          (a, b) async {
            throw StateError('test');
          },
          scope: scope,
          now: now,
        ),
        throwsStateError,
      );
      expect(value.disposed, isTrue);
    });
    final policy = PaymentReturnPolicy(
      allowedSchemes: ['https'],
      allowedHosts: ['payments.mytrippl.com'],
      allowedPaths: ['/return'],
      allowedQueryKeys: ['state', 'status', 'payment_intent'],
    );
    test('return signal is never payment proof', () {
      final signal = PaymentReturns.decode(
        'https://payments.mytrippl.com/return?state=nonce&status=success&payment_intent=pi_fixture',
        policy,
        now: now,
        expectedState: 'nonce',
        expectedIntentId: 'pi_fixture',
      );
      expect(signal.paymentConfirmed, isFalse);
      expect(signal.needsVerification, isTrue);
    });
    for (final url in [
      'https://payments.mytrippl.com.evil/return?state=nonce',
      'https://evil/return?state=nonce',
      'https://payments.mytrippl.com/return?state=other',
      'https://payments.mytrippl.com/return?state=nonce&state=nonce',
      'https://payments.mytrippl.com/return?state=nonce&client_secret=bad',
    ]) {
      test(
        'rejects unsafe return $url',
        () => expect(
          () => PaymentReturns.decode(
            url,
            policy,
            now: now,
            expectedState: 'nonce',
          ),
          throwsA(anything),
        ),
      );
    }
    test('sensitive persisted keys and recursive inputs are rejected', () {
      for (final key in [
        'client_secret',
        'cardNumber',
        'cvc',
        'ephemeralKey',
        'password',
      ]) {
        expect(
          () => PaymentGuard.noSensitiveKeys({key: 'value'}),
          throwsFormatException,
        );
      }
      final cyclic = <Object>[];
      cyclic.add(cyclic);
      expect(() => PaymentGuard.inspect(cyclic), throwsFormatException);
    });
  });
}
