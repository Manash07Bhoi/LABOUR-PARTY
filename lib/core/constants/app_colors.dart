import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  // Primary & Brand
  static const Color primaryDeepBlue    = Color(0xFF0D47A1);   // Deep royal blue
  static const Color primaryBrightBlue  = Color(0xFF1565C0);   // Slightly lighter blue
  static const Color accentCyan         = Color(0xFF00BCD4);   // Cyan accent
  static const Color accentCyanLight    = Color(0xFF4DD0E1);   // Light cyan

  // Backgrounds (Dark Theme)
  static const Color backgroundDeep     = Color(0xFF060B18);   // Almost black with blue tint
  static const Color backgroundCard     = Color(0xFF0D1B2E);   // Dark blue-grey card bg
  static const Color backgroundSurface  = Color(0xFF112240);   // Elevated surface

  // Glass Effect
  static const Color glassWhite         = Color(0x1AFFFFFF);   // 10% white - glass fill
  static const Color glassBorder        = Color(0x33FFFFFF);   // 20% white - glass border

  // Status Colors
  static const Color successGreen       = Color(0xFF00E676);   // Bright green
  static const Color warningAmber       = Color(0xFFFFAB40);   // Amber
  static const Color errorRed           = Color(0xFFEF5350);   // Red
  static const Color infoBlue           = Color(0xFF40C4FF);   // Light blue

  // Text Colors
  static const Color textPrimary        = Color(0xFFF0F4FF);   // Near-white
  static const Color textSecondary      = Color(0xFF90A4C0);   // Muted blue-grey
  static const Color textDisabled       = Color(0xFF445568);   // Dark muted

  // Gradient definitions
  static const LinearGradient splashGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF060B18), Color(0xFF0D2040), Color(0xFF0A1628)],
  );

  static const LinearGradient cardGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF1A2E4A), Color(0xFF0D1B2E)],
  );

  static const LinearGradient accentGradient = LinearGradient(
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
    colors: [Color(0xFF0D47A1), Color(0xFF00BCD4)],
  );
}
