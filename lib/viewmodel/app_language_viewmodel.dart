import 'package:flutter/material.dart';
import 'package:yu_gi_oh_app/data/services/api/user_settings.dart';

class AppLanguageViewmodel extends ChangeNotifier {
  Locale _appLanguage = const Locale('en');
  final UserSettings _settings = UserSettings();

  AppLanguageViewmodel() {
    _loadLocale();
  }

  Locale get appLanguage => _appLanguage;

  Future<void> _loadLocale() async {
    final langCode = await _settings.getAppLanguage();
    _appLanguage = Locale(langCode);
    notifyListeners();
  }

  Future<void> setLocale(Locale newAppLanguage) async {
    _appLanguage = newAppLanguage;
    await _settings.setAppLanguage(newAppLanguage.languageCode);
    notifyListeners();
  }
}