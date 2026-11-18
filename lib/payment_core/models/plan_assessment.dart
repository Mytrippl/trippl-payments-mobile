// Generated typed payment records. Edit tool/payment_models.json and regenerate.
import '../payment_codec.dart';
import '../payment_issue.dart';
import 'money.dart';

class PaymentPlanAssessment {
  PaymentPlanAssessment({
    required this.planId,
    required this.orderId,
    required this.evaluatedAt,
    required this.paid,
    required this.pending,
    required this.remaining,
    List<String> overdueIds = const [],
    this.nextInstallmentId = "none",
    this.complete = false,
    List<String> reasonCodes = const [],
  }) : overdueIds = List.unmodifiable(overdueIds),
       reasonCodes = List.unmodifiable(reasonCodes);

  final String planId;
  final String orderId;
  final DateTime evaluatedAt;
  final PaymentMoney paid;
  final PaymentMoney pending;
  final PaymentMoney remaining;
  final List<String> overdueIds;
  final String nextInstallmentId;
  final bool complete;
  final List<String> reasonCodes;

  factory PaymentPlanAssessment.fromJson(Map<String, Object?> json) {
    PaymentCodec.keys(json, {
      "planId",
      "orderId",
      "evaluatedAt",
      "paid",
      "pending",
      "remaining",
      "overdueIds",
      "nextInstallmentId",
      "complete",
      "reasonCodes",
    });
    final value = PaymentPlanAssessment(
      planId: PaymentCodec.text(json, 'planId', required: true)!,
      orderId: PaymentCodec.text(json, 'orderId', required: true)!,
      evaluatedAt: PaymentCodec.date(json, 'evaluatedAt', required: true)!,
      paid: (json['paid'] == null
          ? null
          : PaymentMoney.fromJson(PaymentCodec.object(json['paid'])))!,
      pending: (json['pending'] == null
          ? null
          : PaymentMoney.fromJson(PaymentCodec.object(json['pending'])))!,
      remaining: (json['remaining'] == null
          ? null
          : PaymentMoney.fromJson(PaymentCodec.object(json['remaining'])))!,
      overdueIds:
          PaymentCodec.list(json, 'overdueIds', (v) {
            if (v is! String || v.trim().isEmpty || v.length > 200)
              throw const FormatException('Invalid list text');
            return v;
          }, maximum: 100) ??
          [],
      nextInstallmentId: PaymentCodec.text(json, 'nextInstallmentId') ?? "none",
      complete: PaymentCodec.boolean(json, 'complete') ?? false,
      reasonCodes:
          PaymentCodec.list(json, 'reasonCodes', (v) {
            if (v is! String || v.trim().isEmpty || v.length > 200)
              throw const FormatException('Invalid list text');
            return v;
          }, maximum: 100) ??
          [],
    );
    final issues = value.validate();
    if (issues.any((i) => i.severity == PaymentSeverity.error))
      throw PaymentValidationException(issues);
    return value;
  }

  static PaymentResult<PaymentPlanAssessment> tryDecode(Object? input) {
    try {
      return PaymentResult(
        value: PaymentPlanAssessment.fromJson(PaymentCodec.object(input)),
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

  PaymentPlanAssessment copyWith({
    Set<String> clear = const {},
    String? planId,
    String? orderId,
    DateTime? evaluatedAt,
    PaymentMoney? paid,
    PaymentMoney? pending,
    PaymentMoney? remaining,
    List<String>? overdueIds,
    String? nextInstallmentId,
    bool? complete,
    List<String>? reasonCodes,
  }) {
    final clearableFields = <String>{};
    if (clear.any((key) => !clearableFields.contains(key)))
      throw const FormatException('Only optional fields may be cleared');
    return PaymentPlanAssessment(
      planId: (planId ?? this.planId),
      orderId: (orderId ?? this.orderId),
      evaluatedAt: (evaluatedAt ?? this.evaluatedAt),
      paid: (paid ?? this.paid),
      pending: (pending ?? this.pending),
      remaining: (remaining ?? this.remaining),
      overdueIds: (overdueIds ?? this.overdueIds),
      nextInstallmentId: (nextInstallmentId ?? this.nextInstallmentId),
      complete: (complete ?? this.complete),
      reasonCodes: (reasonCodes ?? this.reasonCodes),
    );
  }

  List<PaymentIssue> validate() {
    final validationIssues = <PaymentIssue>[];
    {
      if (planId.trim().isEmpty || planId.length > 4000)
        validationIssues.add(
          const PaymentIssue('planId', 'text', 'Use nonempty bounded text'),
        );
    }
    {
      if (orderId.trim().isEmpty || orderId.length > 4000)
        validationIssues.add(
          const PaymentIssue('orderId', 'text', 'Use nonempty bounded text'),
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
      for (final issue in pending.validate())
        validationIssues.add(
          PaymentIssue(
            'pending.${issue.field}',
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
      if (overdueIds.length > 100)
        validationIssues.add(
          const PaymentIssue(
            'overdueIds',
            'count',
            'Payment list is empty or exceeds its limit',
          ),
        );
    }
    {
      if (overdueIds.any((item) => item.trim().isEmpty || item.length > 200))
        validationIssues.add(
          const PaymentIssue(
            'overdueIds',
            'text',
            'Use bounded nonempty list text',
          ),
        );
    }
    {
      if (nextInstallmentId.trim().isEmpty || nextInstallmentId.length > 4000)
        validationIssues.add(
          const PaymentIssue(
            'nextInstallmentId',
            'text',
            'Use nonempty bounded text',
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
    return List.unmodifiable(validationIssues);
  }

  Map<String, Object?> toJson() => {
    "planId": planId,
    "orderId": orderId,
    "evaluatedAt": evaluatedAt.toUtc().toIso8601String(),
    "paid": paid.toJson(),
    "pending": pending.toJson(),
    "remaining": remaining.toJson(),
    "overdueIds": overdueIds,
    "nextInstallmentId": nextInstallmentId,
    "complete": complete,
    "reasonCodes": reasonCodes,
  };

  @override
  bool operator ==(Object other) =>
      other is PaymentPlanAssessment &&
      PaymentCodec.same(toJson(), other.toJson());
  @override
  int get hashCode => PaymentCodec.digest(toJson()).hashCode;
  @override
  String toString() => 'PaymentPlanAssessment(redacted)';
}
