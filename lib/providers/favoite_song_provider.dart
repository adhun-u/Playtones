import 'package:flutter/material.dart';
import 'package:playtones/models/favorites%20model/favorite.dart';
import 'package:playtones/services/database/favorite_list_db.dart';

//Getting ids for showing if the song is favorite or not
class FavoiteSongProvider extends ChangeNotifier {
  List<FavoriteModel> favorites = [];

  FavoiteSongProvider() {
    getId();
  }

  //getting all ids
  Future<void> getId() async {
    List<FavoriteModel> model = await FavoriteListDB().getSongs();
    favorites.clear();
    for (var favoriteModel in model) {
      favorites.add(favoriteModel);
      notifyListeners();
    }
  }

  //Deleting from favorites list
  void delete(int id) async {
    int index = favorites.indexWhere((model) {
      return model.songId == id;
    });
    favorites.removeAt(index);
    notifyListeners();
  }

  //Adding model to favorite list for getting real time data
  void addToList(FavoriteModel model) async {
    favorites.add(model);
    notifyListeners();
  }

  @override
  void dispose() {
    FavoiteSongProvider().dispose();
    super.dispose();
  }
}
