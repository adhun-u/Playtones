import 'package:hive_flutter/hive_flutter.dart';
part 'lyrics_line_model.g.dart';

@HiveType(typeId: 10)
class LyricsLine {
  @HiveField(0)
  String text;
  @HiveField(1)
  int minute;
  @HiveField(2)
  int second;
  @HiveField(3)
  int songId;
  LyricsLine({
    required this.minute,
    required this.second,
    required this.text,
    required this.songId,
  });
}
