// lib/core/api/coach_api_service.dart
import 'dart:convert';

import 'package:http/http.dart' as http;

class CoachApiService {
  CoachApiService({http.Client? client}) : _client = client ?? http.Client();

  final http.Client _client;

  // Deine Worker-URL
  static const String _baseUrl =
      'https://viventis-coachbot.nyraeffect.workers.dev';

  Future<String> sendMessage(String message) async {
    final uri = Uri.parse(_baseUrl);

    final response = await _client.post(
      uri,
      headers: const {
        'Content-Type': 'application/json',
      },
      body: jsonEncode(<String, dynamic>{
        'message': message,
      }),
    );

    if (response.statusCode != 200) {
      throw Exception(
        'Serverfehler (${response.statusCode}): ${response.body}',
      );
    }

    final data = jsonDecode(response.body) as Map<String, dynamic>;
    final reply = data['reply'];

    if (reply is! String) {
      throw Exception('Ungültige Antwort vom Server');
    }

    return reply;
  }
}
