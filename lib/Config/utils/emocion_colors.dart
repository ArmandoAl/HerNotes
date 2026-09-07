import 'package:flutter/material.dart';

/// Softer, more accessible emotion hues for a therapeutic journal.
const emotionColors = {
  'Amor': Color(0xFFC47B9A),
  'Felicidad': Color(0xFF7BA05B),
  'Repugnancia': Color(0xFFA18462),
  'Sorpresa': Color(0xFFD4A054),
  'Miedo': Color(0xFF7A8494),
  'Tristeza': Color(0xFF6B8CAD),
  'Enojo': Color(0xFFC47A6A),
};

Color emotionColorOf(String base) {
  return emotionColors[base] ?? const Color(0xFF8A837A);
}

IconData emotionIconOf(String base) {
  switch (base) {
    case 'Amor':
      return Icons.favorite_rounded;
    case 'Felicidad':
      return Icons.wb_sunny_rounded;
    case 'Repugnancia':
      return Icons.water_drop_rounded;
    case 'Sorpresa':
      return Icons.auto_awesome_rounded;
    case 'Miedo':
      return Icons.cloud_rounded;
    case 'Tristeza':
      return Icons.nights_stay_rounded;
    case 'Enojo':
      return Icons.local_fire_department_rounded;
    default:
      return Icons.spa_rounded;
  }
}
