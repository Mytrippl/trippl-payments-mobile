// Generated typed payment records. Edit tool/payment_models.json and regenerate.
import '../payment_codec.dart';
import '../payment_issue.dart';
import 'adjustment.dart';
import 'money.dart';
import 'order_line.dart';

class PaymentOrder {
  PaymentOrder({
    required this.id,
    required this.scopeFingerprint,
    required this.serviceType,
    required this.total,
    required this.createdAt,
    required this.updatedAt,
    List<PaymentOrderLine> lines = const [],
    List<PaymentAdjustment> adjustments = const [],
    required this.revision,
    this.status = "draft",
    this.bookingReference,
    this.customerReference,
  }) : lines = List.unmodifiable(lines),
       adjustments = List.unmodifiable(adjustments);

  final String id;
  final String scopeFingerprint;
  final String serviceType;
  final PaymentMoney total;
  final DateTime createdAt;
  final DateTime updatedAt;
  final List<PaymentOrderLine> lines;
  final List<PaymentAdjustment> adjustments;
  final int revision;
  final String status;
  final String? bookingReference;
  final String? customerReference;

  factory PaymentOrder.fromJson(Map<String, Object?> json) {
    PaymentCodec.keys(json, {
      "id",
      "scopeFingerprint",
      "serviceType",
      "total",
      "createdAt",
      "updatedAt",
      "lines",
      "adjustments",
      "revision",
      "status",
      "bookingReference",
      "customerReference",
    });
    final value = PaymentOrder(
      id: PaymentCodec.text(json, 'id', required: true)!,
      scopeFingerprint: PaymentCodec.text(
        json,
        'scopeFingerprint',
        required: true,
      )!,
      serviceType: PaymentCodec.text(json, 'serviceType', required: true)!,
      total: (json['total'] == null
          ? null
          : PaymentMoney.fromJson(PaymentCodec.object(json['total'])))!,
      createdAt: PaymentCodec.date(json, 'createdAt', required: true)!,
      updatedAt: PaymentCodec.date(json, 'updatedAt', required: true)!,
      lines:
          PaymentCodec.list(
            json,
            'lines',
            (v) => PaymentOrderLine.fromJson(PaymentCodec.object(v)),
            maximum: 100,
          ) ??
          [],
      adjustments:
          PaymentCodec.list(
            json,
            'adjustments',
            (v) => PaymentAdjustment.fromJson(PaymentCodec.object(v)),
            maximum: 100,
          ) ??
          [],
      revision: PaymentCodec.integer(
        json,
        'revision',
        required: true,
        minimum: 0,
        maximum: 9000000000000,
      )!,
      status: PaymentCodec.text(json, 'status') ?? "draft",
      bookingReference: PaymentCodec.text(json, 'bookingReference'),
      customerReference: PaymentCodec.text(json, 'customerReference'),
    );
    final issues = value.validate();
    if (issues.any((i) => i.severity == PaymentSeverity.error))
      throw PaymentValidationException(issues);
    return value;
  }

  static PaymentResult<PaymentOrder> tryDecode(Object? input) {
    try {
      return PaymentResult(
        value: PaymentOrder.fromJson(PaymentCodec.object(input)),
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

  PaymentOrder copyWith({
    Set<String> clear = const {},
    String? id,
    String? scopeFingerprint,
    String? serviceType,
    PaymentMoney? total,
    DateTime? createdAt,
    DateTime? updatedAt,
    List<PaymentOrderLine>? lines,
    List<PaymentAdjustment>? adjustments,
    int? revision,
    String? status,
    String? bookingReference,
    String? customerReference,
  }) {
    final clearableFields = <String>{"bookingReference", "customerReference"};
    if (clear.any((key) => !clearableFields.contains(key)))
      throw const FormatException('Only optional fields may be cleared');
    return PaymentOrder(
      id: (id ?? this.id),
      scopeFingerprint: (scopeFingerprint ?? this.scopeFingerprint),
      serviceType: (serviceType ?? this.serviceType),
      total: (total ?? this.total),
      createdAt: (createdAt ?? this.createdAt),
      updatedAt: (updatedAt ?? this.updatedAt),
      lines: (lines ?? this.lines),
      adjustments: (adjustments ?? this.adjustments),
      revision: (revision ?? this.revision),
      status: (status ?? this.status),
      bookingReference: clear.contains('bookingReference')
          ? null
          : (bookingReference ?? this.bookingReference),
      customerReference: clear.contains('customerReference')
          ? null
          : (customerReference ?? this.customerReference),
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
      if (serviceType.trim().isEmpty || serviceType.length > 4000)
        validationIssues.add(
          const PaymentIssue(
            'serviceType',
            'text',
            'Use nonempty bounded text',
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
      if (adjustments.length > 100)
        validationIssues.add(
          const PaymentIssue(
            'adjustments',
            'count',
            'Payment list is empty or exceeds its limit',
          ),
        );
    }
    {
      for (var i = 0; i < adjustments.length; i++)
        for (final issue in adjustments[i].validate())
          validationIssues.add(
            PaymentIssue(
              'adjustments[$i].${issue.field}',
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
    {
      if (status.trim().isEmpty || status.length > 4000)
        validationIssues.add(
          const PaymentIssue('status', 'text', 'Use nonempty bounded text'),
        );
    }
    if (bookingReference != null) {
      if (bookingReference!.trim().isEmpty || bookingReference!.length > 4000)
        validationIssues.add(
          const PaymentIssue(
            'bookingReference',
            'text',
            'Use nonempty bounded text',
          ),
        );
    }
    if (customerReference != null) {
      if (customerReference!.trim().isEmpty || customerReference!.length > 4000)
        validationIssues.add(
          const PaymentIssue(
            'customerReference',
            'text',
            'Use nonempty bounded text',
          ),
        );
    }
    if (revision < 1 ||
        updatedAt.isBefore(createdAt) ||
        !{
          'draft',
          'quoted',
          'paymentPending',
          'paid',
          'cancelled',
          'unknown',
        }.contains(status) ||
        lines.map((l) => l.id).toSet().length != lines.length ||
        adjustments.map((a) => a.id).toSet().length != adjustments.length)
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
    "serviceType": serviceType,
    "total": total.toJson(),
    "createdAt": createdAt.toUtc().toIso8601String(),
    "updatedAt": updatedAt.toUtc().toIso8601String(),
    "lines": lines.map((item) => item.toJson()).toList(),
    "adjustments": adjustments.map((item) => item.toJson()).toList(),
    "revision": revision,
    "status": status,
    if (bookingReference != null) "bookingReference": bookingReference,
    if (customerReference != null) "customerReference": customerReference,
  };

  @override
  bool operator ==(Object other) =>
      other is PaymentOrder && PaymentCodec.same(toJson(), other.toJson());
  @override
  int get hashCode => PaymentCodec.digest(toJson()).hashCode;
  @override
  String toString() => 'PaymentOrder(redacted)';
}
