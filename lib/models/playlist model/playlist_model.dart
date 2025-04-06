import 'package:hive_flutter/adapters.dart';
part 'playlist_model.g.dart';

@HiveType(typeId: 4)
class PlaylistDataModel {
  @HiveField(0)
  String? playlistName;
  @HiveField(1)
  String playlistId;

  PlaylistDataModel({required this.playlistName, required this.playlistId});
}
