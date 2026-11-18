// Generated typed payment records. Edit tool/payment_models.json and regenerate.
import '../payment_codec.dart';
import '../payment_issue.dart';
import 'activity_entry.dart';
import 'dispute.dart';
import 'installment_plan.dart';
import 'invoice.dart';

class PaymentAccountSnapshot {
  PaymentAccountSnapshot({
    required this.id,
    required this.scopeFingerprint,
    required this.environment,
    required this.customerId,
    List<PaymentInvoice> invoices = const [],
    List<PaymentInstallmentPlan> plans = const [],
    List<PaymentDispute> disputes = const [],
    List<PaymentActivityEntry> activity = const [],
    this.complete = false,
    required this.observedAt,
    required this.expiresAt,
    this.serverVerified = false,
    this.revision = 1,
  }) : invoices = List.unmodifiable(invoices),
       plans = List.unmodifiable(plans),
       disputes = List.unmodifiable(disputes),
       activity = List.unmodifiable(activity);

  final String id;
  final String scopeFingerprint;
  final String environment;
  final String customerId;
  final List<PaymentInvoice> invoices;
  final List<PaymentInstallmentPlan> plans;
  final List<PaymentDispute> disputes;
  final List<PaymentActivityEntry> activity;
  final bool complete;
  final DateTime observedAt;
  final DateTime expiresAt;
  final bool serverVerified;
  final int revision;

  factory PaymentAccountSnapshot.fromJson(Map<String, Object?> json) {
    PaymentCodec.keys(json, {
      "id",
      "scopeFingerprint",
      "environment",
      "customerId",
      "invoices",
      "plans",
      "disputes",
      "activity",
      "complete",
      "observedAt",
      "expiresAt",
      "serverVerified",
      "revision",
    });
    final value = PaymentAccountSnapshot(
      id: PaymentCodec.text(json, 'id', required: true)!,
      scopeFingerprint: PaymentCodec.text(
        json,
        'scopeFingerprint',
        required: true,
      )!,
      environment: PaymentCodec.text(json, 'environment', required: true)!,
      customerId: PaymentCodec.text(json, 'customerId', required: true)!,
      invoices:
          PaymentCodec.list(
            json,
            'invoices',
            (v) => PaymentInvoice.fromJson(PaymentCodec.object(v)),
            maximum: 100,
          ) ??
          [],
      plans:
          PaymentCodec.list(
            json,
            'plans',
            (v) => PaymentInstallmentPlan.fromJson(PaymentCodec.object(v)),
            maximum: 100,
          ) ??
          [],
      disputes:
          PaymentCodec.list(
            json,
            'disputes',
            (v) => PaymentDispute.fromJson(PaymentCodec.object(v)),
            maximum: 100,
          ) ??
          [],
      activity:
          PaymentCodec.list(
            json,
            'activity',
            (v) => PaymentActivityEntry.fromJson(PaymentCodec.object(v)),
            maximum: 100,
          ) ??
          [],
      complete: PaymentCodec.boolean(json, 'complete') ?? false,
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

  static PaymentResult<PaymentAccountSnapshot> tryDecode(Object? input) {
    try {
      return PaymentResult(
        value: PaymentAccountSnapshot.fromJson(PaymentCodec.object(input)),
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

  PaymentAccountSnapshot copyWith({
    Set<String> clear = const {},
    String? id,
    String? scopeFingerprint,
    String? environment,
    String? customerId,
    List<PaymentInvoice>? invoices,
    List<PaymentInstallmentPlan>? plans,
    List<PaymentDispute>? disputes,
    List<PaymentActivityEntry>? activity,
    bool? complete,
    DateTime? observedAt,
    DateTime? expiresAt,
    bool? serverVerified,
    int? revision,
  }) {
    final clearableFields = <String>{};
    if (clear.any((key) => !clearableFields.contains(key)))
      throw const FormatException('Only optional fields may be cleared');
    return PaymentAccountSnapshot(
      id: (id ?? this.id),
      scopeFingerprint: (scopeFingerprint ?? this.scopeFingerprint),
      environment: (environment ?? this.environment),
      customerId: (customerId ?? this.customerId),
      invoices: (invoices ?? this.invoices),
      plans: (plans ?? this.plans),
      disputes: (disputes ?? this.disputes),
      activity: (activity ?? this.activity),
      complete: (complete ?? this.complete),
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
      if (invoices.length > 100)
        validationIssues.add(
          const PaymentIssue(
            'invoices',
            'count',
            'Payment list is empty or exceeds its limit',
          ),
        );
    }
    {
      for (var i = 0; i < invoices.length; i++)
        for (final issue in invoices[i].validate())
          validationIssues.add(
            PaymentIssue(
              'invoices[$i].${issue.field}',
              issue.code,
              issue.message,
              severity: issue.severity,
            ),
          );
    }
    {
      if (plans.length > 100)
        validationIssues.add(
          const PaymentIssue(
            'plans',
            'count',
            'Payment list is empty or exceeds its limit',
          ),
        );
    }
    {
      for (var i = 0; i < plans.length; i++)
        for (final issue in plans[i].validate())
          validationIssues.add(
            PaymentIssue(
              'plans[$i].${issue.field}',
              issue.code,
              issue.message,
              severity: issue.severity,
            ),
          );
    }
    {
      if (disputes.length > 100)
        validationIssues.add(
          const PaymentIssue(
            'disputes',
            'count',
            'Payment list is empty or exceeds its limit',
          ),
        );
    }
    {
      for (var i = 0; i < disputes.length; i++)
        for (final issue in disputes[i].validate())
          validationIssues.add(
            PaymentIssue(
              'disputes[$i].${issue.field}',
              issue.code,
              issue.message,
              severity: issue.severity,
            ),
          );
    }
    {
      if (activity.length > 100)
        validationIssues.add(
          const PaymentIssue(
            'activity',
            'count',
            'Payment list is empty or exceeds its limit',
          ),
        );
    }
    {
      for (var i = 0; i < activity.length; i++)
        for (final issue in activity[i].validate())
          validationIssues.add(
            PaymentIssue(
              'activity[$i].${issue.field}',
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
    if (revision < 1 ||
        !expiresAt.isAfter(observedAt) ||
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
    "environment": environment,
    "customerId": customerId,
    "invoices": invoices.map((item) => item.toJson()).toList(),
    "plans": plans.map((item) => item.toJson()).toList(),
    "disputes": disputes.map((item) => item.toJson()).toList(),
    "activity": activity.map((item) => item.toJson()).toList(),
    "complete": complete,
    "observedAt": observedAt.toUtc().toIso8601String(),
    "expiresAt": expiresAt.toUtc().toIso8601String(),
    "serverVerified": serverVerified,
    "revision": revision,
  };

  @override
  bool operator ==(Object other) =>
      other is PaymentAccountSnapshot &&
      PaymentCodec.same(toJson(), other.toJson());
  @override
  int get hashCode => PaymentCodec.digest(toJson()).hashCode;
  @override
  String toString() => 'PaymentAccountSnapshot(redacted)';
}
