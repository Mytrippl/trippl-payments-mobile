// Generated typed payment records. Edit tool/payment_models.json and regenerate.
import '../payment_codec.dart';
import '../payment_issue.dart';

class PaymentRefundTimelineEntry {
  PaymentRefundTimelineEntry({
    required this.id,
    required this.refundId,
    required this.occurredAt,
    required this.state,
    required this.label,
    this.reasonCode,
    this.source = "backend",
    this.sequence = 1,
  });

  final String id;
  final String refundId;
  final DateTime occurredAt;
  final String state;
  final String label;
  final String? reasonCode;
  final String source;
  final int sequence;

  factory PaymentRefundTimelineEntry.fromJson(Map<String, Object?> json) {
    PaymentCodec.keys(json, {
      "id",
      "refundId",
      "occurredAt",
      "state",
      "label",
      "reasonCode",
      "source",
      "sequence",
    });
    final value = PaymentRefundTimelineEntry(
      id: PaymentCodec.text(json, 'id', required: true)!,
      refundId: PaymentCodec.text(json, 'refundId', required: true)!,
      occurredAt: PaymentCodec.date(json, 'occurredAt', required: true)!,
      state: PaymentCodec.text(json, 'state', required: true)!,
      label: PaymentCodec.text(json, 'label', required: true)!,
      reasonCode: PaymentCodec.text(json, 'reasonCode'),
      source: PaymentCodec.text(json, 'source') ?? "backend",
      sequence:
          PaymentCodec.integer(
            json,
            'sequence',
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

  static PaymentResult<PaymentRefundTimelineEntry> tryDecode(Object? input) {
    try {
      return PaymentResult(
        value: PaymentRefundTimelineEntry.fromJson(PaymentCodec.object(input)),
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

  PaymentRefundTimelineEntry copyWith({
    Set<String> clear = const {},
    String? id,
    String? refundId,
    DateTime? occurredAt,
    String? state,
    String? label,
    String? reasonCode,
    String? source,
    int? sequence,
  }) {
    final clearableFields = <String>{"reasonCode"};
    if (clear.any((key) => !clearableFields.contains(key)))
      throw const FormatException('Only optional fields may be cleared');
    return PaymentRefundTimelineEntry(
      id: (id ?? this.id),
      refundId: (refundId ?? this.refundId),
      occurredAt: (occurredAt ?? this.occurredAt),
      state: (state ?? this.state),
      label: (label ?? this.label),
      reasonCode: clear.contains('reasonCode')
          ? null
          : (reasonCode ?? this.reasonCode),
      source: (source ?? this.source),
      sequence: (sequence ?? this.sequence),
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
      if (refundId.trim().isEmpty || refundId.length > 4000)
        validationIssues.add(
          const PaymentIssue('refundId', 'text', 'Use nonempty bounded text'),
        );
    }
    {
      if (state.trim().isEmpty || state.length > 4000)
        validationIssues.add(
          const PaymentIssue('state', 'text', 'Use nonempty bounded text'),
        );
    }
    {
      if (label.trim().isEmpty || label.length > 4000)
        validationIssues.add(
          const PaymentIssue('label', 'text', 'Use nonempty bounded text'),
        );
    }
    if (reasonCode != null) {
      if (reasonCode!.trim().isEmpty || reasonCode!.length > 4000)
        validationIssues.add(
          const PaymentIssue('reasonCode', 'text', 'Use nonempty bounded text'),
        );
    }
    {
      if (source.trim().isEmpty || source.length > 4000)
        validationIssues.add(
          const PaymentIssue('source', 'text', 'Use nonempty bounded text'),
        );
    }
    {
      if (sequence < 0 || sequence > 9000000000000)
        validationIssues.add(
          const PaymentIssue(
            'sequence',
            'range',
            'Number is outside the payment limits',
          ),
        );
    }
    if (sequence < 1 ||
        !{
          'requested',
          'review',
          'pending',
          'succeeded',
          'failed',
          'cancelled',
          'unknown',
        }.contains(state) ||
        source != 'backend')
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
    "refundId": refundId,
    "occurredAt": occurredAt.toUtc().toIso8601String(),
    "state": state,
    "label": label,
    if (reasonCode != null) "reasonCode": reasonCode,
    "source": source,
    "sequence": sequence,
  };

  @override
  bool operator ==(Object other) =>
      other is PaymentRefundTimelineEntry &&
      PaymentCodec.same(toJson(), other.toJson());
  @override
  int get hashCode => PaymentCodec.digest(toJson()).hashCode;
  @override
  String toString() => 'PaymentRefundTimelineEntry(redacted)';
}
