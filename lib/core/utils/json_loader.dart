import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;

class JsonLoader {
  const JsonLoader._();

  static Future<Map<String, dynamic>> loadJsonMap(String assetPath) async {
    final raw = await rootBundle.loadString(assetPath);
    final decoded = json.decode(raw);
    if (decoded is Map<String, dynamic>) {
      return decoded;
    }
    // <-- hier geändert: const entfernt
    throw FormatException(
      'Expected JSON object at root of $assetPath',
    );
  }
}
