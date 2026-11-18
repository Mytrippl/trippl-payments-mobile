import 'dart:convert';
import 'package:crypto/crypto.dart';

class PaymentCodec {
  static const maximumJsonBytes = 1000000;
  static String? verbatim(
    Map<String, Object?> json,
    String key, {
    bool required = false,
  }) {
    final value = json[key];
    if (value == null) {
      if (required) throw FormatException('$key is required');
      return null;
    }
    if (value is! String ||
        value.length > 4000 ||
        RegExp(r'[\x00-\x08\x0b\x0c\x0e-\x1f]').hasMatch(value))
      throw FormatException('Invalid $key');
    return value;
  }

  static Map<String, Object?> object(Object? value, {String field = 'record'}) {
    if (value is! Map || value.keys.any((k) => k is! String))
      throw FormatException('$field must be a JSON object');
    return Map<String, Object?>.from(value);
  }

  static Map<String, Object?> decode(
    String source, {
    int maximumBytes = maximumJsonBytes,
  }) {
    if (utf8.encode(source).length > maximumBytes)
      throw const FormatException('Payment JSON is too large');
    return object(jsonDecode(source));
  }

  static void keys(Map<String, Object?> json, Set<String> allowed) {
    if (json.keys.any((k) => !allowed.contains(k)))
      throw const FormatException('Unknown canonical payment field');
  }

  static String? text(
    Map<String, Object?> json,
    String key, {
    bool required = false,
    int maximum = 4000,
  }) {
    final v = json[key];
    if (v == null) {
      if (required) throw FormatException('$key is required');
      return null;
    }
    if (v is! String ||
        v.length > maximum ||
        RegExp(r'[\x00-\x08\x0b\x0c\x0e-\x1f]').hasMatch(v))
      throw FormatException('Invalid $key');
    final text = v.trim();
    if (required && text.isEmpty) throw FormatException('$key is required');
    return text;
  }

  static int? integer(
    Map<String, Object?> json,
    String key, {
    bool required = false,
    int? minimum,
    int? maximum,
  }) {
    final v = json[key];
    if (v == null) {
      if (required) throw FormatException('$key is required');
      return null;
    }
    if (v is! int ||
        minimum != null && v < minimum ||
        maximum != null && v > maximum)
      throw FormatException('Invalid integer $key');
    return v;
  }

  static double? decimal(
    Map<String, Object?> json,
    String key, {
    bool required = false,
  }) {
    final v = json[key];
    if (v == null) {
      if (required) throw FormatException('$key is required');
      return null;
    }
    if (v is! num || !v.isFinite) throw FormatException('Invalid number $key');
    return v.toDouble();
  }

  static bool? boolean(
    Map<String, Object?> json,
    String key, {
    bool required = false,
  }) {
    final v = json[key];
    if (v == null) {
      if (required) throw FormatException('$key is required');
      return null;
    }
    if (v is! bool) throw FormatException('Invalid boolean $key');
    return v;
  }

  static DateTime? date(
    Map<String, Object?> json,
    String key, {
    bool required = false,
    bool calendar = false,
  }) {
    final text = PaymentCodec.text(json, key, required: required);
    if (text == null) return null;
    if (calendar && !RegExp(r'^\d{4}-\d{2}-\d{2}$').hasMatch(text) ||
        !calendar && !RegExp(r'(Z|[+-]\d{2}:\d{2})$').hasMatch(text))
      throw FormatException('$key needs an explicit date or time offset');
    if (!calendar) {
      final match = RegExp(
        r'^(\d{4})-(\d{2})-(\d{2})T(\d{2}):(\d{2}):(\d{2})(?:\.\d{1,6})?(Z|[+-]\d{2}:\d{2})$',
      ).firstMatch(text);
      if (match == null)
        throw FormatException('Use a bounded ISO instant for $key');
      final year = int.parse(match.group(1)!),
          month = int.parse(match.group(2)!),
          day = int.parse(match.group(3)!);
      if (calendarText(DateTime.utc(year, month, day)) !=
              text.substring(0, 10) ||
          int.parse(match.group(4)!) > 23 ||
          int.parse(match.group(5)!) > 59 ||
          int.parse(match.group(6)!) > 59) {
        throw FormatException('Invalid clock or calendar components for $key');
      }
      final zone = match.group(7)!;
      if (zone != 'Z') {
        final hours = int.parse(zone.substring(1, 3)),
            minutes = int.parse(zone.substring(4, 6));
        if (hours > 14 || minutes > 59 || hours == 14 && minutes != 0)
          throw FormatException('Invalid UTC offset for $key');
      }
    }
    final date = DateTime.tryParse(text);
    if (date == null) throw FormatException('Invalid date $key');
    if (calendar && calendarText(date) != text)
      throw FormatException('Invalid calendar date $key');
    return calendar
        ? DateTime.utc(date.year, date.month, date.day)
        : date.toUtc();
  }

  static String calendarText(DateTime value) =>
      '${value.year.toString().padLeft(4, '0')}-${value.month.toString().padLeft(2, '0')}-${value.day.toString().padLeft(2, '0')}';
  static List<T>? list<T>(
    Map<String, Object?> json,
    String key,
    T Function(Object?) read, {
    bool required = false,
    int maximum = 100,
  }) {
    final v = json[key];
    if (v == null) {
      if (required) throw FormatException('$key is required');
      return null;
    }
    if (v is! List || v.length > maximum)
      throw FormatException('Invalid list $key');
    return List.unmodifiable(v.map(read));
  }

  static List<String>? strings(Map<String, Object?> json, String key) =>
      list(json, key, (v) {
        if (v is! String || v.length > 200)
          throw FormatException('Invalid $key value');
        return v;
      });
  static Object? canonical(Object? v) {
    if (v is Map) {
      final keys = v.keys.cast<String>().toList()..sort();
      return {for (final key in keys) key: canonical(v[key])};
    }
    if (v is List) return v.map(canonical).toList();
    if (v is DateTime) return v.toUtc().toIso8601String();
    return v;
  }

  static String digest(Object? value) =>
      sha256.convert(utf8.encode(jsonEncode(canonical(value)))).toString();
  static bool same(Object? a, Object? b) =>
      jsonEncode(canonical(a)) == jsonEncode(canonical(b));
}
