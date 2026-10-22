import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

/// Reads JSON this app saved under [key], or [fallback] if it is missing or
/// no longer parses.
T readJson<T>(SharedPreferences prefs, String key, T fallback,
    T Function(dynamic json) parse) {
  final raw = prefs.getString(key);
  if (raw == null) return fallback;
  try {
    return parse(jsonDecode(raw));
  } catch (_) {
    return fallback; // corrupt or old-format data must not crash startup
  }
}

void writeJson(SharedPreferences prefs, String key, Object value) =>
    prefs.setString(key, jsonEncode(value));

List<Map<String, String>> parseExercises(dynamic json) =>
    [for (final e in json as List) Map<String, String>.from(e as Map)];
