import 'package:flutter/material.dart';
import 'package:her_notes/Config/theme/app_palette.dart';
import 'package:her_notes/Config/theme/app_theme.dart';
import 'package:localstorage/localstorage.dart';
import 'package:provider/provider.dart';

class ThemeProvider extends ChangeNotifier {
  final LocalStorage storage;
  ThemeProvider({required this.storage});

  bool isDarkModeEnabled = false;

  AppPalette get palette =>
      isDarkModeEnabled ? AppPalette.dark : AppPalette.light;

  ThemeData get themeData => AppTheme.build(palette);

  Map<String, Color> get light => {
        'backgroundColor': AppPalette.light.background,
        'textColor': AppPalette.light.ink,
        'iconColorLight': AppPalette.light.primary,
        'iconColorDark': AppPalette.light.ink,
        'drawerColor': AppPalette.light.primaryDeep,
        'cardColor': AppPalette.light.surface,
        'shadowColor': AppPalette.light.shadow,
      };

  Map<String, Color> get dark => {
        'backgroundColor': AppPalette.dark.background,
        'textColor': AppPalette.dark.ink,
        'iconColorLight': AppPalette.dark.primary,
        'iconColorDark': AppPalette.dark.ink,
        'drawerColor': AppPalette.dark.surface,
        'cardColor': AppPalette.dark.surface,
        'shadowColor': AppPalette.dark.shadow,
      };

  void getTheme() async {
    isDarkModeEnabled = storage.getItem('isDarkModeEnabled') ?? false;
    notifyListeners();
  }

  void setTheme(bool enabled) {
    storage.setItem('isDarkModeEnabled', enabled);
    isDarkModeEnabled = enabled;
    notifyListeners();
  }
}

AppPalette havenPalette(BuildContext context, {bool listen = true}) {
  return Provider.of<ThemeProvider>(context, listen: listen).palette;
}
