import 'dart:async';
import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:just_audio/just_audio.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:playtones/bloc/enums.dart';
import 'package:playtones/services/audio%20service/audio_service.dart';
part 'fetch_album_event.dart';
part 'fetch_album_state.dart';

class FetchAlbumBloc extends Bloc<FetchAlbumEvent, FetchAlbumState> {
  final OnAudioQuery audioQuery = OnAudioQuery();
  ConcatenatingAudioSource tempPlaylist = ConcatenatingAudioSource(
    children: [],
  );
  ConcatenatingAudioSource playlist = ConcatenatingAudioSource(children: []);
  AudioPlayer audioPlayer = AudioService.audioPlayer;
  FetchAlbumBloc() : super(FetchAlbumInitial()) {
    on<AlbumFetch>(fetchAlbums);
    on<AlbumBasedEvent>(fetchSongsFromAnAlbum);
    on<PlaySong>(playSong);
  }

  //Fetching albums for external storage
  Future<void> fetchAlbums(
    AlbumFetch event,
    Emitter<FetchAlbumState> emit,
  ) async {
    emit(LoadingState());

    try {
      //Fetching the albums with songs (avoid empty albums)
      List<AlbumModel> validAlbums = [];
      List<SongModel> songs = [];
      List<AlbumModel> albums = await audioQuery.queryAlbums();

      for (var album in albums) {
        List<SongModel> songsFromAlbum = await audioQuery.queryAudiosFrom(
          AudiosFromType.ALBUM_ID,
          album.id,
        );

        //chacking the album exist or not
        if (songsFromAlbum.isNotEmpty) {
          songs =
              songsFromAlbum.where((song) {
                File songFile = File(song.data);
                return songFile.existsSync();
              }).toList();

          if (songs.isNotEmpty) {
            validAlbums.add(album);
          }
        }
      }

      emit(AlbumsLoaded(albums: validAlbums));
    } catch (e) {
      emit(ErrorState(error: 'Cannot fetch albums'));
    }
  }

  //Fetching all songs from an album
  Future<void> fetchSongsFromAnAlbum(
    AlbumBasedEvent event,
    Emitter<FetchAlbumState> emit,
  ) async {
    emit(LoadingState());
    try {
      List<SongModel> songs = [];
      List<SongModel> albumSongs = [];
      List<SongModel> songsFromAlbum = await audioQuery.querySongs(
        uriType: UriType.EXTERNAL,
        orderType: OrderType.ASC_OR_SMALLER,
        sortType: SongSortType.ALBUM,
      );

      //Chacking the songs exist or not
      songs =
          songsFromAlbum.where((song) {
            File songExist = File(song.data);
            return songExist.existsSync();
          }).toList();

      if (songs.isNotEmpty) {
        //converting album songs
        albumSongs =
            songs.where((song) => song.albumId == event.albumId).toList();

        List<AudioSource> source =
            albumSongs.map((song) {
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

        emit(AlbumBasedSongsState(songs: albumSongs, albumId: event.albumId));
        await tempPlaylist.clear();
        await tempPlaylist.addAll(source);
      }
    } catch (e) {
      emit(ErrorState(error: 'Cannot fetch songs'));
    }
  }

  //Playing a song
  Future<void> playSong(PlaySong event, Emitter<FetchAlbumState> emit) async {
    try {
      List<AudioSource> tempSource = List<AudioSource>.from(
        tempPlaylist.children,
      );
      await playlist.clear();
      await playlist.addAll(tempSource);
      await audioPlayer.setAudioSource(playlist);
      if (event.index >= 0 && event.index < tempPlaylist.length) {
        await audioPlayer.seek(Duration.zero, index: event.index);
        await audioPlayer.play();
        selected = null;
      } else {
        emit(ErrorState(error: 'Invalid Song'));
        selected = null;
      }
    } catch (e) {
      emit(ErrorState(error: 'Cannot play'));
    }
  }
}
