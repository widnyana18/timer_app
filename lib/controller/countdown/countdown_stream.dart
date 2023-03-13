import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:rxdart/rxdart.dart';
import 'package:stop_watch_timer/stop_watch_timer.dart';

class CountDownStream with DiagnosticableTreeMixin {
  final StopWatchTimer _timer = StopWatchTimer(mode: StopWatchMode.countDown);

  final BehaviorSubject<int> _stepController = BehaviorSubject<int>.seeded(150);
  final BehaviorSubject<String> _displayTimeController =
      BehaviorSubject<String>.seeded('00:00:00');
  final BehaviorSubject<int> _hoursController = BehaviorSubject<int>.seeded(0);
  final BehaviorSubject<int> _minutesController =
      BehaviorSubject<int>.seeded(0);
  final BehaviorSubject<int> _secondsController =
      BehaviorSubject<int>.seeded(0);

  final PublishSubject<bool> _stoppedController = PublishSubject<bool>();
  final PublishSubject<bool> _endedController = PublishSubject<bool>();

  ValueStream<String> get displayTime => _displayTimeController.stream;
  ValueStream<int> get currentStep => _stepController.stream;
  ValueStream<int> get hours => _hoursController.stream;
  ValueStream<int> get minutes => _minutesController.stream;
  ValueStream<int> get seconds => _secondsController.stream;

  bool get isNotEmpty =>
      _hoursController.stream.hasValue ||
      _minutesController.stream.hasValue ||
      _secondsController.stream.hasValue;

  Stream<bool> get isPrepare => Rx.combineLatest3(
        Stream.value(_timer.isRunning),
        _stoppedController.stream,
        _endedController.stream,
        (bool a, bool b, bool c) => !a && !b || c,
      );

  Stream<bool> get isStarted => Rx.combineLatest3(
        Stream.value(_timer.isRunning),
        _stoppedController.stream,
        _endedController.stream,
        (bool a, bool b, bool c) => a || !b && !c,
      );

  Stream<bool> get isPaused => Rx.combineLatest3(
        Stream.value(_timer.isRunning),
        _stoppedController.stream,
        _endedController.stream,
        (bool a, bool b, bool c) => !a || b && !c,
      );

  // // !_timer.isRunning && !_stoppedController.stream || _endedController.stream;
  //   // _timer.isRunning || !_stoppedController.stream && !_endedController.stream;
  // // !_timer.isRunning || _stoppedController.stream && !_endedController.stream;

  String get timerResult {
    var timerResult = 'Total ';
    if (hours.value != 0) {
      timerResult += '${hours.value} hours ';
    }
    if (minutes.value != 0) {
      timerResult += '${hours.value} minutes ';
    }
    if (seconds.value != 0) {
      timerResult += '${hours.value} seconds ';
    }

    return timerResult;
  }

  void fetchHours(int value) {
    _hoursController.sink.add(value);
    _timer.setPresetHoursTime(hours.value, add: false);
  }

  void fetchMinutes(int value) {
    _minutesController.sink.add(value);
    _timer.setPresetMinuteTime(minutes.value, add: false);
  }

  void fetchSeconds(int value) {
    _secondsController.sink.add(value);
    _timer.setPresetSecondTime(seconds.value, add: false);
  }

  void onStart() {
    final miliSec = _timer.rawTime;

    try {
      _timer.onStartTimer();

      if (_timer.isRunning) {
        _stoppedController.sink.add(false);
        _endedController.sink.add(false);
        _stepCounter();

        miliSec.listen((tick) {
          _displayTimeController.sink.add(
            StopWatchTimer.getDisplayTime(
              tick,
              milliSecond: false,
              secondRightBreak: '',
            ),
          );
        });

        if (miliSec.value == 0) onStopped();
      }
    } on Exception catch (e) {
      throw e.toString();
    }
  }

  void _stepCounter() {
    _timer.rawTime.listen((tick) {
      final calculateStep = ((tick % 61000) / 60000 * 150).floor();
      _stepController.sink.add(calculateStep);
    });
  }

  void onPause() {
    _timer.onStopTimer();
    _stoppedController.sink.add(true);
    _endedController.sink.add(false);
  }

  Future<void> onStopped() async {
    try {
      _timer.onResetTimer();
      _stoppedController.sink.add(true);
      _endedController.sink.add(true);

      if (!_timer.isRunning) {
        _reset();
      }
    } on Exception catch (e) {
      throw e.toString();
    }
  }

  Future<void> _reset() async {
    _displayTimeController.sink.add('00:00.00');
    _stepController.sink.add(150);
    _stoppedController.sink.add(false);
    _endedController.sink.add(false);
  }

  Future<void> dispose() async {
    await Future.wait<dynamic>([
      _timer.dispose(),
      _displayTimeController.sink.close(),
      _stepController.sink.close(),
      _hoursController.sink.close(),
      _minutesController.sink.close(),
      _secondsController.sink.close(),
      _stoppedController.sink.close(),
      _endedController.sink.close(),
    ]);
  }

  /// Makes `hourser` readable inside the devtools by listing all of its properties
  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(StringProperty('displayTime', displayTime.valueOrNull));
    properties.add(IntProperty('stepper', currentStep.valueOrNull));
    properties.add(IntProperty('hours', hours.valueOrNull));
    properties.add(IntProperty('minutes', minutes.valueOrNull));
    properties.add(IntProperty('seconds', seconds.valueOrNull));
  }
}
