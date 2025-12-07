import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Centralized application themes for both light and dark modes.
class AppTheme {
  AppTheme._();

  static const _seedColor = Color(0xFF2563EB); // deep blue accent
  static const _lightSurface = Colors.white;
  static const _lightBackground = Color(0xFFF6F8FB);
  static const _darkSurface = Color(0xFF111827);
  static const _darkBackground = Color(0xFF0B1221);

  /// Light theme used across the app.
  static final ThemeData lightTheme = _buildTheme(
    brightness: Brightness.light,
    colorScheme: ColorScheme.fromSeed(
      seedColor: _seedColor,
      brightness: Brightness.light,
      background: _lightBackground,
      surface: _lightSurface,
    ),
  );

  /// Dark theme counterpart.
  static final ThemeData darkTheme = _buildTheme(
    brightness: Brightness.dark,
    colorScheme: ColorScheme.fromSeed(
      seedColor: _seedColor,
      brightness: Brightness.dark,
      background: _darkBackground,
      surface: _darkSurface,
    ),
  );

  // Aliases to satisfy existing usage.
  static ThemeData get light => lightTheme;
  static ThemeData get dark => darkTheme;

  static ThemeData _buildTheme({
    required Brightness brightness,
    required ColorScheme colorScheme,
  }) {
    final textTheme = GoogleFonts.interTextTheme().apply(
      bodyColor: colorScheme.onBackground,
      displayColor: colorScheme.onBackground,
    );

    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: colorScheme.background,
      textTheme: textTheme,
      appBarTheme: AppBarTheme(
        backgroundColor: colorScheme.surface,
        foregroundColor: colorScheme.onSurface,
        elevation: 0,
        centerTitle: false,
        titleTextStyle: textTheme.titleLarge?.copyWith(
          fontWeight: FontWeight.w700,
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: brightness == Brightness.light
            ? colorScheme.surface
            : colorScheme.surface.withOpacity(0.85),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 14,
          vertical: 12,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: colorScheme.outlineVariant),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: colorScheme.outlineVariant),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: colorScheme.primary,
            width: 1.5,
          ),
        ),
        hintStyle: TextStyle(
          color: colorScheme.onSurfaceVariant.withOpacity(0.8),
        ),
        labelStyle: TextStyle(
          color: colorScheme.onSurfaceVariant,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: colorScheme.primary,
          foregroundColor: colorScheme.onPrimary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: textTheme.labelLarge?.copyWith(
            fontWeight: FontWeight.w700,
          ),
          padding: const EdgeInsets.symmetric(
            horizontal: 18,
            vertical: 14,
          ),
        ),
      ),
      cardTheme: CardTheme(
        color: colorScheme.surface,
        elevation: 1.5,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
        ),
      ),
      chipTheme: ChipThemeData(
        backgroundColor: colorScheme.secondaryContainer,
        selectedColor: colorScheme.primaryContainer,
        disabledColor: colorScheme.surface,
        labelStyle: textTheme.labelMedium?.copyWith(
          color: colorScheme.onSecondaryContainer,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      dividerColor: colorScheme.outlineVariant,
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: colorScheme.primary,
        foregroundColor: colorScheme.onPrimary,
      ),
    );
  }
}

// Typedef to accommodate `Apptheme.lightTheme` references in main.dart.
typedef Apptheme = AppTheme;



