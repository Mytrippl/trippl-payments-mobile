// Generated typed payment records. Edit tool/payment_models.json and regenerate.
import '../payment_codec.dart';
import '../payment_issue.dart';

class PaymentDisputeEvent {
  PaymentDisputeEvent({
    required this.id,
    required this.disputeId,
    required this.occurredAt,
    required this.status,
    required this.sequence,
    required this.label,
    this.reasonCode,
    this.serverVerified = false,
  });

  final String id;
  final String disputeId;
  final DateTime occurredAt;
  final String status;
  final int sequence;
  final String label;
  final String? reasonCode;
  final bool serverVerified;

  factory PaymentDisputeEvent.fromJson(Map<String, Object?> json) {
    PaymentCodec.keys(json, {
      "id",
      "disputeId",
      "occurredAt",
      "status",
      "sequence",
      "label",
      "reasonCode",
      "serverVerified",
    });
    final value = PaymentDisputeEvent(
      id: PaymentCodec.text(json, 'id', required: true)!,
      disputeId: PaymentCodec.text(json, 'disputeId', required: true)!,
      occurredAt: PaymentCodec.date(json, 'occurredAt', required: true)!,
      status: PaymentCodec.text(json, 'status', required: true)!,
      sequence: PaymentCodec.integer(
        json,
        'sequence',
        required: true,
        minimum: 0,
        maximum: 9000000000000,
      )!,
      label: PaymentCodec.text(json, 'label', required: true)!,
      reasonCode: PaymentCodec.text(json, 'reasonCode'),
      serverVerified: PaymentCodec.boolean(json, 'serverVerified') ?? false,
    );
    final issues = value.validate();
    if (issues.any((i) => i.severity == PaymentSeverity.error))
      throw PaymentValidationException(issues);
    return value;
  }

  static PaymentResult<PaymentDisputeEvent> tryDecode(Object? input) {
    try {
      return PaymentResult(
        value: PaymentDisputeEvent.fromJson(PaymentCodec.object(input)),
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

  PaymentDisputeEvent copyWith({
    Set<String> clear = const {},
    String? id,
    String? disputeId,
    DateTime? occurredAt,
    String? status,
    int? sequence,
    String? label,
    String? reasonCode,
    bool? serverVerified,
  }) {
    final clearableFields = <String>{"reasonCode"};
    if (clear.any((key) => !clearableFields.contains(key)))
      throw const FormatException('Only optional fields may be cleared');
    return PaymentDisputeEvent(
      id: (id ?? this.id),
      disputeId: (disputeId ?? this.disputeId),
      occurredAt: (occurredAt ?? this.occurredAt),
      status: (status ?? this.status),
      sequence: (sequence ?? this.sequence),
      label: (label ?? this.label),
      reasonCode: clear.contains('reasonCode')
          ? null
          : (reasonCode ?? this.reasonCode),
      serverVerified: (serverVerified ?? this.serverVerified),
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
      if (disputeId.trim().isEmpty || disputeId.length > 4000)
        validationIssues.add(
          const PaymentIssue('disputeId', 'text', 'Use nonempty bounded text'),
        );
    }
    {
      if (status.trim().isEmpty || status.length > 4000)
        validationIssues.add(
          const PaymentIssue('status', 'text', 'Use nonempty bounded text'),
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
    if (sequence < 1)
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
    "disputeId": disputeId,
    "occurredAt": occurredAt.toUtc().toIso8601String(),
    "status": status,
    "sequence": sequence,
    "label": label,
    if (reasonCode != null) "reasonCode": reasonCode,
    "serverVerified": serverVerified,
  };

  @override
  bool operator ==(Object other) =>
      other is PaymentDisputeEvent &&
      PaymentCodec.same(toJson(), other.toJson());
  @override
  int get hashCode => PaymentCodec.digest(toJson()).hashCode;
  @override
  String toString() => 'PaymentDisputeEvent(redacted)';
}
