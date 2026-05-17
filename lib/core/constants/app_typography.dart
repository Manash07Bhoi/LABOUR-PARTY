import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

class AppTypography {
  AppTypography._();

  static TextStyle get displayLarge => GoogleFonts.outfit(
    fontSize: 32,
    fontWeight: FontWeight.w700,
    letterSpacing: -0.5,
    color: AppColors.textPrimary,
  );

  static TextStyle get headlineLarge => GoogleFonts.outfit(
    fontSize: 24,
    fontWeight: FontWeight.w700,
    letterSpacing: -0.3,
    color: AppColors.textPrimary,
  );

  static TextStyle get headlineMedium => GoogleFonts.outfit(
    fontSize: 20,
    fontWeight: FontWeight.w600,
    letterSpacing: -0.2,
    color: AppColors.textPrimary,
  );

  static TextStyle get titleLarge => GoogleFonts.outfit(
    fontSize: 18,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
  );

  static TextStyle get bodyLarge => GoogleFonts.inter(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    color: AppColors.textPrimary,
  );

  static TextStyle get bodyMedium => GoogleFonts.inter(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: AppColors.textSecondary,
  );

  static TextStyle get labelLarge => GoogleFonts.inter(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.1,
    color: AppColors.textPrimary,
  );

  static TextStyle get moneyDisplay => GoogleFonts.outfit(
    fontSize: 28,
    fontWeight: FontWeight.w700,
    color: AppColors.accentCyan,
    letterSpacing: -1.0,
  );

  static TextTheme get textTheme => TextTheme(
    displayLarge: displayLarge,
    headlineLarge: headlineLarge,
    headlineMedium: headlineMedium,
    titleLarge: titleLarge,
    bodyLarge: bodyLarge,
    bodyMedium: bodyMedium,
    labelLarge: labelLarge,
  );
}
