// Generated typed payment records. Edit tool/payment_models.json and regenerate.
import '../payment_codec.dart';
import '../payment_issue.dart';

class PaymentStatementExport {
  PaymentStatementExport({
    required this.id,
    required this.scopeFingerprint,
    required this.environment,
    required this.statementId,
    required this.createdAt,
    required this.expiresAt,
    required this.contentFingerprint,
    required this.rowCount,
    this.format = "csv",
    this.containsPersonalData = false,
    this.paymentProof = false,
  });

  final String id;
  final String scopeFingerprint;
  final String environment;
  final String statementId;
  final DateTime createdAt;
  final DateTime expiresAt;
  final String contentFingerprint;
  final int rowCount;
  final String format;
  final bool containsPersonalData;
  final bool paymentProof;

  factory PaymentStatementExport.fromJson(Map<String, Object?> json) {
    PaymentCodec.keys(json, {
      "id",
      "scopeFingerprint",
      "environment",
      "statementId",
      "createdAt",
      "expiresAt",
      "contentFingerprint",
      "rowCount",
      "format",
      "containsPersonalData",
      "paymentProof",
    });
    final value = PaymentStatementExport(
      id: PaymentCodec.text(json, 'id', required: true)!,
      scopeFingerprint: PaymentCodec.text(
        json,
        'scopeFingerprint',
        required: true,
      )!,
      environment: PaymentCodec.text(json, 'environment', required: true)!,
      statementId: PaymentCodec.text(json, 'statementId', required: true)!,
      createdAt: PaymentCodec.date(json, 'createdAt', required: true)!,
      expiresAt: PaymentCodec.date(json, 'expiresAt', required: true)!,
      contentFingerprint: PaymentCodec.text(
        json,
        'contentFingerprint',
        required: true,
      )!,
      rowCount: PaymentCodec.integer(
        json,
        'rowCount',
        required: true,
        minimum: 0,
        maximum: 9000000000000,
      )!,
      format: PaymentCodec.text(json, 'format') ?? "csv",
      containsPersonalData:
          PaymentCodec.boolean(json, 'containsPersonalData') ?? false,
      paymentProof: PaymentCodec.boolean(json, 'paymentProof') ?? false,
    );
    final issues = value.validate();
    if (issues.any((i) => i.severity == PaymentSeverity.error))
      throw PaymentValidationException(issues);
    return value;
  }

  static PaymentResult<PaymentStatementExport> tryDecode(Object? input) {
    try {
      return PaymentResult(
        value: PaymentStatementExport.fromJson(PaymentCodec.object(input)),
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

  PaymentStatementExport copyWith({
    Set<String> clear = const {},
    String? id,
    String? scopeFingerprint,
    String? environment,
    String? statementId,
    DateTime? createdAt,
    DateTime? expiresAt,
    String? contentFingerprint,
    int? rowCount,
    String? format,
    bool? containsPersonalData,
    bool? paymentProof,
  }) {
    final clearableFields = <String>{};
    if (clear.any((key) => !clearableFields.contains(key)))
      throw const FormatException('Only optional fields may be cleared');
    return PaymentStatementExport(
      id: (id ?? this.id),
      scopeFingerprint: (scopeFingerprint ?? this.scopeFingerprint),
      environment: (environment ?? this.environment),
      statementId: (statementId ?? this.statementId),
      createdAt: (createdAt ?? this.createdAt),
      expiresAt: (expiresAt ?? this.expiresAt),
      contentFingerprint: (contentFingerprint ?? this.contentFingerprint),
      rowCount: (rowCount ?? this.rowCount),
      format: (format ?? this.format),
      containsPersonalData: (containsPersonalData ?? this.containsPersonalData),
      paymentProof: (paymentProof ?? this.paymentProof),
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
      if (statementId.trim().isEmpty || statementId.length > 4000)
        validationIssues.add(
          const PaymentIssue(
            'statementId',
            'text',
            'Use nonempty bounded text',
          ),
        );
    }
    {
      if (contentFingerprint.trim().isEmpty || contentFingerprint.length > 4000)
        validationIssues.add(
          const PaymentIssue(
            'contentFingerprint',
            'text',
            'Use nonempty bounded text',
          ),
        );
    }
    {
      if (rowCount < 0 || rowCount > 9000000000000)
        validationIssues.add(
          const PaymentIssue(
            'rowCount',
            'range',
            'Number is outside the payment limits',
          ),
        );
    }
    {
      if (format.trim().isEmpty || format.length > 4000)
        validationIssues.add(
          const PaymentIssue('format', 'text', 'Use nonempty bounded text'),
        );
    }
    if (!{'test', 'live'}.contains(environment) ||
        !expiresAt.isAfter(createdAt) ||
        format != 'csv' ||
        rowCount > 100 ||
        paymentProof)
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
    "statementId": statementId,
    "createdAt": createdAt.toUtc().toIso8601String(),
    "expiresAt": expiresAt.toUtc().toIso8601String(),
    "contentFingerprint": contentFingerprint,
    "rowCount": rowCount,
    "format": format,
    "containsPersonalData": containsPersonalData,
    "paymentProof": paymentProof,
  };

  @override
  bool operator ==(Object other) =>
      other is PaymentStatementExport &&
      PaymentCodec.same(toJson(), other.toJson());
  @override
  int get hashCode => PaymentCodec.digest(toJson()).hashCode;
  @override
  String toString() => 'PaymentStatementExport(redacted)';
}
