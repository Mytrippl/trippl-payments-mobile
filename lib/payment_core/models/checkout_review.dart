// Generated typed payment records. Edit tool/payment_models.json and regenerate.
import '../payment_codec.dart';
import '../payment_issue.dart';
import 'money.dart';

class PaymentCheckoutReview {
  PaymentCheckoutReview({
    required this.scopeFingerprint,
    required this.orderId,
    required this.orderFingerprint,
    required this.quoteId,
    required this.quoteRevision,
    required this.total,
    required this.reviewedAt,
    required this.expiresAt,
    List<String> acknowledgedWarningCodes = const [],
    this.revision = 1,
  }) : acknowledgedWarningCodes = List.unmodifiable(acknowledgedWarningCodes);

  final String scopeFingerprint;
  final String orderId;
  final String orderFingerprint;
  final String quoteId;
  final int quoteRevision;
  final PaymentMoney total;
  final DateTime reviewedAt;
  final DateTime expiresAt;
  final List<String> acknowledgedWarningCodes;
  final int revision;

  factory PaymentCheckoutReview.fromJson(Map<String, Object?> json) {
    PaymentCodec.keys(json, {
      "scopeFingerprint",
      "orderId",
      "orderFingerprint",
      "quoteId",
      "quoteRevision",
      "total",
      "reviewedAt",
      "expiresAt",
      "acknowledgedWarningCodes",
      "revision",
    });
    final value = PaymentCheckoutReview(
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
      quoteId: PaymentCodec.text(json, 'quoteId', required: true)!,
      quoteRevision: PaymentCodec.integer(
        json,
        'quoteRevision',
        required: true,
        minimum: 0,
        maximum: 9000000000000,
      )!,
      total: (json['total'] == null
          ? null
          : PaymentMoney.fromJson(PaymentCodec.object(json['total'])))!,
      reviewedAt: PaymentCodec.date(json, 'reviewedAt', required: true)!,
      expiresAt: PaymentCodec.date(json, 'expiresAt', required: true)!,
      acknowledgedWarningCodes:
          PaymentCodec.list(json, 'acknowledgedWarningCodes', (v) {
            if (v is! String || v.trim().isEmpty || v.length > 200)
              throw const FormatException('Invalid list text');
            return v;
          }, maximum: 100) ??
          [],
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

  static PaymentResult<PaymentCheckoutReview> tryDecode(Object? input) {
    try {
      return PaymentResult(
        value: PaymentCheckoutReview.fromJson(PaymentCodec.object(input)),
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

  PaymentCheckoutReview copyWith({
    Set<String> clear = const {},
    String? scopeFingerprint,
    String? orderId,
    String? orderFingerprint,
    String? quoteId,
    int? quoteRevision,
    PaymentMoney? total,
    DateTime? reviewedAt,
    DateTime? expiresAt,
    List<String>? acknowledgedWarningCodes,
    int? revision,
  }) {
    final clearableFields = <String>{};
    if (clear.any((key) => !clearableFields.contains(key)))
      throw const FormatException('Only optional fields may be cleared');
    return PaymentCheckoutReview(
      scopeFingerprint: (scopeFingerprint ?? this.scopeFingerprint),
      orderId: (orderId ?? this.orderId),
      orderFingerprint: (orderFingerprint ?? this.orderFingerprint),
      quoteId: (quoteId ?? this.quoteId),
      quoteRevision: (quoteRevision ?? this.quoteRevision),
      total: (total ?? this.total),
      reviewedAt: (reviewedAt ?? this.reviewedAt),
      expiresAt: (expiresAt ?? this.expiresAt),
      acknowledgedWarningCodes:
          (acknowledgedWarningCodes ?? this.acknowledgedWarningCodes),
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
      if (quoteId.trim().isEmpty || quoteId.length > 4000)
        validationIssues.add(
          const PaymentIssue('quoteId', 'text', 'Use nonempty bounded text'),
        );
    }
    {
      if (quoteRevision < 0 || quoteRevision > 9000000000000)
        validationIssues.add(
          const PaymentIssue(
            'quoteRevision',
            'range',
            'Number is outside the payment limits',
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
      if (acknowledgedWarningCodes.length > 100)
        validationIssues.add(
          const PaymentIssue(
            'acknowledgedWarningCodes',
            'count',
            'Payment list is empty or exceeds its limit',
          ),
        );
    }
    {
      if (acknowledgedWarningCodes.any(
        (item) => item.trim().isEmpty || item.length > 200,
      ))
        validationIssues.add(
          const PaymentIssue(
            'acknowledgedWarningCodes',
            'text',
            'Use bounded nonempty list text',
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
    if (revision < 1 || quoteRevision < 1 || !expiresAt.isAfter(reviewedAt))
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
    "quoteId": quoteId,
    "quoteRevision": quoteRevision,
    "total": total.toJson(),
    "reviewedAt": reviewedAt.toUtc().toIso8601String(),
    "expiresAt": expiresAt.toUtc().toIso8601String(),
    "acknowledgedWarningCodes": acknowledgedWarningCodes,
    "revision": revision,
  };

  @override
  bool operator ==(Object other) =>
      other is PaymentCheckoutReview &&
      PaymentCodec.same(toJson(), other.toJson());
  @override
  int get hashCode => PaymentCodec.digest(toJson()).hashCode;
  @override
  String toString() => 'PaymentCheckoutReview(redacted)';
}
