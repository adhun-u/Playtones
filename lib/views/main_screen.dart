import 'package:flutter/material.dart';
import 'package:playtones/providers/log_provider.dart';
import 'package:playtones/providers/song_details_provider.dart';
import 'package:playtones/services/audio%20service/audio_service.dart';
import 'package:playtones/services/database/save_songs_db.dart';
import 'package:playtones/views/navigator/album_nav.dart';
import 'package:playtones/views/navigator/artist_nav.dart';
import 'package:playtones/views/navigator/playlist_nav.dart';
import 'package:playtones/views/widgets/bottom_nav.dart';
import 'package:playtones/views/songs%20screen.dart/songs_screen.dart';
import 'package:playtones/views/widgets/playcard.dart';
import 'package:provider/provider.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen>
    with SingleTickerProviderStateMixin, WidgetsBindingObserver {
  late AnimationController controller;

  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    super.initState();

    controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 8),
    );
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    if (state == AppLifecycleState.detached) {
      await SaveSongsDb().deleteAllData();
      await Provider.of<SongDetailsProvider>(
        context,
        listen: false,
      ).whenDetached();
      AudioService.audioPlayer.stop();
    }
    super.didChangeAppLifecycleState(state);
  }

  @override
  void dispose() {
    controller.dispose();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  final screens = [SongsScreen(), AlbumNav(), ArtistNav(), PlaylistNav()];

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: ValueListenableBuilder(
              valueListenable: currentIndex,
              builder: (context, index, _) {
                return IndexedStack(
                  index: currentIndex.value,
                  children: screens,
                );
              },
            ),
          ),
          Provider.of<LogProvider>(context).isLogged
              ? Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Container(
                  height: size.height * 0.091,
                  width: size.width - 40,
                  color: Colors.transparent,
                  child: customBottomSheet(context, controller),
                ),
              )
              : Container(),
        ],
      ),
      bottomNavigationBar: BottomNav(),
    );
  }
}
