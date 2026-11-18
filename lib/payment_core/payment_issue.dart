enum PaymentSeverity { error, warning, information }

class PaymentIssue {
  const PaymentIssue(
    this.field,
    this.code,
    this.message, {
    this.severity = PaymentSeverity.error,
  });
  final String field, code, message;
  final PaymentSeverity severity;
  Map<String, Object?> toJson() => {
    'field': field,
    'code': code,
    'message': message,
    'severity': severity.name,
  };
  @override
  bool operator ==(Object other) =>
      other is PaymentIssue &&
      other.field == field &&
      other.code == code &&
      other.message == message &&
      other.severity == severity;
  @override
  int get hashCode => Object.hash(field, code, message, severity);
  @override
  String toString() => '$field: $message';
}

class PaymentValidationException implements Exception {
  PaymentValidationException(Iterable<PaymentIssue> issues)
    : issues = List.unmodifiable(issues);
  final List<PaymentIssue> issues;
  @override
  String toString() => issues.map((i) => i.message).join('; ');
}

class PaymentResult<T> {
  PaymentResult({this.value, Iterable<PaymentIssue> issues = const []})
    : issues = List.unmodifiable(issues);
  final T? value;
  final List<PaymentIssue> issues;
  bool get isSuccess =>
      value != null && !issues.any((i) => i.severity == PaymentSeverity.error);
  T require() {
    if (!isSuccess) throw PaymentValidationException(issues);
    return value as T;
  }

  PaymentResult<R> map<R>(R Function(T value) transform) => isSuccess
      ? PaymentResult(value: transform(value as T), issues: issues)
      : PaymentResult(issues: issues);
}
