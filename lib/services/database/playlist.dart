import 'package:hive_flutter/hive_flutter.dart';
import 'package:playtones/models/playlist%20model/playlist_model.dart';
import 'package:playtones/models/playlist%20model/songs_model.dart';

class PlaylistDB {
  final _playlistBox = 'playlistBox';
  final _songsBox = 'songsBox';

  //Adding new Playlist to hive
  Future<void> addPlaylist({required PlaylistDataModel model}) async {
    Box<PlaylistDataModel> playlistBox = await Hive.openBox<PlaylistDataModel>(
      _playlistBox,
    );
    await playlistBox.put(model.playlistId, model);
  }

  //Getting the playlists that saved
  Future<List<PlaylistDataModel>> getPlaylists() async {
    Box<PlaylistDataModel> playlistBox = await Hive.openBox<PlaylistDataModel>(
      _playlistBox,
    );
    return playlistBox.values.toList();
  }

  //Deleting each playlist from database
  Future<void> deletePlaylist(String id) async {
    Box<PlaylistDataModel> playlistBox = await Hive.openBox<PlaylistDataModel>(
      _playlistBox,
    );
    await playlistBox.delete(id);
  }

  //Adding songs to a specific playlist using the playlis id
  Future<void> addSongsToPlaylist({required SongsDataModel model}) async {
    Box<SongsDataModel> songBox = await Hive.openBox<SongsDataModel>(_songsBox);
    await songBox.put(model.uniqueId, model);
  }

  //Getting the songs from database
  Future<List<SongsDataModel>> getAllSongs() async {
    Box<SongsDataModel> songBox = await Hive.openBox<SongsDataModel>(_songsBox);
    return songBox.values.toList();
  }

  //Deleting each songs from database using song id
  Future<void> deleteSongs(String id) async {
    Box<SongsDataModel> songBox = await Hive.openBox<SongsDataModel>(_songsBox);
    await songBox.delete(id);
  }

  //Changing the name of a playlist
  Future<void> renamePlaylist(PlaylistDataModel model) async {
    Box<PlaylistDataModel> playlistBox = await Hive.openBox<PlaylistDataModel>(
      _playlistBox,
    );
    await playlistBox.put(model.playlistId, model);
  }
}
