// Generated typed payment records. Edit tool/payment_models.json and regenerate.
import '../payment_codec.dart';
import '../payment_issue.dart';
import 'invoice_line.dart';
import 'invoice_tax.dart';
import 'money.dart';

class PaymentInvoice {
  PaymentInvoice({
    required this.id,
    required this.scopeFingerprint,
    required this.environment,
    required this.customerId,
    required this.orderId,
    required this.number,
    required this.status,
    required this.total,
    required this.paid,
    required this.remaining,
    required this.issuedAt,
    this.dueAt,
    List<PaymentInvoiceLine> lines = const [],
    List<PaymentInvoiceTax> taxes = const [],
    List<String> intentIds = const [],
    required this.observedAt,
    required this.expiresAt,
    this.serverVerified = false,
    this.revision = 1,
  }) : lines = List.unmodifiable(lines),
       taxes = List.unmodifiable(taxes),
       intentIds = List.unmodifiable(intentIds);

  final String id;
  final String scopeFingerprint;
  final String environment;
  final String customerId;
  final String orderId;
  final String number;
  final String status;
  final PaymentMoney total;
  final PaymentMoney paid;
  final PaymentMoney remaining;
  final DateTime issuedAt;
  final DateTime? dueAt;
  final List<PaymentInvoiceLine> lines;
  final List<PaymentInvoiceTax> taxes;
  final List<String> intentIds;
  final DateTime observedAt;
  final DateTime expiresAt;
  final bool serverVerified;
  final int revision;

  factory PaymentInvoice.fromJson(Map<String, Object?> json) {
    PaymentCodec.keys(json, {
      "id",
      "scopeFingerprint",
      "environment",
      "customerId",
      "orderId",
      "number",
      "status",
      "total",
      "paid",
      "remaining",
      "issuedAt",
      "dueAt",
      "lines",
      "taxes",
      "intentIds",
      "observedAt",
      "expiresAt",
      "serverVerified",
      "revision",
    });
    final value = PaymentInvoice(
      id: PaymentCodec.text(json, 'id', required: true)!,
      scopeFingerprint: PaymentCodec.text(
        json,
        'scopeFingerprint',
        required: true,
      )!,
      environment: PaymentCodec.text(json, 'environment', required: true)!,
      customerId: PaymentCodec.text(json, 'customerId', required: true)!,
      orderId: PaymentCodec.text(json, 'orderId', required: true)!,
      number: PaymentCodec.text(json, 'number', required: true)!,
      status: PaymentCodec.text(json, 'status', required: true)!,
      total: (json['total'] == null
          ? null
          : PaymentMoney.fromJson(PaymentCodec.object(json['total'])))!,
      paid: (json['paid'] == null
          ? null
          : PaymentMoney.fromJson(PaymentCodec.object(json['paid'])))!,
      remaining: (json['remaining'] == null
          ? null
          : PaymentMoney.fromJson(PaymentCodec.object(json['remaining'])))!,
      issuedAt: PaymentCodec.date(json, 'issuedAt', required: true)!,
      dueAt: PaymentCodec.date(json, 'dueAt'),
      lines:
          PaymentCodec.list(
            json,
            'lines',
            (v) => PaymentInvoiceLine.fromJson(PaymentCodec.object(v)),
            maximum: 100,
          ) ??
          [],
      taxes:
          PaymentCodec.list(
            json,
            'taxes',
            (v) => PaymentInvoiceTax.fromJson(PaymentCodec.object(v)),
            maximum: 100,
          ) ??
          [],
      intentIds:
          PaymentCodec.list(json, 'intentIds', (v) {
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

  static PaymentResult<PaymentInvoice> tryDecode(Object? input) {
    try {
      return PaymentResult(
        value: PaymentInvoice.fromJson(PaymentCodec.object(input)),
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

  PaymentInvoice copyWith({
    Set<String> clear = const {},
    String? id,
    String? scopeFingerprint,
    String? environment,
    String? customerId,
    String? orderId,
    String? number,
    String? status,
    PaymentMoney? total,
    PaymentMoney? paid,
    PaymentMoney? remaining,
    DateTime? issuedAt,
    DateTime? dueAt,
    List<PaymentInvoiceLine>? lines,
    List<PaymentInvoiceTax>? taxes,
    List<String>? intentIds,
    DateTime? observedAt,
    DateTime? expiresAt,
    bool? serverVerified,
    int? revision,
  }) {
    final clearableFields = <String>{"dueAt"};
    if (clear.any((key) => !clearableFields.contains(key)))
      throw const FormatException('Only optional fields may be cleared');
    return PaymentInvoice(
      id: (id ?? this.id),
      scopeFingerprint: (scopeFingerprint ?? this.scopeFingerprint),
      environment: (environment ?? this.environment),
      customerId: (customerId ?? this.customerId),
      orderId: (orderId ?? this.orderId),
      number: (number ?? this.number),
      status: (status ?? this.status),
      total: (total ?? this.total),
      paid: (paid ?? this.paid),
      remaining: (remaining ?? this.remaining),
      issuedAt: (issuedAt ?? this.issuedAt),
      dueAt: clear.contains('dueAt') ? null : (dueAt ?? this.dueAt),
      lines: (lines ?? this.lines),
      taxes: (taxes ?? this.taxes),
      intentIds: (intentIds ?? this.intentIds),
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
      if (orderId.trim().isEmpty || orderId.length > 4000)
        validationIssues.add(
          const PaymentIssue('orderId', 'text', 'Use nonempty bounded text'),
        );
    }
    {
      if (number.trim().isEmpty || number.length > 4000)
        validationIssues.add(
          const PaymentIssue('number', 'text', 'Use nonempty bounded text'),
        );
    }
    {
      if (status.trim().isEmpty || status.length > 4000)
        validationIssues.add(
          const PaymentIssue('status', 'text', 'Use nonempty bounded text'),
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
      for (final issue in paid.validate())
        validationIssues.add(
          PaymentIssue(
            'paid.${issue.field}',
            issue.code,
            issue.message,
            severity: issue.severity,
          ),
        );
    }
    {
      for (final issue in remaining.validate())
        validationIssues.add(
          PaymentIssue(
            'remaining.${issue.field}',
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
    {
      if (taxes.length > 100)
        validationIssues.add(
          const PaymentIssue(
            'taxes',
            'count',
            'Payment list is empty or exceeds its limit',
          ),
        );
    }
    {
      for (var i = 0; i < taxes.length; i++)
        for (final issue in taxes[i].validate())
          validationIssues.add(
            PaymentIssue(
              'taxes[$i].${issue.field}',
              issue.code,
              issue.message,
              severity: issue.severity,
            ),
          );
    }
    {
      if (intentIds.length > 100)
        validationIssues.add(
          const PaymentIssue(
            'intentIds',
            'count',
            'Payment list is empty or exceeds its limit',
          ),
        );
    }
    {
      if (intentIds.any((item) => item.trim().isEmpty || item.length > 200))
        validationIssues.add(
          const PaymentIssue(
            'intentIds',
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
        !{'test', 'live'}.contains(environment) ||
        !{
          'draft',
          'open',
          'paid',
          'void',
          'uncollectible',
          'unknown',
        }.contains(status) ||
        dueAt != null && dueAt!.isBefore(issuedAt))
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
    "orderId": orderId,
    "number": number,
    "status": status,
    "total": total.toJson(),
    "paid": paid.toJson(),
    "remaining": remaining.toJson(),
    "issuedAt": issuedAt.toUtc().toIso8601String(),
    if (dueAt != null) "dueAt": dueAt!.toUtc().toIso8601String(),
    "lines": lines.map((item) => item.toJson()).toList(),
    "taxes": taxes.map((item) => item.toJson()).toList(),
    "intentIds": intentIds,
    "observedAt": observedAt.toUtc().toIso8601String(),
    "expiresAt": expiresAt.toUtc().toIso8601String(),
    "serverVerified": serverVerified,
    "revision": revision,
  };

  @override
  bool operator ==(Object other) =>
      other is PaymentInvoice && PaymentCodec.same(toJson(), other.toJson());
  @override
  int get hashCode => PaymentCodec.digest(toJson()).hashCode;
  @override
  String toString() => 'PaymentInvoice(redacted)';
}
