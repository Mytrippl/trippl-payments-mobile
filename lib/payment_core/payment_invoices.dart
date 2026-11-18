import '../trippl_payments_mobile.dart';

class PaymentInvoices {
  static void validate(
    PaymentInvoice invoice, {
    required String scope,
    required String environment,
    required String customerId,
    required DateTime now,
  }) {
    PaymentGuard.record(invoice.validate());
    PaymentAccountGuard.context(
      invoice.scopeFingerprint,
      invoice.environment,
      scope: scope,
      environment: environment,
    );
    PaymentAccountGuard.customer(invoice.customerId, customerId);
    PaymentAccountGuard.current(
      invoice.observedAt,
      invoice.expiresAt,
      invoice.serverVerified,
      now,
    );
    if (invoice.issuedAt.isAfter(invoice.observedAt))
      throw StateError('Invoice issue timestamp is in the future');
    PaymentGuard.distinct(invoice.lines.map((l) => l.id));
    PaymentGuard.distinct(invoice.taxes.map((t) => t.id));
    PaymentGuard.distinct(invoice.intentIds);
    for (final id in invoice.intentIds) PaymentGuard.objectId(id, 'pi');
    if (PaymentAmounts.add(invoice.paid, invoice.remaining) != invoice.total)
      throw StateError('Invoice paid and remaining amounts do not reconcile');
    if (invoice.status == 'paid' &&
        (invoice.remaining.amountMinor != 0 || invoice.paid != invoice.total))
      throw StateError('Paid invoice has a remaining balance');
    if (invoice.status == 'void' && invoice.paid.amountMinor > 0)
      throw StateError('Voided invoice contains collected payment');
    var total = invoice.total.copyWith(amountMinor: 0), tax = total;
    for (final line in invoice.lines) {
      final net = PaymentAmounts.multiply(line.unitAmount, line.quantity);
      PaymentAmounts.compatible(invoice.total, line.total);
      PaymentAmounts.compatible(invoice.total, line.taxAmount);
      if (net != line.netAmount ||
          (line.taxInclusive ? net : PaymentAmounts.add(net, line.taxAmount)) !=
              line.total ||
          line.taxInclusive && line.taxAmount.amountMinor > net.amountMinor)
        throw StateError('Invoice line amount mismatch');
      total = PaymentAmounts.add(total, line.total);
      tax = PaymentAmounts.add(tax, line.taxAmount);
    }
    if (invoice.lines.isNotEmpty && total != invoice.total)
      throw StateError('Invoice lines do not reconcile with total');
    if (invoice.taxes.isNotEmpty) {
      var declared = invoice.total.copyWith(amountMinor: 0);
      for (final t in invoice.taxes) {
        PaymentAmounts.compatible(invoice.total, t.taxableAmount);
        declared = PaymentAmounts.add(declared, t.amount);
      }
      if (invoice.lines.isNotEmpty && declared != tax)
        throw StateError('Invoice tax lines do not reconcile');
    }
  }

  static List<PaymentInvoice> filter(
    List<PaymentInvoice> invoices,
    PaymentInvoiceFilter filter, {
    required DateTime now,
  }) {
    PaymentGuard.record(filter.validate());
    PaymentGuard.distinct(invoices.map((i) => i.id));
    final result =
        invoices
            .where(
              (i) =>
                  i.customerId == filter.customerId &&
                  (filter.includeDrafts || i.status != 'draft') &&
                  (filter.orderIds.isEmpty ||
                      filter.orderIds.contains(i.orderId)) &&
                  (filter.statuses.isEmpty ||
                      filter.statuses.contains(i.status)) &&
                  (filter.currency == null ||
                      i.total.currency == filter.currency) &&
                  (filter.issuedFrom == null ||
                      !i.issuedAt.isBefore(filter.issuedFrom!)) &&
                  (filter.issuedUntil == null ||
                      !i.issuedAt.isAfter(filter.issuedUntil!)) &&
                  !i.issuedAt.isAfter(now),
            )
            .toList()
          ..sort((a, b) {
            final date = b.issuedAt.compareTo(a.issuedAt);
            return date != 0 ? date : a.id.compareTo(b.id);
          });
    return List.unmodifiable(result.take(filter.limit));
  }

  static PaymentInvoiceSummary summarize(
    List<PaymentInvoice> invoices, {
    required String customerId,
    required String currency,
    required DateTime now,
    bool complete = false,
  }) {
    PaymentGuard.distinct(invoices.map((i) => i.id));
    PaymentAccountGuard.currencyCode(currency);
    final matching = invoices
        .where(
          (i) =>
              i.customerId == customerId &&
              i.total.currency == currency &&
              i.status != 'void' &&
              i.status != 'draft',
        )
        .toList();
    final zero = matching.isEmpty
        ? PaymentMoney(currency: currency, amountMinor: 0)
        : matching.first.total.copyWith(amountMinor: 0);
    var total = zero, paid = zero, remaining = zero;
    for (final i in matching) {
      PaymentGuard.record(i.validate());
      total = PaymentAmounts.add(total, i.total);
      paid = PaymentAmounts.add(paid, i.paid);
      remaining = PaymentAmounts.add(remaining, i.remaining);
    }
    return PaymentInvoiceSummary(
      customerId: customerId,
      currency: currency,
      evaluatedAt: now,
      total: total,
      paid: paid,
      remaining: remaining,
      count: matching.length,
      complete: complete,
      overdueIds: matching
          .where(
            (i) =>
                i.dueAt != null &&
                i.dueAt!.isBefore(now) &&
                i.remaining.amountMinor > 0,
          )
          .map((i) => i.id)
          .toList(),
      reasonCodes: [if (!complete) 'invoiceHistoryIncomplete'],
    );
  }
}
