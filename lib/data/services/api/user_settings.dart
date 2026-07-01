import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserSettings extends ChangeNotifier {
  static final UserSettings _instance = UserSettings._internal();
  factory UserSettings() => _instance;
  UserSettings._internal();

  static const String _keyTargetLanguage = 'target_language';
  static const String _keyAppLanguage = 'app_language';
  static const String _keyDarkMode = 'dark_mode';
  static const String _keyEnabledMarkets = 'enabled_markets';
  static const String _keyCurrency = 'currency';

  Future<String> getTargetLanguage() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyTargetLanguage) ?? ''; // '' = English
  }

  Future<void> setTargetLanguage(String languageCode) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyTargetLanguage, languageCode);
    notifyListeners(); 
  }

  // app language
  Future<String> getAppLanguage() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyAppLanguage) ?? 'en';
  }

  Future<void> setAppLanguage(String code) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyAppLanguage, code);
    notifyListeners();
  }

  // Dark mode
  Future<String> getThemeMode() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyDarkMode) ?? 'dark';
  }

  Future<void> setThemeMode(String mode) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyDarkMode, mode);
    notifyListeners();
  }

  // Enabled markets
  Future<Set<String>> getEnabledMarkets() async {
    final prefs = await SharedPreferences.getInstance();
    final str = prefs.getString(_keyEnabledMarkets) ?? 'cardmarket,tcgplayer,coolstuffinc,ebay,amazon';
    return str.split(',').toSet();
  }

  Future<void> setEnabledMarkets(Set<String> markets) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyEnabledMarkets, markets.join(','));
    notifyListeners();
  }

  // Currency
  Future<String> getCurrency() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyCurrency) ?? 'EUR';
  }

  Future<void> setCurrency(String currency) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyCurrency, currency);
    notifyListeners();
  }
}