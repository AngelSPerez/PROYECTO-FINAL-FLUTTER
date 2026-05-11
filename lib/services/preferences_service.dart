import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PreferencesService {
  PreferencesService._();

  static const _themeKey = 'theme_mode';
  static const _langKey = 'language';
  static late SharedPreferences _prefs;

  static Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  static ThemeMode getThemeMode() {
    switch (_prefs.getString(_themeKey)) {
      case 'dark':
        return ThemeMode.dark;
      case 'system':
        return ThemeMode.system;
      default:
        return ThemeMode.light;
    }
  }

  static Future<void> setThemeMode(ThemeMode mode) async {
    final val = switch (mode) {
      ThemeMode.dark => 'dark',
      ThemeMode.system => 'system',
      _ => 'light',
    };
    await _prefs.setString(_themeKey, val);
  }

  static String getLanguage() => _prefs.getString(_langKey) ?? 'en';

  static Future<void> setLanguage(String lang) async {
    await _prefs.setString(_langKey, lang);
  }
}
