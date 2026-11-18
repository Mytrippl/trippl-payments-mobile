// Generated typed payment records. Edit tool/payment_models.json and regenerate.
import '../payment_codec.dart';
import '../payment_issue.dart';
import 'money.dart';

class PaymentLedgerEntry {
  PaymentLedgerEntry({
    required this.id,
    required this.scopeFingerprint,
    required this.environment,
    required this.orderId,
    required this.occurredAt,
    required this.kind,
    required this.direction,
    required this.amount,
    required this.referenceId,
    required this.sequence,
    this.posted = false,
    this.serverVerified = false,
  });

  final String id;
  final String scopeFingerprint;
  final String environment;
  final String orderId;
  final DateTime occurredAt;
  final String kind;
  final String direction;
  final PaymentMoney amount;
  final String referenceId;
  final int sequence;
  final bool posted;
  final bool serverVerified;

  factory PaymentLedgerEntry.fromJson(Map<String, Object?> json) {
    PaymentCodec.keys(json, {
      "id",
      "scopeFingerprint",
      "environment",
      "orderId",
      "occurredAt",
      "kind",
      "direction",
      "amount",
      "referenceId",
      "sequence",
      "posted",
      "serverVerified",
    });
    final value = PaymentLedgerEntry(
      id: PaymentCodec.text(json, 'id', required: true)!,
      scopeFingerprint: PaymentCodec.text(
        json,
        'scopeFingerprint',
        required: true,
      )!,
      environment: PaymentCodec.text(json, 'environment', required: true)!,
      orderId: PaymentCodec.text(json, 'orderId', required: true)!,
      occurredAt: PaymentCodec.date(json, 'occurredAt', required: true)!,
      kind: PaymentCodec.text(json, 'kind', required: true)!,
      direction: PaymentCodec.text(json, 'direction', required: true)!,
      amount: (json['amount'] == null
          ? null
          : PaymentMoney.fromJson(PaymentCodec.object(json['amount'])))!,
      referenceId: PaymentCodec.text(json, 'referenceId', required: true)!,
      sequence: PaymentCodec.integer(
        json,
        'sequence',
        required: true,
        minimum: 0,
        maximum: 9000000000000,
      )!,
      posted: PaymentCodec.boolean(json, 'posted') ?? false,
      serverVerified: PaymentCodec.boolean(json, 'serverVerified') ?? false,
    );
    final issues = value.validate();
    if (issues.any((i) => i.severity == PaymentSeverity.error))
      throw PaymentValidationException(issues);
    return value;
  }

  static PaymentResult<PaymentLedgerEntry> tryDecode(Object? input) {
    try {
      return PaymentResult(
        value: PaymentLedgerEntry.fromJson(PaymentCodec.object(input)),
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

  PaymentLedgerEntry copyWith({
    Set<String> clear = const {},
    String? id,
    String? scopeFingerprint,
    String? environment,
    String? orderId,
    DateTime? occurredAt,
    String? kind,
    String? direction,
    PaymentMoney? amount,
    String? referenceId,
    int? sequence,
    bool? posted,
    bool? serverVerified,
  }) {
    final clearableFields = <String>{};
    if (clear.any((key) => !clearableFields.contains(key)))
      throw const FormatException('Only optional fields may be cleared');
    return PaymentLedgerEntry(
      id: (id ?? this.id),
      scopeFingerprint: (scopeFingerprint ?? this.scopeFingerprint),
      environment: (environment ?? this.environment),
      orderId: (orderId ?? this.orderId),
      occurredAt: (occurredAt ?? this.occurredAt),
      kind: (kind ?? this.kind),
      direction: (direction ?? this.direction),
      amount: (amount ?? this.amount),
      referenceId: (referenceId ?? this.referenceId),
      sequence: (sequence ?? this.sequence),
      posted: (posted ?? this.posted),
      serverVerified: (serverVerified ?? this.serverVerified),
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
      if (orderId.trim().isEmpty || orderId.length > 4000)
        validationIssues.add(
          const PaymentIssue('orderId', 'text', 'Use nonempty bounded text'),
        );
    }
    {
      if (kind.trim().isEmpty || kind.length > 4000)
        validationIssues.add(
          const PaymentIssue('kind', 'text', 'Use nonempty bounded text'),
        );
    }
    {
      if (direction.trim().isEmpty || direction.length > 4000)
        validationIssues.add(
          const PaymentIssue('direction', 'text', 'Use nonempty bounded text'),
        );
    }
    {
      for (final issue in amount.validate())
        validationIssues.add(
          PaymentIssue(
            'amount.${issue.field}',
            issue.code,
            issue.message,
            severity: issue.severity,
          ),
        );
    }
    {
      if (referenceId.trim().isEmpty || referenceId.length > 4000)
        validationIssues.add(
          const PaymentIssue(
            'referenceId',
            'text',
            'Use nonempty bounded text',
          ),
        );
    }
    {
      if (sequence < 0 || sequence > 9000000000000)
        validationIssues.add(
          const PaymentIssue(
            'sequence',
            'range',
            'Number is outside the payment limits',
          ),
        );
    }
    if (!{'test', 'live'}.contains(environment) ||
        sequence < 1 ||
        !{'charge', 'refund', 'credit', 'adjustment'}.contains(kind) ||
        !{'debit', 'credit'}.contains(direction))
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
    "orderId": orderId,
    "occurredAt": occurredAt.toUtc().toIso8601String(),
    "kind": kind,
    "direction": direction,
    "amount": amount.toJson(),
    "referenceId": referenceId,
    "sequence": sequence,
    "posted": posted,
    "serverVerified": serverVerified,
  };

  @override
  bool operator ==(Object other) =>
      other is PaymentLedgerEntry &&
      PaymentCodec.same(toJson(), other.toJson());
  @override
  int get hashCode => PaymentCodec.digest(toJson()).hashCode;
  @override
  String toString() => 'PaymentLedgerEntry(redacted)';
}
