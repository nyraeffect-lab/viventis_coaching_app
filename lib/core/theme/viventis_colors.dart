import 'package:flutter/material.dart';

/// Zentrale Viventis-Farben angelehnt an viventis.net.
///
/// Diese Klasse dient als einzige Quelle für Markenfarben,
/// damit das Design konsistent bleibt.
class ViventisColors {
  ViventisColors._();

  /// Dunkles Kompass-Blau (Hintergründe / Header).
  static const Color navy = Color(0xFF003366);

  /// Helles Creme / Off-White (Flächen).
  static const Color cream = Color(0xFFFAFAF5);

  /// CTA-Gelb (primäre Buttons, Highlights).
  static const Color accentYellow = Color(0xFFF5C43D);

  /// Dunkelgrün für Headlines und wichtige Akzente.
  static const Color headlineGreen = Color(0xFF004632);

  /// Neutrales Dunkelgrau für Fließtext.
  static const Color textDark = Color(0xFF222222);
}
