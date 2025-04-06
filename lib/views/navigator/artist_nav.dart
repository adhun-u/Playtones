import 'package:flutter/cupertino.dart';
import 'package:playtones/views/artists%20screen/artists_screen.dart';

class ArtistNav extends StatelessWidget {
  const ArtistNav({super.key});

  @override
  Widget build(BuildContext context) {
    GlobalKey<NavigatorState> artistScreenKey = GlobalKey<NavigatorState>();
    return Navigator(
      key: artistScreenKey,
      onGenerateRoute: (settings) {
        return CupertinoPageRoute(
          settings: settings,
          builder: (context) {
            return ArtistsScreen();
          },
        );
      },
    );
  }
}
