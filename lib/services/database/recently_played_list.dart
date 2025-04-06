import 'package:hive_flutter/hive_flutter.dart';
import 'package:playtones/models/recent%20model/recently_played_list.dart';

class RecentlyPlayedDB {
  final _boxName = 'recentPlayedBox';

  //Adding the song that played recently
  Future<void> addSong(
    int songId,
    DateTime time,
    String title,
    String artist,
  ) async {
    final model = RecentlyPlayedListModel(
      songId: songId,
      time: time,
      title: title,
      artist: artist,
    );
    Box<RecentlyPlayedListModel> recentSongBox =
        await Hive.openBox<RecentlyPlayedListModel>(_boxName);
    await recentSongBox.put(songId, model);
  }

  //Getting song id from hive
  Future<List<RecentlyPlayedListModel>> getSongDetails() async {
    Box<RecentlyPlayedListModel> recentSongBox =
        await Hive.openBox<RecentlyPlayedListModel>(_boxName);
    List<RecentlyPlayedListModel> ids = recentSongBox.values.toList();
    return ids;
  }

  //Delete All songs
  Future<void> deleteAll() async {
    await Hive.deleteBoxFromDisk(_boxName);
  }
}
