import 'package:hive_flutter/hive_flutter.dart';
import 'package:playtones/models/most%20played/most_played_model.dart';

class MostPlayedListDB {
  final _boxName = "mostPlayedList";

  //Adding song details to database
  Future<void> addSongs(MostPlayedModel model, int id) async {
    Box<MostPlayedModel> mostPlayedBox = await Hive.openBox<MostPlayedModel>(
      _boxName,
    );
    mostPlayedBox.put(id, model);
  }

  //Getting song details from database
  Future<List<MostPlayedModel>> getSong() async {
    Box<MostPlayedModel> mostPlayedBox = await Hive.openBox<MostPlayedModel>(
      _boxName,
    );
    return mostPlayedBox.values.toList();
  }

  //Deleting a specific key
  Future<void> deleteKey(int id) async {
    Box<MostPlayedModel> mostPlayedBox = await Hive.openBox<MostPlayedModel>(
      _boxName,
    );
    mostPlayedBox.delete(id);
  }

  //Deleting all keys and values
  Future<void> deleteAll() async {
    Box<MostPlayedModel> mostPlayedBox = await Hive.openBox<MostPlayedModel>(
      _boxName,
    );
    await mostPlayedBox.deleteFromDisk();
  }
}
