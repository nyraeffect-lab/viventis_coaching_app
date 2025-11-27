import 'package:flutter/material.dart';
import 'viventis_colors.dart';

/// Baut das zentrale Viventis-Theme auf Basis der Markenfarben.
///
/// Leichte, ruhige Gestaltung angelehnt an viventis.net.
ThemeData buildViventisTheme() {
  final baseScheme = ColorScheme.fromSeed(
    seedColor: ViventisColors.navy,
    brightness: Brightness.light,
  );

  final colorScheme = baseScheme.copyWith(
    primary: ViventisColors.navy,
    onPrimary: Colors.white,
    secondary: ViventisColors.accentYellow,
    onSecondary: Colors.black,
    surface: ViventisColors.cream,
    onSurface: ViventisColors.textDark,
  );

  return ThemeData(
    useMaterial3: true,
    colorScheme: colorScheme,
    scaffoldBackgroundColor: ViventisColors.cream,

    // Typografie – ruhige, gut lesbare Basis.
    textTheme: const TextTheme(
      headlineMedium: TextStyle(
        fontSize: 28,
        fontWeight: FontWeight.bold,
        color: ViventisColors.headlineGreen,
      ),
      bodyMedium: TextStyle(
        fontSize: 16,
        color: ViventisColors.textDark,
      ),
      bodySmall: TextStyle(
        fontSize: 13,
        color: ViventisColors.textDark,
      ),
    ),

    // Primäre Call-to-Action Buttons (klassisch erhöht).
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: ViventisColors.accentYellow,
        foregroundColor: Colors.black,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(999),
        ),
        padding: const EdgeInsets.symmetric(
          vertical: 14,
          horizontal: 24,
        ),
        textStyle: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
      ),
    ),

    // Text-Links (z. B. Impressum/Datenschutz).
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: ViventisColors.navy,
        textStyle: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
      ),
    ),

    // AppBar für Screens, die eine eigene Leiste haben.
    appBarTheme: const AppBarTheme(
      backgroundColor: ViventisColors.navy,
      foregroundColor: Colors.white,
      elevation: 0,
      centerTitle: true,
      titleTextStyle: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        color: Colors.white,
      ),
    ),

    // BottomNavigationBar-Grundstil (Farben).
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: ViventisColors.cream,
      selectedItemColor: colorScheme.primary,
      unselectedItemColor: ViventisColors.textDark.withOpacity(0.6),
      showUnselectedLabels: true,
    ),
  );
}
