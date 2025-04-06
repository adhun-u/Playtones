import 'package:just_audio/just_audio.dart';
import 'package:on_audio_query/on_audio_query.dart';

//Creating a singleton instance(instance is created once)
class AudioService {
  static final AudioService _instance = AudioService._internal();
  static final AudioPlayer audioPlayer = AudioPlayer();
  //Adding for search
  static List<SongModel> songs = [];

  factory AudioService() {
    return _instance;
  }
  AudioService._internal();
}
