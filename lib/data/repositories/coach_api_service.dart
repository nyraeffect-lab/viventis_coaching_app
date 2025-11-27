import 'dart:convert';
import 'package:http/http.dart' as http;

/// Einfache API-Schicht zum Viventis-Cloudflare-Worker.
/// Erwartet vom Worker eine JSON-Antwort mit einem Feld `reply` (String).
class CoachApiService {
  CoachApiService({
    http.Client? client,
    Uri? endpoint,
  })  : _client = client ?? http.Client(),
        _endpoint = endpoint ?? Uri.parse(_defaultEndpoint);

  /// URL deines Cloudflare-Workers
  static const String _defaultEndpoint =
      'https://viventis-coachbot.nyraeffect.workers.dev';

  /// Optional: API-Key, falls du später Auth einbauen möchtest.
  /// Aktuell leer, weil der Worker keinen Key erwartet.
  static const String _apiKey = '';

  final http.Client _client;
  final Uri _endpoint;

  /// Sendet Nachricht + History an den Worker und gibt den Reply-Text zurück.
  Future<String> sendMessage({
    required String message,
    required List<Map<String, dynamic>> history,
  }) async {
    final payload = <String, dynamic>{
      'message': message,
      'history': history,
      'meta': {
        'client': 'viventis_coaching_app',
        'source': 'mobile',
      },
    };

    final response = await _client.post(
      _endpoint,
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        if (_apiKey.isNotEmpty) 'Authorization': 'Bearer $_apiKey',
      },
      body: jsonEncode(payload),
    );

    if (response.statusCode != 200) {
      throw Exception(
        'Serverfehler (${response.statusCode}): ${response.body}',
      );
    }

    final dynamic decoded = jsonDecode(response.body);
    if (decoded is Map<String, dynamic>) {
      final reply = decoded['reply'] ?? decoded['message'] ?? decoded['text'];
      if (reply is String && reply.trim().isNotEmpty) {
        return reply.trim();
      }
    }

    throw Exception('Unerwartete Antwort vom Server.');
  }

  void dispose() {
    _client.close();
  }
}
