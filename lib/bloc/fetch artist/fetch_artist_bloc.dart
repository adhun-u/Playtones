import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:just_audio/just_audio.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:playtones/bloc/enums.dart';
import 'package:playtones/services/audio%20service/audio_service.dart';
part 'fetch_artist_event.dart';
part 'fetch_artist_state.dart';

class FetchArtistBloc extends Bloc<FetchArtistEvent, FetchArtistState> {
  AudioPlayer audioPlayer = AudioService.audioPlayer;
  OnAudioQuery audioQuery = OnAudioQuery();
  ConcatenatingAudioSource tempPlaylist = ConcatenatingAudioSource(
    children: [],
  );
  ConcatenatingAudioSource playlist = ConcatenatingAudioSource(children: []);
  FetchArtistBloc() : super(FetchArtistInitial()) {
    on<ArtistFetchEvent>(fetchArtist);
    on<ArtistBasedSongsEvent>(fetchSongsFromArtist);
    on<PlaysongEvent>(playSong);
  }

  //Fetching all artists from external storage
  Future<void> fetchArtist(
    ArtistFetchEvent event,
    Emitter<FetchArtistState> emit,
  ) async {
    emit(LoadingState());
    try {
      List<ArtistModel> validArtists = [];
      List<SongModel> songs = [];

      List<ArtistModel> artists = await audioQuery.queryArtists(
        sortType: ArtistSortType.ARTIST,
        orderType: OrderType.ASC_OR_SMALLER,
        uriType: UriType.EXTERNAL,
      );

      //Checking the artist exist or not in external storage
      List<SongModel> songsFromArtsit = await audioQuery.querySongs(
        orderType: OrderType.ASC_OR_SMALLER,
        sortType: SongSortType.TITLE,
        uriType: UriType.EXTERNAL,
      );
      for (var artist in artists) {
        songs =
            songsFromArtsit
                .where((song) => song.artistId == artist.id)
                .toList();
        if (songs.isNotEmpty) {
          List<SongModel> existSongs =
              songs.where((song) {
                File songFile = File(song.data);
                return songFile.existsSync();
              }).toList();

          if (existSongs.isNotEmpty) {
            validArtists.add(artist);
          }
        }
      }
      emit(ArtistFetchState(artists: validArtists));
    } catch (e) {
      emit(ErrorState(errorMessage: 'Cannot fetch artist'));
    }
  }

  //Fetching songs from an artist
  Future<void> fetchSongsFromArtist(
    ArtistBasedSongsEvent event,
    Emitter<FetchArtistState> emit,
  ) async {
    emit(LoadingState());
    try {
      //Fetching all songs from external storage
      List<SongModel> songs = [];
      List<SongModel> querySongs = await audioQuery.querySongs(
        orderType: OrderType.ASC_OR_SMALLER,
        sortType: SongSortType.TITLE,
        uriType: UriType.EXTERNAL,
      );

      //Checking the songs are valid(that is not deleted)
      List<SongModel> validSongs =
          querySongs.where((song) {
            File songFile = File(song.data);
            return songFile.existsSync();
          }).toList();

      //Converting the songs by artist id for fetching songs based on an artist
      songs =
          validSongs.where((song) => song.artistId == event.artistId).toList();
      emit(ArtistBasedSongState(songs: songs, artistId: event.artistId));
      List<AudioSource> source =
          songs.map((song) {
            return AudioSource.uri(
              Uri.parse(song.uri ?? ""),
              tag: MediaItem(
                id: song.id.toString(),
                title: song.title,
                artist: song.artist,
                artUri: Uri.parse(
                  "content://media/external/audio/albumart/${song.albumId}",
                ),
              ),
            );
          }).toList();

      await tempPlaylist.clear();
      await tempPlaylist.addAll(source);
    } catch (e) {
      emit(ErrorState(errorMessage: 'Cannot fetch songs'));
    }
  }

  Future<void> playSong(
    PlaysongEvent event,
    Emitter<FetchArtistState> emit,
  ) async {
    try {
      //Adding the tempPlaylist into playlist
      await playlist.clear();
      List<AudioSource> tempSource = List<AudioSource>.from(
        tempPlaylist.children,
      );
      await playlist.addAll(tempSource);
      await audioPlayer.setAudioSource(playlist);
      if (event.index >= 0 && event.index < tempPlaylist.length) {
        await audioPlayer.seek(Duration.zero, index: event.index);
        await audioPlayer.play();
        selected = null;
      } else {
        emit(ErrorState(errorMessage: 'Invalid Song'));
        selected = null;
      }
    } catch (e) {
      emit(ErrorState(errorMessage: 'Cannot play'));
    }
  }
}
