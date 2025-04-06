// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'songs_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class SongsDataModelAdapter extends TypeAdapter<SongsDataModel> {
  @override
  final int typeId = 5;

  @override
  SongsDataModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return SongsDataModel(
      playlistId: fields[0] as String,
      songId: fields[3] as int,
      title: fields[1] as String,
      artist: fields[2] as String,
      uniqueId: fields[4] as String?,
      time: fields[5] as DateTime?,
    );
  }

  @override
  void write(BinaryWriter writer, SongsDataModel obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.playlistId)
      ..writeByte(1)
      ..write(obj.title)
      ..writeByte(2)
      ..write(obj.artist)
      ..writeByte(3)
      ..write(obj.songId)
      ..writeByte(4)
      ..write(obj.uniqueId)
      ..writeByte(5)
      ..write(obj.time);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SongsDataModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
