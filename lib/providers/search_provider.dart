import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:playtones/services/audio%20service/audio_service.dart';

class SearchProvider extends ChangeNotifier {
  List<SongModel> searchedSongs = [];
  final _audioPlayer = AudioService.audioPlayer;

  //Searching
  void search(String query) {
    searchedSongs =
        AudioService.songs
            .where(
              (song) => song.title.toLowerCase().contains(query.toLowerCase()),
            )
            .toList();
    notifyListeners();
  }

  //playling the searched song
  Future<void> playSong(SongModel song) async {
    final audioSource = AudioSource.uri(
      Uri.parse(song.uri ?? ""),
      tag: MediaItem(
        id: song.id.toString(),
        title: song.title,
        artist: song.artist ?? "",
        artUri: Uri.parse(
          "content://media/external/audio/albumart/${song.albumId}",
        ),
      ),
    );
    await _audioPlayer.setAudioSource(audioSource);
    await _audioPlayer.play();
  }

  @override
  void dispose() {
    SearchProvider().dispose();
    super.dispose();
  }
}
