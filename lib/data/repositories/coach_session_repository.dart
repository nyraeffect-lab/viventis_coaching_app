// lib/data/repositories/coach_session_repository.dart

import 'dart:convert';

import 'package:hive/hive.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/coach_session.dart';

abstract class CoachSessionRepository {
  Future<List<CoachSession>> loadAllSessions();
  Future<CoachSession?> loadLastSession();
  Future<void> saveSession(CoachSession session);
}

/// ---------------------------------------------------------------------------
/// HIVE-IMPLEMENTIERUNG (empfohlen)
/// ---------------------------------------------------------------------------
class HiveCoachSessionRepository implements CoachSessionRepository {
  static const String _boxName = 'sessions';

  Future<Box<CoachSession>> get _box async {
    if (Hive.isBoxOpen(_boxName)) {
      return Hive.box<CoachSession>(_boxName);
    }
    return Hive.openBox<CoachSession>(_boxName);
  }

  @override
  Future<List<CoachSession>> loadAllSessions() async {
    try {
      final box = await _box;
      return box.values.toList(growable: false);
    } catch (_) {
      // Im Zweifel lieber leer zurück als Crash
      return [];
    }
  }

  @override
  Future<CoachSession?> loadLastSession() async {
    final sessions = await loadAllSessions();
    if (sessions.isEmpty) return null;

    sessions.sort((a, b) => a.updatedAt.compareTo(b.updatedAt));
    return sessions.last;
  }

  @override
  Future<void> saveSession(CoachSession session) async {
    final box = await _box;
    // Wir nutzen die ID als Key – damit wird jede Session eindeutig gespeichert/überschrieben
    await box.put(session.id, session);
  }
}

/// ---------------------------------------------------------------------------
/// ALTE IMPLEMENTIERUNG (SharedPreferences) – kann später entfernt werden
/// ---------------------------------------------------------------------------
class SharedPrefsCoachSessionRepository implements CoachSessionRepository {
  static const String _storageKey = 'coach_sessions';

  Future<SharedPreferences> get _prefs async =>
      SharedPreferences.getInstance();

  @override
  Future<List<CoachSession>> loadAllSessions() async {
    try {
      final prefs = await _prefs;
      final raw = prefs.getString(_storageKey);
      if (raw == null || raw.trim().isEmpty) {
        return [];
      }

      final decoded = jsonDecode(raw);
      if (decoded is! List) {
        return [];
      }

      return decoded
          .map(
            (e) => CoachSession.fromJson(
              (e as Map).cast<String, dynamic>(),
            ),
          )
          .toList();
    } catch (_) {
      // Im Zweifel lieber leer zurück als Crash
      return [];
    }
  }

  @override
  Future<CoachSession?> loadLastSession() async {
    final sessions = await loadAllSessions();
    if (sessions.isEmpty) return null;

    sessions.sort((a, b) => a.updatedAt.compareTo(b.updatedAt));
    return sessions.last;
  }

  @override
  Future<void> saveSession(CoachSession session) async {
    final prefs = await _prefs;
    final sessions = await loadAllSessions();

    final index = sessions.indexWhere((s) => s.id == session.id);
    if (index >= 0) {
      sessions[index] = session;
    } else {
      sessions.add(session);
    }

    final encoded = jsonEncode(
      sessions.map((s) => s.toJson()).toList(growable: false),
    );

    await prefs.setString(_storageKey, encoded);
  }
}
