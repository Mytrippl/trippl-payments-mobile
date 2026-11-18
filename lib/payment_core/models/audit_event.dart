// Generated typed payment records. Edit tool/payment_models.json and regenerate.
import '../payment_codec.dart';
import '../payment_issue.dart';

class PaymentAuditEvent {
  PaymentAuditEvent({
    required this.id,
    required this.scopeFingerprint,
    required this.orderId,
    required this.operation,
    required this.occurredAt,
    required this.state,
    this.attemptId,
    List<String> reasonCodes = const [],
    this.revision = 1,
  }) : reasonCodes = List.unmodifiable(reasonCodes);

  final String id;
  final String scopeFingerprint;
  final String orderId;
  final String operation;
  final DateTime occurredAt;
  final String state;
  final String? attemptId;
  final List<String> reasonCodes;
  final int revision;

  factory PaymentAuditEvent.fromJson(Map<String, Object?> json) {
    PaymentCodec.keys(json, {
      "id",
      "scopeFingerprint",
      "orderId",
      "operation",
      "occurredAt",
      "state",
      "attemptId",
      "reasonCodes",
      "revision",
    });
    final value = PaymentAuditEvent(
      id: PaymentCodec.text(json, 'id', required: true)!,
      scopeFingerprint: PaymentCodec.text(
        json,
        'scopeFingerprint',
        required: true,
      )!,
      orderId: PaymentCodec.text(json, 'orderId', required: true)!,
      operation: PaymentCodec.text(json, 'operation', required: true)!,
      occurredAt: PaymentCodec.date(json, 'occurredAt', required: true)!,
      state: PaymentCodec.text(json, 'state', required: true)!,
      attemptId: PaymentCodec.text(json, 'attemptId'),
      reasonCodes:
          PaymentCodec.list(json, 'reasonCodes', (v) {
            if (v is! String || v.trim().isEmpty || v.length > 200)
              throw const FormatException('Invalid list text');
            return v;
          }, maximum: 100) ??
          [],
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

  static PaymentResult<PaymentAuditEvent> tryDecode(Object? input) {
    try {
      return PaymentResult(
        value: PaymentAuditEvent.fromJson(PaymentCodec.object(input)),
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

  PaymentAuditEvent copyWith({
    Set<String> clear = const {},
    String? id,
    String? scopeFingerprint,
    String? orderId,
    String? operation,
    DateTime? occurredAt,
    String? state,
    String? attemptId,
    List<String>? reasonCodes,
    int? revision,
  }) {
    final clearableFields = <String>{"attemptId"};
    if (clear.any((key) => !clearableFields.contains(key)))
      throw const FormatException('Only optional fields may be cleared');
    return PaymentAuditEvent(
      id: (id ?? this.id),
      scopeFingerprint: (scopeFingerprint ?? this.scopeFingerprint),
      orderId: (orderId ?? this.orderId),
      operation: (operation ?? this.operation),
      occurredAt: (occurredAt ?? this.occurredAt),
      state: (state ?? this.state),
      attemptId: clear.contains('attemptId')
          ? null
          : (attemptId ?? this.attemptId),
      reasonCodes: (reasonCodes ?? this.reasonCodes),
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
      if (operation.trim().isEmpty || operation.length > 4000)
        validationIssues.add(
          const PaymentIssue('operation', 'text', 'Use nonempty bounded text'),
        );
    }
    {
      if (state.trim().isEmpty || state.length > 4000)
        validationIssues.add(
          const PaymentIssue('state', 'text', 'Use nonempty bounded text'),
        );
    }
    if (attemptId != null) {
      if (attemptId!.trim().isEmpty || attemptId!.length > 4000)
        validationIssues.add(
          const PaymentIssue('attemptId', 'text', 'Use nonempty bounded text'),
        );
    }
    {
      if (reasonCodes.length > 100)
        validationIssues.add(
          const PaymentIssue(
            'reasonCodes',
            'count',
            'Payment list is empty or exceeds its limit',
          ),
        );
    }
    {
      if (reasonCodes.any((item) => item.trim().isEmpty || item.length > 200))
        validationIssues.add(
          const PaymentIssue(
            'reasonCodes',
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
    if (revision < 1)
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
    "operation": operation,
    "occurredAt": occurredAt.toUtc().toIso8601String(),
    "state": state,
    if (attemptId != null) "attemptId": attemptId,
    "reasonCodes": reasonCodes,
    "revision": revision,
  };

  @override
  bool operator ==(Object other) =>
      other is PaymentAuditEvent && PaymentCodec.same(toJson(), other.toJson());
  @override
  int get hashCode => PaymentCodec.digest(toJson()).hashCode;
  @override
  String toString() => 'PaymentAuditEvent(redacted)';
}
