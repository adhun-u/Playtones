import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';
import 'package:playtones/views/playlist%20screen/custom%20playlist/custom_playlist_screen.dart';
import 'package:playtones/views/playlist%20screen/favorite_screen.dart';
import 'package:playtones/views/playlist%20screen/most_played_screen.dart';
import 'package:playtones/views/playlist%20screen/recently_played_screen.dart';
import 'package:playtones/views/widgets/appbar.dart';

class PlaylistScreen extends StatelessWidget {
  const PlaylistScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final textTheme = Theme.of(context).textTheme;
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size(size.width, size.height * 0.1),
        child: const CustomAppBar(),
      ),
      body: ListView(
        physics: const NeverScrollableScrollPhysics(),
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 12, right: 12, top: 12),
            child: GestureDetector(
              onTap:
                  () => PersistentNavBarNavigator.pushNewScreen(
                    context,
                    screen: FavoriteScreen(),
                    withNavBar: true,
                  ),
              child: Card(
                color: Colors.grey[900],
                child: SizedBox(
                  height: size.height * 0.1,

                  child: Center(
                    child: ListTile(
                      leading: Image.asset('icons/wishlist.png'),
                      title: Text(
                        'Favorite List',
                        style: TextStyle(
                          fontSize: textTheme.titleMedium!.fontSize,
                          color: textTheme.titleMedium!.color,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 12, right: 12),
            child: GestureDetector(
              onTap:
                  () => PersistentNavBarNavigator.pushNewScreen(
                    context,
                    screen: RecentlyPlayedScreen(),
                    pageTransitionAnimation: PageTransitionAnimation.cupertino,
                  ),
              child: Card(
                color: Colors.grey[900],
                child: SizedBox(
                  height: size.height * 0.1,
                  child: Center(
                    child: ListTile(
                      leading: Image.asset('icons/history.png'),
                      title: Text(
                        'Recently Played',
                        style: TextStyle(
                          fontSize: textTheme.titleMedium!.fontSize,
                          color: textTheme.titleMedium!.color,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 12, right: 12),
            child: GestureDetector(
              onTap:
                  () => PersistentNavBarNavigator.pushNewScreen(
                    context,
                    screen: MostPlayedScreen(),
                    pageTransitionAnimation: PageTransitionAnimation.cupertino,
                  ),
              child: Card(
                color: Colors.grey[900],
                child: SizedBox(
                  height: size.height * 0.1,
                  child: Center(
                    child: ListTile(
                      leading: Image.asset('icons/music (1).png'),
                      title: Text(
                        'Most Played',
                        style: TextStyle(
                          fontSize: textTheme.titleMedium!.fontSize,
                          color: textTheme.titleMedium!.color,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 12, right: 12),
            child: GestureDetector(
              onTap:
                  () => PersistentNavBarNavigator.pushNewScreen(
                    context,
                    screen: CustomPlaylistScreen(),
                    pageTransitionAnimation: PageTransitionAnimation.cupertino,
                  ),
              child: Card(
                color: Colors.grey[900],
                child: SizedBox(
                  height: size.height * 0.1,
                  child: Center(
                    child: ListTile(
                      leading: Image.asset('icons/playlist.png'),
                      title: Text(
                        'Your Playlist',
                        style: TextStyle(
                          fontSize: textTheme.titleMedium!.fontSize,
                          color: textTheme.titleMedium!.color,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
