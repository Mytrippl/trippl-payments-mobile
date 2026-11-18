// Generated typed payment records. Edit tool/payment_models.json and regenerate.
import '../payment_codec.dart';
import '../payment_issue.dart';

class PaymentNotificationPreference {
  PaymentNotificationPreference({
    required this.scopeFingerprint,
    required this.updatedAt,
    this.paymentUpdates = true,
    this.refundUpdates = true,
    this.invoiceUpdates = false,
    this.planReminders = false,
    this.disputeUpdates = true,
    this.quietStartHour = 22,
    this.quietEndHour = 8,
    this.revision = 1,
  });

  final String scopeFingerprint;
  final DateTime updatedAt;
  final bool paymentUpdates;
  final bool refundUpdates;
  final bool invoiceUpdates;
  final bool planReminders;
  final bool disputeUpdates;
  final int quietStartHour;
  final int quietEndHour;
  final int revision;

  factory PaymentNotificationPreference.fromJson(Map<String, Object?> json) {
    PaymentCodec.keys(json, {
      "scopeFingerprint",
      "updatedAt",
      "paymentUpdates",
      "refundUpdates",
      "invoiceUpdates",
      "planReminders",
      "disputeUpdates",
      "quietStartHour",
      "quietEndHour",
      "revision",
    });
    final value = PaymentNotificationPreference(
      scopeFingerprint: PaymentCodec.text(
        json,
        'scopeFingerprint',
        required: true,
      )!,
      updatedAt: PaymentCodec.date(json, 'updatedAt', required: true)!,
      paymentUpdates: PaymentCodec.boolean(json, 'paymentUpdates') ?? true,
      refundUpdates: PaymentCodec.boolean(json, 'refundUpdates') ?? true,
      invoiceUpdates: PaymentCodec.boolean(json, 'invoiceUpdates') ?? false,
      planReminders: PaymentCodec.boolean(json, 'planReminders') ?? false,
      disputeUpdates: PaymentCodec.boolean(json, 'disputeUpdates') ?? true,
      quietStartHour:
          PaymentCodec.integer(
            json,
            'quietStartHour',
            minimum: 0,
            maximum: 9000000000000,
          ) ??
          22,
      quietEndHour:
          PaymentCodec.integer(
            json,
            'quietEndHour',
            minimum: 0,
            maximum: 9000000000000,
          ) ??
          8,
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

  static PaymentResult<PaymentNotificationPreference> tryDecode(Object? input) {
    try {
      return PaymentResult(
        value: PaymentNotificationPreference.fromJson(
          PaymentCodec.object(input),
        ),
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

  PaymentNotificationPreference copyWith({
    Set<String> clear = const {},
    String? scopeFingerprint,
    DateTime? updatedAt,
    bool? paymentUpdates,
    bool? refundUpdates,
    bool? invoiceUpdates,
    bool? planReminders,
    bool? disputeUpdates,
    int? quietStartHour,
    int? quietEndHour,
    int? revision,
  }) {
    final clearableFields = <String>{};
    if (clear.any((key) => !clearableFields.contains(key)))
      throw const FormatException('Only optional fields may be cleared');
    return PaymentNotificationPreference(
      scopeFingerprint: (scopeFingerprint ?? this.scopeFingerprint),
      updatedAt: (updatedAt ?? this.updatedAt),
      paymentUpdates: (paymentUpdates ?? this.paymentUpdates),
      refundUpdates: (refundUpdates ?? this.refundUpdates),
      invoiceUpdates: (invoiceUpdates ?? this.invoiceUpdates),
      planReminders: (planReminders ?? this.planReminders),
      disputeUpdates: (disputeUpdates ?? this.disputeUpdates),
      quietStartHour: (quietStartHour ?? this.quietStartHour),
      quietEndHour: (quietEndHour ?? this.quietEndHour),
      revision: (revision ?? this.revision),
    );
  }

  List<PaymentIssue> validate() {
    final validationIssues = <PaymentIssue>[];
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
      if (quietStartHour < 0 || quietStartHour > 9000000000000)
        validationIssues.add(
          const PaymentIssue(
            'quietStartHour',
            'range',
            'Number is outside the payment limits',
          ),
        );
    }
    {
      if (quietEndHour < 0 || quietEndHour > 9000000000000)
        validationIssues.add(
          const PaymentIssue(
            'quietEndHour',
            'range',
            'Number is outside the payment limits',
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
    if (revision < 1 || quietStartHour > 23 || quietEndHour > 23)
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
    "scopeFingerprint": scopeFingerprint,
    "updatedAt": updatedAt.toUtc().toIso8601String(),
    "paymentUpdates": paymentUpdates,
    "refundUpdates": refundUpdates,
    "invoiceUpdates": invoiceUpdates,
    "planReminders": planReminders,
    "disputeUpdates": disputeUpdates,
    "quietStartHour": quietStartHour,
    "quietEndHour": quietEndHour,
    "revision": revision,
  };

  @override
  bool operator ==(Object other) =>
      other is PaymentNotificationPreference &&
      PaymentCodec.same(toJson(), other.toJson());
  @override
  int get hashCode => PaymentCodec.digest(toJson()).hashCode;
  @override
  String toString() => 'PaymentNotificationPreference(redacted)';
}
