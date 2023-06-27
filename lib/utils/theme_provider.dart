import 'package:flutter/material.dart';

class ThemeProvider extends ChangeNotifier {
  final light = {
    'backgroundColor': const Color(0xF5F5F5F5),
    'textColor': Colors.black,
    'iconColorLight': const Color.fromRGBO(47, 137, 252, 1),
    'iconColorDark': Colors.black,
    'drawerColor': const Color.fromARGB(255, 41, 141, 228)
  };

  final dark = {
    'backgroundColor': const Color(0xFF212121),
    'textColor': Colors.white,
    'iconColorLight': const Color.fromRGBO(47, 137, 252, 1),
    'iconColorDark': Colors.white,
    'drawerColor': const Color.fromARGB(255, 33, 33, 33)
  };

  bool isDarkModeEnabled = false;

  void enableDarkMode(bool isDarkModeEnabled) {
    this.isDarkModeEnabled = isDarkModeEnabled;
    notifyListeners();
  }
}
