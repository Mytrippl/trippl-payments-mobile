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

// Navigation marker only. Confirm the payment through the backend.
bool isStripePaymentSuccessURL(String currentUrl) {
  final uri = Uri.tryParse(currentUrl);
  return uri != null &&
      {'https', 'mytrippl'}.contains(uri.scheme) &&
      uri.host.isNotEmpty && uri.userInfo.isEmpty &&
      uri.path == '/stripe-payment-success';
}
