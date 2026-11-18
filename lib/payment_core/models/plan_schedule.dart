// Generated typed payment records. Edit tool/payment_models.json and regenerate.
import '../payment_codec.dart';
import '../payment_issue.dart';

class PaymentPlanSchedule {
  PaymentPlanSchedule({
    required this.planId,
    required this.orderId,
    required this.generatedAt,
    required this.expiresAt,
    List<String> dueNowIds = const [],
    List<String> upcomingIds = const [],
    List<String> overdueIds = const [],
    this.timezone = "UTC",
    this.mayChargeAutomatically = false,
  }) : dueNowIds = List.unmodifiable(dueNowIds),
       upcomingIds = List.unmodifiable(upcomingIds),
       overdueIds = List.unmodifiable(overdueIds);

  final String planId;
  final String orderId;
  final DateTime generatedAt;
  final DateTime expiresAt;
  final List<String> dueNowIds;
  final List<String> upcomingIds;
  final List<String> overdueIds;
  final String timezone;
  final bool mayChargeAutomatically;

  factory PaymentPlanSchedule.fromJson(Map<String, Object?> json) {
    PaymentCodec.keys(json, {
      "planId",
      "orderId",
      "generatedAt",
      "expiresAt",
      "dueNowIds",
      "upcomingIds",
      "overdueIds",
      "timezone",
      "mayChargeAutomatically",
    });
    final value = PaymentPlanSchedule(
      planId: PaymentCodec.text(json, 'planId', required: true)!,
      orderId: PaymentCodec.text(json, 'orderId', required: true)!,
      generatedAt: PaymentCodec.date(json, 'generatedAt', required: true)!,
      expiresAt: PaymentCodec.date(json, 'expiresAt', required: true)!,
      dueNowIds:
          PaymentCodec.list(json, 'dueNowIds', (v) {
            if (v is! String || v.trim().isEmpty || v.length > 200)
              throw const FormatException('Invalid list text');
            return v;
          }, maximum: 100) ??
          [],
      upcomingIds:
          PaymentCodec.list(json, 'upcomingIds', (v) {
            if (v is! String || v.trim().isEmpty || v.length > 200)
              throw const FormatException('Invalid list text');
            return v;
          }, maximum: 100) ??
          [],
      overdueIds:
          PaymentCodec.list(json, 'overdueIds', (v) {
            if (v is! String || v.trim().isEmpty || v.length > 200)
              throw const FormatException('Invalid list text');
            return v;
          }, maximum: 100) ??
          [],
      timezone: PaymentCodec.text(json, 'timezone') ?? "UTC",
      mayChargeAutomatically:
          PaymentCodec.boolean(json, 'mayChargeAutomatically') ?? false,
    );
    final issues = value.validate();
    if (issues.any((i) => i.severity == PaymentSeverity.error))
      throw PaymentValidationException(issues);
    return value;
  }

  static PaymentResult<PaymentPlanSchedule> tryDecode(Object? input) {
    try {
      return PaymentResult(
        value: PaymentPlanSchedule.fromJson(PaymentCodec.object(input)),
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

  PaymentPlanSchedule copyWith({
    Set<String> clear = const {},
    String? planId,
    String? orderId,
    DateTime? generatedAt,
    DateTime? expiresAt,
    List<String>? dueNowIds,
    List<String>? upcomingIds,
    List<String>? overdueIds,
    String? timezone,
    bool? mayChargeAutomatically,
  }) {
    final clearableFields = <String>{};
    if (clear.any((key) => !clearableFields.contains(key)))
      throw const FormatException('Only optional fields may be cleared');
    return PaymentPlanSchedule(
      planId: (planId ?? this.planId),
      orderId: (orderId ?? this.orderId),
      generatedAt: (generatedAt ?? this.generatedAt),
      expiresAt: (expiresAt ?? this.expiresAt),
      dueNowIds: (dueNowIds ?? this.dueNowIds),
      upcomingIds: (upcomingIds ?? this.upcomingIds),
      overdueIds: (overdueIds ?? this.overdueIds),
      timezone: (timezone ?? this.timezone),
      mayChargeAutomatically:
          (mayChargeAutomatically ?? this.mayChargeAutomatically),
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
      if (dueNowIds.length > 100)
        validationIssues.add(
          const PaymentIssue(
            'dueNowIds',
            'count',
            'Payment list is empty or exceeds its limit',
          ),
        );
    }
    {
      if (dueNowIds.any((item) => item.trim().isEmpty || item.length > 200))
        validationIssues.add(
          const PaymentIssue(
            'dueNowIds',
            'text',
            'Use bounded nonempty list text',
          ),
        );
    }
    {
      if (upcomingIds.length > 100)
        validationIssues.add(
          const PaymentIssue(
            'upcomingIds',
            'count',
            'Payment list is empty or exceeds its limit',
          ),
        );
    }
    {
      if (upcomingIds.any((item) => item.trim().isEmpty || item.length > 200))
        validationIssues.add(
          const PaymentIssue(
            'upcomingIds',
            'text',
            'Use bounded nonempty list text',
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
      if (timezone.trim().isEmpty || timezone.length > 4000)
        validationIssues.add(
          const PaymentIssue('timezone', 'text', 'Use nonempty bounded text'),
        );
    }
    if (!expiresAt.isAfter(generatedAt) ||
        timezone != 'UTC' ||
        mayChargeAutomatically)
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
    "planId": planId,
    "orderId": orderId,
    "generatedAt": generatedAt.toUtc().toIso8601String(),
    "expiresAt": expiresAt.toUtc().toIso8601String(),
    "dueNowIds": dueNowIds,
    "upcomingIds": upcomingIds,
    "overdueIds": overdueIds,
    "timezone": timezone,
    "mayChargeAutomatically": mayChargeAutomatically,
  };

  @override
  bool operator ==(Object other) =>
      other is PaymentPlanSchedule &&
      PaymentCodec.same(toJson(), other.toJson());
  @override
  int get hashCode => PaymentCodec.digest(toJson()).hashCode;
  @override
  String toString() => 'PaymentPlanSchedule(redacted)';
}
