import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:just_audio/just_audio.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:playtones/bloc/enums.dart';
import 'package:playtones/services/audio%20service/audio_service.dart';
part 'fetch_audio_event.dart';
part 'fetch_audio_state.dart';

class FetchAudioBloc extends Bloc<FetchAudioEvent, FetchAudioState> {
  //Creating instance of Audioplayer,OnAudioQuery
  AudioPlayer audioPlayer = AudioService.audioPlayer;
  OnAudioQuery audioQuery = OnAudioQuery();
  ConcatenatingAudioSource playlist = ConcatenatingAudioSource(children: []);
  ConcatenatingAudioSource tempPlaylist = ConcatenatingAudioSource(
    children: [],
  );
  List<SongModel> songs = [];

  FetchAudioBloc() : super(FetchAudioInitial()) {
    on<FetchSongsEvent>(fetchSongs);
    on<PlaysongEvent>(playSong);
  }

  Future<void> fetchSongs(
    FetchSongsEvent event,
    Emitter<FetchAudioState> emit,
  ) async {
    emit(FetchAudioLoadingState());
    try {
      //fetching songs from externel storage

      List<SongModel> fetchedSongs = await audioQuery.querySongs(
        sortType: SongSortType.TITLE,
        orderType: OrderType.ASC_OR_SMALLER,
        uriType: UriType.EXTERNAL,
      );
      //chacking the songs the exist in the storage

      songs =
          fetchedSongs.where((song) {
            File songFile = File(song.data);
            return songFile.existsSync();
          }).toList();

      emit(FetchAudioLoadedState(songs: songs));

      //Converting All songs into a single playlist

      if (songs.isNotEmpty) {
        List<AudioSource> source =
            songs.map((song) {
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
        playlist.insertAll(0, source);
        AudioService.songs.clear();
        AudioService.songs = songs;
      }
    } catch (exception) {
      emit(FetchErrorState(errorMessage: 'Cannot fetch songs'));
    }
  }

  //to play song
  void playSong(PlaysongEvent event, Emitter<FetchAudioState> emit) async {
    try {
      //For playling song from recently played section

      if (event.isFromPlaylist) {
        if (event.songId != null) {
          int index = songs.indexWhere((song) {
            return event.songId == song.id;
          });
          await audioPlayer.setAudioSource(playlist);
          await audioPlayer.seek(Duration.zero, index: index);
          await audioPlayer.play();
        }
      } else {
        if (selected != Selected.fromAudio) {
          List<AudioSource> tempSource = List<AudioSource>.from(
            playlist.children,
          );
          await tempPlaylist.clear();
          await tempPlaylist.addAll(tempSource);
          await audioPlayer.setAudioSource(tempPlaylist);
          selected = Selected.fromAudio;
        }
        if (event.index >= 0 && event.index < tempPlaylist.length) {
          await audioPlayer.seek(Duration.zero, index: event.index);
          await audioPlayer.play();
        } else {
          emit(FetchErrorState(errorMessage: 'Invalid Song'));
        }
      }
    } catch (_) {
      emit(FetchErrorState(errorMessage: "Cannot play"));
    }
  }
}
