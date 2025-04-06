import 'package:hive_flutter/adapters.dart';
import 'package:playtones/models/lyrics%20model/lyrics_line_model.dart';

class LyricsDB {
  final _boxName = 'lyrics_box';

  Future<void> addLyrics(List<LyricsLine> lyrics, int songId) async {
    Box<List<dynamic>> lyricsBox = await Hive.openBox<List<dynamic>>(_boxName);
    await lyricsBox.put(songId, lyrics);
  }

  Future<Iterable<List<LyricsLine>>> getLyrics() async {
    Box<List<dynamic>> lyricsBox = await Hive.openBox<List<dynamic>>(_boxName);
    return lyricsBox.values.map((value) => value.cast<LyricsLine>().toList());
  }
}
