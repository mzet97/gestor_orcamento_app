import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zet_gestor_orcamento/database/isar_database.dart';

class SettingsRepository {
  static const String keyDateFormat = 'date_format';
  static const String keyCurrency = 'currency';
  static const String keyLanguage = 'language';
  static const String keyDarkMode = 'dark_mode';
  static const String keyNotifications = 'notifications';
  static const String keyBiometric = 'biometric_auth';
  // Proteção de visualização do salário
  static const String keyProtectSalary = 'protect_salary';
  static const String keySalaryPasscode = 'salary_passcode';

  Future<String?> getString(String key) async {
    if (kIsWeb) {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getString(key);
    }
    return await IsarDatabase().getSetting(key);
  }

  Future<void> setString(String key, String value) async {
    if (kIsWeb) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(key, value);
      return;
    }
    await IsarDatabase().setSetting(key, value);
  }

  Future<bool?> getBool(String key) async {
    final s = await getString(key);
    if (s == null) return null;
    return s == 'true';
  }

  Future<void> setBool(String key, bool value) async {
    await setString(key, value ? 'true' : 'false');
  }

  Future<String> getDateFormatOrDefault() async {
    return (await getString(keyDateFormat)) ?? 'dd/MM/yyyy';
  }

  Future<void> setDateFormat(String pattern) async {
    await setString(keyDateFormat, pattern);
  }
}