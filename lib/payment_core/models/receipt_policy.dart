// Generated typed payment records. Edit tool/payment_models.json and regenerate.
import '../payment_codec.dart';
import '../payment_issue.dart';

class PaymentReceiptPolicy {
  PaymentReceiptPolicy({
    required List<String> allowedHosts,
    List<String> allowedPathPrefixes = const [],
    this.allowQuery = false,
    this.maximumAgeSeconds = 300,
    this.version = 1,
  }) : allowedHosts = List.unmodifiable(allowedHosts),
       allowedPathPrefixes = List.unmodifiable(allowedPathPrefixes);

  final List<String> allowedHosts;
  final List<String> allowedPathPrefixes;
  final bool allowQuery;
  final int maximumAgeSeconds;
  final int version;

  factory PaymentReceiptPolicy.fromJson(Map<String, Object?> json) {
    PaymentCodec.keys(json, {
      "allowedHosts",
      "allowedPathPrefixes",
      "allowQuery",
      "maximumAgeSeconds",
      "version",
    });
    final value = PaymentReceiptPolicy(
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
      allowedPathPrefixes:
          PaymentCodec.list(json, 'allowedPathPrefixes', (v) {
            if (v is! String || v.trim().isEmpty || v.length > 200)
              throw const FormatException('Invalid list text');
            return v;
          }, maximum: 100) ??
          [],
      allowQuery: PaymentCodec.boolean(json, 'allowQuery') ?? false,
      maximumAgeSeconds:
          PaymentCodec.integer(
            json,
            'maximumAgeSeconds',
            minimum: 0,
            maximum: 9000000000000,
          ) ??
          300,
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

  static PaymentResult<PaymentReceiptPolicy> tryDecode(Object? input) {
    try {
      return PaymentResult(
        value: PaymentReceiptPolicy.fromJson(PaymentCodec.object(input)),
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

  PaymentReceiptPolicy copyWith({
    Set<String> clear = const {},
    List<String>? allowedHosts,
    List<String>? allowedPathPrefixes,
    bool? allowQuery,
    int? maximumAgeSeconds,
    int? version,
  }) {
    final clearableFields = <String>{};
    if (clear.any((key) => !clearableFields.contains(key)))
      throw const FormatException('Only optional fields may be cleared');
    return PaymentReceiptPolicy(
      allowedHosts: (allowedHosts ?? this.allowedHosts),
      allowedPathPrefixes: (allowedPathPrefixes ?? this.allowedPathPrefixes),
      allowQuery: (allowQuery ?? this.allowQuery),
      maximumAgeSeconds: (maximumAgeSeconds ?? this.maximumAgeSeconds),
      version: (version ?? this.version),
    );
  }

  List<PaymentIssue> validate() {
    final validationIssues = <PaymentIssue>[];
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
      if (allowedPathPrefixes.length > 100)
        validationIssues.add(
          const PaymentIssue(
            'allowedPathPrefixes',
            'count',
            'Payment list is empty or exceeds its limit',
          ),
        );
    }
    {
      if (allowedPathPrefixes.any(
        (item) => item.trim().isEmpty || item.length > 200,
      ))
        validationIssues.add(
          const PaymentIssue(
            'allowedPathPrefixes',
            'text',
            'Use bounded nonempty list text',
          ),
        );
    }
    {
      if (maximumAgeSeconds < 0 || maximumAgeSeconds > 9000000000000)
        validationIssues.add(
          const PaymentIssue(
            'maximumAgeSeconds',
            'range',
            'Number is outside the payment limits',
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
        allowedHosts.isEmpty ||
        maximumAgeSeconds < 1 ||
        maximumAgeSeconds > 3600 ||
        allowedHosts.any(
          (h) =>
              h.isEmpty ||
              h != h.toLowerCase() ||
              h.contains('/') ||
              h.contains('*'),
        ) ||
        allowedPathPrefixes.any((p) => !p.startsWith('/') || p.contains('..')))
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
    "allowedHosts": allowedHosts,
    "allowedPathPrefixes": allowedPathPrefixes,
    "allowQuery": allowQuery,
    "maximumAgeSeconds": maximumAgeSeconds,
    "version": version,
  };

  @override
  bool operator ==(Object other) =>
      other is PaymentReceiptPolicy &&
      PaymentCodec.same(toJson(), other.toJson());
  @override
  int get hashCode => PaymentCodec.digest(toJson()).hashCode;
  @override
  String toString() => 'PaymentReceiptPolicy(redacted)';
}
