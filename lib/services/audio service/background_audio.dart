import 'package:just_audio_background/just_audio_background.dart';

Future<void> initializeJustAudio() async {
  //Initializing JustAudioBackground playling background and push notification
  await JustAudioBackground.init(
    androidNotificationChannelId: 'com.playtones',
    androidNotificationChannelName: 'Playtones',
    androidNotificationOngoing: true,
    androidNotificationIcon: 'drawable/ic_launcher',
  );
}
