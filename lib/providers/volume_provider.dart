import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_volume_controller/flutter_volume_controller.dart';
import 'package:headset_connection_event/headset_event.dart';
import 'package:playtones/views/widgets/snack_bar.dart';

class VolumeProvider extends ChangeNotifier {
  static final _headsetEvent = HeadsetEvent();
  HeadsetState? headsetState;
  double? currentVol;
  bool? isSpeaker;

  VolumeProvider() {
    currentVolume();
    initializePlugin();
  }

  //For getting current volume of the device
  void currentVolume() async {
    await FlutterVolumeController.updateShowSystemUI(false);
    FlutterVolumeController.addListener((volume) {
      currentVol = volume;
      notifyListeners();
    });
  }

  //Changing the volume
  void changeVolume(double volume) async {
    await FlutterVolumeController.setVolume(volume);
  }

  //Checking if headset is connected
  void initializePlugin() {
    _headsetEvent.getCurrentState.then((value) {
      headsetState = value;
      isSpeaker = value == HeadsetState.CONNECT ? false : true;
      notifyListeners();
    });
    //checking headset is plugged or unplugged
    _headsetEvent.setListener((state) {
      headsetState = state;
      isSpeaker = state == HeadsetState.CONNECT ? false : true;
      notifyListeners();
    });
  }

  //Switching to speaker or headphone
  void switchSpeakerOrHeadphone(bool speaker, BuildContext context) async {
    try {
      final channel = MethodChannel("change_audio");
      if (speaker) {
        isSpeaker = true;
        await channel.invokeMethod("switchToSpeaker");
        notifyListeners();
      } else {
        isSpeaker = false;
        await channel.invokeMethod("switchToHeadphones");
        notifyListeners();
      }
    } on PlatformException catch (_) {
      customScaffoldMessager(context, 'Something went wrong');
    }
  }

  @override
  void dispose() {
    VolumeProvider().dispose();
    super.dispose();
  }
}
