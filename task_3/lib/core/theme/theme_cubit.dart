import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

class ThemeCubit extends Cubit<ThemeData> {
  ThemeCubit() : super(ThemeData.light()) {
    _initializeWithSystemTheme();
  }

  static const Color primaryColor = Color(0xFF2563EB);

  // Derived shades for primary color
  static const Color primaryLight = Color(0xFF3d78f5);
  static const Color primaryDark = Color(0xFF78C96D);

  // Accent colors that complement the primary green
  static const Color accentColor = Color(0xFF8F7BEC);  // Purple accent
  static const Color secondaryAccentColor = Color(0xFFEC8F9B);  // Salmon accent

  // Neutral colors
  static const Color neutralLight = Color(0xFFF0F0F0);
  static const Color neutralMedium = Color(0xFFE0E0E0);
  static const Color neutralDark = Color(0xFF282828);

  // Text colors
  static const Color textDark = Color(0xFF212121);
  static const Color textMedium = Color(0xFF757575);
  static const Color textLight = Color(0xFFBDBDBD);

  // Feedback colors
  static const Color success = Color(0xFF4CAF50);
  static const Color error = Color(0xFFE53935);
  static const Color warning = Color(0xFFFFC107);
  static const Color info = Color(0xFF2196F3);

  // Background colors
  static const Color surfaceLight = Color(0xFFF9FAFB);
  static const Color surfaceDark = Color(0xFF020617);

  void _initializeWithSystemTheme() {
    final brightness = WidgetsBinding.instance.platformDispatcher.platformBrightness;
    emit(_buildThemeData(brightness));
  }

  void toggleTheme() {
    final isDark = state.brightness == Brightness.dark;
    emit(_buildThemeData(isDark ? Brightness.light : Brightness.dark));
  }

  ThemeData _buildThemeData(Brightness brightness) {
    final isDark = brightness == Brightness.dark;

    return !isDark ? ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      primaryColor: primaryLight,
      scaffoldBackgroundColor: surfaceLight,
      colorScheme: ColorScheme(
        brightness: Brightness.light,
        primary: primaryLight,
        onPrimary: Colors.white,
        secondary: Colors.black,
        onSecondary: Colors.white,
        error: error,
        onError: Colors.black54,
        surface: surfaceLight,
        onSurface: Colors.white,
        tertiary: secondaryAccentColor,
        onTertiary: Colors.grey[300],
        surfaceContainer: neutralLight,
      ),
      textTheme: TextTheme(
        displayLarge: GoogleFonts.poppins(color: textDark, fontWeight: FontWeight.bold),
        displayMedium: GoogleFonts.poppins(color: textDark, fontWeight: FontWeight.bold),
        displaySmall: GoogleFonts.poppins(color: textDark, fontWeight: FontWeight.bold),
        headlineLarge: GoogleFonts.poppins(color: textDark, fontWeight: FontWeight.w600),
        headlineMedium: GoogleFonts.poppins(color: textDark, fontWeight: FontWeight.bold),
        headlineSmall: GoogleFonts.poppins(color: textDark),
        titleLarge: GoogleFonts.poppins(color: textDark, fontWeight: FontWeight.w600),
        titleMedium: GoogleFonts.poppins(color: textDark),
        titleSmall: GoogleFonts.poppins(color: textDark),
        bodyLarge: GoogleFonts.poppins(color: textDark),
        bodyMedium: GoogleFonts.poppins(color: Colors.black54),
        bodySmall: GoogleFonts.poppins(color: textMedium),
        labelLarge: GoogleFonts.poppins(color: textDark, fontWeight: FontWeight.w500),
        labelMedium: GoogleFonts.poppins(color: Colors.black, fontWeight: FontWeight.w500),
        labelSmall: GoogleFonts.poppins(color: textMedium),
      )
    ): ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      primaryColor: primaryColor,
      scaffoldBackgroundColor: surfaceDark,
      colorScheme: ColorScheme(
        brightness: Brightness.dark,
        primary: primaryColor,
        onPrimary: Colors.black,
        secondary: Colors.white,
        onSecondary: Color(0xFF1E293B),
        error: error,
        onError: Colors.white70,
        surface: surfaceDark,
        onSurface: Color(0xFF0F172A),
        tertiary: secondaryAccentColor,
        onTertiary: Colors.grey[600],
        surfaceContainer: neutralDark,
      ),
      textTheme: TextTheme(
        displayLarge: GoogleFonts.poppins(color: Colors.white, fontWeight: FontWeight.bold),
        displayMedium: GoogleFonts.poppins(color: Colors.white, fontWeight: FontWeight.bold),
        displaySmall: GoogleFonts.poppins(color: Colors.white, fontWeight: FontWeight.bold),
        headlineLarge: GoogleFonts.poppins(color: Colors.white, fontWeight: FontWeight.w600),
        headlineMedium: GoogleFonts.poppins(color: Colors.white, fontWeight: FontWeight.w600),
        headlineSmall: GoogleFonts.poppins(color: Colors.white),
        titleLarge: GoogleFonts.poppins(color: Colors.white, fontWeight: FontWeight.w600),
        titleMedium: GoogleFonts.poppins(color: Colors.white),
        titleSmall: GoogleFonts.poppins(color: Colors.white),
        bodyLarge: GoogleFonts.poppins(color: Colors.white),
        bodyMedium: GoogleFonts.poppins(color: Colors.white70),
        bodySmall: GoogleFonts.poppins(color: Colors.white70),
        labelLarge: GoogleFonts.poppins(color: Colors.white, fontWeight: FontWeight.w500),
        labelMedium: GoogleFonts.poppins(color: Colors.white, fontWeight: FontWeight.w500),
        labelSmall: GoogleFonts.poppins(color: Colors.white70),
      ),
    );
  }
}