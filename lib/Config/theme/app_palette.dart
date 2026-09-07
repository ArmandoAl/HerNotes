import 'package:flutter/material.dart';

/// Therapeutic color system for HerNotes.
/// Warm linen, sage, and clay — never clinical blue or harsh teal.
class AppPalette {
  final bool isDark;
  final Color background;
  final Color backgroundAlt;
  final Color surface;
  final Color surfaceMuted;
  final Color primary;
  final Color primarySoft;
  final Color primaryDeep;
  final Color onPrimary;
  final Color accent;
  final Color accentSoft;
  final Color ink;
  final Color inkSoft;
  final Color inkFaint;
  final Color line;
  final Color shadow;
  final Color success;
  final Color warning;
  final Color danger;
  final Color fab;
  final Color navBar;
  final Color blobSage;
  final Color blobRose;
  final Color blobSand;

  const AppPalette({
    required this.isDark,
    required this.background,
    required this.backgroundAlt,
    required this.surface,
    required this.surfaceMuted,
    required this.primary,
    required this.primarySoft,
    required this.primaryDeep,
    required this.onPrimary,
    required this.accent,
    required this.accentSoft,
    required this.ink,
    required this.inkSoft,
    required this.inkFaint,
    required this.line,
    required this.shadow,
    required this.success,
    required this.warning,
    required this.danger,
    required this.fab,
    required this.navBar,
    required this.blobSage,
    required this.blobRose,
    required this.blobSand,
  });

  static const light = AppPalette(
    isDark: false,
    background: Color(0xFFF4EFE8),
    backgroundAlt: Color(0xFFEAE4DA),
    surface: Color(0xFFFFFBF7),
    surfaceMuted: Color(0xFFF0E9DF),
    primary: Color(0xFF5C7A6B),
    primarySoft: Color(0xFFD8E4DC),
    primaryDeep: Color(0xFF3E574C),
    onPrimary: Color(0xFFFFFBF7),
    accent: Color(0xFFC4896A),
    accentSoft: Color(0xFFF3E0D4),
    ink: Color(0xFF2C2723),
    inkSoft: Color(0xFF5A544C),
    inkFaint: Color(0xFF9A9288),
    line: Color(0xFFE4DCD2),
    shadow: Color(0x332C2723),
    success: Color(0xFF5C7A6B),
    warning: Color(0xFFC4A265),
    danger: Color(0xFFB56A5A),
    fab: Color(0xFF5C7A6B),
    navBar: Color(0xFFFFFBF7),
    blobSage: Color(0x335C7A6B),
    blobRose: Color(0x28C9898B),
    blobSand: Color(0x33C4896A),
  );

  static const dark = AppPalette(
    isDark: true,
    background: Color(0xFF1A1816),
    backgroundAlt: Color(0xFF221F1C),
    surface: Color(0xFF262320),
    surfaceMuted: Color(0xFF312D29),
    primary: Color(0xFF9BB6A8),
    primarySoft: Color(0xFF314038),
    primaryDeep: Color(0xFFC5D7CC),
    onPrimary: Color(0xFF1A1816),
    accent: Color(0xFFD4A58A),
    accentSoft: Color(0xFF3B2E27),
    ink: Color(0xFFF3EDE6),
    inkSoft: Color(0xFFC9C0B6),
    inkFaint: Color(0xFF8A8278),
    line: Color(0xFF3A3530),
    shadow: Color(0x66000000),
    success: Color(0xFF9BB6A8),
    warning: Color(0xFFD4B06A),
    danger: Color(0xFFD09284),
    fab: Color(0xFF9BB6A8),
    navBar: Color(0xFF262320),
    blobSage: Color(0x339BB6A8),
    blobRose: Color(0x33C9898B),
    blobSand: Color(0x33D4A58A),
  );
}
