import 'package:flutter/cupertino.dart';
import 'package:playtones/views/playlist%20screen/playlist_screen.dart';

class PlaylistNav extends StatelessWidget {
  const PlaylistNav({super.key});

  @override
  Widget build(BuildContext context) {
    GlobalKey<NavigatorState> playlistKey = GlobalKey<NavigatorState>();
    return Navigator(
      key: playlistKey,
      onGenerateRoute: (settings) {
        return CupertinoPageRoute(
          settings: settings,
          builder: (context) {
            return PlaylistScreen();
          },
        );
      },
    );
  }
}
