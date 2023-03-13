import 'package:flutter/foundation.dart';
import 'package:rxdart/rxdart.dart';
import 'package:timer_app/controller/countdown/countdown_stream.dart';

class MarkTimerStream with DiagnosticableTreeMixin {
  final VoidCallback? closeThemeMenu;
  final CountDownStream _countDown = CountDownStream();
  final BehaviorSubject<int> _presetHoursCtrl = BehaviorSubject<int>.seeded(0);
  final BehaviorSubject<int> _presetMinutesCtrl =
      BehaviorSubject<int>.seeded(5);
  late BehaviorSubject<List<int>> _minutesDataCtrl;
  final List<int> _minutesList = [5, 15, 25, 45];
  final ValueNotifier<int> _currentMinutes = ValueNotifier<int>(0);
  final ValueNotifier<bool> _isClosed = ValueNotifier<bool>(true);

  MarkTimerStream({this.closeThemeMenu}) {
    _minutesDataCtrl = BehaviorSubject<List<int>>.seeded(_minutesList);
  }

  ValueStream<List<int>> get minutesData => _minutesDataCtrl.stream;
  ValueStream<int> get presetHours => _presetHoursCtrl.stream;
  ValueStream<int> get presetMinutes => _presetMinutesCtrl.stream;
  bool get isEmpty => presetHours.value == 0 && presetMinutes.value == 0;
  ValueNotifier<bool> get isClosed => _isClosed;

  void setHours(int value) {
    try {
      _presetHoursCtrl.sink.add(value);
    } on Exception catch (e) {
      throw e.toString();
    }
  }

  void setMinutes(int value) {
    try {
      _presetMinutesCtrl.sink.add(value);
    } on Exception catch (e) {
      throw e.toString();
    }
  }

  void create() {
    final hours = _presetHoursCtrl.value * 60;
    final minutes = hours + _presetMinutesCtrl.value;

    try {
      if (minutes != 0 && _minutesDataCtrl.value.contains(minutes)) {
        _minutesList.add(minutes);
        _minutesDataCtrl.sink.add(_minutesList);
      }
    } on Exception catch (e) {
      throw e.toString();
    }
  }

  void select(int index) {
    final rawMinutes = _minutesDataCtrl.value[index];
    final selectedHours = (rawMinutes / 60).floor();
    final selectedMinutes = rawMinutes % 60;

    try {
      _currentMinutes.value = rawMinutes;
      if (rawMinutes != _currentMinutes.value) {
        _countDown.fetchHours(selectedHours);
        _countDown.fetchMinutes(selectedMinutes);

        _isClosed.value = true;
      }
    } on Exception catch (e) {
      throw e.toString();
    }
  }

  void delete(int index) {
    try {
      _minutesList.removeAt(index);
      _minutesDataCtrl.add(_minutesList);
    } on Exception catch (e) {
      throw e.toString();
    }
  }

  void toggleBtn() {
    try {
      _isClosed.value = !_isClosed.value;
      if (!_isClosed.value) {
        closeThemeMenu!();
      }
    } on Exception catch (e) {
      throw e.toString();
    }
  }

  void closeMarkTimer() {
    try {
      _isClosed.value = true;
    } on Exception catch (e) {
      throw e.toString();
    }
  }

  Future<void> dispose() async {
    await Future.wait([
      _presetHoursCtrl.sink.close(),
      _presetMinutesCtrl.sink.close(),
      _minutesDataCtrl.close(),
    ]);
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(IntProperty('selected Minutes', _currentMinutes.value));
    properties.add(IterableProperty('minutes data', _minutesDataCtrl.value));
    properties.add(IntProperty('preset hours', _presetHoursCtrl.value));
    properties.add(IntProperty('preset minutes', _presetMinutesCtrl.value));
  }
}
