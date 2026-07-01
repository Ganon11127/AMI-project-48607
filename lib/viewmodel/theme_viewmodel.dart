import 'package:flutter/material.dart';
import 'package:yu_gi_oh_app/data/services/api/user_settings.dart';

class ThemeViewmodel extends ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.dark;
  final UserSettings _settings = UserSettings();

  ThemeViewmodel() {
    _loadTheme();
  }

  ThemeMode get themeMode => _themeMode;

  Future<void> _loadTheme() async {
    final mode = await _settings.getThemeMode();
    _themeMode = mode == 'light' ? ThemeMode.light : mode == 'dark' ? ThemeMode.dark : ThemeMode.system;
    notifyListeners();
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    _themeMode = mode;
    final modeStr = mode == ThemeMode.light ? 'light' : mode == ThemeMode.dark ? 'dark' : 'system';
    await _settings.setThemeMode(modeStr);
    notifyListeners();
  }
}