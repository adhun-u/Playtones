import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:playtones/models/favorites%20model/favorite.dart';

class FavoriteListDB {
  final _boxName = 'favoriteBox';

  //Adding a song id
  Future<void> addSongs(FavoriteModel songid) async {
    Box<FavoriteModel> favoriteListBox = await Hive.openBox<FavoriteModel>(
      _boxName,
    );
    await favoriteListBox.put(songid.songId, songid);
  }

  //Getting songs id
  Future<List<FavoriteModel>> getSongs() async {
    Box<FavoriteModel> favoriteListBox = await Hive.openBox<FavoriteModel>(
      _boxName,
    );
    return favoriteListBox.values.toList();
  }

  //Deleting a specific id
  Future<void> deleteSong(int id) async {
    Box<FavoriteModel> favoriteListBox = await Hive.openBox<FavoriteModel>(
      _boxName,
    );
    await favoriteListBox.delete(id);
  }

  //Deleting all songs
  Future<void> deletAllSongs() async {
    await Hive.deleteBoxFromDisk(_boxName);
  }
}
