import 'package:test/test.dart';
import 'package:trippl_payments_mobile/trippl_payments_mobile.dart';
import 'fixtures.dart';
import 'account_fixtures.dart';

void main() {
  group('billing and tax', () {
    test('country rules identify missing required address fields', () {
      final result = PaymentBillingAddresses.assess(
        address().copyWith(line1: '', clear: {'postalCode', 'regionCode'}),
        addressRule(),
        now: now,
      );
      expect(result.valid, isFalse);
      expect(
        result.missingFields,
        containsAll(['line1', 'postalCode', 'regionCode']),
      );
    });
    for (final postal in ['90210', '90210-1234']) {
      test('US postal code $postal is supported', () {
        expect(
          PaymentBillingAddresses.assess(
            address().copyWith(postalCode: postal),
            addressRule(),
            now: now,
          ).valid,
          isTrue,
        );
      });
    }
    for (final postal in ['ABCDE', '902', '90210-12345']) {
      test('US postal code $postal is rejected', () {
        expect(
          PaymentBillingAddresses.assess(
            address().copyWith(postalCode: postal),
            addressRule(),
            now: now,
          ).valid,
          isFalse,
        );
      });
    }
    test('billing changes preserve identity and expected revisions', () {
      final patch = PaymentBillingProfiles.patch(
        profile(),
        address().copyWith(line1: '101 Example Street', revision: 2),
        addressRule(),
        scope: scope,
        environment: 'test',
        customerId: customerId,
        now: now,
        expectedRevision: 1,
      );
      expect(patch.changedFields, ['line1']);
      expect(patch.submitted, isFalse);
      expect(
        () => PaymentBillingProfiles.patch(
          profile(),
          address().copyWith(line1: '101 Example Street', revision: 2),
          addressRule(),
          scope: scope,
          environment: 'test',
          customerId: customerId,
          now: now,
          expectedRevision: 2,
        ),
        throwsStateError,
      );
    });
    test('billing profile cannot cross customer or environment boundaries', () {
      for (final p in [
        profile().copyWith(customerId: 'cus_other'),
        profile().copyWith(environment: 'live'),
        profile().copyWith(serverVerified: false),
      ]) {
        expect(
          () => PaymentBillingProfiles.validate(
            p,
            scope: scope,
            environment: 'test',
            customerId: customerId,
            now: now,
          ),
          throwsStateError,
        );
      }
    });
    test('masked tax identity is required for presentation', () {
      final tax = PaymentTaxIdentity(
        id: 'tax-1',
        scopeFingerprint: fingerprint,
        environment: 'test',
        customerId: customerId,
        countryCode: 'GB',
        type: 'vat',
        maskedValue: '***1234',
        status: 'verified',
        observedAt: now,
        expiresAt: expiry,
        serverVerified: true,
      );
      PaymentBillingProfiles.taxIdentity(
        tax,
        scope: scope,
        environment: 'test',
        customerId: customerId,
        now: now,
      );
      expect(
        () => PaymentBillingProfiles.taxIdentity(
          tax.copyWith(maskedValue: 'GB123456789'),
          scope: scope,
          environment: 'test',
          customerId: customerId,
          now: now,
        ),
        throwsStateError,
      );
    });
    test('inclusive and exclusive tax totals are distinguished', () {
      final tax = PaymentTaxAssessment(
        orderId: 'order-1',
        scopeFingerprint: fingerprint,
        environment: 'test',
        subtotal: money,
        tax: zero,
        total: money,
        observedAt: now,
        expiresAt: expiry,
        serverVerified: true,
      );
      PaymentBillingProfiles.taxAssessment(
        tax,
        order(),
        scope: scope,
        environment: 'test',
        now: now,
      );
      expect(
        () => PaymentBillingProfiles.taxAssessment(
          tax.copyWith(tax: money),
          order(),
          scope: scope,
          environment: 'test',
          now: now,
        ),
        throwsStateError,
      );
      PaymentBillingProfiles.taxAssessment(
        tax.copyWith(inclusive: true, tax: money.copyWith(amountMinor: 250)),
        order(),
        scope: scope,
        environment: 'test',
        now: now,
      );
    });
  });
  group('invoices and statements', () {
    test('invoice line and settlement totals reconcile', () {
      PaymentInvoices.validate(
        invoice(),
        scope: scope,
        environment: 'test',
        customerId: customerId,
        now: now,
      );
      final invalid = invoice().copyWith(remaining: money);
      expect(
        () => PaymentInvoices.validate(
          invalid,
          scope: scope,
          environment: 'test',
          customerId: customerId,
          now: now,
        ),
        throwsStateError,
      );
    });
    test('invoice line quantity cannot silently change total', () {
      final bad = invoice().copyWith(
        lines: [invoice().lines.single.copyWith(quantity: 2)],
      );
      expect(
        () => PaymentInvoices.validate(
          bad,
          scope: scope,
          environment: 'test',
          customerId: customerId,
          now: now,
        ),
        throwsStateError,
      );
    });
    test('invoice tax declarations reconcile with line tax', () {
      final bad = invoice().copyWith(
        taxes: [
          PaymentInvoiceTax(
            id: 'tax',
            label: 'Tax',
            jurisdictionCode: 'GB',
            taxableAmount: money,
            amount: money.copyWith(amountMinor: 1),
            rateBasisPoints: 1,
          ),
        ],
      );
      expect(
        () => PaymentInvoices.validate(
          bad,
          scope: scope,
          environment: 'test',
          customerId: customerId,
          now: now,
        ),
        throwsStateError,
      );
    });
    test(
      'invoice filter has deterministic tie ordering and excludes drafts',
      () {
        final values = [
          invoice().copyWith(id: 'b'),
          invoice().copyWith(id: 'a'),
          invoice().copyWith(id: 'draft', status: 'draft'),
        ];
        expect(
          PaymentInvoices.filter(
            values,
            invoiceFilter(),
            now: now,
          ).map((i) => i.id),
          ['a', 'b'],
        );
      },
    );
    test('invoice summary separates currencies and incomplete histories', () {
      final summary = PaymentInvoices.summarize(
        [invoice()],
        customerId: customerId,
        currency: 'GBP',
        now: now,
      );
      expect(summary.paid, money);
      expect(summary.remaining, zero);
      expect(summary.complete, isFalse);
      expect(summary.reasonCodes, ['invoiceHistoryIncomplete']);
    });
    test('statement query binds customer time interval and status', () {
      PaymentStatements.validate(
        statement(),
        statementQuery(),
        scope: scope,
        environment: 'test',
        now: now,
      );
      expect(
        () => PaymentStatements.validate(
          statement(),
          statementQuery().copyWith(customerId: 'cus_other'),
          scope: scope,
          environment: 'test',
          now: now,
        ),
        throwsStateError,
      );
      final pending = statement().copyWith(
        entries: [statement().entries.single.copyWith(status: 'pending')],
      );
      expect(
        () => PaymentStatements.validate(
          pending,
          statementQuery(),
          scope: scope,
          environment: 'test',
          now: now,
        ),
        throwsStateError,
      );
    });
    test('statement totals exclude pending postings', () {
      final s = statement().copyWith(
        entries: [
          statement().entries.single,
          statement().entries.single.copyWith(id: 'pending', status: 'pending'),
        ],
      );
      expect(PaymentStatements.totals(s)['charged'], money);
    });
    test('CSV export quotes formulas commas and embedded quotes', () {
      expect(PaymentAccountExports.cell('=SUM(A1)'), contains("'=SUM(A1)"));
      expect(PaymentAccountExports.cell('a,"b"'), '"a,""b"""');
      final csv = PaymentAccountExports.csv(statement());
      expect(csv, contains('amountMinor'));
      expect(csv, contains('1250'));
      expect(csv.endsWith('\r\n'), isTrue);
      final manifest = PaymentAccountExports.manifest(
        statement(),
        scope: scope,
        environment: 'test',
        now: now,
      );
      expect(manifest.paymentProof, isFalse);
      expect(manifest.contentFingerprint, PaymentCodec.digest(csv));
    });
    test('invoice PDF link requires exact host and matching invoice', () {
      final document = PaymentInvoiceDocument(
        id: 'doc',
        scopeFingerprint: fingerprint,
        environment: 'test',
        invoiceId: 'invoice-1',
        uri: 'https://receipts.mytrippl.com/invoices/invoice-1.pdf',
        mediaType: 'application/pdf',
        byteCount: 100,
        checksum: 'a' * 64,
        issuedAt: now,
        observedAt: now,
        expiresAt: expiry,
        serverVerified: true,
      );
      final policy = PaymentReceiptPolicy(
        allowedHosts: ['receipts.mytrippl.com'],
        allowedPathPrefixes: ['/invoices'],
      );
      expect(
        PaymentAccountExports.invoiceDocument(
          document,
          invoice(),
          policy,
          scope: scope,
          environment: 'test',
          customerId: customerId,
          now: now,
        ).host,
        'receipts.mytrippl.com',
      );
      expect(
        () => PaymentAccountExports.invoiceDocument(
          document.copyWith(
            uri: 'https://receipts.mytrippl.com.evil/invoices/a.pdf',
          ),
          invoice(),
          policy,
          scope: scope,
          environment: 'test',
          customerId: customerId,
          now: now,
        ),
        throwsStateError,
      );
    });
  });
  group('FX and deposits', () {
    test('FX fee is reconciled without changing charge currency', () {
      final display = PaymentForeignExchange.disclose(
        fxQuote(),
        order(),
        scope: scope,
        environment: 'test',
        now: now,
      );
      expect(display.displayOnly, isTrue);
      expect(display.displayAmount.currency, 'EUR');
      expect(display.sourceAmount.currency, 'GBP');
      expect(display.displayAmount.amountMinor, 1400);
      expect(
        () => PaymentForeignExchange.disclose(
          fxQuote().copyWith(
            targetAmount: PaymentMoney(currency: 'EUR', amountMinor: 1401),
          ),
          order(),
          scope: scope,
          environment: 'test',
          now: now,
        ),
        throwsStateError,
      );
    });
    for (final amount in [1, 5, 13, 1250, 9000000000000]) {
      test('FX rounding bounds for minor amount $amount', () {
        final source = money.copyWith(amountMinor: amount),
            rate = fxRate().copyWith(numerator: 1, denominator: 3);
        final floor = PaymentForeignExchange.convert(
          source,
          rate,
          targetDecimals: 2,
          now: now,
          rounding: 'floor',
        ).amountMinor;
        final half = PaymentForeignExchange.convert(
          source,
          rate,
          targetDecimals: 2,
          now: now,
        ).amountMinor;
        final ceil = PaymentForeignExchange.convert(
          source,
          rate,
          targetDecimals: 2,
          now: now,
          rounding: 'ceil',
        ).amountMinor;
        expect(half, greaterThanOrEqualTo(floor));
        expect(half, lessThanOrEqualTo(ceil));
        expect(ceil - floor, lessThanOrEqualTo(1));
      });
    }
    test('FX refuses overflow and unverified rates', () {
      expect(
        () => PaymentForeignExchange.convert(
          money.copyWith(amountMinor: 9000000000000),
          fxRate(),
          targetDecimals: 2,
          now: now,
        ),
        throwsStateError,
      );
      expect(
        () => PaymentForeignExchange.convert(
          money,
          fxRate().copyWith(serverVerified: false),
          targetDecimals: 2,
          now: now,
        ),
        throwsStateError,
      );
    });
    test('deposit plus balance matches immutable order terms', () {
      PaymentDeposits.validate(
        depositQuote(),
        depositTerms(),
        order(),
        scope: scope,
        environment: 'test',
        now: now,
      );
      expect(
        PaymentDeposits.presentation(
          depositQuote(),
          depositTerms(),
        )['requiresBackendVerification'],
        isTrue,
      );
      expect(
        () => PaymentDeposits.validate(
          depositQuote().copyWith(deposit: money),
          depositTerms(),
          order(),
          scope: scope,
          environment: 'test',
          now: now,
        ),
        throwsStateError,
      );
    });
  });
  group('installment review', () {
    test('scheduled plan totals reconcile without automatic charges', () {
      final assessment = PaymentInstallments.assess(
        plan(),
        order(),
        scope: scope,
        environment: 'test',
        now: now,
      );
      expect(assessment.remaining, money);
      expect(assessment.paid, zero);
      final schedule = PaymentInstallments.schedule(plan(), now: now);
      expect(schedule.upcomingIds.length, 2);
      expect(schedule.mayChargeAutomatically, isFalse);
    });
    test('plan order fingerprint and installment sequence are enforced', () {
      for (final bad in [
        plan().copyWith(orderFingerprint: 'b' * 64),
        plan().copyWith(
          installments: [
            plan().installments[0].copyWith(sequence: 2),
            plan().installments[1],
          ],
        ),
      ]) {
        expect(
          () => PaymentInstallments.validate(
            bad,
            order(),
            scope: scope,
            environment: 'test',
            now: now,
          ),
          throwsStateError,
        );
      }
    });
    test('paid installments require referenced backend payment and time', () {
      final bad = plan().copyWith(
        installments: [
          plan().installments[0].copyWith(status: 'paid'),
          plan().installments[1],
        ],
      );
      expect(
        () => PaymentInstallments.validate(
          bad,
          order(),
          scope: scope,
          environment: 'test',
          now: now,
        ),
        throwsStateError,
      );
    });
    test('customer consent expires on a plan reprice', () {
      final consent = PaymentPlanConsents.accept(
        plan(),
        order(),
        scope: scope,
        environment: 'test',
        now: now,
        acknowledgedCodes: ['scheduleReviewed', 'noAutomaticCharge'],
      );
      expect(consent.automaticChargeConsent, isFalse);
      expect(consent.submitted, isFalse);
      PaymentPlanConsents.validate(
        consent,
        plan(),
        scope: scope,
        environment: 'test',
        now: now,
      );
      expect(
        () => PaymentPlanConsents.validate(
          consent,
          plan().copyWith(termsRevision: 2),
          scope: scope,
          environment: 'test',
          now: now,
        ),
        throwsStateError,
      );
    });
    test('plan changes preserve paid installments and advance terms', () {
      final paid = plan().installments[0].copyWith(
        status: 'paid',
        intentId: 'pi_deposit',
        paidAt: now,
      );
      final current = plan().copyWith(
        status: 'active',
        installments: [paid, plan().installments[1]],
      );
      final replacement = current.copyWith(revision: 2, termsRevision: 2);
      final proposal = PaymentPlanChanges.propose(
        current,
        replacement,
        order(),
        scope: scope,
        environment: 'test',
        now: now,
        expectedRevision: 1,
        reasonCode: 'schedule_change',
      );
      expect(proposal.submitted, isFalse);
      final altered = replacement.copyWith(
        installments: [
          paid.copyWith(dueAt: now.add(const Duration(days: 1))),
          replacement.installments[1],
        ],
      );
      expect(
        () => PaymentPlanChanges.propose(
          current,
          altered,
          order(),
          scope: scope,
          environment: 'test',
          now: now,
          expectedRevision: 1,
          reasonCode: 'schedule_change',
        ),
        throwsStateError,
      );
    });
    test('history rejects repeated backend revisions', () {
      final history = PaymentPlanHistory(
        planId: 'plan-1',
        scopeFingerprint: fingerprint,
        environment: 'test',
        orderId: 'order-1',
        versions: [plan(), plan()],
        observedAt: now,
        expiresAt: expiry,
        serverVerified: true,
      );
      expect(
        () => PaymentPlanChanges.history(
          history,
          scope: scope,
          environment: 'test',
          now: now,
        ),
        throwsStateError,
      );
    });
  });
  group('refund review', () {
    test('draft eligibility preview remain separate from refund creation', () {
      PaymentRefundEligibilityRules.validate(
        refundEligibility(),
        refundDraft(),
        refundSummary(),
        scope: scope,
        environment: 'test',
        now: now,
      );
      final submission = refundSubmission();
      expect(submission.refundCreated, isFalse);
      expect(submission.requiresBackendReview, isTrue);
      expect(
        PaymentRefundDrafts.payload(refundDraft())['draftFingerprint'],
        PaymentRefundDrafts.fingerprint(refundDraft()),
      );
    });
    test('refund draft rejects unsupported partial amount', () {
      expect(
        () => PaymentRefundDrafts.create(
          order(),
          intent(),
          money.copyWith(amountMinor: 1),
          refundReason().copyWith(partialAllowed: false),
          scope: scope,
          environment: 'test',
          now: now,
          nonce: 'refund0123456789abcdef',
        ),
        throwsStateError,
      );
    });
    test('refund draft cannot cross order revisions or customer binding', () {
      expect(
        () => PaymentRefundDrafts.create(
          order(),
          intent().copyWith(orderRevision: 2),
          money,
          refundReason(),
          scope: scope,
          environment: 'test',
          now: now,
          nonce: 'refund0123456789abcdef',
        ),
        throwsStateError,
      );
    });
    test('incomplete refund history cannot authorize an amount', () {
      expect(
        () => PaymentRefundEligibilityRules.validate(
          refundEligibility(),
          refundDraft(),
          refundSummary().copyWith(complete: false),
          scope: scope,
          environment: 'test',
          now: now,
        ),
        throwsStateError,
      );
    });
    test('refund ceiling and currency are enforced before review', () {
      for (final eligible in [
        refundEligibility().copyWith(
          maximumRequest: money.copyWith(amountMinor: 1),
        ),
        refundEligibility().copyWith(
          maximumRequest: money.copyWith(currency: 'EUR'),
        ),
      ]) {
        expect(
          () => PaymentRefundPreviews.validate(
            refundPreview(),
            refundDraft(),
            eligible,
            scope: scope,
            environment: 'test',
            now: now,
          ),
          throwsA(anything),
        );
      }
    });
    test('refund previews cannot change fee or draft identity', () {
      for (final preview in [
        refundPreview().copyWith(fee: money),
        refundPreview().copyWith(draftFingerprint: 'd' * 64),
      ]) {
        expect(
          () => PaymentRefundPreviews.validate(
            preview,
            refundDraft(),
            refundEligibility(),
            scope: scope,
            environment: 'test',
            now: now,
          ),
          throwsStateError,
        );
      }
    });
    test('refund preview requires all current warnings acknowledged', () {
      expect(
        () => PaymentRefundPreviews.review(
          refundPreview().copyWith(warningCodes: ['feeApplies']),
          refundDraft(),
          refundEligibility(),
          scope: scope,
          environment: 'test',
          now: now,
          acknowledgedWarnings: [],
        ),
        throwsStateError,
      );
    });
    test('refund timeline rejects a terminal-state regression', () {
      final timeline = PaymentRefundTimeline(
        id: 'timeline',
        scopeFingerprint: fingerprint,
        environment: 'test',
        orderId: 'order-1',
        intentId: 'pi_fixture',
        refundId: 're_fixture',
        entries: [
          PaymentRefundTimelineEntry(
            id: 't1',
            refundId: 're_fixture',
            occurredAt: now,
            state: 'succeeded',
            label: 'Complete',
          ),
          PaymentRefundTimelineEntry(
            id: 't2',
            refundId: 're_fixture',
            occurredAt: now,
            state: 'pending',
            label: 'Pending',
            sequence: 2,
          ),
        ],
        observedAt: now,
        expiresAt: expiry,
        serverVerified: true,
      );
      expect(
        () => PaymentRefundTimelines.validate(
          timeline,
          refund(),
          scope: scope,
          environment: 'test',
          now: now,
        ),
        throwsStateError,
      );
    });
  });
  group('ledger and disputes', () {
    test('ledger closing balance and payment reference reconcile', () {
      final balance = PaymentLedger.balance(
        ledger(),
        scope: scope,
        environment: 'test',
        customerId: customerId,
        now: now,
      );
      expect(balance.reconciled, isTrue);
      expect(balance.closingMinor, 1250);
      final result = PaymentLedger.reconcile(
        ledger(),
        order(),
        intent(),
        scope: scope,
        environment: 'test',
        customerId: customerId,
        now: now,
      );
      expect(result.matched, isTrue);
      expect(result.paymentConfirmed, isFalse);
    });
    test(
      'ledger reports mismatched closing balance without claiming success',
      () {
        final result = PaymentLedger.balance(
          ledger().copyWith(closingMinor: 1),
          scope: scope,
          environment: 'test',
          customerId: customerId,
          now: now,
        );
        expect(result.reconciled, isFalse);
        expect(result.reasonCodes, contains('ledgerClosingBalanceMismatch'));
      },
    );
    test(
      'ledger rejects duplicate references and incorrect posting direction',
      () {
        for (final l in [
          ledger().copyWith(
            entries: [
              ledger().entries.single,
              ledger().entries.single.copyWith(id: 'other', sequence: 2),
            ],
          ),
          ledger().copyWith(
            entries: [ledger().entries.single.copyWith(direction: 'credit')],
          ),
        ]) {
          expect(
            () => PaymentLedger.balance(
              l,
              scope: scope,
              environment: 'test',
              customerId: customerId,
              now: now,
            ),
            throwsA(anything),
          );
        }
      },
    );
    test('dispute history and due dates remain informational', () {
      PaymentDisputes.validate(
        dispute(),
        order(),
        scope: scope,
        environment: 'test',
        now: now,
      );
      final summary = PaymentDisputes.summarize(
        'order-1',
        [dispute()],
        now: now,
        complete: true,
      );
      expect(summary.dueSoonIds, ['dispute-1']);
      expect(summary.maySubmitEvidence, isFalse);
      expect(
        PaymentDisputes.events(dispute(), [
          PaymentDisputeEvent(
            id: 'event',
            disputeId: 'dispute-1',
            occurredAt: now,
            status: 'needs_response',
            sequence: 1,
            label: 'Response required',
            serverVerified: true,
          ),
        ], now: now).length,
        1,
      );
    });
    test('evidence references require a current eligible dispute', () {
      final e = PaymentDisputeEvidenceReference(
        id: 'evidence',
        scopeFingerprint: fingerprint,
        environment: 'test',
        disputeId: 'dispute-1',
        category: 'receipt',
        fileReference: 'opaque_file_123',
        mediaType: 'application/pdf',
        byteCount: 100,
        checksum: 'a' * 64,
        createdAt: now,
      );
      PaymentSupport.evidence(
        e,
        dispute(),
        scope: scope,
        environment: 'test',
        now: now,
      );
      expect(
        () => PaymentSupport.evidence(
          e.copyWith(fileReference: 'https://external/file'),
          dispute(),
          scope: scope,
          environment: 'test',
          now: now,
        ),
        throwsFormatException,
      );
      expect(
        () => PaymentSupport.evidence(
          e,
          dispute().copyWith(evidenceAllowed: false),
          scope: scope,
          environment: 'test',
          now: now,
        ),
        throwsStateError,
      );
    });
    test(
      'support handoff does not send a message or leak context into URL',
      () {
        final c = PaymentSupport.context(
          'order-1',
          'payment',
          scope: scope,
          environment: 'test',
          now: now,
          intentId: 'pi_fixture',
        );
        final p = PaymentReturnPolicy(
          allowedSchemes: ['https'],
          allowedHosts: ['support.mytrippl.com'],
          allowedPaths: ['/payments'],
        );
        final handoff = PaymentSupport.handoff(
          c,
          'https://support.mytrippl.com/payments',
          p,
          scope: scope,
          environment: 'test',
          now: now,
        );
        expect(handoff.messageSent, isFalse);
        expect(PaymentSupport.presentation(c)['messageSent'], isFalse);
      },
    );
  });
}
