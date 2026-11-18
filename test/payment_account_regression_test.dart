import 'dart:async';
import 'package:test/test.dart';
import 'package:trippl_payments_mobile/trippl_payments_mobile.dart';
import 'fixtures.dart';
import 'account_fixtures.dart';

void main() {
  test('clearing an optional billing field remains an explicit change', () {
    final existing = profile().copyWith(
      address: address().copyWith(line2: 'Apartment 1'),
    );
    final replacement = existing.address.copyWith(
      clear: {'line2'},
      revision: 2,
    );
    final patch = PaymentBillingProfiles.patch(
      existing,
      replacement,
      addressRule(),
      scope: scope,
      environment: 'test',
      customerId: customerId,
      now: now,
      expectedRevision: 1,
    );
    expect(patch.changedFields, ['line2']);
    expect(patch.address.line2, isNull);
  });
  test('review timeouts count unresolved underlying requests', () async {
    final gate = Completer<PaymentOperationResult>(),
        provider = ReviewProvider()..submitCallback = (_) => gate.future;
    final operations = PaymentReviewOperations(
      provider,
      sessions: sessions(),
      clock: () => now,
      policy: PaymentReadPolicy(timeoutSeconds: 1, maximumInflight: 1),
    );
    final ticket = operations.prepare(
      refundSubmission(),
      access(),
      nonce: 'operation0123456789abcdef',
    );
    await expectLater(
      operations.submit(userApproved: true),
      throwsA(isA<TimeoutException>()),
    );
    await expectLater(operations.refresh(), throwsStateError);
    expect(provider.lookups, 0);
    expect(operations.unresolved, isTrue);
    gate.complete(reviewResult(ticket));
    await Future<void>.delayed(Duration.zero);
    expect(operations.result!.state, 'unknown');
    expect((await operations.refresh())!.state, 'acceptedForReview');
    expect(provider.submissions, 1);
    operations.close();
  });
  test(
    'an accepted review cannot change backend reference on lookup',
    () async {
      final provider = ChangingReviewProvider(),
          operations = PaymentReviewOperations(
            ChangingReviewProvider(),
            sessions: sessions(),
            clock: () => now,
          );
      operations.close();
      final o = PaymentReviewOperations(
        provider,
        sessions: sessions(),
        clock: () => now,
      );
      o.prepare(
        refundSubmission(),
        access(),
        nonce: 'operation0123456789abcdef',
      );
      await o.submit(userApproved: true);
      provider.changed = true;
      await expectLater(o.refresh(), throwsStateError);
      expect(o.result!.referenceId, 'review-reference');
      o.close();
    },
  );
  test('old review results are hidden after account logout', () async {
    final s = sessions(),
        operations = PaymentReviewOperations(
          ReviewProvider(),
          sessions: s,
          clock: () => now,
        );
    operations.prepare(
      refundSubmission(),
      access(),
      nonce: 'operation0123456789abcdef',
    );
    await operations.submit(userApproved: true);
    expect(operations.result, isNotNull);
    s.invalidate();
    expect(operations.result, isNull);
    expect(operations.ticket, isNull);
    operations.close();
  });
  test(
    'empty account snapshots still require active matching authorization',
    () {
      final empty = account().copyWith(
        invoices: [],
        plans: [],
        disputes: [],
        activity: [],
      );
      expect(
        () => PaymentAccountWorkspace.validate(
          empty,
          sessions().current().copyWith(active: false),
          access(),
          [],
          scope: scope,
          environment: 'test',
          now: now,
        ),
        throwsStateError,
      );
      expect(
        () => PaymentAccountWorkspace.validate(
          empty,
          sessions().current(),
          access().copyWith(customerId: 'cus_other'),
          [],
          scope: scope,
          environment: 'test',
          now: now,
        ),
        throwsStateError,
      );
    },
  );
  test(
    'failed offline authorization clears an earlier visible account',
    () async {
      final s = sessions(),
          cache = PaymentAccountCache(
            MemoryStorage(),
            scope: scope,
            environment: 'test',
            customerId: customerId,
            clock: () => now,
            policy: PaymentCachePolicy(
              enabled: true,
              allowOfflineDisplay: true,
            ),
          );
      final w = PaymentAccountWorkspace(
        AccountProvider((_) async => account()),
        sessions: s,
        clock: () => now,
        cache: cache,
      );
      await w.load(access(), [order()]);
      expect(w.view, isNotNull);
      await expectLater(
        w.restoreOffline(access().copyWith(permissions: [])),
        throwsStateError,
      );
      expect(w.view, isNull);
      w.close();
      await cache.close();
    },
  );
  test('a later account load fences an earlier response', () async {
    final first = Completer<PaymentAccountSnapshot>(),
        second = Completer<PaymentAccountSnapshot>();
    var calls = 0;
    final w = PaymentAccountWorkspace(
      AccountProvider((_) => ++calls == 1 ? first.future : second.future),
      sessions: sessions(),
      clock: () => now,
    );
    final a = w.load(access(), [order()]), b = w.load(access(), [order()]);
    second.complete(account().copyWith(id: 'new-account'));
    expect((await b)!.snapshot.id, 'new-account');
    first.complete(account());
    expect(await a, isNull);
    expect(w.view!.snapshot.id, 'new-account');
    w.close();
  });
}

class ChangingReviewProvider extends ReviewProvider {
  bool changed = false;
  @override
  Future<PaymentOperationResult?> lookup(PaymentOperationTicket ticket) async =>
      reviewResult(
        ticket,
      ).copyWith(referenceId: changed ? 'other-reference' : 'review-reference');
}
