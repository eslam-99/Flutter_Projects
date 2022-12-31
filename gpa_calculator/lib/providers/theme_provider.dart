import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/scheduler.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeProvider with ChangeNotifier {
  bool isDark = false;

  void switchTheme(bool val) {
    isDark = val;
    updatePrefs();
    notifyListeners();
  }

  Future setTheme() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs = await SharedPreferences.getInstance();
    bool checkTheme = prefs.getBool("checkTheme") == null
        ? true
        : prefs.getBool("checkTheme");
    if (checkTheme) {
      isDark = SchedulerBinding.instance.window.platformBrightness == Brightness.dark;
      prefs.setBool("checkTheme", false);
      prefs.setBool("isDark", isDark);
    } else isDark = prefs.getBool("isDark");
  }

  Future updatePrefs() async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    _prefs.setBool("isDark", isDark);
  }
}