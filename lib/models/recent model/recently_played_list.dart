import 'package:hive_flutter/adapters.dart';
part 'recently_played_list.g.dart';

@HiveType(typeId: 2)
class RecentlyPlayedListModel {
  @HiveField(0)
  int? songId;
  @HiveField(1)
  DateTime? time;
  @HiveField(2)
  String? title;
  @HiveField(3)
  String? artist;

  RecentlyPlayedListModel({
    required this.songId,
    required this.time,
    required this.title,
    required this.artist,
  });
}
