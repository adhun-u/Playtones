import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';
import 'package:playtones/bloc/fetch%20audio/fetch_audio_bloc.dart';
import 'package:playtones/bloc/most%20played/most_played_bloc.dart';
import 'package:playtones/models/most%20played/most_played_model.dart';
import 'package:playtones/providers/log_provider.dart';
import 'package:playtones/providers/song_details_provider.dart';
import 'package:playtones/views/other%20screens/empty_screen.dart';
import 'package:playtones/views/other%20screens/loading_screen.dart';
import 'package:playtones/views/now%20playing%20screen/now_playing_screen.dart';
import 'package:provider/provider.dart';

class MostPlayedScreen extends StatefulWidget {
  const MostPlayedScreen({super.key});

  @override
  State<MostPlayedScreen> createState() => _MostPlayedScreenState();
}

class _MostPlayedScreenState extends State<MostPlayedScreen> {
  @override
  void initState() {
    super.initState();
    BlocProvider.of<MostPlayedBloc>(
      context,
      listen: false,
    ).add(GetMostPlayedSongEvent());
  }

  List<MostPlayedModel> mostPlayedSongs = [];

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final textTheme = Theme.of(context).textTheme;
    return Scaffold(
      extendBody: true,
      body: SizedBox(
        height: size.height,
        width: size.width,
        child: Column(
          children: [
            SizedBox(height: size.height * 0.06),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    IconButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      icon: Icon(
                        CupertinoIcons.back,
                        color: Colors.white,
                        size: 30,
                      ),
                    ),
                    Text(
                      'Most Played',
                      style: TextStyle(
                        fontFamily: 'Font',
                        color: Colors.white,
                        fontSize: textTheme.titleLarge!.fontSize,
                      ),
                    ),
                  ],
                ),
                Theme(
                  data: ThemeData(
                    splashColor: Colors.transparent,
                    highlightColor: Colors.transparent,
                    splashFactory: NoSplash.splashFactory,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(right: 10),
                    child: IconButton(
                      onPressed: () => clearAll(),
                      splashColor: Colors.black,
                      highlightColor: Colors.transparent,
                      icon: Icon(CupertinoIcons.delete, color: Colors.grey),
                    ),
                  ),
                ),
              ],
            ),
            Expanded(
              child: BlocBuilder<MostPlayedBloc, MostPlayedState>(
                builder: (context, state) {
                  if (state is LoadingMostPlayed) {
                    return const LoadingScreen();
                  }
                  if (state is GetMostPlayedSongState) {
                    mostPlayedSongs = state.mostPlayedSongs;
                  }
                  if (mostPlayedSongs.isEmpty) {
                    return EmptyScreen(text: 'No song played');
                  } else {
                    return Theme(
                      data: ThemeData(
                        splashColor: Colors.grey[850],
                        highlightColor: Colors.grey[850],
                      ),
                      child: ListView.builder(
                        physics: const BouncingScrollPhysics(),
                        itemCount: mostPlayedSongs.length,
                        itemBuilder: (context, index) {
                          final song = mostPlayedSongs[index];
                          return Consumer<SongDetailsProvider>(
                            builder: (context, provider, _) {
                              return ListTile(
                                //Defined the function at the bottom of the file
                                onTap:
                                    () => playoperation(provider, song, index),
                                leading: QueryArtworkWidget(
                                  keepOldArtwork: true,
                                  artworkQuality: FilterQuality.high,
                                  artworkFit: BoxFit.fill,
                                  artworkBorder: BorderRadius.circular(5),
                                  artworkHeight: 60,
                                  artworkWidth: 60,
                                  id: song.songId,
                                  type: ArtworkType.AUDIO,
                                  nullArtworkWidget: Container(
                                    width: 60,
                                    height: 60,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(5),
                                      color: Colors.grey[800],
                                    ),
                                    child: const Icon(
                                      Icons.music_note_rounded,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                                title: Text(
                                  song.title,
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12,
                                    color:
                                        provider.songId == song.songId
                                            ? Color(0xFFFD0000)
                                            : textTheme.titleSmall!.color,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),

                                subtitle: Text(
                                  song.artist,
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 10,
                                    color: Colors.grey[400],
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              );
                            },
                          );
                        },
                      ),
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  //------------------------------------------------------------------------------
  void playoperation(
    SongDetailsProvider provider,
    MostPlayedModel song,
    int index,
  ) {
    if (Provider.of<LogProvider>(context, listen: false).isLogged == false) {
      Provider.of<LogProvider>(context, listen: false).logIn();
    }
    if (provider.songId == song.songId) {
      PersistentNavBarNavigator.pushNewScreen(
        context,
        screen: NowPlayingScreen(),
        pageTransitionAnimation: PageTransitionAnimation.cupertino,
      );
    } else {
      //-------------------------------------
      BlocProvider.of<FetchAudioBloc>(context, listen: false).add(
        PlaysongEvent(index: index, isFromPlaylist: true, songId: song.songId),
      );
      //-------------------------------------
      BlocProvider.of<MostPlayedBloc>(context, listen: false).add(
        AddMostPlayedSongEvent(
          songId: song.songId,
          title: song.title,
          artist: song.artist,
        ),
      );
      //---------------------------------------
      BlocProvider.of<MostPlayedBloc>(
        context,
        listen: false,
      ).add(GetMostPlayedSongEvent());
    }
  }

  //------------------------------------------------------------------------------
  void clearAll() {
    final size = MediaQuery.of(context).size;
    final textTheme = Theme.of(context).textTheme;
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          child: Container(
            height: size.height * 0.26,
            width: size.width - 60,
            decoration: BoxDecoration(
              color: Colors.grey[900],
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: Text('Clear History', style: textTheme.titleMedium),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 5),
                  child: Divider(
                    endIndent: 10,
                    indent: 10,
                    color: Colors.grey[800],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 10, right: 10),
                  child: Text(
                    'Do you want to clear history',
                    style: textTheme.titleSmall,
                  ),
                ),
                SizedBox(
                  child: Padding(
                    padding: const EdgeInsets.only(
                      left: 10,
                      right: 10,
                      top: 50,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        CupertinoButton(
                          onPressed: () {
                            PersistentNavBarNavigator.pop(context);
                          },
                          color: Colors.transparent,
                          child: Text(
                            'Cancel',
                            style: TextStyle(
                              fontSize: textTheme.titleMedium!.fontSize,
                              color: Colors.white70,
                            ),
                          ),
                        ),
                        CupertinoButton(
                          onPressed: () async {
                            //-----------------------------
                            BlocProvider.of<MostPlayedBloc>(
                              context,
                              listen: false,
                            ).add(DeleteAllMostSongs());
                            //-------------------------------
                            Navigator.of(context).pop();
                          },
                          sizeStyle: CupertinoButtonSize.small,
                          borderRadius: BorderRadius.circular(5),
                          color: Colors.transparent,
                          child: Text(
                            'Clear',
                            style: TextStyle(
                              fontSize: textTheme.titleMedium!.fontSize,
                              color: Color(0xFFFD0000),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
