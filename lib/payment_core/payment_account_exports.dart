import '../trippl_payments_mobile.dart';

class PaymentAccountExports {
  static String cell(Object? value) {
    var text = (value ?? '').toString();
    if (text.length > 4000) throw StateError('Export cell exceeds capacity');
    // Spreadsheet formula prefixes remain inert when the CSV is opened.
    if (RegExp(r'^\s*[=+@\-\t\r]').hasMatch(text)) text = "'$text";
    return '"${text.replaceAll('"', '""')}"';
  }

  static String csv(PaymentStatement statement) {
    PaymentGuard.record(statement.validate());
    PaymentGuard.distinct(statement.entries.map((e) => e.id));
    final rows = <List<Object?>>[
      [
        'reference',
        'order',
        'date',
        'kind',
        'status',
        'currency',
        'amountMinor',
        'decimals',
      ],
    ];
    for (final entry in PaymentStatements.ordered(statement))
      rows.add([
        entry.id,
        entry.orderId,
        entry.occurredAt.toUtc().toIso8601String(),
        entry.kind,
        entry.status,
        entry.amount.currency,
        entry.amount.amountMinor,
        entry.amount.decimals,
      ]);
    return rows.map((r) => r.map(cell).join(',')).join('\r\n') + '\r\n';
  }

  static PaymentStatementExport manifest(
    PaymentStatement statement, {
    required String scope,
    required String environment,
    required DateTime now,
  }) {
    PaymentGuard.record(statement.validate());
    PaymentAccountGuard.context(
      statement.scopeFingerprint,
      statement.environment,
      scope: scope,
      environment: environment,
    );
    PaymentAccountGuard.current(
      statement.observedAt,
      statement.expiresAt,
      statement.serverVerified,
      now,
    );
    final text = csv(statement);
    return PaymentStatementExport(
      id: 'export-${statement.id}',
      scopeFingerprint: statement.scopeFingerprint,
      environment: environment,
      statementId: statement.id,
      createdAt: now,
      expiresAt: statement.expiresAt,
      contentFingerprint: PaymentCodec.digest(text),
      rowCount: statement.entries.length,
      containsPersonalData: true,
    );
  }

  static Uri invoiceDocument(
    PaymentInvoiceDocument document,
    PaymentInvoice invoice,
    PaymentReceiptPolicy policy, {
    required String scope,
    required String environment,
    required String customerId,
    required DateTime now,
  }) {
    PaymentGuard.record(document.validate());
    PaymentGuard.record(policy.validate());
    PaymentInvoices.validate(
      invoice,
      scope: scope,
      environment: environment,
      customerId: customerId,
      now: now,
    );
    PaymentAccountGuard.context(
      document.scopeFingerprint,
      document.environment,
      scope: scope,
      environment: environment,
    );
    PaymentAccountGuard.current(
      document.observedAt,
      document.expiresAt,
      document.serverVerified,
      now,
    );
    if (document.invoiceId != invoice.id ||
        document.issuedAt.isAfter(document.observedAt) ||
        now.difference(document.observedAt).inSeconds >
            policy.maximumAgeSeconds)
      throw StateError('Invoice document binding mismatch');
    final uri = PaymentGuard.https(document.uri);
    if (!policy.allowedHosts.contains(uri.host) ||
        !policy.allowQuery && uri.hasQuery ||
        uri.pathSegments.any((s) => s == '.' || s == '..' || s.contains('/')) ||
        policy.allowedPathPrefixes.isNotEmpty &&
            !policy.allowedPathPrefixes.any(
              (p) =>
                  uri.path == p ||
                  uri.path.startsWith(p.endsWith('/') ? p : '$p/'),
            ))
      throw StateError('Invoice document destination not permitted');
    return uri;
  }
}
