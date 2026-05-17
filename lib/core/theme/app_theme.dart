import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../constants/app_typography.dart';

class AppTheme {
  AppTheme._();

  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: const ColorScheme.dark(
        primary: Color(0xFF4FC3F7),
        onPrimary: Color(0xFF003355),
        primaryContainer: Color(0xFF00497A),
        onPrimaryContainer: Color(0xFFCDE5FF),
        secondary: Color(0xFF4DD0E1),
        onSecondary: Color(0xFF003740),
        secondaryContainer: Color(0xFF004E59),
        onSecondaryContainer: Color(0xFFB2EBF2),
        surface: Color(0xFF0D1B2E),
        onSurface: Color(0xFFF0F4FF),
        error: Color(0xFFEF5350),
        onError: Color(0xFF690005),
      ),
      scaffoldBackgroundColor: AppColors.backgroundDeep,
      textTheme: AppTypography.textTheme,
      cardTheme: CardThemeData(
        color: const Color(0xFF0D1B2E),
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        margin: EdgeInsets.zero,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: const Color(0xFF112240),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: Color(0xFF2A4A6A), width: 1),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: Color(0xFF2A4A6A), width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: Color(0xFF4DD0E1), width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: Color(0xFFEF5350), width: 1),
        ),
        labelStyle: AppTypography.bodyMedium.copyWith(color: const Color(0xFF90A4C0)),
        floatingLabelStyle: AppTypography.bodyMedium.copyWith(color: const Color(0xFF4DD0E1)),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: const Color(0xFF4DD0E1),
        foregroundColor: const Color(0xFF003740),
        elevation: 8,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: const Color(0xFF0D1B2E),
        indicatorColor: const Color(0x334DD0E1),
        labelTextStyle: WidgetStateProperty.all(
          AppTypography.labelLarge.copyWith(fontSize: 12),
        ),
      ),
      drawerTheme: const DrawerThemeData(
        backgroundColor: Color(0xFF0A1525),
        elevation: 16,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(24),
            bottomRight: Radius.circular(24),
          ),
        ),
      ),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: const Color(0xFF1A2E4A),
        contentTextStyle: AppTypography.bodyMedium.copyWith(color: const Color(0xFFF0F4FF)),
        actionTextColor: const Color(0xFF4DD0E1),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: const Color(0xFF0D1B2E),
        elevation: 24,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      ),
      chipTheme: ChipThemeData(
        backgroundColor: const Color(0xFF112240),
        selectedColor: const Color(0xFF004E59),
        labelStyle: AppTypography.bodyMedium.copyWith(fontSize: 13),
        side: const BorderSide(color: Color(0xFF2A4A6A)),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  static ThemeData get lightTheme {
    // Basic light theme fallback if needed, though PRD says dark is primary
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF0D47A1)),
      textTheme: AppTypography.textTheme,
    );
  }
}
