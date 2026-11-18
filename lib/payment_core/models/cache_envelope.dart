// Generated typed payment records. Edit tool/payment_models.json and regenerate.
import '../payment_codec.dart';
import '../payment_issue.dart';
import 'account_snapshot.dart';

class PaymentCacheEnvelope {
  PaymentCacheEnvelope({
    required this.keyFingerprint,
    required this.scopeFingerprint,
    required this.environment,
    required this.snapshot,
    required this.storedAt,
    required this.expiresAt,
    required this.digest,
    this.schemaVersion = 1,
    this.offline = true,
  });

  final String keyFingerprint;
  final String scopeFingerprint;
  final String environment;
  final PaymentAccountSnapshot snapshot;
  final DateTime storedAt;
  final DateTime expiresAt;
  final String digest;
  final int schemaVersion;
  final bool offline;

  factory PaymentCacheEnvelope.fromJson(Map<String, Object?> json) {
    PaymentCodec.keys(json, {
      "keyFingerprint",
      "scopeFingerprint",
      "environment",
      "snapshot",
      "storedAt",
      "expiresAt",
      "digest",
      "schemaVersion",
      "offline",
    });
    final value = PaymentCacheEnvelope(
      keyFingerprint: PaymentCodec.text(
        json,
        'keyFingerprint',
        required: true,
      )!,
      scopeFingerprint: PaymentCodec.text(
        json,
        'scopeFingerprint',
        required: true,
      )!,
      environment: PaymentCodec.text(json, 'environment', required: true)!,
      snapshot: (json['snapshot'] == null
          ? null
          : PaymentAccountSnapshot.fromJson(
              PaymentCodec.object(json['snapshot']),
            ))!,
      storedAt: PaymentCodec.date(json, 'storedAt', required: true)!,
      expiresAt: PaymentCodec.date(json, 'expiresAt', required: true)!,
      digest: PaymentCodec.text(json, 'digest', required: true)!,
      schemaVersion:
          PaymentCodec.integer(
            json,
            'schemaVersion',
            minimum: 0,
            maximum: 9000000000000,
          ) ??
          1,
      offline: PaymentCodec.boolean(json, 'offline') ?? true,
    );
    final issues = value.validate();
    if (issues.any((i) => i.severity == PaymentSeverity.error))
      throw PaymentValidationException(issues);
    return value;
  }

  static PaymentResult<PaymentCacheEnvelope> tryDecode(Object? input) {
    try {
      return PaymentResult(
        value: PaymentCacheEnvelope.fromJson(PaymentCodec.object(input)),
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

  PaymentCacheEnvelope copyWith({
    Set<String> clear = const {},
    String? keyFingerprint,
    String? scopeFingerprint,
    String? environment,
    PaymentAccountSnapshot? snapshot,
    DateTime? storedAt,
    DateTime? expiresAt,
    String? digest,
    int? schemaVersion,
    bool? offline,
  }) {
    final clearableFields = <String>{};
    if (clear.any((key) => !clearableFields.contains(key)))
      throw const FormatException('Only optional fields may be cleared');
    return PaymentCacheEnvelope(
      keyFingerprint: (keyFingerprint ?? this.keyFingerprint),
      scopeFingerprint: (scopeFingerprint ?? this.scopeFingerprint),
      environment: (environment ?? this.environment),
      snapshot: (snapshot ?? this.snapshot),
      storedAt: (storedAt ?? this.storedAt),
      expiresAt: (expiresAt ?? this.expiresAt),
      digest: (digest ?? this.digest),
      schemaVersion: (schemaVersion ?? this.schemaVersion),
      offline: (offline ?? this.offline),
    );
  }

  List<PaymentIssue> validate() {
    final validationIssues = <PaymentIssue>[];
    {
      if (keyFingerprint.trim().isEmpty || keyFingerprint.length > 4000)
        validationIssues.add(
          const PaymentIssue(
            'keyFingerprint',
            'text',
            'Use nonempty bounded text',
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
      for (final issue in snapshot.validate())
        validationIssues.add(
          PaymentIssue(
            'snapshot.${issue.field}',
            issue.code,
            issue.message,
            severity: issue.severity,
          ),
        );
    }
    {
      if (digest.trim().isEmpty || digest.length > 4000)
        validationIssues.add(
          const PaymentIssue('digest', 'text', 'Use nonempty bounded text'),
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
    if (!{'test', 'live'}.contains(environment) ||
        schemaVersion != 1 ||
        !expiresAt.isAfter(storedAt) ||
        !offline)
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
    "keyFingerprint": keyFingerprint,
    "scopeFingerprint": scopeFingerprint,
    "environment": environment,
    "snapshot": snapshot.toJson(),
    "storedAt": storedAt.toUtc().toIso8601String(),
    "expiresAt": expiresAt.toUtc().toIso8601String(),
    "digest": digest,
    "schemaVersion": schemaVersion,
    "offline": offline,
  };

  @override
  bool operator ==(Object other) =>
      other is PaymentCacheEnvelope &&
      PaymentCodec.same(toJson(), other.toJson());
  @override
  int get hashCode => PaymentCodec.digest(toJson()).hashCode;
  @override
  String toString() => 'PaymentCacheEnvelope(redacted)';
}
