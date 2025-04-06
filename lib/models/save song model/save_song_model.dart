import 'package:hive_flutter/adapters.dart';
part 'save_song_model.g.dart';

@HiveType(typeId: 20)
class SaveSongModel {
  @HiveField(0)
  String? songtitle;
  @HiveField(1)
  String? artist;
  @HiveField(2)
  int? songId;
  @HiveField(3)
  int? currentseconds;
  @HiveField(4)
  int? currentminute;
  @HiveField(5)
  int? index;
  @HiveField(6)
  int? totalminute;
  @HiveField(7)
  int? totalsecond;

  SaveSongModel({
    required this.songtitle,
    required this.artist,
    required this.currentseconds,
    required this.songId,
    required this.currentminute,
    required this.index,
    required this.totalminute,
    required this.totalsecond,
  });
}
