// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'coach_session.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class CoachMessageAdapter extends TypeAdapter<CoachMessage> {
  @override
  final int typeId = 1;

  @override
  CoachMessage read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return CoachMessage(
      role: fields[0] as String,
      text: fields[1] as String,
      createdAt: fields[2] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, CoachMessage obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.role)
      ..writeByte(1)
      ..write(obj.text)
      ..writeByte(2)
      ..write(obj.createdAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CoachMessageAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class CoachSessionAdapter extends TypeAdapter<CoachSession> {
  @override
  final int typeId = 2;

  @override
  CoachSession read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return CoachSession(
      id: fields[0] as String,
      startedAt: fields[1] as DateTime,
      updatedAt: fields[2] as DateTime,
      messages: (fields[3] as List).cast<CoachMessage>(),
    );
  }

  @override
  void write(BinaryWriter writer, CoachSession obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.startedAt)
      ..writeByte(2)
      ..write(obj.updatedAt)
      ..writeByte(3)
      ..write(obj.messages);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CoachSessionAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
