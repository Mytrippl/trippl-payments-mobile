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

Future initStripe() async {
  Stripe.publishableKey =
      'pk_live_51NCX67E0VA6PEbBpET231QFlH0voW8XXX3fbAzXDf21yErjDuQ5nLwrbJ3NTapJhXo01mQpFHcOzUjWkPcQScYI800drYuAoz5';

  Stripe.instance.applySettings();
}
