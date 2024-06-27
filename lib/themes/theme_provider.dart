import 'package:chatting_app/themes/dark_mode.dart';
import 'package:chatting_app/themes/light_mode.dart';
import 'package:flutter/material.dart';

class ThemeProvider extends ChangeNotifier {
  ThemeData _themeData = lighmode;
  ThemeData get themeData => _themeData;
  bool get isDarkMode => _themeData == darkmode;

  set themeData(ThemeData themeData) {
    _themeData = themeData;
    notifyListeners();
  }

  void toggleTheme() {
    if (_themeData == lighmode) {
      themeData = darkmode;
    } else {
      themeData = lighmode;
    }
  }
}
