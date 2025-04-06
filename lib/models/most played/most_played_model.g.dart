// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'most_played_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class MostPlayedModelAdapter extends TypeAdapter<MostPlayedModel> {
  @override
  final int typeId = 3;

  @override
  MostPlayedModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return MostPlayedModel(
      songId: fields[0] as int,
      count: fields[1] as int,
      title: fields[2] as String,
      artist: fields[3] as String,
    );
  }

  @override
  void write(BinaryWriter writer, MostPlayedModel obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.songId)
      ..writeByte(1)
      ..write(obj.count)
      ..writeByte(2)
      ..write(obj.title)
      ..writeByte(3)
      ..write(obj.artist);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MostPlayedModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
