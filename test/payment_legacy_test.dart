import 'package:test/test.dart';
import 'legacy/is_stripe_payment_success.dart' as marker;
import 'legacy/is_stripe_payment_success_u_r_l.dart' as success;
import 'legacy/is_stripe_payment_cancel_u_r_l.dart' as cancel;
import 'legacy/convert_to_stripe_amount.dart' as amount;
import 'legacy/payment_intent_status.dart' as status;

void main() {
  test('legacy marker matches an exact query parameter', () {
    expect(
      marker.isStripePaymentSuccess(
        'https://mytrippl.com/return?status=success',
      ),
      isTrue,
    );
    for (final url in [
      'https://mytrippl.com/return?status=successful',
      'https://mytrippl.com/return?next=status=success',
      'https://mytrippl.com/return?status=success&status=cancel',
      'javascript:status=success',
    ]) {
      expect(marker.isStripePaymentSuccess(url), isFalse);
    }
  });
  test(
    'legacy success and cancel paths cannot match inside unrelated URLs',
    () {
      expect(
        success.isStripePaymentSuccessURL(
          'https://mytrippl.com/stripe-payment-success',
        ),
        isTrue,
      );
      expect(
        cancel.isStripePaymentCancelURL(
          'mytrippl://payments/stripe-payment-cancel',
        ),
        isTrue,
      );
      expect(
        success.isStripePaymentSuccessURL(
          'https://mytrippl.com/stripe-payment-success-evil',
        ),
        isFalse,
      );
      expect(
        cancel.isStripePaymentCancelURL(
          'https://mytrippl.com/page?next=/stripe-payment-cancel',
        ),
        isFalse,
      );
    },
  );
  test('existing conversion interface retains ordinary GBP and JPY values', () {
    expect(amount.convertToStripeAmount(12.5, 'GBP'), 1250);
    expect(amount.convertToStripeAmount(12, 'JPY'), 12);
  });
  test('legacy processing is not paid', () {
    expect(status.isPaymentIntentSuccessful('processing'), isFalse);
    expect(status.isPaymentIntentSuccessful('succeeded'), isTrue);
  });
}
