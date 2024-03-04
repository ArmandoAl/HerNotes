// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:localstorage/localstorage.dart';

class ThemeProvider extends ChangeNotifier {
  final LocalStorage storage;
  ThemeProvider({required this.storage});

  final light = {
    'backgroundColor': const Color(0xF5F5F5F5),
    'textColor': Colors.black,
    'iconColorLight': const Color.fromRGBO(47, 137, 252, 1),
    'iconColorDark': Colors.black,
    'drawerColor': const Color.fromARGB(255, 41, 141, 228),
    'cardColor': Colors.white70,
    'shadowColor': Colors.black54,
  };

  final dark = {
    'backgroundColor': const Color(0xFF212121),
    'textColor': Colors.white,
    'iconColorLight': const Color.fromRGBO(47, 137, 252, 1),
    'iconColorDark': Colors.white,
    'drawerColor': const Color.fromARGB(255, 33, 33, 33),
    'cardColor': Colors.black54,
    'shadowColor': Colors.white54,
  };

  bool isDarkModeEnabled = false;

  void getTheme() async {
    isDarkModeEnabled = storage.getItem('isDarkModeEnabled') ?? false;
    notifyListeners();
  }

  void setTheme(bool isDarkModeEnabled) {
    storage.setItem('isDarkModeEnabled', isDarkModeEnabled);
    this.isDarkModeEnabled = isDarkModeEnabled;
    notifyListeners();
  }
}
