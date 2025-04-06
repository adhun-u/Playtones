import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:playtones/services/audio%20service/audio_service.dart';

//Creating features such as suffle mode ,loop mode
class AudioFeaturesProvider extends ChangeNotifier {
  //Creating instance of audioPlayer
  final audioPlayer = AudioService.audioPlayer;

  bool isSuffle = false;
  LoopMode? loop;
  double speedOfAudio = 1;

  AudioFeaturesProvider() {
    loop = audioPlayer.loopMode;
    isSuffle = audioPlayer.shuffleModeEnabled;
    initializeListeners();
  }

  //Initializing the listeners for suffle mode , loop mode , speed
  void initializeListeners() {
    audioPlayer.shuffleModeEnabledStream.listen((suffle) {
      isSuffle = suffle;
      notifyListeners();
    });
    audioPlayer.loopModeStream.listen((loopMode) {
      loop = loopMode;
      notifyListeners();
    });
    audioPlayer.speedStream.listen((speed) {
      speedOfAudio = speed;
      notifyListeners();
    });
  }

  //Enabling suffle mode
  void suffleMode(bool suffle) async {
    await audioPlayer.setShuffleModeEnabled(suffle);
  }

  //Enabling loop mode
  void changeLoopMode() async {
    if (loop == LoopMode.off) {
      await audioPlayer.setLoopMode(LoopMode.one);
    } else {
      await audioPlayer.setLoopMode(LoopMode.off);
    }
  }

  //Changing the speed of audio
  void increaseSpeed() async {
    if (speedOfAudio == 1) {
      await audioPlayer.setSpeed(2);
    } else if (speedOfAudio == 2) {
      await audioPlayer.setSpeed(0.25);
    } else if (speedOfAudio == 0.25) {
      await audioPlayer.setSpeed(0.5);
    } else if (speedOfAudio == 0.5) {
      await audioPlayer.setSpeed(1);
    }
  }

  @override
  void dispose() {
    AudioFeaturesProvider().dispose();
    super.dispose();
  }
}
