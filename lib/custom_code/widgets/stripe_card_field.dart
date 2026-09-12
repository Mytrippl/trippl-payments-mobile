// Automatic FlutterFlow imports
import '/backend/backend.dart';
import '/backend/schema/structs/index.dart';
import '/backend/schema/enums/enums.dart';
import '/actions/actions.dart' as action_blocks;
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/custom_code/widgets/index.dart'; // Imports other custom widgets
import '/custom_code/actions/index.dart'; // Imports custom actions
import '/flutter_flow/custom_functions.dart'; // Imports custom functions
import 'package:flutter/material.dart';
// Begin custom widget code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

import 'package:flutter_stripe/flutter_stripe.dart';

class StripeCardField extends StatefulWidget {
  const StripeCardField({
    super.key,
    this.width,
    this.height,
    required this.isDarkMode,
    required this.locale,
  });

  final double? width;
  final double? height;
  final bool isDarkMode;
  final String locale;

  @override
  State<StripeCardField> createState() => _StripeCardFieldState();
}

class _StripeCardFieldState extends State<StripeCardField> {
  @override
  Widget build(BuildContext context) {
    const lightBackground = Color(0xFFFFE8E1);
    const lightShadow = Color(0xFFF5D3C8);

    const darkBackground = Color(0xFF222222);
    const darkShadow = Color(0xFF000000);

    final background = widget.isDarkMode ? darkBackground : lightBackground;

    final shadow = widget.isDarkMode ? darkShadow : lightShadow;

    return Container(
      width: widget.width ?? double.infinity,
      height: widget.height ?? 56,
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: shadow,
            blurRadius: 0,
            spreadRadius: 0,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Center(
        child: CardField(
          enablePostalCode: false,
          decoration: const InputDecoration(
            border: InputBorder.none,
          ),
          onCardChanged: (card) {
            final complete = card?.complete ?? false;
            FFAppState().isCardComplete = complete;
            FFAppState().update(() {});
          },
        ),
      ),
    );
  }
}
