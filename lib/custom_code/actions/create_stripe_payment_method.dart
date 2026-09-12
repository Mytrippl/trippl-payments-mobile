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

// Stripe import
import 'package:flutter_stripe/flutter_stripe.dart';

Future<String?> createStripePaymentMethod() async {
  try {
    final paymentMethod = await Stripe.instance.createPaymentMethod(
      params: PaymentMethodParams.card(
        paymentMethodData: PaymentMethodData(), // ✅ required in your version
      ),
    );

    return paymentMethod.id; // e.g. "pm_12345"
  } catch (e) {
    debugPrint('Stripe createPaymentMethod error: $e');
    return null;
  }
}
