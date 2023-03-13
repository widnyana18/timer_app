import 'package:rxdart/rxdart.dart';
import 'package:timer_app/controller/countdown/countdown_stream.dart';

class PresetTimerStream {
  final CountDownStream _countDown = CountDownStream();
  final PublishSubject<bool> _beforeAfterHourCtrl = PublishSubject<bool>();
  final PublishSubject<bool> _beforeAfterMinCtrl = PublishSubject<bool>();
  final PublishSubject<bool> _beforeAfterSecCtrl = PublishSubject<bool>();

  Stream<bool> get isBeforeAfterVal => Rx.combineLatest3(
        _beforeAfterHourCtrl.stream,
        _beforeAfterMinCtrl.stream,
        _beforeAfterSecCtrl.stream,
        (bool a, bool b, bool c) => a || b || c,
      );

  void getAllHoursItems(String value) {
    final valParsed = int.parse(value);

    _countDown.hours.listen((event) {
      final selectedVal = valParsed == event - 1 && valParsed == event + 1;
      _beforeAfterHourCtrl.sink.add(selectedVal);
    });
  }

  void getAllMinItems(String value) {
    final valParsed = int.parse(value);

    _countDown.minutes.listen((event) {
      final selectedVal = valParsed == event - 1 && valParsed == event + 1;
      _beforeAfterMinCtrl.sink.add(selectedVal);
    });
  }

  void getAllSecItems(String value) {
    final valParsed = int.parse(value);

    _countDown.seconds.listen((event) {
      final selectedVal = valParsed == event - 1 && valParsed == event + 1;
      _beforeAfterSecCtrl.sink.add(selectedVal);
    });
  }

  Future<void> dispose() async {
    await Future.wait([
      _beforeAfterHourCtrl.close(),
      _beforeAfterMinCtrl.close(),
      _beforeAfterSecCtrl.close(),
    ]);
  }

  /// Makes `hourser` readable inside the devtools by listing all of its properties
  // @override
  // void debugFillProperties(DiagnosticPropertiesBuilder properties) {
  //   super.debugFillProperties(properties);
  //   properties.add(IntProperty('coverIdx', _cover));
  //   properties.add(EnumProperty('button state', _btnState));
  //   properties.add(EnumProperty('overlapping', _isOverlap));
  // }
}
