import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class SharePreferencesService {
  static SharedPreferences? prefs;

  static Future<void> init() async {
    prefs = await SharedPreferences.getInstance();
  }

  static Future<void> setString(String key, Object value) async {
    await prefs?.setString(key, jsonEncode(value));
  }

  static String? getString(String key) {
    final String? action = prefs?.getString(key);
    return action;
  }

  static Future<void> remove(String key) async {
    await prefs?.remove(key);
  }
}
