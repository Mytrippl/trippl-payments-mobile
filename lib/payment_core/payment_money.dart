import '../trippl_payments_mobile.dart';

class PaymentAmounts {
  static int scale(int decimals) {
    if (decimals < 0 || decimals > 4)
      throw const FormatException('Payment precision outside bounds');
    var n = 1;
    for (var i = 0; i < decimals; i++) n *= 10;
    return n;
  }

  static PaymentMoney parse(
    String text,
    PaymentCurrencyRule rule, {
    required DateTime now,
  }) {
    validateRule(rule, now: now);
    if (text.length > 30 || !RegExp(r'^\d+(?:\.\d+)?$').hasMatch(text))
      throw const FormatException(
        'Use an explicit unsigned decimal payment amount',
      );
    final parts = text.split('.'), fraction = parts.length > 1 ? parts[1] : '';
    if (fraction.length > rule.decimals)
      throw const FormatException('Payment amount has excess precision');
    final whole = int.tryParse(parts[0]);
    if (whole == null || whole > 9000000000000 ~/ scale(rule.decimals))
      throw const FormatException('Payment amount outside range');
    final amount = PaymentMoney(
      currency: rule.currency,
      amountMinor:
          whole * scale(rule.decimals) +
          (fraction.isEmpty
              ? 0
              : int.parse(fraction.padRight(rule.decimals, '0'))),
      decimals: rule.decimals,
    );
    validate(amount, rule, now: now);
    return amount;
  }

  static void validateRule(PaymentCurrencyRule rule, {required DateTime now}) {
    PaymentGuard.record(rule.validate());
    if (!rule.enabled ||
        !rule.serverVerified ||
        !PaymentGuard.fresh(rule.observedAt, rule.expiresAt, now))
      throw StateError('Current server-verified charge currency rule required');
  }

  static void validate(
    PaymentMoney money,
    PaymentCurrencyRule rule, {
    required DateTime now,
    bool allowZero = false,
  }) {
    PaymentGuard.record(money.validate());
    validateRule(rule, now: now);
    if (money.currency != rule.currency ||
        money.decimals != rule.decimals ||
        money.amountMinor % rule.stepMinor != 0 ||
        !allowZero && money.amountMinor == 0 ||
        rule.minimumMinor != null && money.amountMinor < rule.minimumMinor! ||
        rule.maximumMinor != null && money.amountMinor > rule.maximumMinor!)
      throw const FormatException(
        'Payment amount does not match the supplied charge currency rule',
      );
  }

  static void compatible(PaymentMoney a, PaymentMoney b) {
    PaymentGuard.record(a.validate());
    PaymentGuard.record(b.validate());
    if (a.currency != b.currency || a.decimals != b.decimals)
      throw const FormatException(
        'Payment currencies or minor-unit precision differ',
      );
  }

  static PaymentMoney add(PaymentMoney a, PaymentMoney b) {
    compatible(a, b);
    final next = a.copyWith(amountMinor: a.amountMinor + b.amountMinor);
    PaymentGuard.record(next.validate());
    return next;
  }

  static PaymentMoney subtract(PaymentMoney a, PaymentMoney b) {
    compatible(a, b);
    if (b.amountMinor > a.amountMinor)
      throw const FormatException('Payment deductions exceed charges');
    return a.copyWith(amountMinor: a.amountMinor - b.amountMinor);
  }

  static PaymentMoney multiply(PaymentMoney a, int quantity) {
    PaymentGuard.record(a.validate());
    if (quantity < 1 || quantity > 100)
      throw const FormatException('Payment quantity outside limits');
    final next = a.copyWith(amountMinor: a.amountMinor * quantity);
    PaymentGuard.record(next.validate());
    return next;
  }

  static PaymentMoney percent(PaymentMoney a, int basisPoints) {
    PaymentGuard.record(a.validate());
    if (basisPoints < 0 || basisPoints > 10000)
      throw ArgumentError('Percentage outside bounds');
    return a.copyWith(
      amountMinor:
          (a.amountMinor ~/ 10000) * basisPoints +
          (a.amountMinor % 10000) * basisPoints ~/ 10000,
    );
  }

  static List<PaymentMoney> split(PaymentMoney total, int parts) {
    PaymentGuard.record(total.validate());
    if (parts < 1 || parts > 100)
      throw ArgumentError('Payment split outside bounds');
    final base = total.amountMinor ~/ parts,
        remainder = total.amountMinor % parts;
    return List.unmodifiable([
      for (var i = 0; i < parts; i++)
        total.copyWith(amountMinor: base + (i < remainder ? 1 : 0)),
    ]);
  }

  static String format(PaymentMoney value, {String language = 'en'}) {
    PaymentGuard.record(value.validate());
    PaymentGuard.language(language);
    final divisor = scale(value.decimals),
        whole = value.amountMinor ~/ divisor,
        fraction = value.amountMinor % divisor;
    return '$whole${value.decimals == 0 ? '' : (language.startsWith('tr') ? ',' : '.') + fraction.toString().padLeft(value.decimals, '0')} ${value.currency}';
  }

  static PaymentCurrencyRule rule(
    PaymentCurrencyCatalog catalog,
    String currency, {
    required String scope,
    required DateTime now,
  }) {
    PaymentGuard.record(catalog.validate());
    PaymentGuard.scope(catalog.scopeFingerprint, scope);
    if (!catalog.serverVerified ||
        !PaymentGuard.fresh(catalog.observedAt, catalog.expiresAt, now))
      throw StateError('Refresh the merchant currency catalog');
    final r =
        catalog.rules.where((r) => r.currency == currency).firstOrNull ??
        (throw StateError('Currency is not enabled for this merchant'));
    validateRule(r, now: now);
    return r;
  }
}
