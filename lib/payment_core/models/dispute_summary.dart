// Generated typed payment records. Edit tool/payment_models.json and regenerate.
import '../payment_codec.dart';
import '../payment_issue.dart';

class PaymentDisputeSummary {
  PaymentDisputeSummary({
    required this.orderId,
    required this.evaluatedAt,
    List<String> openIds = const [],
    List<String> dueSoonIds = const [],
    List<String> closedIds = const [],
    List<String> reasonCodes = const [],
    this.complete = false,
    this.maySubmitEvidence = false,
  }) : openIds = List.unmodifiable(openIds),
       dueSoonIds = List.unmodifiable(dueSoonIds),
       closedIds = List.unmodifiable(closedIds),
       reasonCodes = List.unmodifiable(reasonCodes);

  final String orderId;
  final DateTime evaluatedAt;
  final List<String> openIds;
  final List<String> dueSoonIds;
  final List<String> closedIds;
  final List<String> reasonCodes;
  final bool complete;
  final bool maySubmitEvidence;

  factory PaymentDisputeSummary.fromJson(Map<String, Object?> json) {
    PaymentCodec.keys(json, {
      "orderId",
      "evaluatedAt",
      "openIds",
      "dueSoonIds",
      "closedIds",
      "reasonCodes",
      "complete",
      "maySubmitEvidence",
    });
    final value = PaymentDisputeSummary(
      orderId: PaymentCodec.text(json, 'orderId', required: true)!,
      evaluatedAt: PaymentCodec.date(json, 'evaluatedAt', required: true)!,
      openIds:
          PaymentCodec.list(json, 'openIds', (v) {
            if (v is! String || v.trim().isEmpty || v.length > 200)
              throw const FormatException('Invalid list text');
            return v;
          }, maximum: 100) ??
          [],
      dueSoonIds:
          PaymentCodec.list(json, 'dueSoonIds', (v) {
            if (v is! String || v.trim().isEmpty || v.length > 200)
              throw const FormatException('Invalid list text');
            return v;
          }, maximum: 100) ??
          [],
      closedIds:
          PaymentCodec.list(json, 'closedIds', (v) {
            if (v is! String || v.trim().isEmpty || v.length > 200)
              throw const FormatException('Invalid list text');
            return v;
          }, maximum: 100) ??
          [],
      reasonCodes:
          PaymentCodec.list(json, 'reasonCodes', (v) {
            if (v is! String || v.trim().isEmpty || v.length > 200)
              throw const FormatException('Invalid list text');
            return v;
          }, maximum: 100) ??
          [],
      complete: PaymentCodec.boolean(json, 'complete') ?? false,
      maySubmitEvidence:
          PaymentCodec.boolean(json, 'maySubmitEvidence') ?? false,
    );
    final issues = value.validate();
    if (issues.any((i) => i.severity == PaymentSeverity.error))
      throw PaymentValidationException(issues);
    return value;
  }

  static PaymentResult<PaymentDisputeSummary> tryDecode(Object? input) {
    try {
      return PaymentResult(
        value: PaymentDisputeSummary.fromJson(PaymentCodec.object(input)),
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

  PaymentDisputeSummary copyWith({
    Set<String> clear = const {},
    String? orderId,
    DateTime? evaluatedAt,
    List<String>? openIds,
    List<String>? dueSoonIds,
    List<String>? closedIds,
    List<String>? reasonCodes,
    bool? complete,
    bool? maySubmitEvidence,
  }) {
    final clearableFields = <String>{};
    if (clear.any((key) => !clearableFields.contains(key)))
      throw const FormatException('Only optional fields may be cleared');
    return PaymentDisputeSummary(
      orderId: (orderId ?? this.orderId),
      evaluatedAt: (evaluatedAt ?? this.evaluatedAt),
      openIds: (openIds ?? this.openIds),
      dueSoonIds: (dueSoonIds ?? this.dueSoonIds),
      closedIds: (closedIds ?? this.closedIds),
      reasonCodes: (reasonCodes ?? this.reasonCodes),
      complete: (complete ?? this.complete),
      maySubmitEvidence: (maySubmitEvidence ?? this.maySubmitEvidence),
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
      if (openIds.length > 100)
        validationIssues.add(
          const PaymentIssue(
            'openIds',
            'count',
            'Payment list is empty or exceeds its limit',
          ),
        );
    }
    {
      if (openIds.any((item) => item.trim().isEmpty || item.length > 200))
        validationIssues.add(
          const PaymentIssue(
            'openIds',
            'text',
            'Use bounded nonempty list text',
          ),
        );
    }
    {
      if (dueSoonIds.length > 100)
        validationIssues.add(
          const PaymentIssue(
            'dueSoonIds',
            'count',
            'Payment list is empty or exceeds its limit',
          ),
        );
    }
    {
      if (dueSoonIds.any((item) => item.trim().isEmpty || item.length > 200))
        validationIssues.add(
          const PaymentIssue(
            'dueSoonIds',
            'text',
            'Use bounded nonempty list text',
          ),
        );
    }
    {
      if (closedIds.length > 100)
        validationIssues.add(
          const PaymentIssue(
            'closedIds',
            'count',
            'Payment list is empty or exceeds its limit',
          ),
        );
    }
    {
      if (closedIds.any((item) => item.trim().isEmpty || item.length > 200))
        validationIssues.add(
          const PaymentIssue(
            'closedIds',
            'text',
            'Use bounded nonempty list text',
          ),
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
    if (maySubmitEvidence)
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
    "evaluatedAt": evaluatedAt.toUtc().toIso8601String(),
    "openIds": openIds,
    "dueSoonIds": dueSoonIds,
    "closedIds": closedIds,
    "reasonCodes": reasonCodes,
    "complete": complete,
    "maySubmitEvidence": maySubmitEvidence,
  };

  @override
  bool operator ==(Object other) =>
      other is PaymentDisputeSummary &&
      PaymentCodec.same(toJson(), other.toJson());
  @override
  int get hashCode => PaymentCodec.digest(toJson()).hashCode;
  @override
  String toString() => 'PaymentDisputeSummary(redacted)';
}
