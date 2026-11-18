// Generated typed payment records. Edit tool/payment_models.json and regenerate.
import '../payment_codec.dart';
import '../payment_issue.dart';

class PaymentReturnPolicy {
  PaymentReturnPolicy({
    required List<String> allowedSchemes,
    required List<String> allowedHosts,
    required List<String> allowedPaths,
    List<String> allowedQueryKeys = const [],
    this.requireState = true,
    this.version = 1,
  }) : allowedSchemes = List.unmodifiable(allowedSchemes),
       allowedHosts = List.unmodifiable(allowedHosts),
       allowedPaths = List.unmodifiable(allowedPaths),
       allowedQueryKeys = List.unmodifiable(allowedQueryKeys);

  final List<String> allowedSchemes;
  final List<String> allowedHosts;
  final List<String> allowedPaths;
  final List<String> allowedQueryKeys;
  final bool requireState;
  final int version;

  factory PaymentReturnPolicy.fromJson(Map<String, Object?> json) {
    PaymentCodec.keys(json, {
      "allowedSchemes",
      "allowedHosts",
      "allowedPaths",
      "allowedQueryKeys",
      "requireState",
      "version",
    });
    final value = PaymentReturnPolicy(
      allowedSchemes: PaymentCodec.list(
        json,
        'allowedSchemes',
        (v) {
          if (v is! String || v.trim().isEmpty || v.length > 200)
            throw const FormatException('Invalid list text');
          return v;
        },
        required: true,
        maximum: 100,
      )!,
      allowedHosts: PaymentCodec.list(
        json,
        'allowedHosts',
        (v) {
          if (v is! String || v.trim().isEmpty || v.length > 200)
            throw const FormatException('Invalid list text');
          return v;
        },
        required: true,
        maximum: 100,
      )!,
      allowedPaths: PaymentCodec.list(
        json,
        'allowedPaths',
        (v) {
          if (v is! String || v.trim().isEmpty || v.length > 200)
            throw const FormatException('Invalid list text');
          return v;
        },
        required: true,
        maximum: 100,
      )!,
      allowedQueryKeys:
          PaymentCodec.list(json, 'allowedQueryKeys', (v) {
            if (v is! String || v.trim().isEmpty || v.length > 200)
              throw const FormatException('Invalid list text');
            return v;
          }, maximum: 100) ??
          [],
      requireState: PaymentCodec.boolean(json, 'requireState') ?? true,
      version:
          PaymentCodec.integer(
            json,
            'version',
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

  static PaymentResult<PaymentReturnPolicy> tryDecode(Object? input) {
    try {
      return PaymentResult(
        value: PaymentReturnPolicy.fromJson(PaymentCodec.object(input)),
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

  PaymentReturnPolicy copyWith({
    Set<String> clear = const {},
    List<String>? allowedSchemes,
    List<String>? allowedHosts,
    List<String>? allowedPaths,
    List<String>? allowedQueryKeys,
    bool? requireState,
    int? version,
  }) {
    final clearableFields = <String>{};
    if (clear.any((key) => !clearableFields.contains(key)))
      throw const FormatException('Only optional fields may be cleared');
    return PaymentReturnPolicy(
      allowedSchemes: (allowedSchemes ?? this.allowedSchemes),
      allowedHosts: (allowedHosts ?? this.allowedHosts),
      allowedPaths: (allowedPaths ?? this.allowedPaths),
      allowedQueryKeys: (allowedQueryKeys ?? this.allowedQueryKeys),
      requireState: (requireState ?? this.requireState),
      version: (version ?? this.version),
    );
  }

  List<PaymentIssue> validate() {
    final validationIssues = <PaymentIssue>[];
    {
      if (allowedSchemes.length > 100 || allowedSchemes.isEmpty)
        validationIssues.add(
          const PaymentIssue(
            'allowedSchemes',
            'count',
            'Payment list is empty or exceeds its limit',
          ),
        );
    }
    {
      if (allowedSchemes.any(
        (item) => item.trim().isEmpty || item.length > 200,
      ))
        validationIssues.add(
          const PaymentIssue(
            'allowedSchemes',
            'text',
            'Use bounded nonempty list text',
          ),
        );
    }
    {
      if (allowedHosts.length > 100 || allowedHosts.isEmpty)
        validationIssues.add(
          const PaymentIssue(
            'allowedHosts',
            'count',
            'Payment list is empty or exceeds its limit',
          ),
        );
    }
    {
      if (allowedHosts.any((item) => item.trim().isEmpty || item.length > 200))
        validationIssues.add(
          const PaymentIssue(
            'allowedHosts',
            'text',
            'Use bounded nonempty list text',
          ),
        );
    }
    {
      if (allowedPaths.length > 100 || allowedPaths.isEmpty)
        validationIssues.add(
          const PaymentIssue(
            'allowedPaths',
            'count',
            'Payment list is empty or exceeds its limit',
          ),
        );
    }
    {
      if (allowedPaths.any((item) => item.trim().isEmpty || item.length > 200))
        validationIssues.add(
          const PaymentIssue(
            'allowedPaths',
            'text',
            'Use bounded nonempty list text',
          ),
        );
    }
    {
      if (allowedQueryKeys.length > 100)
        validationIssues.add(
          const PaymentIssue(
            'allowedQueryKeys',
            'count',
            'Payment list is empty or exceeds its limit',
          ),
        );
    }
    {
      if (allowedQueryKeys.any(
        (item) => item.trim().isEmpty || item.length > 200,
      ))
        validationIssues.add(
          const PaymentIssue(
            'allowedQueryKeys',
            'text',
            'Use bounded nonempty list text',
          ),
        );
    }
    {
      if (version < 0 || version > 9000000000000)
        validationIssues.add(
          const PaymentIssue(
            'version',
            'range',
            'Number is outside the payment limits',
          ),
        );
    }
    if (version != 1 ||
        allowedSchemes.any((s) => !{'https', 'mytrippl'}.contains(s)))
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
    "allowedSchemes": allowedSchemes,
    "allowedHosts": allowedHosts,
    "allowedPaths": allowedPaths,
    "allowedQueryKeys": allowedQueryKeys,
    "requireState": requireState,
    "version": version,
  };

  @override
  bool operator ==(Object other) =>
      other is PaymentReturnPolicy &&
      PaymentCodec.same(toJson(), other.toJson());
  @override
  int get hashCode => PaymentCodec.digest(toJson()).hashCode;
  @override
  String toString() => 'PaymentReturnPolicy(redacted)';
}
