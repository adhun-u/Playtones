import 'package:flutter/material.dart';
import 'package:playtones/models/lyrics%20model/lyrics_line_model.dart';
import 'package:playtones/services/database/lyrics.dart';

class LyricsProvider extends ChangeNotifier {
  List<LyricsLine> lyrics = [];

  //Getting all lyrics from database
  Future<void> getLyrics(int songId) async {
    List<LyricsLine> values = [];
    Iterable<List<LyricsLine>> data = await LyricsDB().getLyrics();
    values.clear();
    for (var lyric in data) {
      values.addAll(lyric);
    }
    lyrics.clear();
    for (var list in values) {
      if (list.songId == songId) {
        lyrics.add(list);
      }
    }
    notifyListeners();
  }

  @override
  void dispose() {
    LyricsProvider().dispose();
    super.dispose();
  }
}
