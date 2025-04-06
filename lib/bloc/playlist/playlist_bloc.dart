import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:just_audio/just_audio.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:playtones/models/playlist%20model/playlist_model.dart';
import 'package:playtones/models/playlist%20model/songs_model.dart';
import 'package:playtones/services/audio%20service/audio_service.dart';
import 'package:playtones/services/database/playlist.dart';
import 'package:uuid/uuid.dart';
part 'playlist_event.dart';
part 'playlist_state.dart';

class PlaylistBloc extends Bloc<PlaylistEvent, PlaylistState> {
  final _onaudioQuery = OnAudioQuery();
  final _audioPlayer = AudioService.audioPlayer;
  final _tempPlaylist = ConcatenatingAudioSource(children: []);
  PlaylistBloc() : super(PlaylistInitial()) {
    on<CreatePlaylistEvent>(createPlaylist);
    on<FetchPlaylistEvent>(getPlaylists);
    on<AddSongsToPlaylistEvent>(addSongsToPlaylist);
    on<GetSongsFromPlaylistEvent>(getSongsFromPlaylist);
    on<DeleteSongFromPlaylistEvent>(deleteSong);
    on<PlaySongEvent>(playSong);
    on<DeletePlaylistEvent>(deletePlaylist);
    on<RenamePlaylistEvent>(renamePlaylist);
  }

  //Creating a playlist
  Future<void> createPlaylist(
    CreatePlaylistEvent event,
    Emitter<PlaylistState> emit,
  ) async {
    //Adding name to database
    final id = Uuid().v1();
    final model = PlaylistDataModel(playlistName: event.name, playlistId: id);
    await PlaylistDB().addPlaylist(model: model);
  }

  //Getting all playlist
  Future<void> getPlaylists(
    FetchPlaylistEvent event,
    Emitter<PlaylistState> emit,
  ) async {
    List<PlaylistDataModel> playlists = [];
    Iterable<PlaylistDataModel> data = await PlaylistDB().getPlaylists();
    for (var model in data) {
      playlists.add(model);
    }
    //For getting number of each songs
    List<int> numOfSongs = List.filled(playlists.length, 0);
    List<int> lastSongIds = List.filled(playlists.length, 0);
    Iterable<SongsDataModel> playlistSongs = await PlaylistDB().getAllSongs();
    for (int i = 0; i < data.length; i++) {
      int count = 1;
      for (int j = 0; j < playlistSongs.length; j++) {
        if (data.elementAt(i).playlistId ==
            playlistSongs.elementAt(j).playlistId) {
          numOfSongs[i] = count++;
          lastSongIds[i] = playlistSongs.elementAt(j).songId;
        }
      }
    }
    emit(
      AllPlaylistState(
        playlists: playlists,
        counts: numOfSongs,
        lastSongIds: lastSongIds,
      ),
    );
  }

  //Adding songs to playlist
  Future<void> addSongsToPlaylist(
    AddSongsToPlaylistEvent event,
    Emitter<PlaylistState> emit,
  ) async {
    //Getting all songs from playlist to check if the song is exist or not
    Iterable<SongsDataModel> playlistSongs = await PlaylistDB().getAllSongs();
    bool doesExist = playlistSongs.any(
      (song) =>
          song.playlistId == event.playlistId && song.songId == event.song.id,
    );
    if (!doesExist) {
      //Creating a model to insert database
      final id = Uuid().v1();
      final model = SongsDataModel(
        playlistId: event.playlistId,
        songId: event.song.id,
        title: event.song.title,
        artist: event.song.artist ?? "Unknown",
        uniqueId: id,
        time: DateTime.now(),
      );
      //Adding the model to database
      await PlaylistDB().addSongsToPlaylist(model: model);
    }
  }

  //Getting songs from a specific playlist
  Future<void> getSongsFromPlaylist(
    GetSongsFromPlaylistEvent event,
    Emitter<PlaylistState> emit,
  ) async {
    List<SongsDataModel> playlistsongs = [];
    List<SongModel> songs = [];
    List<SongModel> validSongs = [];

    List<SongModel> querySongs = await _onaudioQuery.querySongs(
      uriType: UriType.EXTERNAL,
      orderType: OrderType.ASC_OR_SMALLER,
    );

    songs =
        querySongs.where((song) {
          File songFile = File(song.data);
          return songFile.existsSync();
        }).toList();

    Iterable<SongsDataModel> playlistSongs = await PlaylistDB().getAllSongs();
    for (var song in playlistSongs) {
      if (song.playlistId == event.playlistId) {
        playlistsongs.add(song);
        for (var validSong in songs) {
          if (validSong.id == song.songId) {
            validSongs.add(validSong);
          }
        }
      }
    }
    playlistsongs.sort((firstSong, secondSong) {
      return secondSong.time!.compareTo(firstSong.time!);
    });
    validSongs.sort((firstSong, secondSong) {
      int firstIndex = playlistsongs.indexWhere(
        (song) => song.songId == firstSong.id,
      );
      int secondIndex = playlistsongs.indexWhere(
        (song) => song.songId == secondSong.id,
      );
      return firstIndex.compareTo(secondIndex);
    });
    if (validSongs.isNotEmpty) {
      List<AudioSource> source =
          validSongs.map((song) {
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
      await _tempPlaylist.insertAll(0, source);
    }
    emit(AllSongsFromPlaylist(songs: playlistsongs));
  }

  //To play song
  Future<void> playSong(
    PlaySongEvent event,
    Emitter<PlaylistState> emit,
  ) async {
    await _audioPlayer.setAudioSource(_tempPlaylist);
    if (event.index >= 0 && event.index < _tempPlaylist.length) {
      await _audioPlayer.seek(Duration.zero, index: event.index);
      await _audioPlayer.play();
    } else {
      emit(ErrorState(message: 'Invalid Song'));
    }
  }

  Future<void> deleteSong(
    DeleteSongFromPlaylistEvent event,
    Emitter<PlaylistState> emit,
  ) async {
    await PlaylistDB().deleteSongs(event.songId);
  }

  //Deleting playlist
  Future<void> deletePlaylist(
    DeletePlaylistEvent event,
    Emitter<PlaylistState> emit,
  ) async {
    await PlaylistDB().deletePlaylist(event.playlistId);
  }

  Future<void> renamePlaylist(
    RenamePlaylistEvent event,
    Emitter<PlaylistState> emit,
  ) async {
    final model = PlaylistDataModel(
      playlistName: event.newName,
      playlistId: event.id,
    );
    await PlaylistDB().renamePlaylist(model);
  }
}
