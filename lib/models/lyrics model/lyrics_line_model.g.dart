// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'lyrics_line_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class LyricsLineAdapter extends TypeAdapter<LyricsLine> {
  @override
  final int typeId = 10;

  @override
  LyricsLine read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return LyricsLine(
      minute: fields[1] as int,
      second: fields[2] as int,
      text: fields[0] as String,
      songId: fields[3] as int,
    );
  }

  @override
  void write(BinaryWriter writer, LyricsLine obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.text)
      ..writeByte(1)
      ..write(obj.minute)
      ..writeByte(2)
      ..write(obj.second)
      ..writeByte(3)
      ..write(obj.songId);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is LyricsLineAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
