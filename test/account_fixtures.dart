import 'package:trippl_payments_mobile/trippl_payments_mobile.dart';
import 'fixtures.dart';

const customerId = 'cus_fixture';
const permissions = [
  'billing.read',
  'billing.review',
  'invoices.read',
  'plans.read',
  'plans.review',
  'refunds.read',
  'refunds.review',
  'disputes.read',
  'support.review',
  'activity.read',
  'ledger.read',
];
final zero = money.copyWith(amountMinor: 0);
PaymentAccessPolicy access() => PaymentAccessPolicy(
  scopeFingerprint: fingerprint,
  customerId: customerId,
  permissions: permissions,
  observedAt: now,
  expiresAt: expiry,
  serverVerified: true,
);
PaymentAccountSession sessions({DateTime Function()? clock}) =>
    PaymentAccountSession(
      scope: scope,
      environment: 'test',
      clock: clock ?? () => now,
    )..begin(customerId, permissions, expiresAt: expiry);
PaymentCountryAddressRule addressRule() => PaymentCountryAddressRule(
  countryCode: 'US',
  postalCodeRequired: true,
  regionRequired: true,
  postalPattern: 'us',
  allowedRegionCodes: ['CA'],
  observedAt: now,
  expiresAt: expiry,
  serverVerified: true,
);
PaymentBillingAddress address() => PaymentBillingAddress(
  id: 'address-1',
  countryCode: 'US',
  line1: '100 Example Street',
  city: 'Example',
  regionCode: 'CA',
  postalCode: '90210',
  updatedAt: now,
);
PaymentBillingProfile profile() => PaymentBillingProfile(
  id: 'billing-1',
  scopeFingerprint: fingerprint,
  environment: 'test',
  customerId: customerId,
  address: address(),
  observedAt: now,
  expiresAt: expiry,
  serverVerified: true,
);
PaymentInvoice invoice() => PaymentInvoice(
  id: 'invoice-1',
  scopeFingerprint: fingerprint,
  environment: 'test',
  customerId: customerId,
  orderId: 'order-1',
  number: 'INV-1',
  status: 'paid',
  total: money,
  paid: money,
  remaining: zero,
  issuedAt: now,
  lines: [
    PaymentInvoiceLine(
      id: 'invoice-line-1',
      description: 'Hotel',
      quantity: 1,
      unitAmount: money,
      netAmount: money,
      taxAmount: zero,
      total: money,
    ),
  ],
  intentIds: ['pi_fixture'],
  observedAt: now,
  expiresAt: expiry,
  serverVerified: true,
);
PaymentInvoiceFilter invoiceFilter() =>
    PaymentInvoiceFilter(customerId: customerId);
PaymentInvoicePage invoicePage(
  PaymentInvoiceFilter filter, {
  List<PaymentInvoice>? rows,
  String? cursor,
  bool complete = true,
}) => PaymentInvoicePage(
  id: 'invoice-page',
  scopeFingerprint: fingerprint,
  environment: 'test',
  requestFingerprint: PaymentInvoiceReader.fingerprint(filter),
  invoices: rows ?? [invoice()],
  cursor: cursor,
  complete: complete,
  observedAt: now,
  expiresAt: expiry,
  serverVerified: true,
);
PaymentStatementQuery statementQuery() => PaymentStatementQuery(
  customerId: customerId,
  currency: 'GBP',
  periodStart: now.subtract(const Duration(days: 1)),
  periodEnd: now.add(const Duration(days: 1)),
);
PaymentStatement statement() => PaymentStatement(
  id: 'statement-1',
  scopeFingerprint: fingerprint,
  environment: 'test',
  customerId: customerId,
  currency: 'GBP',
  periodStart: statementQuery().periodStart,
  periodEnd: statementQuery().periodEnd,
  entries: [
    PaymentStatementEntry(
      id: 'entry-1',
      orderId: 'order-1',
      occurredAt: now,
      kind: 'charge',
      amount: money,
      status: 'posted',
      intentId: 'pi_fixture',
    ),
  ],
  complete: true,
  observedAt: now,
  expiresAt: expiry,
  serverVerified: true,
);
PaymentFxRate fxRate() => PaymentFxRate(
  id: 'rate-1',
  baseCurrency: 'GBP',
  quoteCurrency: 'EUR',
  numerator: 11,
  denominator: 10,
  source: 'backend',
  observedAt: now,
  expiresAt: expiry,
  serverVerified: true,
);
PaymentFxQuote fxQuote() => PaymentFxQuote(
  id: 'fx-1',
  scopeFingerprint: fingerprint,
  environment: 'test',
  orderId: 'order-1',
  sourceAmount: money,
  targetAmount: PaymentMoney(currency: 'EUR', amountMinor: 1400),
  rate: fxRate(),
  fee: PaymentMoney(currency: 'EUR', amountMinor: 25),
  observedAt: now,
  expiresAt: expiry,
  serverVerified: true,
);
PaymentDepositTerms depositTerms() => PaymentDepositTerms(
  id: 'deposit-terms',
  scopeFingerprint: fingerprint,
  environment: 'test',
  serviceType: 'hotel',
  depositBasisPoints: 2000,
  minimumDeposit: money.copyWith(amountMinor: 100),
  balanceDueAt: now.add(const Duration(days: 10)),
  observedAt: now,
  expiresAt: expiry,
  serverVerified: true,
);
PaymentDepositQuote depositQuote() => PaymentDepositQuote(
  id: 'deposit-quote',
  scopeFingerprint: fingerprint,
  environment: 'test',
  orderId: 'order-1',
  orderFingerprint: PaymentOrders.fingerprint(order()),
  termsId: 'deposit-terms',
  total: money,
  deposit: money.copyWith(amountMinor: 250),
  balance: money.copyWith(amountMinor: 1000),
  balanceDueAt: depositTerms().balanceDueAt,
  observedAt: now,
  expiresAt: expiry,
  serverVerified: true,
);
PaymentInstallmentPlan plan() => PaymentInstallmentPlan(
  id: 'plan-1',
  scopeFingerprint: fingerprint,
  environment: 'test',
  orderId: 'order-1',
  orderFingerprint: PaymentOrders.fingerprint(order()),
  total: money,
  status: 'proposed',
  termsRevision: 1,
  installments: [
    PaymentInstallment(
      id: 'installment-1',
      sequence: 1,
      amount: money.copyWith(amountMinor: 625),
      dueAt: now.add(const Duration(days: 2)),
      status: 'scheduled',
    ),
    PaymentInstallment(
      id: 'installment-2',
      sequence: 2,
      amount: money.copyWith(amountMinor: 625),
      dueAt: now.add(const Duration(days: 4)),
      status: 'scheduled',
    ),
  ],
  observedAt: now,
  expiresAt: expiry,
  serverVerified: true,
);
PaymentRefundReason refundReason() => PaymentRefundReason(
  code: 'customer_request',
  label: 'Customer request',
  partialAllowed: true,
  serviceTypes: ['hotel'],
  observedAt: now,
  expiresAt: expiry,
  serverVerified: true,
);
PaymentRefundRequestDraft refundDraft() => PaymentRefundDrafts.create(
  order(),
  intent(),
  money.copyWith(amountMinor: 250),
  refundReason(),
  scope: scope,
  environment: 'test',
  now: now,
  nonce: 'refund0123456789abcdef',
);
PaymentRefundEligibility refundEligibility() => PaymentRefundEligibility(
  id: 'eligible-1',
  scopeFingerprint: fingerprint,
  environment: 'test',
  orderId: 'order-1',
  intentId: 'pi_fixture',
  available: money,
  maximumRequest: money,
  eligible: true,
  reasons: [refundReason()],
  observedAt: now,
  expiresAt: expiry,
  serverVerified: true,
);
PaymentRefundSummary refundSummary() => PaymentRefundSummary(
  orderId: 'order-1',
  intentId: 'pi_fixture',
  evaluatedAt: now,
  paid: money,
  refunded: zero,
  pending: zero,
  remaining: money,
  complete: true,
);
PaymentRefundPreview refundPreview() => PaymentRefundPreview(
  id: 'preview-1',
  scopeFingerprint: fingerprint,
  environment: 'test',
  draftFingerprint: PaymentRefundDrafts.fingerprint(refundDraft()),
  orderId: 'order-1',
  intentId: 'pi_fixture',
  requested: refundDraft().amount,
  fee: zero,
  net: refundDraft().amount,
  status: 'review',
  observedAt: now,
  expiresAt: expiry,
  serverVerified: true,
);
PaymentRefundSubmission refundSubmission() => PaymentRefundPreviews.review(
  refundPreview(),
  refundDraft(),
  refundEligibility(),
  scope: scope,
  environment: 'test',
  now: now,
  acknowledgedWarnings: [],
);
PaymentRefundReference refund() => PaymentRefundReference(
  id: 're_fixture',
  scopeFingerprint: fingerprint,
  environment: 'test',
  orderId: 'order-1',
  intentId: 'pi_fixture',
  amount: money.copyWith(amountMinor: 250),
  status: 'pending',
  createdAt: now,
  observedAt: now,
  expiresAt: expiry,
  serverVerified: true,
);
PaymentDispute dispute() => PaymentDispute(
  id: 'dispute-1',
  scopeFingerprint: fingerprint,
  environment: 'test',
  orderId: 'order-1',
  intentId: 'pi_fixture',
  amount: money,
  reasonCode: 'unrecognized',
  status: 'needs_response',
  openedAt: now,
  responseDueAt: now.add(const Duration(days: 1)),
  evidenceAllowed: true,
  observedAt: now,
  expiresAt: expiry,
  serverVerified: true,
);
PaymentActivityEntry activity() => PaymentActivityEntry(
  id: 'activity-1',
  scopeFingerprint: fingerprint,
  environment: 'test',
  orderId: 'order-1',
  kind: 'payment',
  status: 'succeeded',
  occurredAt: now,
  amount: money,
  intentId: 'pi_fixture',
  observedAt: now,
  expiresAt: expiry,
  serverVerified: true,
);
PaymentLedgerStatement ledger() => PaymentLedgerStatement(
  id: 'ledger-1',
  scopeFingerprint: fingerprint,
  environment: 'test',
  customerId: customerId,
  currency: 'GBP',
  periodStart: statementQuery().periodStart,
  periodEnd: statementQuery().periodEnd,
  openingMinor: 0,
  closingMinor: 1250,
  entries: [
    PaymentLedgerEntry(
      id: 'ledger-entry',
      scopeFingerprint: fingerprint,
      environment: 'test',
      orderId: 'order-1',
      occurredAt: now,
      kind: 'charge',
      direction: 'debit',
      amount: money,
      referenceId: 'pi_fixture',
      sequence: 1,
      posted: true,
      serverVerified: true,
    ),
  ],
  complete: true,
  observedAt: now,
  expiresAt: expiry,
  serverVerified: true,
);
PaymentAccountSnapshot account() => PaymentAccountSnapshot(
  id: 'account-1',
  scopeFingerprint: fingerprint,
  environment: 'test',
  customerId: customerId,
  invoices: [invoice()],
  plans: [plan()],
  disputes: [dispute()],
  activity: [activity()],
  complete: true,
  observedAt: now,
  expiresAt: expiry,
  serverVerified: true,
);

class InvoiceProvider implements PaymentInvoiceProvider {
  InvoiceProvider(this.callback);
  final Future<PaymentInvoicePage> Function(PaymentInvoiceFilter, String?)
  callback;
  @override
  Future<PaymentInvoicePage> invoices(
    PaymentInvoiceFilter filter, {
    String? cursor,
  }) => callback(filter, cursor);
}

class AccountProvider implements PaymentAccountProvider {
  AccountProvider(this.callback);
  final Future<PaymentAccountSnapshot> Function(PaymentSessionContext) callback;
  @override
  Future<PaymentAccountSnapshot> account(PaymentSessionContext session) =>
      callback(session);
}

PaymentOperationResult reviewResult(
  PaymentOperationTicket ticket, {
  String state = 'acceptedForReview',
}) => PaymentOperationResult(
  ticketId: ticket.id,
  scopeFingerprint: ticket.scopeFingerprint,
  environment: ticket.environment,
  payloadFingerprint: ticket.payloadFingerprint,
  state: state,
  referenceId: 'review-reference',
  observedAt: now,
  expiresAt: expiry,
  serverVerified: true,
);

class ReviewProvider implements PaymentReviewProvider {
  int submissions = 0, lookups = 0;
  bool fail = false, missing = false;
  Future<PaymentOperationResult> Function(PaymentOperationTicket)?
  submitCallback;
  @override
  Future<PaymentOperationResult> submit(
    PaymentOperationTicket t,
    Map<String, Object?> payload,
  ) async {
    submissions++;
    if (fail) throw StateError('simulated network error');
    return submitCallback == null ? reviewResult(t) : await submitCallback!(t);
  }

  @override
  Future<PaymentOperationResult?> lookup(PaymentOperationTicket t) async {
    lookups++;
    return missing ? null : reviewResult(t);
  }
}
