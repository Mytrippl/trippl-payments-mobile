// Generated typed payment records. Edit tool/payment_models.json and regenerate.
import '../payment_codec.dart';
import '../payment_issue.dart';

class PaymentCheckoutSnapshot {
  PaymentCheckoutSnapshot({
    required this.scopeFingerprint,
    required this.orderId,
    required this.orderFingerprint,
    required this.updatedAt,
    required this.state,
    this.intentId,
    this.attemptId,
    this.offline = true,
    this.needsVerification = true,
    this.schemaVersion = 1,
  });

  final String scopeFingerprint;
  final String orderId;
  final String orderFingerprint;
  final DateTime updatedAt;
  final String state;
  final String? intentId;
  final String? attemptId;
  final bool offline;
  final bool needsVerification;
  final int schemaVersion;

  factory PaymentCheckoutSnapshot.fromJson(Map<String, Object?> json) {
    PaymentCodec.keys(json, {
      "scopeFingerprint",
      "orderId",
      "orderFingerprint",
      "updatedAt",
      "state",
      "intentId",
      "attemptId",
      "offline",
      "needsVerification",
      "schemaVersion",
    });
    final value = PaymentCheckoutSnapshot(
      scopeFingerprint: PaymentCodec.text(
        json,
        'scopeFingerprint',
        required: true,
      )!,
      orderId: PaymentCodec.text(json, 'orderId', required: true)!,
      orderFingerprint: PaymentCodec.text(
        json,
        'orderFingerprint',
        required: true,
      )!,
      updatedAt: PaymentCodec.date(json, 'updatedAt', required: true)!,
      state: PaymentCodec.text(json, 'state', required: true)!,
      intentId: PaymentCodec.text(json, 'intentId'),
      attemptId: PaymentCodec.text(json, 'attemptId'),
      offline: PaymentCodec.boolean(json, 'offline') ?? true,
      needsVerification:
          PaymentCodec.boolean(json, 'needsVerification') ?? true,
      schemaVersion:
          PaymentCodec.integer(
            json,
            'schemaVersion',
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

  static PaymentResult<PaymentCheckoutSnapshot> tryDecode(Object? input) {
    try {
      return PaymentResult(
        value: PaymentCheckoutSnapshot.fromJson(PaymentCodec.object(input)),
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

  PaymentCheckoutSnapshot copyWith({
    Set<String> clear = const {},
    String? scopeFingerprint,
    String? orderId,
    String? orderFingerprint,
    DateTime? updatedAt,
    String? state,
    String? intentId,
    String? attemptId,
    bool? offline,
    bool? needsVerification,
    int? schemaVersion,
  }) {
    final clearableFields = <String>{"intentId", "attemptId"};
    if (clear.any((key) => !clearableFields.contains(key)))
      throw const FormatException('Only optional fields may be cleared');
    return PaymentCheckoutSnapshot(
      scopeFingerprint: (scopeFingerprint ?? this.scopeFingerprint),
      orderId: (orderId ?? this.orderId),
      orderFingerprint: (orderFingerprint ?? this.orderFingerprint),
      updatedAt: (updatedAt ?? this.updatedAt),
      state: (state ?? this.state),
      intentId: clear.contains('intentId') ? null : (intentId ?? this.intentId),
      attemptId: clear.contains('attemptId')
          ? null
          : (attemptId ?? this.attemptId),
      offline: (offline ?? this.offline),
      needsVerification: (needsVerification ?? this.needsVerification),
      schemaVersion: (schemaVersion ?? this.schemaVersion),
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
      if (orderId.trim().isEmpty || orderId.length > 4000)
        validationIssues.add(
          const PaymentIssue('orderId', 'text', 'Use nonempty bounded text'),
        );
    }
    {
      if (orderFingerprint.trim().isEmpty || orderFingerprint.length > 4000)
        validationIssues.add(
          const PaymentIssue(
            'orderFingerprint',
            'text',
            'Use nonempty bounded text',
          ),
        );
    }
    {
      if (state.trim().isEmpty || state.length > 4000)
        validationIssues.add(
          const PaymentIssue('state', 'text', 'Use nonempty bounded text'),
        );
    }
    if (intentId != null) {
      if (intentId!.trim().isEmpty || intentId!.length > 4000)
        validationIssues.add(
          const PaymentIssue('intentId', 'text', 'Use nonempty bounded text'),
        );
    }
    if (attemptId != null) {
      if (attemptId!.trim().isEmpty || attemptId!.length > 4000)
        validationIssues.add(
          const PaymentIssue('attemptId', 'text', 'Use nonempty bounded text'),
        );
    }
    {
      if (schemaVersion < 0 || schemaVersion > 9000000000000)
        validationIssues.add(
          const PaymentIssue(
            'schemaVersion',
            'range',
            'Number is outside the payment limits',
          ),
        );
    }
    if (schemaVersion != 1 || !needsVerification)
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
    "orderId": orderId,
    "orderFingerprint": orderFingerprint,
    "updatedAt": updatedAt.toUtc().toIso8601String(),
    "state": state,
    if (intentId != null) "intentId": intentId,
    if (attemptId != null) "attemptId": attemptId,
    "offline": offline,
    "needsVerification": needsVerification,
    "schemaVersion": schemaVersion,
  };

  @override
  bool operator ==(Object other) =>
      other is PaymentCheckoutSnapshot &&
      PaymentCodec.same(toJson(), other.toJson());
  @override
  int get hashCode => PaymentCodec.digest(toJson()).hashCode;
  @override
  String toString() => 'PaymentCheckoutSnapshot(redacted)';
}
