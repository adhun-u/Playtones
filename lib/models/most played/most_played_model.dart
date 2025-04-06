import 'package:hive_flutter/adapters.dart';
part 'most_played_model.g.dart';

@HiveType(typeId: 3)
class MostPlayedModel {
  @HiveField(0)
  int songId;
  @HiveField(1)
  int count;
  @HiveField(2)
  String title;
  @HiveField(3)
  String artist;

  MostPlayedModel({
    required this.songId,
    required this.count,
    required this.title,
    required this.artist,
  });
}
