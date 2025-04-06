import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:playtones/models/save%20song%20model/save_song_model.dart';
import 'package:playtones/services/audio%20service/audio_service.dart';
import 'package:playtones/services/database/save_songs_db.dart';

class SongDetailsProvider extends ChangeNotifier {
  //Creating instance and required variables for getting details
  final AudioPlayer audioPlayer = AudioService.audioPlayer;

  String? songTitle;
  String? artist;
  int? songId;
  int? currentIndex;
  Duration? totalDuration;
  Duration? bufferedDuration;
  Duration? currentPosition;
  String? album;
  String? artUri;
  String? songData;
  int? albumId;
  bool isPlaying = false;

  SongDetailsProvider() {
    getData();
    initializeListeners();
  }

  //Initializing required Listeners for getting details
  void initializeListeners() {
    audioPlayer.sequenceStateStream.listen((sequence) async {
      if (sequence?.currentSource?.tag != null) {
        final MediaItem mediaItem = sequence!.currentSource!.tag as MediaItem;
        songTitle = mediaItem.title;
        artist = mediaItem.artist;
        songId = int.parse(mediaItem.id);
        album = mediaItem.album;
        artUri = mediaItem.artUri.toString();
        notifyListeners();
      }
    });

    audioPlayer.currentIndexStream.listen((index) {
      currentIndex = index;
      notifyListeners();
    });

    audioPlayer.positionStream.listen((duration) async {
      if (currentPosition != null && totalDuration != null) {
        Duration totalDur = Duration(
          seconds: totalDuration!.inSeconds,
          minutes: totalDuration!.inMinutes,
          milliseconds: totalDuration!.inMilliseconds,
          microseconds: totalDuration!.inMicroseconds,
        );
        Duration changingDur = Duration(
          minutes: duration.inMinutes,
          seconds: duration.inSeconds,
          milliseconds: duration.inMilliseconds,
          microseconds: duration.inMicroseconds,
        );
        if (!audioPlayer.hasNext && changingDur >= totalDur ||
            totalDur == changingDur) {
          await audioPlayer.seek(Duration.zero, index: 0);
          await audioPlayer.play();
        }
      }
      currentPosition = duration;
      notifyListeners();
    });

    audioPlayer.durationStream.listen((duration) async {
      totalDuration = duration;
      notifyListeners();
    });

    audioPlayer.playerStateStream.listen((state) {
      isPlaying = state.playing;
      notifyListeners();
    });

    audioPlayer.bufferedPositionStream.listen((duration) {
      bufferedDuration = duration;
      notifyListeners();
    });
  }

  Future<void> whenDetached() async {
    await SaveSongsDb().deleteAllData();
    if (songId != null &&
        songTitle != null &&
        artist != null &&
        currentPosition != null) {
      final SaveSongModel model = SaveSongModel(
        songtitle: songTitle,
        artist: artist,
        currentminute: currentPosition!.inMinutes,
        currentseconds: currentPosition!.inSeconds,
        songId: songId,
        index: currentIndex,
        totalminute: totalDuration!.inMinutes,
        totalsecond: totalDuration!.inSeconds,
      );
      await SaveSongsDb().saveSong(model);
    }
  }

  void getData() async {
    final SaveSongModel? savedSong = await SaveSongsDb().getSavedSong();
    if (savedSong != null) {
      songId = savedSong.songId;
      songTitle = savedSong.songtitle;
      artist = savedSong.artist;
      currentIndex = savedSong.index;
      currentPosition = Duration(
        minutes: savedSong.currentminute!,
        seconds: savedSong.currentseconds!,
      );
      totalDuration = Duration(
        minutes: savedSong.totalminute!,
        seconds: savedSong.totalsecond!,
      );
      notifyListeners();
    }
  }

  @override
  void dispose() {
    SongDetailsProvider().dispose();
    super.dispose();
  }
}
