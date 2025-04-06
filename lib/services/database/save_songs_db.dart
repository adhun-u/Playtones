import 'package:hive_flutter/adapters.dart';
import 'package:playtones/models/save%20song%20model/save_song_model.dart';

class SaveSongsDb {
  final _boxName = 'saveSongsBox';

  //Saving the songs when terminate the app
  Future<void> saveSong(SaveSongModel model) async {
    Box<SaveSongModel> hiveBox = await Hive.openBox<SaveSongModel>(_boxName);
    await hiveBox.put(model.songId, model);
  }

  //Getting the song the saved
  Future<SaveSongModel?> getSavedSong() async {
    Box<SaveSongModel> hiveBox = await Hive.openBox<SaveSongModel>(_boxName);
    return hiveBox.values.isNotEmpty ? hiveBox.values.toList().first : null;
  }

  //Deleting all previous data when saving another song
  Future<void> deleteAllData() async {
    Box<SaveSongModel> hiveBox = await Hive.openBox<SaveSongModel>(_boxName);
    await hiveBox.deleteFromDisk();
  }
}
