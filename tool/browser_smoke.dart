import 'package:trippl_payments_mobile/trippl_payments_mobile.dart';
import '../test/fixtures.dart';

Future<void> main() async {
  final backend = FakeBackend(),
      native = FakeSdk(),
      checkout = controller(backend, native);
  await checkout.prepare(order(), quote(order()), currency());
  final result = await checkout.present();
  if (result?.paid != true ||
      result!.bookingConfirmed ||
      backend.allocations != 1 ||
      backend.verifications != 1) {
    throw StateError('Browser checkout verification failed');
  }
  if (!backend.lastEnvelope!.credentials.disposed)
    throw StateError('Credential cleanup failed');
  final split = PaymentAmounts.split(money, 3);
  if (split.fold<int>(0, (a, b) => a + b.amountMinor) != 1250)
    throw StateError('Browser amount arithmetic failed');
  final memory = MemoryStorage(),
      store = PaymentPendingStore(
        memory,
        scope: scope,
        environment: 'test',
        clock: () => now,
        policy: PaymentPrivacyPolicy(persistPendingReferences: true),
      );
  await store.save(checkoutRequest());
  if (await store.load('order-1') != checkoutRequest())
    throw StateError('Browser recovery persistence failed');
  await store.close();
  await checkout.close();
  print('Browser payment coordination, exact amounts and recovery passed.');
}
