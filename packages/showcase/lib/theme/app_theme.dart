import 'package:material_ui/material_ui.dart';

/// Brand palette for the showcase.
abstract final class BrandColors {
  static const indigo = Color(0xFF6366F1);
  static const purple = Color(0xFF8B5CF6);
  static const pink = Color(0xFFEC4899);
  static const deepBlue = Color(0xFF1E1B4B);
  static const darkBg = Color(0xFF0F0F1A);
  static const darkCard = Color(0xFF1A1A2E);
  static const darkCardBorder = Color(0xFF2A2A3E);
  static const lightBg = Color(0xFFF8F9FC);
  static const lightCard = Color(0xFFFFFFFF);
  static const emerald = Color(0xFF10B981);

  static const heroGradient = [indigo, purple, deepBlue];
  static const accentGradient = [indigo, pink];
}

/// Creates the dark theme for the showcase.
ThemeData buildDarkTheme() {
  return ThemeData(
    brightness: Brightness.dark,
    scaffoldBackgroundColor: BrandColors.darkBg,
    colorScheme: ColorScheme.dark(
      primary: BrandColors.indigo,
      secondary: BrandColors.purple,
      surface: BrandColors.darkCard,
      error: const Color(0xFFEF4444),
      onPrimary: Colors.white,
      onSecondary: Colors.white,
      onSurface: Colors.white,
      outline: const Color(0xFF4A4A5E),
      surfaceContainerHighest: const Color(0xFF2A2A3E),
    ),
    textTheme: _buildTextTheme(Brightness.dark),
    useMaterial3: true,
  );
}

/// Creates the light theme for the showcase.
ThemeData buildLightTheme() {
  return ThemeData(
    brightness: Brightness.light,
    scaffoldBackgroundColor: BrandColors.lightBg,
    colorScheme: ColorScheme.light(
      primary: BrandColors.indigo,
      secondary: BrandColors.purple,
      surface: BrandColors.lightCard,
      error: const Color(0xFFEF4444),
      onPrimary: Colors.white,
      onSecondary: Colors.white,
      onSurface: const Color(0xFF1A1A2E),
      outline: const Color(0xFFD1D5DB),
      surfaceContainerHighest: const Color(0xFFF0F0F5),
    ),
    textTheme: _buildTextTheme(Brightness.light),
    useMaterial3: true,
  );
}

TextTheme _buildTextTheme(Brightness brightness) {
  final color = brightness == Brightness.dark
      ? Colors.white
      : const Color(0xFF1A1A2E);
  final mutedColor = brightness == Brightness.dark
      ? Colors.white70
      : const Color(0xFF6B7280);

  return TextTheme(
    displayLarge: TextStyle(
      fontSize: 64,
      fontWeight: FontWeight.w800,
      letterSpacing: -1.5,
      color: color,
      height: 1.1,
    ),
    displayMedium: TextStyle(
      fontSize: 48,
      fontWeight: FontWeight.w700,
      letterSpacing: -0.5,
      color: color,
      height: 1.2,
    ),
    headlineLarge: TextStyle(
      fontSize: 36,
      fontWeight: FontWeight.w700,
      color: color,
      height: 1.2,
    ),
    headlineMedium: TextStyle(
      fontSize: 28,
      fontWeight: FontWeight.w600,
      color: color,
    ),
    headlineSmall: TextStyle(
      fontSize: 24,
      fontWeight: FontWeight.w600,
      color: color,
    ),
    titleLarge: TextStyle(
      fontSize: 20,
      fontWeight: FontWeight.w600,
      color: color,
    ),
    bodyLarge: TextStyle(fontSize: 18, color: mutedColor, height: 1.7),
    bodyMedium: TextStyle(fontSize: 16, color: mutedColor, height: 1.6),
    bodySmall: TextStyle(fontSize: 14, color: mutedColor, height: 1.5),
    labelLarge: TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w600,
      color: color,
    ),
  );
}
