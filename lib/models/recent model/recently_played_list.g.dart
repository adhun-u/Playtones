// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'recently_played_list.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class RecentlyPlayedListModelAdapter
    extends TypeAdapter<RecentlyPlayedListModel> {
  @override
  final int typeId = 2;

  @override
  RecentlyPlayedListModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return RecentlyPlayedListModel(
      songId: fields[0] as int?,
      time: fields[1] as DateTime?,
      title: fields[2] as String?,
      artist: fields[3] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, RecentlyPlayedListModel obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.songId)
      ..writeByte(1)
      ..write(obj.time)
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
      other is RecentlyPlayedListModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
