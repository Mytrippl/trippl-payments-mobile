// Generated typed payment records. Edit tool/payment_models.json and regenerate.
import '../payment_codec.dart';
import '../payment_issue.dart';
import 'statement_entry.dart';

class PaymentStatement {
  PaymentStatement({
    required this.id,
    required this.scopeFingerprint,
    required this.environment,
    required this.customerId,
    required this.currency,
    required this.periodStart,
    required this.periodEnd,
    List<PaymentStatementEntry> entries = const [],
    this.complete = false,
    required this.observedAt,
    required this.expiresAt,
    this.serverVerified = false,
    this.revision = 1,
  }) : entries = List.unmodifiable(entries);

  final String id;
  final String scopeFingerprint;
  final String environment;
  final String customerId;
  final String currency;
  final DateTime periodStart;
  final DateTime periodEnd;
  final List<PaymentStatementEntry> entries;
  final bool complete;
  final DateTime observedAt;
  final DateTime expiresAt;
  final bool serverVerified;
  final int revision;

  factory PaymentStatement.fromJson(Map<String, Object?> json) {
    PaymentCodec.keys(json, {
      "id",
      "scopeFingerprint",
      "environment",
      "customerId",
      "currency",
      "periodStart",
      "periodEnd",
      "entries",
      "complete",
      "observedAt",
      "expiresAt",
      "serverVerified",
      "revision",
    });
    final value = PaymentStatement(
      id: PaymentCodec.text(json, 'id', required: true)!,
      scopeFingerprint: PaymentCodec.text(
        json,
        'scopeFingerprint',
        required: true,
      )!,
      environment: PaymentCodec.text(json, 'environment', required: true)!,
      customerId: PaymentCodec.text(json, 'customerId', required: true)!,
      currency: PaymentCodec.text(json, 'currency', required: true)!,
      periodStart: PaymentCodec.date(json, 'periodStart', required: true)!,
      periodEnd: PaymentCodec.date(json, 'periodEnd', required: true)!,
      entries:
          PaymentCodec.list(
            json,
            'entries',
            (v) => PaymentStatementEntry.fromJson(PaymentCodec.object(v)),
            maximum: 100,
          ) ??
          [],
      complete: PaymentCodec.boolean(json, 'complete') ?? false,
      observedAt: PaymentCodec.date(json, 'observedAt', required: true)!,
      expiresAt: PaymentCodec.date(json, 'expiresAt', required: true)!,
      serverVerified: PaymentCodec.boolean(json, 'serverVerified') ?? false,
      revision:
          PaymentCodec.integer(
            json,
            'revision',
            minimum: 0,
            maximum: 9000000000000,
          ) ??
          1,
    );
    final issues = value.validate();
    if (issues.any((i) => i.severity == PaymentSeverity.error))
      throw PaymentValidationException(issues);
    return value;
  }

  static PaymentResult<PaymentStatement> tryDecode(Object? input) {
    try {
      return PaymentResult(
        value: PaymentStatement.fromJson(PaymentCodec.object(input)),
      );
    } on PaymentValidationException catch (e) {
      return PaymentResult(issues: e.issues);
    } on FormatException {
      return PaymentResult(
        issues: const [
          PaymentIssue(
            'record',
            'format',
            'Payment record has invalid fields or values',
          ),
        ],
      );
    }
  }

  PaymentStatement copyWith({
    Set<String> clear = const {},
    String? id,
    String? scopeFingerprint,
    String? environment,
    String? customerId,
    String? currency,
    DateTime? periodStart,
    DateTime? periodEnd,
    List<PaymentStatementEntry>? entries,
    bool? complete,
    DateTime? observedAt,
    DateTime? expiresAt,
    bool? serverVerified,
    int? revision,
  }) {
    final clearableFields = <String>{};
    if (clear.any((key) => !clearableFields.contains(key)))
      throw const FormatException('Only optional fields may be cleared');
    return PaymentStatement(
      id: (id ?? this.id),
      scopeFingerprint: (scopeFingerprint ?? this.scopeFingerprint),
      environment: (environment ?? this.environment),
      customerId: (customerId ?? this.customerId),
      currency: (currency ?? this.currency),
      periodStart: (periodStart ?? this.periodStart),
      periodEnd: (periodEnd ?? this.periodEnd),
      entries: (entries ?? this.entries),
      complete: (complete ?? this.complete),
      observedAt: (observedAt ?? this.observedAt),
      expiresAt: (expiresAt ?? this.expiresAt),
      serverVerified: (serverVerified ?? this.serverVerified),
      revision: (revision ?? this.revision),
    );
  }

  List<PaymentIssue> validate() {
    final validationIssues = <PaymentIssue>[];
    {
      if (id.trim().isEmpty || id.length > 4000)
        validationIssues.add(
          const PaymentIssue('id', 'text', 'Use nonempty bounded text'),
        );
    }
    {
      if (scopeFingerprint.trim().isEmpty || scopeFingerprint.length > 4000)
        validationIssues.add(
          const PaymentIssue(
            'scopeFingerprint',
            'text',
            'Use nonempty bounded text',
          ),
        );
    }
    {
      if (environment.trim().isEmpty || environment.length > 4000)
        validationIssues.add(
          const PaymentIssue(
            'environment',
            'text',
            'Use nonempty bounded text',
          ),
        );
    }
    {
      if (customerId.trim().isEmpty || customerId.length > 4000)
        validationIssues.add(
          const PaymentIssue('customerId', 'text', 'Use nonempty bounded text'),
        );
    }
    {
      if (currency.trim().isEmpty || currency.length > 4000)
        validationIssues.add(
          const PaymentIssue('currency', 'text', 'Use nonempty bounded text'),
        );
    }
    {
      if (entries.length > 100)
        validationIssues.add(
          const PaymentIssue(
            'entries',
            'count',
            'Payment list is empty or exceeds its limit',
          ),
        );
    }
    {
      for (var i = 0; i < entries.length; i++)
        for (final issue in entries[i].validate())
          validationIssues.add(
            PaymentIssue(
              'entries[$i].${issue.field}',
              issue.code,
              issue.message,
              severity: issue.severity,
            ),
          );
    }
    {
      if (revision < 0 || revision > 9000000000000)
        validationIssues.add(
          const PaymentIssue(
            'revision',
            'range',
            'Number is outside the payment limits',
          ),
        );
    }
    if (revision < 1 ||
        !expiresAt.isAfter(observedAt) ||
        !{'test', 'live'}.contains(environment) ||
        periodEnd.isBefore(periodStart))
      validationIssues.add(
        const PaymentIssue(
          'record',
          'contract',
          'Record violates its domain constraints',
        ),
      );
    return List.unmodifiable(validationIssues);
  }

  Map<String, Object?> toJson() => {
    "id": id,
    "scopeFingerprint": scopeFingerprint,
    "environment": environment,
    "customerId": customerId,
    "currency": currency,
    "periodStart": periodStart.toUtc().toIso8601String(),
    "periodEnd": periodEnd.toUtc().toIso8601String(),
    "entries": entries.map((item) => item.toJson()).toList(),
    "complete": complete,
    "observedAt": observedAt.toUtc().toIso8601String(),
    "expiresAt": expiresAt.toUtc().toIso8601String(),
    "serverVerified": serverVerified,
    "revision": revision,
  };

  @override
  bool operator ==(Object other) =>
      other is PaymentStatement && PaymentCodec.same(toJson(), other.toJson());
  @override
  int get hashCode => PaymentCodec.digest(toJson()).hashCode;
  @override
  String toString() => 'PaymentStatement(redacted)';
}
