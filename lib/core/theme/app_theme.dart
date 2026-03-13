import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// BTG Pactual brand theme configuration.
///
/// Uses Material 3 design with a corporate blue palette
/// and Google Fonts (Inter) for premium typography.
abstract final class AppTheme {
  // ── Brand Colors ──────────────────────────────────────────────
  static const _primaryBlue = Color(0xFF003B71);
  static const _accentBlue = Color(0xFF0066CC);
  static const _successGreen = Color(0xFF2E7D32);
  static const _errorRed = Color(0xFFD32F2F);
  static const _warningAmber = Color(0xFFF9A825);
  static const _surfaceLight = Color(0xFFF5F7FA);
  static const _cardWhite = Color(0xFFFFFFFF);

  /// Light theme for the application.
  static ThemeData get lightTheme {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: _primaryBlue,
      primary: _primaryBlue,
      secondary: _accentBlue,
      error: _errorRed,
      surface: _surfaceLight,
      brightness: Brightness.light,
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      textTheme: GoogleFonts.interTextTheme(),
      appBarTheme: AppBarTheme(
        centerTitle: true,
        elevation: 0,
        backgroundColor: _primaryBlue,
        foregroundColor: Colors.white,
        titleTextStyle: GoogleFonts.inter(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: Colors.white,
        ),
      ),
      cardTheme: CardThemeData(
        elevation: 2,
        color: _cardWhite,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: _primaryBlue,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: GoogleFonts.inter(
            fontSize: 15,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: _errorRed,
          side: const BorderSide(color: _errorRed),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: GoogleFonts.inter(
            fontSize: 15,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        filled: true,
        fillColor: Colors.white,
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        selectedItemColor: _primaryBlue,
        unselectedItemColor: Colors.grey.shade500,
        type: BottomNavigationBarType.fixed,
        elevation: 8,
      ),
      scaffoldBackgroundColor: _surfaceLight,
    );
  }

  // ── Semantic Colors (for access outside ThemeData) ────────────
  static const Color success = _successGreen;
  static const Color warning = _warningAmber;
  static const Color error = _errorRed;
  static const Color primary = _primaryBlue;
  static const Color accent = _accentBlue;
}
