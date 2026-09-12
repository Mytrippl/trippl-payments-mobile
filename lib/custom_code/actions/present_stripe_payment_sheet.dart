// Automatic FlutterFlow imports
import '/backend/backend.dart';
import '/backend/schema/structs/index.dart';
import '/backend/schema/enums/enums.dart';
import '/actions/actions.dart' as action_blocks;
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/custom_code/actions/index.dart'; // Imports other custom actions
import '/flutter_flow/custom_functions.dart'; // Imports custom functions
import 'package:flutter/material.dart';
// Begin custom action code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

import 'package:flutter_stripe/flutter_stripe.dart';

Future<bool> presentStripePaymentSheet(
  String clientSecret,
  String customerId,
  String ephemeralKey,
  String merchantName,
) async {
  try {
    await Stripe.instance.initPaymentSheet(
      paymentSheetParameters: SetupPaymentSheetParameters(
        paymentIntentClientSecret: clientSecret,
        merchantDisplayName: merchantName,

        // ✅ Required for saved cards
        customerId: customerId,
        customerEphemeralKeySecret: ephemeralKey,

        // ✅ Automatic system dark/light
        style: ThemeMode.system,

        // ✅ Remove billing address
        billingDetailsCollectionConfiguration:
            BillingDetailsCollectionConfiguration(
          name: CollectionMode.never,
          email: CollectionMode.never,
          phone: CollectionMode.never,
          address: AddressCollectionMode.never,
        ),

        // ✅ Apple Pay
        applePay: const PaymentSheetApplePay(
          merchantCountryCode: 'GB',
        ),

        // ✅ Google Pay
        googlePay: const PaymentSheetGooglePay(
          merchantCountryCode: 'GB',
          currencyCode: 'GBP',
          testEnv: false,
        ),

        // ✅ Minimal appearance (safe version for FlutterFlow)
        appearance: const PaymentSheetAppearance(
          colors: PaymentSheetAppearanceColors(
            primary: Color(0xFFFE6B40),
          ),
          shapes: PaymentSheetShape(
            borderRadius: 15,
          ),
        ),
      ),
    );

    await Stripe.instance.presentPaymentSheet();
    return true;
  } catch (e) {
    print("STRIPE ERROR: $e");
    rethrow;
  }
}
