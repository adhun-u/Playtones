import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:just_audio/just_audio.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:playtones/bloc/enums.dart';
import 'package:playtones/models/favorites%20model/favorite.dart';
import 'package:playtones/services/audio%20service/audio_service.dart';
import 'package:playtones/services/database/favorite_list_db.dart';
part 'favorite_event.dart';
part 'favorite_state.dart';

class FavoriteBloc extends Bloc<FavoriteEvent, FavoriteState> {
  AudioPlayer audioPlayer = AudioService.audioPlayer;
  ConcatenatingAudioSource playlist = ConcatenatingAudioSource(children: []);
  ConcatenatingAudioSource tempPlaylist = ConcatenatingAudioSource(
    children: [],
  );
  FavoriteBloc() : super(FavoriteInitial()) {
    on<AddSongs>(addSong);
    on<GetSongEvent>(getSongs);
    on<RemoveSongEvent>(removeSong);
    on<PlaySongEvent>(playSong);
    on<DeleteAllSongs>(deleteAllSongs);
  }

  //Add song to database
  Future<void> addSong(AddSongs event, Emitter<FavoriteState> emit) async {
    final favoriteModel = FavoriteModel(songId: event.songId);
    await FavoriteListDB().addSongs(favoriteModel);
    emit(SuccessState(message: 'Added to Favorite list'));
  }

  //Get songs from list
  Future<void> getSongs(
    FavoriteEvent event,
    Emitter<FavoriteState> emit,
  ) async {
    List<SongModel> songs = [];
    List<SongModel> validSongs = [];
    List<SongModel> favoriteSongs = [];
    List<FavoriteModel> ids = [];

    try {
      //Fetching songs with saved id
      songs = await OnAudioQuery().querySongs(
        orderType: OrderType.ASC_OR_SMALLER,
        sortType: SongSortType.TITLE,
        uriType: UriType.EXTERNAL,
      );
      //checking if the song exits or not
      validSongs =
          songs.where((song) {
            File songFile = File(song.data);
            return songFile.existsSync();
          }).toList();
      Iterable<FavoriteModel> modelIds = await FavoriteListDB().getSongs();
      for (var model in modelIds) {
        ids.add(model);
      }
      //Adding valid songs into favorite songs according to the condition
      if (ids.isNotEmpty) {
        favoriteSongs =
            validSongs.where((song) {
              return ids.any((id) => id.songId == song.id);
            }).toList();
        List<AudioSource> source =
            favoriteSongs.map((song) {
              return AudioSource.uri(
                Uri.parse(song.uri ?? ""),
                tag: MediaItem(
                  id: song.id.toString(),
                  title: song.title,
                  artist: song.artist,
                  album: song.album,
                  artUri: Uri.parse(
                    "content://media/external/audio/albumart/${song.albumId}",
                  ),
                ),
              );
            }).toList();
        await tempPlaylist.clear();
        await tempPlaylist.addAll(source);
        emit(GetSongsState(songs: favoriteSongs));
      }
    } catch (e) {
      emit(ErrorState(errorMessage: 'Something went wrong'));
    }
  }

  //Remove songs from the list
  Future<void> removeSong(
    RemoveSongEvent event,
    Emitter<FavoriteState> emit,
  ) async {
    await FavoriteListDB().deleteSong(event.songId);
    if (state is GetSongsState) {
      //copying state from GetSongsState for emitting new state
      GetSongsState currentState = state as GetSongsState;
      List<SongModel> songs = List<SongModel>.from(currentState.songs);
      songs.removeWhere((song) {
        return song.id == event.songId;
      });
      //deleting from database
      await FavoriteListDB().deleteSong(event.songId);
      emit(SuccessState(message: 'Removed from favorite'));
      emit(GetSongsState(songs: songs));
    }
  }

  Future<void> playSong(
    PlaySongEvent event,
    Emitter<FavoriteState> emit,
  ) async {
    await playlist.clear();
    List<AudioSource> tempSource = List<AudioSource>.from(
      tempPlaylist.children,
    );
    await playlist.addAll(tempSource);
    await audioPlayer.setAudioSource(playlist);
    await audioPlayer.seek(Duration.zero, index: event.index);
    await audioPlayer.play();
    await tempPlaylist.clear();
    selected = null;
  }

  //Deleting all songs from list and database
  Future<void> deleteAllSongs(
    DeleteAllSongs event,
    Emitter<FavoriteState> emit,
  ) async {
    await FavoriteListDB().deletAllSongs();
    emit(GetSongsState(songs: []));
  }
}
