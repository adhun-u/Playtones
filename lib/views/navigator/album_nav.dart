import 'package:flutter/cupertino.dart';
import 'package:playtones/views/album%20screen/album_screen.dart';

class AlbumNav extends StatelessWidget {
  const AlbumNav({super.key});

  @override
  Widget build(BuildContext context) {
    GlobalKey<NavigatorState> albumKey = GlobalKey<NavigatorState>();
    return Navigator(
      key: albumKey,
      onGenerateRoute: (settings) {
        return CupertinoPageRoute(
          settings: settings,
          builder: (context) {
            return AlbumScreen();
          },
        );
      },
    );
  }
}
