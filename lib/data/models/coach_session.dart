// lib/data/models/coach_session.dart

import 'package:hive/hive.dart';

part 'coach_session.g.dart';

@HiveType(typeId: 1)
class CoachMessage {
  /// 'user' oder 'coach'
  @HiveField(0)
  final String role;

  @HiveField(1)
  final String text;

  @HiveField(2)
  final DateTime createdAt;

  const CoachMessage({
    required this.role,
    required this.text,
    required this.createdAt,
  });

  CoachMessage copyWith({
    String? role,
    String? text,
    DateTime? createdAt,
  }) {
    return CoachMessage(
      role: role ?? this.role,
      text: text ?? this.text,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'role': role,
      'text': text,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory CoachMessage.fromJson(Map<String, dynamic> json) {
    return CoachMessage(
      role: (json['role'] as String?) ?? 'coach',
      text: (json['text'] as String?) ?? '',
      createdAt: DateTime.parse(json['createdAt'] as String),
    );
  }
}

@HiveType(typeId: 2)
class CoachSession {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final DateTime startedAt;

  @HiveField(2)
  final DateTime updatedAt;

  @HiveField(3)
  final List<CoachMessage> messages;

  // WICHTIG: kein 'const'
  CoachSession({
    required this.id,
    required this.startedAt,
    required this.updatedAt,
    required List<CoachMessage> messages,
  }) : messages = List<CoachMessage>.unmodifiable(messages);

  CoachSession copyWith({
    DateTime? startedAt,
    DateTime? updatedAt,
    List<CoachMessage>? messages,
  }) {
    return CoachSession(
      id: id,
      startedAt: startedAt ?? this.startedAt,
      updatedAt: updatedAt ?? this.updatedAt,
      messages: messages ?? this.messages,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'startedAt': startedAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'messages': messages.map((m) => m.toJson()).toList(),
    };
  }

  factory CoachSession.fromJson(Map<String, dynamic> json) {
    final rawMessages = (json['messages'] as List?) ?? const [];

    return CoachSession(
      id: json['id'] as String,
      startedAt: DateTime.parse(json['startedAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      messages: rawMessages
          .map(
            (e) => CoachMessage.fromJson(
              (e as Map).cast<String, dynamic>(),
            ),
          )
          .toList(),
    );
  }
}
