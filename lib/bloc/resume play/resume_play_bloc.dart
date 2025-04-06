import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:just_audio/just_audio.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:playtones/services/audio%20service/audio_service.dart';
import 'package:playtones/services/database/save_songs_db.dart';
part 'resume_play_event.dart';
part 'resume_play_state.dart';

class ResumePlayBloc extends Bloc<ResumePlayEvent, ResumePlayState> {
  final _audioPlayer = AudioService.audioPlayer;
  final _playlist = ConcatenatingAudioSource(children: []);
  final _audioQuery = OnAudioQuery();
  ResumePlayBloc() : super(ResumePlayInitial()) {
    on<PlayWhereStoppedEvent>(resume);
  }
  Future<void> setSongs(int index, Duration duration) async {
    List<SongModel> validSongs = [];
    List<SongModel> songs = [];

    songs = await _audioQuery.querySongs(
      orderType: OrderType.ASC_OR_SMALLER,
      sortType: SongSortType.TITLE,
      uriType: UriType.EXTERNAL,
    );
    if (songs.isNotEmpty) {
      validSongs =
          songs.where((song) {
            File songFile = File(song.data);
            return songFile.existsSync();
          }).toList();

      List<AudioSource> source =
          validSongs.map((song) {
            return AudioSource.uri(
              Uri.parse(song.uri ?? ''),
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
      await _playlist.insertAll(0, source);
      await _audioPlayer.setAudioSource(
        _playlist,
        initialIndex: index,
        initialPosition: duration,
      );
    }
  }

  Future<void> resume(
    PlayWhereStoppedEvent event,
    Emitter<ResumePlayState> emit,
  ) async {
    final savedSong = await SaveSongsDb().getSavedSong();
    if (savedSong != null) {
      int index = savedSong.index!;
      Duration duration = Duration(
        minutes: savedSong.currentminute ?? 0,
        seconds: savedSong.currentseconds ?? 0,
      );
      try {
        await setSongs(index, duration);
        if (index >= 0 && index < _playlist.length) {
          await _audioPlayer.seek(duration, index: index);
          await _audioPlayer.play();
        } else {
          emit(ErrorState(errorMessage: 'Invalid Song'));
        }
        await SaveSongsDb().deleteAllData();
      } catch (e) {
        emit(ErrorState(errorMessage: 'Cannot play'));
      }
    }
  }
}
