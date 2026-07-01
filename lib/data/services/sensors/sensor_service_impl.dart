import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:sensors_plus/sensors_plus.dart';

import 'sensor_service.dart';

class SensorServiceImpl implements SensorService {
  static const double _peakThreshold = 15.0;
  static const int _windowMs = 300;
  static const int _peakCooldownMs = 100;

  StreamSubscription<AccelerometerEvent>? _subscription;
  final _shakeController = StreamController<ShakeEvent>.broadcast();
  bool _isProcessing = false;
  int _peakCount = 0;
  DateTime? _lastPeakTime;
  Timer? _quietTimer;

  @override
  Stream<ShakeEvent> get shakeEvents => _shakeController.stream;

  @override
  void startListening() {
    _subscription?.cancel();
    _subscription = accelerometerEventStream().listen(
      _processEvent,
      onError: (error) {
        debugPrint('Sensor error: $error');
      },
    );
  }

  @override
  void stopListening() {
    _subscription?.cancel();
    _subscription = null;
    _resetDetection();
  }

  void _processEvent(AccelerometerEvent event) {
    if (_isProcessing) return;

    final magnitude = sqrt(event.x * event.x + event.y * event.y + event.z * event.z);

    if (magnitude > _peakThreshold) {
      final now = DateTime.now();
      if (_lastPeakTime == null || now.difference(_lastPeakTime!).inMilliseconds > _peakCooldownMs) {
        _lastPeakTime = now;
        _peakCount++;

        _quietTimer?.cancel();
        _quietTimer = Timer(Duration(milliseconds: _windowMs), () {
          _quietTimer = null;
          if (_isProcessing) return;

          if (_peakCount > 0) {
            _isProcessing = true;
            if (_peakCount == 1) {
              _tossCoin();
            } else {
              _rollDice();
            }
            _resetDetection();
            _isProcessing = false;
          }
        });
      }
    }
  }

  void _resetDetection() {
    _peakCount = 0;
    _lastPeakTime = null;
    _quietTimer?.cancel();
    _quietTimer = null;
  }

  void _rollDice() {
    final value = Random().nextInt(6) + 1;
    _shakeController.add(ShakeEvent.dice(value));
  }

  void _tossCoin() {
    final side = Random().nextBool() ? 'Heads' : 'Tails';
    _shakeController.add(ShakeEvent.coin(side));
  }

  @override
  void dispose() {
    _subscription?.cancel();
    _quietTimer?.cancel();
    _shakeController.close();
  }
}