// Generated typed payment records. Edit tool/payment_models.json and regenerate.
import '../payment_codec.dart';
import '../payment_issue.dart';
import 'money.dart';

class PaymentTaxAssessment {
  PaymentTaxAssessment({
    required this.orderId,
    required this.scopeFingerprint,
    required this.environment,
    required this.subtotal,
    required this.tax,
    required this.total,
    this.inclusive = false,
    this.exemptionApplied = false,
    this.taxIdentityId,
    List<String> jurisdictionCodes = const [],
    required this.observedAt,
    required this.expiresAt,
    this.serverVerified = false,
    this.revision = 1,
  }) : jurisdictionCodes = List.unmodifiable(jurisdictionCodes);

  final String orderId;
  final String scopeFingerprint;
  final String environment;
  final PaymentMoney subtotal;
  final PaymentMoney tax;
  final PaymentMoney total;
  final bool inclusive;
  final bool exemptionApplied;
  final String? taxIdentityId;
  final List<String> jurisdictionCodes;
  final DateTime observedAt;
  final DateTime expiresAt;
  final bool serverVerified;
  final int revision;

  factory PaymentTaxAssessment.fromJson(Map<String, Object?> json) {
    PaymentCodec.keys(json, {
      "orderId",
      "scopeFingerprint",
      "environment",
      "subtotal",
      "tax",
      "total",
      "inclusive",
      "exemptionApplied",
      "taxIdentityId",
      "jurisdictionCodes",
      "observedAt",
      "expiresAt",
      "serverVerified",
      "revision",
    });
    final value = PaymentTaxAssessment(
      orderId: PaymentCodec.text(json, 'orderId', required: true)!,
      scopeFingerprint: PaymentCodec.text(
        json,
        'scopeFingerprint',
        required: true,
      )!,
      environment: PaymentCodec.text(json, 'environment', required: true)!,
      subtotal: (json['subtotal'] == null
          ? null
          : PaymentMoney.fromJson(PaymentCodec.object(json['subtotal'])))!,
      tax: (json['tax'] == null
          ? null
          : PaymentMoney.fromJson(PaymentCodec.object(json['tax'])))!,
      total: (json['total'] == null
          ? null
          : PaymentMoney.fromJson(PaymentCodec.object(json['total'])))!,
      inclusive: PaymentCodec.boolean(json, 'inclusive') ?? false,
      exemptionApplied: PaymentCodec.boolean(json, 'exemptionApplied') ?? false,
      taxIdentityId: PaymentCodec.text(json, 'taxIdentityId'),
      jurisdictionCodes:
          PaymentCodec.list(json, 'jurisdictionCodes', (v) {
            if (v is! String || v.trim().isEmpty || v.length > 200)
              throw const FormatException('Invalid list text');
            return v;
          }, maximum: 100) ??
          [],
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

  static PaymentResult<PaymentTaxAssessment> tryDecode(Object? input) {
    try {
      return PaymentResult(
        value: PaymentTaxAssessment.fromJson(PaymentCodec.object(input)),
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

  PaymentTaxAssessment copyWith({
    Set<String> clear = const {},
    String? orderId,
    String? scopeFingerprint,
    String? environment,
    PaymentMoney? subtotal,
    PaymentMoney? tax,
    PaymentMoney? total,
    bool? inclusive,
    bool? exemptionApplied,
    String? taxIdentityId,
    List<String>? jurisdictionCodes,
    DateTime? observedAt,
    DateTime? expiresAt,
    bool? serverVerified,
    int? revision,
  }) {
    final clearableFields = <String>{"taxIdentityId"};
    if (clear.any((key) => !clearableFields.contains(key)))
      throw const FormatException('Only optional fields may be cleared');
    return PaymentTaxAssessment(
      orderId: (orderId ?? this.orderId),
      scopeFingerprint: (scopeFingerprint ?? this.scopeFingerprint),
      environment: (environment ?? this.environment),
      subtotal: (subtotal ?? this.subtotal),
      tax: (tax ?? this.tax),
      total: (total ?? this.total),
      inclusive: (inclusive ?? this.inclusive),
      exemptionApplied: (exemptionApplied ?? this.exemptionApplied),
      taxIdentityId: clear.contains('taxIdentityId')
          ? null
          : (taxIdentityId ?? this.taxIdentityId),
      jurisdictionCodes: (jurisdictionCodes ?? this.jurisdictionCodes),
      observedAt: (observedAt ?? this.observedAt),
      expiresAt: (expiresAt ?? this.expiresAt),
      serverVerified: (serverVerified ?? this.serverVerified),
      revision: (revision ?? this.revision),
    );
  }

  List<PaymentIssue> validate() {
    final validationIssues = <PaymentIssue>[];
    {
      if (orderId.trim().isEmpty || orderId.length > 4000)
        validationIssues.add(
          const PaymentIssue('orderId', 'text', 'Use nonempty bounded text'),
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
      for (final issue in subtotal.validate())
        validationIssues.add(
          PaymentIssue(
            'subtotal.${issue.field}',
            issue.code,
            issue.message,
            severity: issue.severity,
          ),
        );
    }
    {
      for (final issue in tax.validate())
        validationIssues.add(
          PaymentIssue(
            'tax.${issue.field}',
            issue.code,
            issue.message,
            severity: issue.severity,
          ),
        );
    }
    {
      for (final issue in total.validate())
        validationIssues.add(
          PaymentIssue(
            'total.${issue.field}',
            issue.code,
            issue.message,
            severity: issue.severity,
          ),
        );
    }
    if (taxIdentityId != null) {
      if (taxIdentityId!.trim().isEmpty || taxIdentityId!.length > 4000)
        validationIssues.add(
          const PaymentIssue(
            'taxIdentityId',
            'text',
            'Use nonempty bounded text',
          ),
        );
    }
    {
      if (jurisdictionCodes.length > 100)
        validationIssues.add(
          const PaymentIssue(
            'jurisdictionCodes',
            'count',
            'Payment list is empty or exceeds its limit',
          ),
        );
    }
    {
      if (jurisdictionCodes.any(
        (item) => item.trim().isEmpty || item.length > 200,
      ))
        validationIssues.add(
          const PaymentIssue(
            'jurisdictionCodes',
            'text',
            'Use bounded nonempty list text',
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
        !{'test', 'live'}.contains(environment))
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
    "orderId": orderId,
    "scopeFingerprint": scopeFingerprint,
    "environment": environment,
    "subtotal": subtotal.toJson(),
    "tax": tax.toJson(),
    "total": total.toJson(),
    "inclusive": inclusive,
    "exemptionApplied": exemptionApplied,
    if (taxIdentityId != null) "taxIdentityId": taxIdentityId,
    "jurisdictionCodes": jurisdictionCodes,
    "observedAt": observedAt.toUtc().toIso8601String(),
    "expiresAt": expiresAt.toUtc().toIso8601String(),
    "serverVerified": serverVerified,
    "revision": revision,
  };

  @override
  bool operator ==(Object other) =>
      other is PaymentTaxAssessment &&
      PaymentCodec.same(toJson(), other.toJson());
  @override
  int get hashCode => PaymentCodec.digest(toJson()).hashCode;
  @override
  String toString() => 'PaymentTaxAssessment(redacted)';
}
