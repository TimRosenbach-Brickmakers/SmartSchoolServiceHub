import 'package:flutter/material.dart';

// State-Pattern: jeder Raumzustand weiß selbst, wie er aussieht
abstract class RoomState {
  const RoomState();
  Color get color;
  String get labelKey;
}

class OkState extends RoomState {
  const OkState();
  @override
  Color get color => Colors.green;
  @override
  String get labelKey => 'roomStateOk';
}

class WarningState extends RoomState {
  const WarningState();
  @override
  Color get color => Colors.orange;
  @override
  String get labelKey => 'roomStateWarning';
}

class AlarmState extends RoomState {
  const AlarmState();
  @override
  Color get color => Colors.red;
  @override
  String get labelKey => 'roomStateAlarm';
}

class OutOfOrderState extends RoomState {
  const OutOfOrderState();
  @override
  Color get color => Colors.grey;
  @override
  String get labelKey => 'roomStateOutOfOrder';
}

class UnknownState extends RoomState {
  const UnknownState();
  @override
  Color get color => Colors.blueGrey;
  @override
  String get labelKey => 'roomStateUnknown';
}
