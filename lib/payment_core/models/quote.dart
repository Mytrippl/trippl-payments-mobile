// Generated typed payment records. Edit tool/payment_models.json and regenerate.
import '../payment_codec.dart';
import '../payment_issue.dart';
import 'money.dart';

class PaymentQuote {
  PaymentQuote({
    required this.id,
    required this.orderId,
    required this.orderRevision,
    required this.scopeFingerprint,
    required this.orderFingerprint,
    required this.total,
    required this.observedAt,
    required this.expiresAt,
    this.serverVerified = false,
    this.revision = 1,
    List<String> warningCodes = const [],
  }) : warningCodes = List.unmodifiable(warningCodes);

  final String id;
  final String orderId;
  final int orderRevision;
  final String scopeFingerprint;
  final String orderFingerprint;
  final PaymentMoney total;
  final DateTime observedAt;
  final DateTime expiresAt;
  final bool serverVerified;
  final int revision;
  final List<String> warningCodes;

  factory PaymentQuote.fromJson(Map<String, Object?> json) {
    PaymentCodec.keys(json, {
      "id",
      "orderId",
      "orderRevision",
      "scopeFingerprint",
      "orderFingerprint",
      "total",
      "observedAt",
      "expiresAt",
      "serverVerified",
      "revision",
      "warningCodes",
    });
    final value = PaymentQuote(
      id: PaymentCodec.text(json, 'id', required: true)!,
      orderId: PaymentCodec.text(json, 'orderId', required: true)!,
      orderRevision: PaymentCodec.integer(
        json,
        'orderRevision',
        required: true,
        minimum: 0,
        maximum: 9000000000000,
      )!,
      scopeFingerprint: PaymentCodec.text(
        json,
        'scopeFingerprint',
        required: true,
      )!,
      orderFingerprint: PaymentCodec.text(
        json,
        'orderFingerprint',
        required: true,
      )!,
      total: (json['total'] == null
          ? null
          : PaymentMoney.fromJson(PaymentCodec.object(json['total'])))!,
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
      warningCodes:
          PaymentCodec.list(json, 'warningCodes', (v) {
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

  static PaymentResult<PaymentQuote> tryDecode(Object? input) {
    try {
      return PaymentResult(
        value: PaymentQuote.fromJson(PaymentCodec.object(input)),
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

  PaymentQuote copyWith({
    Set<String> clear = const {},
    String? id,
    String? orderId,
    int? orderRevision,
    String? scopeFingerprint,
    String? orderFingerprint,
    PaymentMoney? total,
    DateTime? observedAt,
    DateTime? expiresAt,
    bool? serverVerified,
    int? revision,
    List<String>? warningCodes,
  }) {
    final clearableFields = <String>{};
    if (clear.any((key) => !clearableFields.contains(key)))
      throw const FormatException('Only optional fields may be cleared');
    return PaymentQuote(
      id: (id ?? this.id),
      orderId: (orderId ?? this.orderId),
      orderRevision: (orderRevision ?? this.orderRevision),
      scopeFingerprint: (scopeFingerprint ?? this.scopeFingerprint),
      orderFingerprint: (orderFingerprint ?? this.orderFingerprint),
      total: (total ?? this.total),
      observedAt: (observedAt ?? this.observedAt),
      expiresAt: (expiresAt ?? this.expiresAt),
      serverVerified: (serverVerified ?? this.serverVerified),
      revision: (revision ?? this.revision),
      warningCodes: (warningCodes ?? this.warningCodes),
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
      if (orderId.trim().isEmpty || orderId.length > 4000)
        validationIssues.add(
          const PaymentIssue('orderId', 'text', 'Use nonempty bounded text'),
        );
    }
    {
      if (orderRevision < 0 || orderRevision > 9000000000000)
        validationIssues.add(
          const PaymentIssue(
            'orderRevision',
            'range',
            'Number is outside the payment limits',
          ),
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
      for (final issue in total.validate())
        validationIssues.add(
          PaymentIssue(
            'total.${issue.field}',
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
    {
      if (warningCodes.length > 100)
        validationIssues.add(
          const PaymentIssue(
            'warningCodes',
            'count',
            'Payment list is empty or exceeds its limit',
          ),
        );
    }
    {
      if (warningCodes.any((item) => item.trim().isEmpty || item.length > 200))
        validationIssues.add(
          const PaymentIssue(
            'warningCodes',
            'text',
            'Use bounded nonempty list text',
          ),
        );
    }
    if (revision < 1 || orderRevision < 1 || !expiresAt.isAfter(observedAt))
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
    "orderId": orderId,
    "orderRevision": orderRevision,
    "scopeFingerprint": scopeFingerprint,
    "orderFingerprint": orderFingerprint,
    "total": total.toJson(),
    "observedAt": observedAt.toUtc().toIso8601String(),
    "expiresAt": expiresAt.toUtc().toIso8601String(),
    "serverVerified": serverVerified,
    "revision": revision,
    "warningCodes": warningCodes,
  };

  @override
  bool operator ==(Object other) =>
      other is PaymentQuote && PaymentCodec.same(toJson(), other.toJson());
  @override
  int get hashCode => PaymentCodec.digest(toJson()).hashCode;
  @override
  String toString() => 'PaymentQuote(redacted)';
}
