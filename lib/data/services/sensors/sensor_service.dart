import 'dart:async';

enum ShakeEventType { coin, dice }

class ShakeEvent {
  final ShakeEventType type;
  final int? diceValue;    // 1-6 if dice
  final String? coinSide;  // 'Heads' or 'Tails' if coin

  ShakeEvent._(this.type, {this.diceValue, this.coinSide});

  factory ShakeEvent.coin(String side) {
    return ShakeEvent._(ShakeEventType.coin, coinSide: side);
  }

  factory ShakeEvent.dice(int value) {
    return ShakeEvent._(ShakeEventType.dice, diceValue: value);
  }
}

abstract class SensorService {
  Stream<ShakeEvent> get shakeEvents;
  void startListening();
  void stopListening();
  void dispose();
}