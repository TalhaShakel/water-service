import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class SharedPref {

  remove(String key) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.remove(key);
  }

  static savePreferenceValue(String key, Object value) async {
    final prefs = await SharedPreferences.getInstance();
    if (value is String) {
      prefs.setString(key, value);
    } else if (value is int) {
      prefs.setInt(key, value);
    } else if (value is double) {
      prefs.setDouble(key, value);
    } else if (value is bool) {
      prefs.setBool(key, value);
    } else if (value is List<String>) {
      prefs.setStringList(key, value);
    } else {
      prefs.setString(key, json.encode(value));
    }
  }

  static Future<dynamic> readPreferenceValue(String key, PrefEnum value) async {
    final prefs = await SharedPreferences.getInstance();
    switch (value) {
      case PrefEnum.STRING:
         return prefs.getString(key);
      case PrefEnum.INT:
        return prefs.getInt(key) ?? 0;
      case PrefEnum.DOUBLE:
        return prefs.getDouble(key) ?? 0.0;
      case PrefEnum.BOOL:
        return prefs.getBool(key) ?? false;
      case PrefEnum.LIST:
        return (prefs.getStringList(key) ?? List<String>());
      case PrefEnum.MODEL:
        return json.decode(prefs.getString(key));
      default:
        break;
    }
  }
}

enum PrefEnum { STRING, INT, DOUBLE, BOOL, LIST, MODEL }
