// Generated typed payment records. Edit tool/payment_models.json and regenerate.
import '../payment_codec.dart';
import '../payment_issue.dart';

class PaymentError {
  PaymentError({
    required this.code,
    required this.category,
    required this.occurredAt,
    this.retryable = false,
    this.cancelled = false,
    this.requiresUserAction = false,
    this.requiresVerification = false,
    this.declineCode,
    List<String> reasonCodes = const [],
  }) : reasonCodes = List.unmodifiable(reasonCodes);

  final String code;
  final String category;
  final DateTime occurredAt;
  final bool retryable;
  final bool cancelled;
  final bool requiresUserAction;
  final bool requiresVerification;
  final String? declineCode;
  final List<String> reasonCodes;

  factory PaymentError.fromJson(Map<String, Object?> json) {
    PaymentCodec.keys(json, {
      "code",
      "category",
      "occurredAt",
      "retryable",
      "cancelled",
      "requiresUserAction",
      "requiresVerification",
      "declineCode",
      "reasonCodes",
    });
    final value = PaymentError(
      code: PaymentCodec.text(json, 'code', required: true)!,
      category: PaymentCodec.text(json, 'category', required: true)!,
      occurredAt: PaymentCodec.date(json, 'occurredAt', required: true)!,
      retryable: PaymentCodec.boolean(json, 'retryable') ?? false,
      cancelled: PaymentCodec.boolean(json, 'cancelled') ?? false,
      requiresUserAction:
          PaymentCodec.boolean(json, 'requiresUserAction') ?? false,
      requiresVerification:
          PaymentCodec.boolean(json, 'requiresVerification') ?? false,
      declineCode: PaymentCodec.text(json, 'declineCode'),
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

  static PaymentResult<PaymentError> tryDecode(Object? input) {
    try {
      return PaymentResult(
        value: PaymentError.fromJson(PaymentCodec.object(input)),
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

  PaymentError copyWith({
    Set<String> clear = const {},
    String? code,
    String? category,
    DateTime? occurredAt,
    bool? retryable,
    bool? cancelled,
    bool? requiresUserAction,
    bool? requiresVerification,
    String? declineCode,
    List<String>? reasonCodes,
  }) {
    final clearableFields = <String>{"declineCode"};
    if (clear.any((key) => !clearableFields.contains(key)))
      throw const FormatException('Only optional fields may be cleared');
    return PaymentError(
      code: (code ?? this.code),
      category: (category ?? this.category),
      occurredAt: (occurredAt ?? this.occurredAt),
      retryable: (retryable ?? this.retryable),
      cancelled: (cancelled ?? this.cancelled),
      requiresUserAction: (requiresUserAction ?? this.requiresUserAction),
      requiresVerification: (requiresVerification ?? this.requiresVerification),
      declineCode: clear.contains('declineCode')
          ? null
          : (declineCode ?? this.declineCode),
      reasonCodes: (reasonCodes ?? this.reasonCodes),
    );
  }

  List<PaymentIssue> validate() {
    final validationIssues = <PaymentIssue>[];
    {
      if (code.trim().isEmpty || code.length > 4000)
        validationIssues.add(
          const PaymentIssue('code', 'text', 'Use nonempty bounded text'),
        );
    }
    {
      if (category.trim().isEmpty || category.length > 4000)
        validationIssues.add(
          const PaymentIssue('category', 'text', 'Use nonempty bounded text'),
        );
    }
    if (declineCode != null) {
      if (declineCode!.trim().isEmpty || declineCode!.length > 4000)
        validationIssues.add(
          const PaymentIssue(
            'declineCode',
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
    if (!RegExp(r'^[A-Za-z0-9_-]{1,80}$').hasMatch(code) ||
        declineCode != null &&
            !RegExp(r'^[A-Za-z0-9_-]{1,80}$').hasMatch(declineCode!))
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
    "code": code,
    "category": category,
    "occurredAt": occurredAt.toUtc().toIso8601String(),
    "retryable": retryable,
    "cancelled": cancelled,
    "requiresUserAction": requiresUserAction,
    "requiresVerification": requiresVerification,
    if (declineCode != null) "declineCode": declineCode,
    "reasonCodes": reasonCodes,
  };

  @override
  bool operator ==(Object other) =>
      other is PaymentError && PaymentCodec.same(toJson(), other.toJson());
  @override
  int get hashCode => PaymentCodec.digest(toJson()).hashCode;
  @override
  String toString() => 'PaymentError(redacted)';
}
