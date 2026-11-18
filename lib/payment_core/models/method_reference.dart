// Generated typed payment records. Edit tool/payment_models.json and regenerate.
import '../payment_codec.dart';
import '../payment_issue.dart';

class PaymentMethodReference {
  PaymentMethodReference({
    required this.id,
    required this.scopeFingerprint,
    required this.customerId,
    required this.methodId,
    required this.type,
    this.brand,
    this.last4,
    this.expiryMonth,
    this.expiryYear,
    this.wallet,
    this.reusable = false,
    required this.observedAt,
    required this.expiresAt,
    this.serverVerified = false,
    required this.environment,
  });

  final String id;
  final String scopeFingerprint;
  final String customerId;
  final String methodId;
  final String type;
  final String? brand;
  final String? last4;
  final int? expiryMonth;
  final int? expiryYear;
  final String? wallet;
  final bool reusable;
  final DateTime observedAt;
  final DateTime expiresAt;
  final bool serverVerified;
  final String environment;

  factory PaymentMethodReference.fromJson(Map<String, Object?> json) {
    PaymentCodec.keys(json, {
      "id",
      "scopeFingerprint",
      "customerId",
      "methodId",
      "type",
      "brand",
      "last4",
      "expiryMonth",
      "expiryYear",
      "wallet",
      "reusable",
      "observedAt",
      "expiresAt",
      "serverVerified",
      "environment",
    });
    final value = PaymentMethodReference(
      id: PaymentCodec.text(json, 'id', required: true)!,
      scopeFingerprint: PaymentCodec.text(
        json,
        'scopeFingerprint',
        required: true,
      )!,
      customerId: PaymentCodec.text(json, 'customerId', required: true)!,
      methodId: PaymentCodec.text(json, 'methodId', required: true)!,
      type: PaymentCodec.text(json, 'type', required: true)!,
      brand: PaymentCodec.text(json, 'brand'),
      last4: PaymentCodec.text(json, 'last4'),
      expiryMonth: PaymentCodec.integer(
        json,
        'expiryMonth',
        minimum: 0,
        maximum: 9000000000000,
      ),
      expiryYear: PaymentCodec.integer(
        json,
        'expiryYear',
        minimum: 0,
        maximum: 9000000000000,
      ),
      wallet: PaymentCodec.text(json, 'wallet'),
      reusable: PaymentCodec.boolean(json, 'reusable') ?? false,
      observedAt: PaymentCodec.date(json, 'observedAt', required: true)!,
      expiresAt: PaymentCodec.date(json, 'expiresAt', required: true)!,
      serverVerified: PaymentCodec.boolean(json, 'serverVerified') ?? false,
      environment: PaymentCodec.text(json, 'environment', required: true)!,
    );
    final issues = value.validate();
    if (issues.any((i) => i.severity == PaymentSeverity.error))
      throw PaymentValidationException(issues);
    return value;
  }

  static PaymentResult<PaymentMethodReference> tryDecode(Object? input) {
    try {
      return PaymentResult(
        value: PaymentMethodReference.fromJson(PaymentCodec.object(input)),
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

  PaymentMethodReference copyWith({
    Set<String> clear = const {},
    String? id,
    String? scopeFingerprint,
    String? customerId,
    String? methodId,
    String? type,
    String? brand,
    String? last4,
    int? expiryMonth,
    int? expiryYear,
    String? wallet,
    bool? reusable,
    DateTime? observedAt,
    DateTime? expiresAt,
    bool? serverVerified,
    String? environment,
  }) {
    final clearableFields = <String>{
      "brand",
      "last4",
      "expiryMonth",
      "expiryYear",
      "wallet",
    };
    if (clear.any((key) => !clearableFields.contains(key)))
      throw const FormatException('Only optional fields may be cleared');
    return PaymentMethodReference(
      id: (id ?? this.id),
      scopeFingerprint: (scopeFingerprint ?? this.scopeFingerprint),
      customerId: (customerId ?? this.customerId),
      methodId: (methodId ?? this.methodId),
      type: (type ?? this.type),
      brand: clear.contains('brand') ? null : (brand ?? this.brand),
      last4: clear.contains('last4') ? null : (last4 ?? this.last4),
      expiryMonth: clear.contains('expiryMonth')
          ? null
          : (expiryMonth ?? this.expiryMonth),
      expiryYear: clear.contains('expiryYear')
          ? null
          : (expiryYear ?? this.expiryYear),
      wallet: clear.contains('wallet') ? null : (wallet ?? this.wallet),
      reusable: (reusable ?? this.reusable),
      observedAt: (observedAt ?? this.observedAt),
      expiresAt: (expiresAt ?? this.expiresAt),
      serverVerified: (serverVerified ?? this.serverVerified),
      environment: (environment ?? this.environment),
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
      if (customerId.trim().isEmpty || customerId.length > 4000)
        validationIssues.add(
          const PaymentIssue('customerId', 'text', 'Use nonempty bounded text'),
        );
    }
    {
      if (methodId.trim().isEmpty || methodId.length > 4000)
        validationIssues.add(
          const PaymentIssue('methodId', 'text', 'Use nonempty bounded text'),
        );
    }
    {
      if (type.trim().isEmpty || type.length > 4000)
        validationIssues.add(
          const PaymentIssue('type', 'text', 'Use nonempty bounded text'),
        );
    }
    if (brand != null) {
      if (brand!.trim().isEmpty || brand!.length > 4000)
        validationIssues.add(
          const PaymentIssue('brand', 'text', 'Use nonempty bounded text'),
        );
    }
    if (last4 != null) {
      if (last4!.trim().isEmpty || last4!.length > 4000)
        validationIssues.add(
          const PaymentIssue('last4', 'text', 'Use nonempty bounded text'),
        );
    }
    if (expiryMonth != null) {
      if (expiryMonth! < 0 || expiryMonth! > 9000000000000)
        validationIssues.add(
          const PaymentIssue(
            'expiryMonth',
            'range',
            'Number is outside the payment limits',
          ),
        );
    }
    if (expiryYear != null) {
      if (expiryYear! < 0 || expiryYear! > 9000000000000)
        validationIssues.add(
          const PaymentIssue(
            'expiryYear',
            'range',
            'Number is outside the payment limits',
          ),
        );
    }
    if (wallet != null) {
      if (wallet!.trim().isEmpty || wallet!.length > 4000)
        validationIssues.add(
          const PaymentIssue('wallet', 'text', 'Use nonempty bounded text'),
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
    if (!expiresAt.isAfter(observedAt) ||
        last4 != null && !RegExp(r'^\d{4}$').hasMatch(last4!) ||
        expiryMonth != null && (expiryMonth! < 1 || expiryMonth! > 12) ||
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
    "customerId": customerId,
    "methodId": methodId,
    "type": type,
    if (brand != null) "brand": brand,
    if (last4 != null) "last4": last4,
    if (expiryMonth != null) "expiryMonth": expiryMonth,
    if (expiryYear != null) "expiryYear": expiryYear,
    if (wallet != null) "wallet": wallet,
    "reusable": reusable,
    "observedAt": observedAt.toUtc().toIso8601String(),
    "expiresAt": expiresAt.toUtc().toIso8601String(),
    "serverVerified": serverVerified,
    "environment": environment,
  };

  @override
  bool operator ==(Object other) =>
      other is PaymentMethodReference &&
      PaymentCodec.same(toJson(), other.toJson());
  @override
  int get hashCode => PaymentCodec.digest(toJson()).hashCode;
  @override
  String toString() => 'PaymentMethodReference(redacted)';
}
