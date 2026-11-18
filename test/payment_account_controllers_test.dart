import 'dart:async';
import 'package:test/test.dart';
import 'package:trippl_payments_mobile/trippl_payments_mobile.dart';
import 'fixtures.dart';
import 'account_fixtures.dart';

void main() {
  group('account sessions and authorization', () {
    test('new sessions invalidate all captured contexts', () {
      final s = sessions(), old = sessions().current();
      final initial = s.current();
      s.begin(customerId, permissions, expiresAt: expiry);
      expect(s.isCurrent(initial), isFalse);
      expect(s.isCurrent(old), isFalse);
      s.close();
      expect(() => s.current(), throwsStateError);
    });
    test('permission requires both active session and backend policy', () {
      final s = sessions();
      PaymentAccountGuard.access(
        s.current(),
        access(),
        'invoices.read',
        scope: scope,
        environment: 'test',
        now: now,
      );
      expect(
        () => PaymentAccountGuard.access(
          s.current(),
          access().copyWith(permissions: []),
          'invoices.read',
          scope: scope,
          environment: 'test',
          now: now,
        ),
        throwsStateError,
      );
      expect(
        () => PaymentAccountGuard.access(
          s.current(),
          access().copyWith(customerId: 'cus_other'),
          'invoices.read',
          scope: scope,
          environment: 'test',
          now: now,
        ),
        throwsStateError,
      );
    });
    test('expired sessions cannot authorize a read', () {
      var time = now;
      final s = sessions(clock: () => time);
      time = expiry;
      expect(() => s.current(), throwsStateError);
    });
  });
  group('invoice history controller', () {
    test('collects complete typed invoice history', () async {
      var calls = 0;
      final reader = PaymentInvoiceReader(
        InvoiceProvider((f, c) async {
          calls++;
          return c == null
              ? invoicePage(f, cursor: 'next', complete: false)
              : invoicePage(f, rows: [invoice().copyWith(id: 'invoice-2')]);
        }),
        scope: scope,
        environment: 'test',
        clock: () => now,
      );
      final rows = await reader.load(invoiceFilter(), requireComplete: true);
      expect(rows!.length, 2);
      expect(calls, 2);
      reader.close();
    });
    test('repeated records on different pages are rejected', () async {
      final reader = PaymentInvoiceReader(
        InvoiceProvider(
          (f, c) async => invoicePage(f, cursor: 'next', complete: false),
        ),
        scope: scope,
        environment: 'test',
        clock: () => now,
      );
      await expectLater(
        reader.load(invoiceFilter(), requireComplete: true),
        throwsStateError,
      );
      reader.close();
    });
    test('incomplete history fails when completeness is required', () async {
      final reader = PaymentInvoiceReader(
        InvoiceProvider((f, c) async => invoicePage(f, complete: false)),
        scope: scope,
        environment: 'test',
        clock: () => now,
      );
      await expectLater(
        reader.load(invoiceFilter(), requireComplete: true),
        throwsStateError,
      );
      reader.close();
    });
    test('read cancellation fences late invoice pages', () async {
      final gate = Completer<PaymentInvoicePage>(), f = invoiceFilter();
      final reader = PaymentInvoiceReader(
        InvoiceProvider((f, c) => gate.future),
        scope: scope,
        environment: 'test',
        clock: () => now,
      );
      final future = reader.load(f, requireComplete: true);
      reader.cancel();
      gate.complete(invoicePage(f));
      expect(await future, isNull);
      reader.close();
    });
    test('invoice reader rejects records outside requested customer', () async {
      final reader = PaymentInvoiceReader(
        InvoiceProvider(
          (f, c) async => invoicePage(
            f,
            rows: [invoice().copyWith(customerId: 'cus_other')],
          ),
        ),
        scope: scope,
        environment: 'test',
        clock: () => now,
      );
      await expectLater(
        reader.load(invoiceFilter(), requireComplete: true),
        throwsStateError,
      );
      reader.close();
    });
  });
  group('offline account cache', () {
    PaymentAccountCache cache(
      MemoryStorage memory, {
      DateTime Function()? clock,
      String customer = customerId,
    }) => PaymentAccountCache(
      memory,
      scope: scope,
      environment: 'test',
      customerId: customer,
      clock: clock ?? () => now,
      policy: PaymentCachePolicy(enabled: true, allowOfflineDisplay: true),
    );
    test('cached records never retain backend payment authority', () async {
      final c = cache(MemoryStorage());
      await c.save(account());
      final cached = await c.load();
      expect(cached!.offline, isTrue);
      expect(cached.needsBackendVerification, isTrue);
      expect(cached.snapshot.serverVerified, isFalse);
      expect(cached.snapshot.invoices.single.serverVerified, isFalse);
      expect(cached.snapshot.plans.single.serverVerified, isFalse);
      expect(cached.snapshot.disputes.single.serverVerified, isFalse);
      expect(cached.snapshot.activity.single.serverVerified, isFalse);
      await c.close();
    });
    test('disabled cache writes nothing', () async {
      final memory = MemoryStorage(),
          c = PaymentAccountCache(
            memory,
            scope: scope,
            environment: 'test',
            customerId: customerId,
            clock: () => now,
          );
      await c.save(account());
      expect(memory.values, isEmpty);
      expect(await c.load(), isNull);
      await c.close();
    });
    test('cache partitions customers and reports stale offline data', () async {
      var time = now;
      final memory = MemoryStorage(), c = cache(memory, clock: () => time);
      await c.save(account());
      time = now.add(const Duration(hours: 1));
      expect((await c.load())!.expired, isTrue);
      final other = cache(memory, customer: 'cus_other');
      expect(await other.load(), isNull);
      await other.close();
      await c.close();
    });
    test('corrupt cache cannot be restored as verified data', () async {
      final memory = MemoryStorage(), c = cache(memory);
      await c.save(account());
      memory.values[c.key] = memory.values[c.key]!.replaceFirst(
        'INV-1',
        'INV-2',
      );
      await expectLater(c.load(), throwsStateError);
      await c.close();
    });
    test('cache byte policy bounds serialized records', () async {
      final c = PaymentAccountCache(
        MemoryStorage(),
        scope: scope,
        environment: 'test',
        customerId: customerId,
        clock: () => now,
        policy: PaymentCachePolicy(enabled: true, maximumBytes: 1024),
      );
      await expectLater(c.save(account()), throwsStateError);
      await c.close();
    });
  });
  group('account workspace', () {
    test('workspace validates every account section', () async {
      final s = sessions(),
          w = PaymentAccountWorkspace(
            AccountProvider((_) async => account()),
            sessions: s,
            clock: () => now,
          );
      final view = await w.load(access(), [order()]);
      expect(view!.current, isTrue);
      expect(view.paymentProof, isFalse);
      expect(view.counts['invoices'], 1);
      w.close();
      s.close();
    });
    test('account switch fences pending account history', () async {
      final gate = Completer<PaymentAccountSnapshot>(),
          s = sessions(),
          w = PaymentAccountWorkspace(
            AccountProvider((_) => gate.future),
            sessions: sessions(),
            clock: () => now,
          );
      w.close();
      final active = PaymentAccountWorkspace(
        AccountProvider((_) => gate.future),
        sessions: s,
        clock: () => now,
      );
      final future = active.load(access(), [order()]);
      s.begin('cus_other', permissions, expiresAt: expiry);
      gate.complete(account());
      expect(await future, isNull);
      expect(active.view, isNull);
      active.close();
      s.close();
    });
    test('backend cannot include a section without permission', () async {
      final s = sessions(),
          w = PaymentAccountWorkspace(
            AccountProvider((_) async => account()),
            sessions: sessions(),
            clock: () => now,
          );
      await expectLater(
        w.load(access().copyWith(permissions: ['invoices.read']), [order()]),
        throwsStateError,
      );
      expect(w.view, isNull);
      w.close();
      s.close();
    });
    test(
      'workspace freshness expires with the earliest child record',
      () async {
        var time = now;
        final s = sessions(clock: () => time),
            childExpiry = now.add(const Duration(seconds: 1));
        final snapshot = account().copyWith(
          invoices: [invoice().copyWith(expiresAt: childExpiry)],
        );
        final w = PaymentAccountWorkspace(
          AccountProvider((_) async => snapshot),
          sessions: s,
          clock: () => time,
        );
        await w.load(access(), [order()]);
        time = time.add(const Duration(seconds: 2));
        expect(w.view!.current, isFalse);
        w.close();
        s.close();
      },
    );
    test(
      'offline restore still requires current account permissions',
      () async {
        final memory = MemoryStorage(),
            c = PaymentAccountCache(
              memory,
              scope: scope,
              environment: 'test',
              customerId: customerId,
              clock: () => now,
              policy: PaymentCachePolicy(
                enabled: true,
                allowOfflineDisplay: true,
              ),
            );
        await c.save(account());
        final s = sessions(),
            w = PaymentAccountWorkspace(
              AccountProvider((_) async => account()),
              sessions: s,
              clock: () => now,
              cache: c,
            );
        await expectLater(
          w.restoreOffline(access().copyWith(permissions: [])),
          throwsStateError,
        );
        final view = await w.restoreOffline(access());
        expect(view!.offline, isTrue);
        expect(view.snapshot.serverVerified, isFalse);
        w.close();
        s.close();
        await c.close();
      },
    );
  });
  group('review operations', () {
    PaymentReviewOperations operation(
      ReviewProvider p, {
      PaymentAccountSession? s,
    }) =>
        PaymentReviewOperations(p, sessions: s ?? sessions(), clock: () => now);
    test(
      'requires explicit approval and returns review outcome only',
      () async {
        final p = ReviewProvider(), o = operation(ReviewProvider());
        o.close();
        final review = operation(p);
        review.prepare(
          refundSubmission(),
          access(),
          nonce: 'operation0123456789abcdef',
        );
        await expectLater(review.submit(userApproved: false), throwsStateError);
        expect(p.submissions, 0);
        final result = await review.submit(userApproved: true);
        expect(result!.state, 'acceptedForReview');
        expect(result.paymentMutationPerformed, isFalse);
        expect(p.submissions, 1);
        review.close();
      },
    );
    test(
      'failed submission remains uncertain and cannot be retried blindly',
      () async {
        final p = ReviewProvider()..fail = true, o = operation(p);
        o.prepare(
          refundSubmission(),
          access(),
          nonce: 'operation0123456789abcdef',
        );
        await expectLater(o.submit(userApproved: true), throwsStateError);
        expect(o.unresolved, isTrue);
        await expectLater(o.submit(userApproved: true), throwsStateError);
        expect(p.submissions, 1);
        p.missing = true;
        expect((await o.refresh())!.state, 'unknown');
        expect(o.unresolved, isTrue);
        p.missing = false;
        expect((await o.refresh())!.state, 'acceptedForReview');
        o.close();
      },
    );
    test(
      'session change blocks submission before it reaches backend',
      () async {
        final s = sessions(), p = ReviewProvider(), o = operation(p, s: s);
        o.prepare(
          refundSubmission(),
          access(),
          nonce: 'operation0123456789abcdef',
        );
        s.begin(customerId, permissions, expiresAt: expiry);
        await expectLater(o.submit(userApproved: true), throwsStateError);
        expect(p.submissions, 0);
        o.close();
        s.close();
      },
    );
    test('session change fences a late review result', () async {
      final gate = Completer<PaymentOperationResult>(),
          s = sessions(),
          p = ReviewProvider()..submitCallback = (_) => gate.future,
          o = operation(p, s: s);
      final t = o.prepare(
        refundSubmission(),
        access(),
        nonce: 'operation0123456789abcdef',
      );
      final future = o.submit(userApproved: true);
      s.invalidate();
      gate.complete(reviewResult(t));
      expect(await future, isNull);
      o.close();
      s.close();
    });
    test('review response cannot change payload fingerprint', () async {
      final p = ReviewProvider()
            ..submitCallback = (t) async =>
                reviewResult(t).copyWith(payloadFingerprint: 'b' * 64),
          o = operation(p);
      o.prepare(
        refundSubmission(),
        access(),
        nonce: 'operation0123456789abcdef',
      );
      await expectLater(o.submit(userApproved: true), throwsStateError);
      expect(o.unresolved, isTrue);
      o.close();
    });
    test('raw maps and foreign customer billing patches are rejected', () {
      final o = operation(ReviewProvider());
      expect(
        () => o.prepare(
          {'amount': 1250},
          access(),
          nonce: 'operation0123456789abcdef',
        ),
        throwsArgumentError,
      );
      final patch = PaymentBillingPatch(
        id: 'patch',
        scopeFingerprint: fingerprint,
        environment: 'test',
        profileId: 'billing-1',
        customerId: 'cus_other',
        expectedRevision: 1,
        address: address(),
        createdAt: now,
      );
      expect(
        () => o.prepare(patch, access(), nonce: 'operation0123456789abcdef'),
        throwsStateError,
      );
      o.close();
    });
    test('review permissions are checked before preparing a ticket', () {
      final o = operation(ReviewProvider());
      expect(
        () => o.prepare(
          refundSubmission(),
          access().copyWith(permissions: []),
          nonce: 'operation0123456789abcdef',
        ),
        throwsStateError,
      );
      o.close();
    });
  });
  group('activity and local notification presentation', () {
    test('activity summaries cannot confirm booking', () {
      final filter = PaymentActivityFilter();
      final page = PaymentActivityPage(
        id: 'activity-page',
        scopeFingerprint: fingerprint,
        environment: 'test',
        requestFingerprint: PaymentActivity.fingerprint(filter),
        entries: [activity()],
        complete: true,
        observedAt: now,
        expiresAt: expiry,
        serverVerified: true,
      );
      expect(
        PaymentActivity.page(
          page,
          filter,
          scope: scope,
          environment: 'test',
          now: now,
        ).length,
        1,
      );
      final summary = PaymentActivity.summarize(
        [activity()],
        currency: 'GBP',
        decimals: 2,
        now: now,
        complete: true,
      );
      expect(summary.charges, money);
      expect(summary.reasonCodes, contains('activityIsNotBookingProof'));
    });
    test('activity page rejects unrequested kinds', () {
      final filter = PaymentActivityFilter(kinds: ['refund']),
          page = PaymentActivityPage(
            id: 'activity-page',
            scopeFingerprint: fingerprint,
            environment: 'test',
            requestFingerprint: PaymentActivity.fingerprint(
              PaymentActivityFilter(kinds: ['refund']),
            ),
            entries: [activity()],
            observedAt: now,
            expiresAt: expiry,
            serverVerified: true,
          );
      expect(
        () => PaymentActivity.page(
          page,
          filter,
          scope: scope,
          environment: 'test',
          now: now,
        ),
        throwsStateError,
      );
    });
    test('quiet hours span midnight and support opt-out', () {
      final pref = PaymentNotificationPreference(
        scopeFingerprint: fingerprint,
        updatedAt: now,
      );
      expect(
        PaymentNotifications.quiet(pref, DateTime.utc(2026, 1, 1, 23)),
        isTrue,
      );
      expect(
        PaymentNotifications.quiet(pref, DateTime.utc(2026, 1, 1, 7)),
        isTrue,
      );
      expect(
        PaymentNotifications.quiet(pref, DateTime.utc(2026, 1, 1, 12)),
        isFalse,
      );
      expect(
        PaymentNotifications.quiet(
          pref.copyWith(quietStartHour: 0, quietEndHour: 0),
          now,
        ),
        isFalse,
      );
    });
    test('notification presentation never sends or confirms payment', () {
      final pref = PaymentNotificationPreference(
            scopeFingerprint: fingerprint,
            updatedAt: now,
          ),
          event = PaymentNotificationEvent(
            id: 'notice',
            scopeFingerprint: fingerprint,
            environment: 'test',
            orderId: 'order-1',
            kind: 'payment',
            status: 'succeeded',
            occurredAt: now,
            expiresAt: expiry,
            sourceReference: 'pi_fixture',
            serverVerified: true,
          );
      expect(
        PaymentNotifications.eligible(
          [event],
          pref,
          scope: scope,
          environment: 'test',
          now: now,
          localTime: now,
        ).length,
        1,
      );
      expect(
        PaymentNotifications.eligible(
          [event],
          pref,
          scope: scope,
          environment: 'test',
          now: now,
          localTime: now,
          alreadyPresented: {'notice'},
        ),
        isEmpty,
      );
      expect(
        PaymentNotifications.presentation(event)['notificationSent'],
        isFalse,
      );
      expect(
        PaymentNotifications.presentation(event)['paymentConfirmed'],
        isFalse,
      );
    });
  });
}
