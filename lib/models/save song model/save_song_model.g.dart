// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'save_song_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class SaveSongModelAdapter extends TypeAdapter<SaveSongModel> {
  @override
  final int typeId = 20;

  @override
  SaveSongModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return SaveSongModel(
      songtitle: fields[0] as String?,
      artist: fields[1] as String?,
      currentseconds: fields[3] as int?,
      songId: fields[2] as int?,
      currentminute: fields[4] as int?,
      index: fields[5] as int?,
      totalminute: fields[6] as int?,
      totalsecond: fields[7] as int?,
    );
  }

  @override
  void write(BinaryWriter writer, SaveSongModel obj) {
    writer
      ..writeByte(8)
      ..writeByte(0)
      ..write(obj.songtitle)
      ..writeByte(1)
      ..write(obj.artist)
      ..writeByte(2)
      ..write(obj.songId)
      ..writeByte(3)
      ..write(obj.currentseconds)
      ..writeByte(4)
      ..write(obj.currentminute)
      ..writeByte(5)
      ..write(obj.index)
      ..writeByte(6)
      ..write(obj.totalminute)
      ..writeByte(7)
      ..write(obj.totalsecond);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SaveSongModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
