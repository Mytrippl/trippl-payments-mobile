import 'package:trippl_payments_mobile/trippl_payments_mobile.dart';
import '../test/fixtures.dart';
import '../test/account_fixtures.dart';

Future<void> main() async {
  final session = sessions(), memory = MemoryStorage();
  final cache = PaymentAccountCache(
    memory,
    scope: scope,
    environment: 'test',
    customerId: customerId,
    clock: () => now,
    policy: PaymentCachePolicy(enabled: true, allowOfflineDisplay: true),
  );
  final workspace = PaymentAccountWorkspace(
    AccountProvider((_) async => account()),
    sessions: session,
    clock: () => now,
    cache: cache,
  );
  final view = await workspace.load(access(), [order()]);
  if (view?.current != true || view!.paymentProof)
    throw StateError('Browser account authorization failed');
  final offline = await workspace.restoreOffline(access());
  if (offline?.offline != true ||
      offline!.snapshot.serverVerified ||
      offline.snapshot.invoices.single.serverVerified)
    throw StateError('Browser offline authority fence failed');
  final review = PaymentReviewOperations(
    ReviewProvider(),
    sessions: session,
    clock: () => now,
  );
  review.prepare(
    refundSubmission(),
    access(),
    nonce: 'browser0123456789abcdef',
  );
  final response = await review.submit(userApproved: true);
  if (response?.state != 'acceptedForReview' ||
      response!.paymentMutationPerformed)
    throw StateError('Browser review semantics failed');
  final fx = PaymentForeignExchange.disclose(
    fxQuote(),
    order(),
    scope: scope,
    environment: 'test',
    now: now,
  );
  if (fx.displayAmount.amountMinor != 1400 || !fx.displayOnly)
    throw StateError('Browser rational FX failed');
  final ledgerResult = PaymentLedger.reconcile(
    ledger(),
    order(),
    intent(),
    scope: scope,
    environment: 'test',
    customerId: customerId,
    now: now,
  );
  if (!ledgerResult.matched || ledgerResult.paymentConfirmed)
    throw StateError('Browser ledger semantics failed');
  if (!PaymentAccountExports.csv(statement()).contains('1250'))
    throw StateError('Browser CSV export failed');
  review.close();
  workspace.close();
  await cache.close();
  session.close();
  print(
    'Browser account, offline history, review, FX, ledger and CSV checks passed.',
  );
}
