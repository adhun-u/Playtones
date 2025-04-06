import 'package:hive_flutter/adapters.dart';
part 'songs_model.g.dart';

@HiveType(typeId: 5)
class SongsDataModel {
  @HiveField(0)
  String playlistId;
  @HiveField(1)
  String title;
  @HiveField(2)
  String artist;
  @HiveField(3)
  int songId;
  @HiveField(4)
  String? uniqueId;
  @HiveField(5)
  DateTime? time;
  SongsDataModel({
    required this.playlistId,
    required this.songId,
    required this.title,
    required this.artist,
    required this.uniqueId,
    required this.time,
  });
}
