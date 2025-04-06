import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:headset_connection_event/headset_event.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'package:playtones/bloc/favorites/favorite_bloc.dart';
import 'package:playtones/bloc/fetch_album/fetch_album_bloc.dart';
import 'package:playtones/bloc/fetch%20artist/fetch_artist_bloc.dart';
import 'package:playtones/bloc/fetch%20audio/fetch_audio_bloc.dart';
import 'package:playtones/bloc/most%20played/most_played_bloc.dart';
import 'package:playtones/bloc/playlist/playlist_bloc.dart';
import 'package:playtones/bloc/recently%20played/recently_played_bloc.dart';
import 'package:playtones/bloc/resume%20play/resume_play_bloc.dart';
import 'package:playtones/models/favorites%20model/favorite.dart';
import 'package:playtones/models/lyrics%20model/lyrics_line_model.dart';
import 'package:playtones/models/most%20played/most_played_model.dart';
import 'package:playtones/models/playlist%20model/playlist_model.dart';
import 'package:playtones/models/playlist%20model/songs_model.dart';
import 'package:playtones/models/recent%20model/recently_played_list.dart';
import 'package:playtones/models/save%20song%20model/save_song_model.dart';
import 'package:playtones/providers/audio_features_provider.dart';
import 'package:playtones/providers/favoite_song_provider.dart';
import 'package:playtones/providers/log_provider.dart';
import 'package:playtones/providers/lyrics_provider.dart';
import 'package:playtones/providers/search_provider.dart';
import 'package:playtones/providers/song_details_provider.dart';
import 'package:playtones/providers/volume_provider.dart';
import 'package:playtones/services/audio%20service/background_audio.dart';
import 'package:playtones/services/audio%20service/permission_handler.dart';
import 'package:playtones/views/main_screen.dart';
import 'package:provider/provider.dart';

Future<void> registerAdapter() async {
  if (!Hive.isAdapterRegistered(FavoriteModelAdapter().typeId)) {
    Hive.registerAdapter(FavoriteModelAdapter());
  }
  if (!Hive.isAdapterRegistered(RecentlyPlayedListModelAdapter().typeId)) {
    Hive.registerAdapter(RecentlyPlayedListModelAdapter());
  }
  if (!Hive.isAdapterRegistered(MostPlayedModelAdapter().typeId)) {
    Hive.registerAdapter(MostPlayedModelAdapter());
  }
  if (!Hive.isAdapterRegistered(PlaylistDataModelAdapter().typeId)) {
    Hive.registerAdapter(PlaylistDataModelAdapter());
  }
  if (!Hive.isAdapterRegistered(SongsDataModelAdapter().typeId)) {
    Hive.registerAdapter(SongsDataModelAdapter());
  }
  if (!Hive.isAdapterRegistered(LyricsLineAdapter().typeId)) {
    Hive.registerAdapter(LyricsLineAdapter());
  }
  if (!Hive.isAdapterRegistered(SaveSongModelAdapter().typeId)) {
    Hive.registerAdapter(SaveSongModelAdapter());
  }
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final directory = await getApplicationDocumentsDirectory();
  await askPermission();
  await HeadsetEvent().requestPermission();
  await Hive.initFlutter(directory.path);
  await initializeJustAudio();
  await registerAdapter();
  Future.delayed(const Duration(seconds: 0), () {
    FlutterNativeSplash.remove();
  });
  runApp(RootApp());
}

class RootApp extends StatelessWidget {
  const RootApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => FetchAudioBloc()..add(FetchSongsEvent()),
        ),
        BlocProvider(create: (context) => FetchAlbumBloc()),
        BlocProvider(create: (context) => FetchArtistBloc()),
        BlocProvider(create: (context) => FavoriteBloc()),
        BlocProvider(create: (context) => RecentlyPlayedBloc()),
        BlocProvider(create: (context) => MostPlayedBloc()),
        BlocProvider(create: (context) => PlaylistBloc()),
        BlocProvider(create: (context) => ResumePlayBloc()),
        ChangeNotifierProvider(create: (context) => SongDetailsProvider()),
        ChangeNotifierProvider(create: (context) => SearchProvider()),
        ChangeNotifierProvider(create: (context) => VolumeProvider()),
        ChangeNotifierProvider(create: (context) => AudioFeaturesProvider()),
        ChangeNotifierProvider(create: (context) => FavoiteSongProvider()),
        ChangeNotifierProvider(create: (context) => LyricsProvider()),
        ChangeNotifierProvider(create: (context) => LogProvider()),
      ],
      child: MaterialApp(
        themeMode: ThemeMode.dark,
        darkTheme: ThemeData(
          bottomSheetTheme: BottomSheetThemeData(
            backgroundColor: Colors.transparent,
          ),
          popupMenuTheme: PopupMenuThemeData(
            iconColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            color: Colors.grey[900],
          ),
          textTheme: TextTheme(
            titleSmall: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
            titleMedium: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
            titleLarge: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
            bodySmall: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          appBarTheme: AppBarTheme(backgroundColor: Colors.black),
          scaffoldBackgroundColor: Colors.black,
        ),
        theme: ThemeData.dark(),
        home: MainScreen(),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
