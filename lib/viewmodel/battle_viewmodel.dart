import 'dart:async';
import 'package:flutter/material.dart';

import '../data/services/sensors/sensor_service.dart';

class BattleViewModel extends ChangeNotifier {
  /// It only allows 2 players, most of the game modes in yugioh are 2 player only,
  /// although there are some games where it allows for more than 2 players.
  /// For other card game this would need to be fully rebuilt, because right now it's "hard coded"
  /// for yugioh due to time restraints.
  
  final SensorService _sensorService;
  StreamSubscription<ShakeEvent>? _shakeSubscription;

  // ===== Life Points and Buffers =====
  int _player1LP = 8000;
  int _player2LP = 8000;
  int _player1Buffer = 0;
  int _player2Buffer = 0;

  // ===== UI State =====
  int _rotationQuarterTurns = 0;
  bool _showBottomNav = true;

  // ===== Results =====
  int? _diceResult;
  String? _coinResult;

  // ===== Calculator State =====
  int? _calculatorPlayerId;
  String _calculatorOperation = '';

  BattleViewModel(this._sensorService);

  // ===== Getters =====
  int get player1LP => _player1LP;
  int get player2LP => _player2LP;
  int get player1Buffer => _player1Buffer;
  int get player2Buffer => _player2Buffer;
  int get rotationQuarterTurns => _rotationQuarterTurns;
  bool get showBottomNav => _showBottomNav;
  int? get diceResult => _diceResult;
  String? get coinResult => _coinResult;
  bool get isCalculatorOpen => _calculatorPlayerId != null;
  String get calculatorOperation => _calculatorOperation;
  int get calculatorCurrentLP => _calculatorPlayerId == 1 ? _player1LP : _player2LP;

  // ===== Life Point Management =====
  void addToBuffer(int player, int amount) {
    if (player == 1) {
      _player1Buffer += amount;
    } else {
      _player2Buffer += amount;
    }
    notifyListeners();
  }

  void applyBuffer(int player, {bool isNegative = false}) {
    final signed = isNegative ? -1 : 1;
    if (player == 1) {
      _player1LP = (_player1LP + _player1Buffer * signed).clamp(0, 99999);
      _player1Buffer = 0;
    } else {
      _player2LP = (_player2LP + _player2Buffer * signed).clamp(0, 99999);
      _player2Buffer = 0;
    }
    notifyListeners();
  }

  void clearBuffer(int player) {
    if (player == 1) {
      _player1Buffer = 0;
    } else {
      _player2Buffer = 0;
    }
    notifyListeners();
  }

  void setLP(int player, int value) {
    if (player == 1) {
      _player1LP = value.clamp(0, 99999);
      _player1Buffer = 0;
    } else {
      _player2LP = value.clamp(0, 99999);
      _player2Buffer = 0;
    }
    notifyListeners();
  }

  void resetLP() {
    _player1LP = 8000;
    _player2LP = 8000;
    _player1Buffer = 0;
    _player2Buffer = 0;
    notifyListeners();
  }

  // ===== Rotation and Navigation =====
  void rotateScreen() {
    _rotationQuarterTurns = (_rotationQuarterTurns + 1) % 4;
    notifyListeners();
  }

  void toggleBottomNav() {
    _showBottomNav = !_showBottomNav;
    notifyListeners();
  }

  // ===== Sensor Listening =====
  void startSensorListening() {
    _shakeSubscription?.cancel();
    _shakeSubscription = _sensorService.shakeEvents.listen((event) {
      if (event.type == ShakeEventType.dice) {
        _diceResult = event.diceValue;
        _coinResult = null;
        notifyListeners();
      } else if (event.type == ShakeEventType.coin) {
        _coinResult = event.coinSide;
        _diceResult = null;
        notifyListeners();
      }
    });
    _sensorService.startListening();
  }

  void stopSensorListening() {
    _shakeSubscription?.cancel();
    _shakeSubscription = null;
    _sensorService.stopListening();
  }

  void clearResults() {
    _diceResult = null;
    _coinResult = null;
    notifyListeners();
  }

  // ===== Calculator Logic =====
  void openCalculator(int playerId) {
    _calculatorPlayerId = playerId;
    _calculatorOperation = '';
    notifyListeners();
  }

  void closeCalculator() {
    _calculatorPlayerId = null;
    _calculatorOperation = '';
    notifyListeners();
  }

  void addDigit(String digit) {
    if (_calculatorPlayerId == null) return;
    if (_calculatorOperation.isEmpty) {
      _calculatorOperation = '-$digit';
    } else {
      _calculatorOperation += digit;
    }
    notifyListeners();
  }

  void addOperator(String op) {
    if (_calculatorPlayerId == null) return;
    if (_calculatorOperation.isEmpty) {
      _calculatorOperation = op;
      notifyListeners();
      return;
    }
    if (!_calculatorOperation.endsWith('+') && !_calculatorOperation.endsWith('-')) {
      _calculatorOperation += op;
      notifyListeners();
    }
  }

  void clearCalculator() {
    if (_calculatorPlayerId == null) return;
    _calculatorOperation = '';
    notifyListeners();
  }

  void deleteLast() {
    if (_calculatorPlayerId == null) return;
    if (_calculatorOperation.isNotEmpty) {
      _calculatorOperation = _calculatorOperation.substring(0, _calculatorOperation.length - 1);
      notifyListeners();
    }
  }

  void doubleLastNumber() {
    if (_calculatorPlayerId == null) return;
    if (_calculatorOperation.isEmpty) {
      final current = calculatorCurrentLP;
      final newVal = (current * 2).clamp(0, 99999);
      setLP(_calculatorPlayerId!, newVal);
      _calculatorOperation = newVal.toString();
      notifyListeners();
      return;
    }
    final lastNum = _getLastNumber();
    if (lastNum.isEmpty) return;
    try {
      final numVal = int.parse(lastNum);
      final newVal = (numVal * 2).clamp(0, 99999);
      _replaceLastNumber(newVal.toString());
      notifyListeners();
    } catch (_) {}
  }

  void halfLastNumber() {
    if (_calculatorPlayerId == null) return;
    if (_calculatorOperation.isEmpty) {
      final current = calculatorCurrentLP;
      final newVal = (current ~/ 2).clamp(0, 99999);
      setLP(_calculatorPlayerId!, newVal);
      _calculatorOperation = newVal.toString();
      notifyListeners();
      return;
    }
    final lastNum = _getLastNumber();
    if (lastNum.isEmpty) return;
    try {
      final numVal = int.parse(lastNum);
      final newVal = (numVal ~/ 2).clamp(0, 99999);
      _replaceLastNumber(newVal.toString());
      notifyListeners();
    } catch (_) {}
  }

  void applyCalculator() {
    if (_calculatorPlayerId == null) return;
    final newLP = _evaluateOperation(_calculatorOperation);
    setLP(_calculatorPlayerId!, newLP);
    _calculatorOperation = '';
    _calculatorPlayerId = null;
    notifyListeners();
  }

  // ===== Calculator Helpers =====
  String _getLastNumber() {
    final tokens = _calculatorOperation.split(RegExp(r'[+\-]'));
    return tokens.isNotEmpty ? tokens.last : '';
  }

  void _replaceLastNumber(String newNum) {
    final lastOpIndex = _calculatorOperation.lastIndexOf(RegExp(r'[+\-]'));
    if (lastOpIndex == -1) {
      _calculatorOperation = newNum;
    } else {
      final prefix = _calculatorOperation.substring(0, lastOpIndex + 1);
      _calculatorOperation = prefix + newNum;
    }
    notifyListeners();
  }

  int _evaluateOperation(String expr) {
    if (expr.isEmpty) return calculatorCurrentLP;
    final tokens = <String>[];
    String current = '';
    for (var char in expr.runes) {
      final c = String.fromCharCode(char);
      if (c == '+' || c == '-') {
        if (current.isNotEmpty) tokens.add(current);
        tokens.add(c);
        current = '';
      } else {
        current += c;
      }
    }
    if (current.isNotEmpty) tokens.add(current);
    if (tokens.isEmpty) return calculatorCurrentLP;

    int result = 0;
    int index = 0;
    try {
      result = int.parse(tokens[0]);
    } catch (_) {
      return calculatorCurrentLP;
    }
    index = 1;

    while (index < tokens.length) {
      final op = tokens[index];
      final num = int.tryParse(tokens[index + 1]);
      if (num == null) break;
      if (op == '+') {
        result += num;
      } else if (op == '-') {
        result -= num;
      }
      index += 2;
    }
    return result.clamp(0, 99999);
  }

  // ===== Cleanup =====
  @override
  void dispose() {
    stopSensorListening();
    _sensorService.dispose();
    super.dispose();
  }
}