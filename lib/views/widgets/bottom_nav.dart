import 'package:flutter/material.dart';

final currentIndex = ValueNotifier(0);

class BottomNav extends StatelessWidget {
  const BottomNav({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: currentIndex,
      builder: (context, changedIndex, _) {
        return NavigationBar(
          height: 60,
          backgroundColor: Colors.black,
          indicatorColor: Colors.transparent,
          labelTextStyle: WidgetStatePropertyAll(
            TextStyle(
              color: Colors.white,
              fontFamily: 'Font',
              fontSize: TextTheme.of(context).labelSmall!.fontSize,
            ),
          ),
          selectedIndex: changedIndex,
          onDestinationSelected: (value) {
            currentIndex.value = value;
          },
          destinations: <NavigationDestination>[
            NavigationDestination(
              icon: Image.asset(
                height: 20,
                width: 20,
                "icons/music.png",
                color: changedIndex == 0 ? Color(0xFFFD0000) : Colors.white,
              ),
              label: 'Songs',
            ),
            NavigationDestination(
              icon: Image.asset(
                height: 20,
                width: 20,
                "icons/music-album.png",
                color: changedIndex == 1 ? Color(0xFFFD0000) : Colors.white,
              ),
              label: 'Album',
            ),
            NavigationDestination(
              icon: Image.asset(
                height: 20,
                width: 20,
                "icons/artist.png",
                color: changedIndex == 2 ? Color(0xFFFD0000) : Colors.white,
              ),
              label: 'Artist',
            ),
            NavigationDestination(
              icon: Image.asset(
                height: 20,
                width: 20,
                "icons/add-to-playlist.png",
                color: changedIndex == 3 ? Color(0xFFFD0000) : Colors.white,
              ),
              label: 'Playlist',
            ),
          ],
        );
      },
    );
  }
}
