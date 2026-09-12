import 'dart:convert';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:timeago/timeago.dart' as timeago;
import '/flutter_flow/custom_functions.dart';
import '/flutter_flow/lat_lng.dart';
import '/flutter_flow/place.dart';
import '/flutter_flow/uploaded_file.dart';
import '/backend/backend.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '/backend/schema/structs/index.dart';
import '/backend/schema/enums/enums.dart';
import '/auth/firebase_auth/auth_util.dart';

int stripeAmountFromRetail(dynamic json) {
  if (json == null) return 0;

  dynamic retail = json["retailPrice"];
  if (retail == null) return 0;

  double price;

  if (retail is num) {
    price = retail.toDouble();
  } else {
    price = double.tryParse(retail.toString()) ?? 0;
  }

  // Convert to smallest currency unit (cents, kuruş, etc.)
  int amountInSmallestUnit = (price * 100).round();

  return amountInSmallestUnit;
}
