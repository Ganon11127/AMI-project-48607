import 'package:flutter/material.dart';
import 'package:yu_gi_oh_app/data/services/api/user_settings.dart';
import 'package:yu_gi_oh_app/data/services/api/local_data_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum UpdateStatus { idle, checking, success, already, error }

class SettingsViewModel extends ChangeNotifier {
  final UserSettings _settings = UserSettings();

  // Settings
  String _appLanguage = 'en';
  String _cardTranslation = '';
  String _themeMode = 'dark';
  Set<String> _enabledMarkets = {};
  String _currency = 'EUR';

  // DB update state
  String _dbVersion = '';
  String _lastUpdate = '';
  UpdateStatus _updateStatus = UpdateStatus.idle;
  String _errorMessage = '';

  // Getters
  String get appLanguage => _appLanguage;
  String get cardTranslation => _cardTranslation;
  String get themeMode => _themeMode;
  Set<String> get enabledMarkets => _enabledMarkets;
  String get currency => _currency;
  String get dbVersion => _dbVersion;
  String get lastUpdate => _lastUpdate;
  UpdateStatus get updateStatus => _updateStatus;
  String get errorMessage => _errorMessage;

  SettingsViewModel() {
    loadSettings();
    _loadDbInfo();
  }

  Future<void> loadSettings() async {
    _appLanguage = await _settings.getAppLanguage();
    _cardTranslation = await _settings.getTargetLanguage();
    _themeMode = await _settings.getThemeMode();
    _enabledMarkets = await _settings.getEnabledMarkets();
    _currency = await _settings.getCurrency();
    notifyListeners();
  }

  Future<void> setAppLanguage(String code) async {
    _appLanguage = code;
    await _settings.setAppLanguage(code);
    notifyListeners();
  }

  Future<void> setCardTranslation(String code) async {
    _cardTranslation = code;
    await _settings.setTargetLanguage(code);
    notifyListeners();
  }

  Future<void> setThemeMode(String mode) async {
    _themeMode = mode;
    await _settings.setThemeMode(mode);
    notifyListeners();
  }

  Future<void> toggleMarket(String market) async {
    if (_enabledMarkets.contains(market)) {
      _enabledMarkets.remove(market);
    } else {
      _enabledMarkets.add(market);
    }
    await _settings.setEnabledMarkets(_enabledMarkets);
    notifyListeners();
  }

  Future<void> setCurrency(String currency) async {
    _currency = currency;
    await _settings.setCurrency(currency);
    notifyListeners();
  }

  // ==== Database Update ====
  Future<void> _loadDbInfo() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      _dbVersion = prefs.getString(LocalDataService.keyLocalDbVersion) ?? 'unknown';
      _lastUpdate = prefs.getString(LocalDataService.keyLastUpdateDate) ?? 'unknown';
      notifyListeners();
    } catch (e) {
      _dbVersion = 'error';
      _lastUpdate = 'error';
      notifyListeners();
    }
  }

  Future<void> checkForUpdates() async {
    if (_updateStatus == UpdateStatus.checking) return;

    _updateStatus = UpdateStatus.checking;
    _errorMessage = '';
    notifyListeners();

    try {
      final updated = await LocalDataService().updateLocalDb();
      await _loadDbInfo();
      _updateStatus = updated ? UpdateStatus.success : UpdateStatus.already;
    } catch (e) {
      _updateStatus = UpdateStatus.error;
      _errorMessage = e.toString();
    } finally {
      notifyListeners();
    }
  }
}