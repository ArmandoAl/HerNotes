import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:her_notes/Config/theme/app_palette.dart';

class AppTheme {
  static ThemeData build(AppPalette palette) {
    final display = GoogleFonts.cormorantGaramondTextTheme();
    final body = GoogleFonts.nunitoTextTheme();

    final textTheme = body.copyWith(
      displayLarge: display.displayLarge?.copyWith(
        fontWeight: FontWeight.w600,
        color: palette.ink,
        height: 1.1,
        letterSpacing: -0.6,
      ),
      displayMedium: display.displayMedium?.copyWith(
        fontWeight: FontWeight.w600,
        color: palette.ink,
        height: 1.15,
      ),
      displaySmall: display.displaySmall?.copyWith(
        fontWeight: FontWeight.w600,
        color: palette.ink,
        height: 1.2,
      ),
      headlineLarge: display.headlineLarge?.copyWith(
        fontWeight: FontWeight.w600,
        color: palette.ink,
        fontSize: 34,
        height: 1.15,
      ),
      headlineMedium: display.headlineMedium?.copyWith(
        fontWeight: FontWeight.w600,
        color: palette.ink,
        fontSize: 28,
        height: 1.2,
      ),
      headlineSmall: display.headlineSmall?.copyWith(
        fontWeight: FontWeight.w600,
        color: palette.ink,
        fontSize: 22,
      ),
      titleLarge: body.titleLarge?.copyWith(
        fontWeight: FontWeight.w700,
        color: palette.ink,
        fontSize: 20,
      ),
      titleMedium: body.titleMedium?.copyWith(
        fontWeight: FontWeight.w700,
        color: palette.ink,
        fontSize: 16,
      ),
      titleSmall: body.titleSmall?.copyWith(
        fontWeight: FontWeight.w600,
        color: palette.inkSoft,
        fontSize: 13,
        letterSpacing: 0.2,
      ),
      bodyLarge: body.bodyLarge?.copyWith(
        color: palette.ink,
        fontSize: 16,
        height: 1.5,
      ),
      bodyMedium: body.bodyMedium?.copyWith(
        color: palette.inkSoft,
        fontSize: 14,
        height: 1.5,
      ),
      bodySmall: body.bodySmall?.copyWith(
        color: palette.inkFaint,
        fontSize: 12,
        height: 1.4,
      ),
      labelLarge: body.labelLarge?.copyWith(
        fontWeight: FontWeight.w700,
        color: palette.ink,
        letterSpacing: 0.2,
      ),
    );

    return ThemeData(
      useMaterial3: true,
      brightness: palette.isDark ? Brightness.dark : Brightness.light,
      scaffoldBackgroundColor: palette.background,
      colorScheme: ColorScheme(
        brightness: palette.isDark ? Brightness.dark : Brightness.light,
        primary: palette.primary,
        onPrimary: palette.onPrimary,
        secondary: palette.accent,
        onSecondary: palette.ink,
        error: palette.danger,
        onError: palette.onPrimary,
        surface: palette.surface,
        onSurface: palette.ink,
      ),
      textTheme: textTheme,
      primaryTextTheme: textTheme,
      canvasColor: palette.background,
      cardColor: palette.surface,
      dividerColor: palette.line,
      splashColor: palette.primarySoft.withOpacity(0.4),
      highlightColor: palette.primarySoft.withOpacity(0.2),
      appBarTheme: AppBarTheme(
        elevation: 0,
        scrolledUnderElevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: palette.ink,
        systemOverlayStyle: palette.isDark
            ? SystemUiOverlayStyle.light
            : SystemUiOverlayStyle.dark,
        centerTitle: false,
        titleTextStyle: display.titleLarge?.copyWith(
          color: palette.ink,
          fontWeight: FontWeight.w600,
          fontSize: 24,
        ),
        iconTheme: IconThemeData(color: palette.ink, size: 22),
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: palette.fab,
        foregroundColor: palette.onPrimary,
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      ),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: palette.ink,
        contentTextStyle: body.bodyMedium?.copyWith(color: palette.surface),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
      dialogTheme: DialogTheme(
        backgroundColor: palette.surface,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
        titleTextStyle: display.headlineSmall?.copyWith(
          color: palette.ink,
          fontWeight: FontWeight.w600,
        ),
        contentTextStyle: body.bodyMedium?.copyWith(color: palette.inkSoft),
      ),
      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: palette.surface,
        surfaceTintColor: Colors.transparent,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: palette.surface,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
        hintStyle: body.bodyMedium?.copyWith(color: palette.inkFaint),
        labelStyle: body.bodyMedium?.copyWith(color: palette.inkSoft),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: BorderSide(color: palette.line),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: BorderSide(color: palette.line),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: BorderSide(color: palette.primary, width: 1.6),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: BorderSide(color: palette.danger),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          elevation: 0,
          backgroundColor: palette.primary,
          foregroundColor: palette.onPrimary,
          textStyle: body.labelLarge,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: palette.primaryDeep,
          textStyle: body.labelLarge,
        ),
      ),
      iconButtonTheme: IconButtonThemeData(
        style: IconButton.styleFrom(
          foregroundColor: palette.ink,
        ),
      ),
      dropdownMenuTheme: DropdownMenuThemeData(
        textStyle: body.bodyMedium?.copyWith(color: palette.ink),
      ),
    );
  }
}
