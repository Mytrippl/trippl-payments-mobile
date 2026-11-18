import 'package:test/test.dart';
import 'package:trippl_payments_mobile/trippl_payments_mobile.dart';
import 'fixtures.dart';

void main() {
  test(
    'SDK adapter rejects expired allocation even when credential expiry is later',
    () async {
      final e = envelope(checkoutRequest());
      final expired = PaymentCheckoutEnvelope(
        allocation: e.allocation.copyWith(
          observedAt: now.subtract(const Duration(minutes: 10)),
          expiresAt: now,
        ),
        credentials: e.credentials,
      );
      final native = FakeSdk(),
          adapter = PaymentSdkAdapter(native, scope: scope, clock: () => now);
      await expectLater(
        adapter.present(expired, configuration(), sdkEnvironment()),
        throwsStateError,
      );
      expect(native.presentations, 0);
      expect(expired.credentials.disposed, isTrue);
      expired.dispose();
    },
  );
  test('an old cancellation cannot clear a newer attempt', () {
    final c = PaymentAttemptCoordinator(),
        a = attempt(order()).copyWith(intentId: 'pi_fixture');
    c.remember(a, scope: scope);
    final assessment = PaymentStatuses.assess(
      intent(status: 'canceled'),
      now: now,
    );
    c.clearCancelled(a, assessment, scope: scope);
    final next = PaymentAttempts.create(
      order(),
      quote(order()),
      scope: scope,
      environment: 'test',
      now: now,
      nonce: 'fedcba9876543210fedcba9876543210',
    );
    c.remember(next, scope: scope);
    expect(
      () => c.clearCancelled(a, assessment, scope: scope),
      throwsStateError,
    );
    expect(c.current(scope, 'order-1', 'test')!.id, next.id);
  });
}
