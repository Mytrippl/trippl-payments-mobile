// Generated typed payment records. Edit tool/payment_models.json and regenerate.
import '../payment_codec.dart';
import '../payment_issue.dart';
import 'money.dart';
import 'receipt_line.dart';

class PaymentReceipt {
  PaymentReceipt({
    required this.id,
    required this.scopeFingerprint,
    required this.orderId,
    required this.intentId,
    required this.total,
    required this.issuedAt,
    required this.observedAt,
    required this.expiresAt,
    List<PaymentReceiptLine> lines = const [],
    this.receiptUri,
    this.serverVerified = false,
    required this.environment,
    this.revision = 1,
  }) : lines = List.unmodifiable(lines);

  final String id;
  final String scopeFingerprint;
  final String orderId;
  final String intentId;
  final PaymentMoney total;
  final DateTime issuedAt;
  final DateTime observedAt;
  final DateTime expiresAt;
  final List<PaymentReceiptLine> lines;
  final String? receiptUri;
  final bool serverVerified;
  final String environment;
  final int revision;

  factory PaymentReceipt.fromJson(Map<String, Object?> json) {
    PaymentCodec.keys(json, {
      "id",
      "scopeFingerprint",
      "orderId",
      "intentId",
      "total",
      "issuedAt",
      "observedAt",
      "expiresAt",
      "lines",
      "receiptUri",
      "serverVerified",
      "environment",
      "revision",
    });
    final value = PaymentReceipt(
      id: PaymentCodec.text(json, 'id', required: true)!,
      scopeFingerprint: PaymentCodec.text(
        json,
        'scopeFingerprint',
        required: true,
      )!,
      orderId: PaymentCodec.text(json, 'orderId', required: true)!,
      intentId: PaymentCodec.text(json, 'intentId', required: true)!,
      total: (json['total'] == null
          ? null
          : PaymentMoney.fromJson(PaymentCodec.object(json['total'])))!,
      issuedAt: PaymentCodec.date(json, 'issuedAt', required: true)!,
      observedAt: PaymentCodec.date(json, 'observedAt', required: true)!,
      expiresAt: PaymentCodec.date(json, 'expiresAt', required: true)!,
      lines:
          PaymentCodec.list(
            json,
            'lines',
            (v) => PaymentReceiptLine.fromJson(PaymentCodec.object(v)),
            maximum: 100,
          ) ??
          [],
      receiptUri: PaymentCodec.text(json, 'receiptUri'),
      serverVerified: PaymentCodec.boolean(json, 'serverVerified') ?? false,
      environment: PaymentCodec.text(json, 'environment', required: true)!,
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

  static PaymentResult<PaymentReceipt> tryDecode(Object? input) {
    try {
      return PaymentResult(
        value: PaymentReceipt.fromJson(PaymentCodec.object(input)),
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

  PaymentReceipt copyWith({
    Set<String> clear = const {},
    String? id,
    String? scopeFingerprint,
    String? orderId,
    String? intentId,
    PaymentMoney? total,
    DateTime? issuedAt,
    DateTime? observedAt,
    DateTime? expiresAt,
    List<PaymentReceiptLine>? lines,
    String? receiptUri,
    bool? serverVerified,
    String? environment,
    int? revision,
  }) {
    final clearableFields = <String>{"receiptUri"};
    if (clear.any((key) => !clearableFields.contains(key)))
      throw const FormatException('Only optional fields may be cleared');
    return PaymentReceipt(
      id: (id ?? this.id),
      scopeFingerprint: (scopeFingerprint ?? this.scopeFingerprint),
      orderId: (orderId ?? this.orderId),
      intentId: (intentId ?? this.intentId),
      total: (total ?? this.total),
      issuedAt: (issuedAt ?? this.issuedAt),
      observedAt: (observedAt ?? this.observedAt),
      expiresAt: (expiresAt ?? this.expiresAt),
      lines: (lines ?? this.lines),
      receiptUri: clear.contains('receiptUri')
          ? null
          : (receiptUri ?? this.receiptUri),
      serverVerified: (serverVerified ?? this.serverVerified),
      environment: (environment ?? this.environment),
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
      if (orderId.trim().isEmpty || orderId.length > 4000)
        validationIssues.add(
          const PaymentIssue('orderId', 'text', 'Use nonempty bounded text'),
        );
    }
    {
      if (intentId.trim().isEmpty || intentId.length > 4000)
        validationIssues.add(
          const PaymentIssue('intentId', 'text', 'Use nonempty bounded text'),
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
    {
      if (lines.length > 100)
        validationIssues.add(
          const PaymentIssue(
            'lines',
            'count',
            'Payment list is empty or exceeds its limit',
          ),
        );
    }
    {
      for (var i = 0; i < lines.length; i++)
        for (final issue in lines[i].validate())
          validationIssues.add(
            PaymentIssue(
              'lines[$i].${issue.field}',
              issue.code,
              issue.message,
              severity: issue.severity,
            ),
          );
    }
    if (receiptUri != null) {
      if (receiptUri!.trim().isEmpty || receiptUri!.length > 4000)
        validationIssues.add(
          const PaymentIssue('receiptUri', 'text', 'Use nonempty bounded text'),
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
        issuedAt.isAfter(observedAt) ||
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
    "id": id,
    "scopeFingerprint": scopeFingerprint,
    "orderId": orderId,
    "intentId": intentId,
    "total": total.toJson(),
    "issuedAt": issuedAt.toUtc().toIso8601String(),
    "observedAt": observedAt.toUtc().toIso8601String(),
    "expiresAt": expiresAt.toUtc().toIso8601String(),
    "lines": lines.map((item) => item.toJson()).toList(),
    if (receiptUri != null) "receiptUri": receiptUri,
    "serverVerified": serverVerified,
    "environment": environment,
    "revision": revision,
  };

  @override
  bool operator ==(Object other) =>
      other is PaymentReceipt && PaymentCodec.same(toJson(), other.toJson());
  @override
  int get hashCode => PaymentCodec.digest(toJson()).hashCode;
  @override
  String toString() => 'PaymentReceipt(redacted)';
}
