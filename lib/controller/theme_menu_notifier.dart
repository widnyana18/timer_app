import 'package:flutter/material.dart';
import 'package:timer_app/controller/mark_timer/mark_timer_stream.dart';

class ThemeMenuNotifier extends ChangeNotifier {
  final MarkTimerStream _markTimer = MarkTimerStream();
  int _themeVal = 0;
  bool _isClosed = true;

  bool get isClosed => _isClosed;
  int get selectedTheme => _themeVal;

  void changeTheme(int newVal) {
    try {
      _themeVal = newVal;
    } on Exception catch (e) {
      throw e.toString();
    }
    notifyListeners();
  }

  void toggleMenu() {
    try {
      _isClosed = !_isClosed;
      if (!_isClosed) {
        _markTimer.isClosed.value = true;
      }
    } on Exception catch (e) {
      throw e.toString();
    }
    notifyListeners();
  }

  void closeMenu() {
    try {
      _isClosed = true;
    } on Exception catch (e) {
      throw e.toString();
    }
    notifyListeners();
  }
}
