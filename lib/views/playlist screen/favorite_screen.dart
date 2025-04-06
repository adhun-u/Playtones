import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';
import 'package:playtones/bloc/favorites/favorite_bloc.dart';
import 'package:playtones/bloc/most%20played/most_played_bloc.dart';
import 'package:playtones/bloc/recently%20played/recently_played_bloc.dart';
import 'package:playtones/providers/favoite_song_provider.dart';
import 'package:playtones/providers/log_provider.dart';
import 'package:playtones/providers/song_details_provider.dart';
import 'package:playtones/views/now%20playing%20screen/now_playing_screen.dart';
import 'package:playtones/views/other%20screens/empty_screen.dart';
import 'package:playtones/views/widgets/snack_bar.dart';
import 'package:provider/provider.dart';

class FavoriteScreen extends StatefulWidget {
  const FavoriteScreen({super.key});

  @override
  State<FavoriteScreen> createState() => _FavoriteScreenState();
}

class _FavoriteScreenState extends State<FavoriteScreen> {
  @override
  void initState() {
    super.initState();
    BlocProvider.of<FavoriteBloc>(context, listen: false).add(GetSongEvent());
  }

  List<SongModel> _songs = [];

  @override
  Widget build(BuildContext context) {
    _songs.clear();
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
                      'Favorites',
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
                    splashColor: Colors.grey[850],
                    highlightColor: Colors.grey[850],
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
              child: BlocBuilder<FavoriteBloc, FavoriteState>(
                builder: (context, state) {
                  if (state is GetSongsState) {
                    _songs = state.songs;
                  }
                  return _songs.isEmpty
                      ? EmptyScreen(text: 'No favorites')
                      : Padding(
                        padding: const EdgeInsets.only(top: 10),
                        child: ListView.builder(
                          physics: BouncingScrollPhysics(),
                          itemCount: _songs.length,
                          itemBuilder: (context, index) {
                            final song = _songs[index];
                            return Consumer<SongDetailsProvider>(
                              builder: (context, provider, _) {
                                return ListTile(
                                  onTap: () {
                                    if (provider.songId == song.id) {
                                      PersistentNavBarNavigator.pushNewScreen(
                                        context,
                                        screen: NowPlayingScreen(),
                                        withNavBar: false,
                                        pageTransitionAnimation:
                                            PageTransitionAnimation.slideUp,
                                      );
                                    } else {
                                      //--------------------------------------------
                                      BlocProvider.of<FavoriteBloc>(
                                        context,
                                        listen: false,
                                      ).add(PlaySongEvent(index: index));
                                      //---------------------------------------------
                                      BlocProvider.of<RecentlyPlayedBloc>(
                                        context,
                                        listen: false,
                                      ).add(
                                        AddData(
                                          songId: song.id,
                                          time: DateTime.now(),
                                          title: song.title,
                                          artist: song.artist ?? "Unknown",
                                        ),
                                      );
                                      //-------------------------------------------
                                      BlocProvider.of<MostPlayedBloc>(
                                        context,
                                        listen: false,
                                      ).add(
                                        AddMostPlayedSongEvent(
                                          songId: song.id,
                                          title: song.title,
                                          artist: song.artist ?? "Unknown",
                                        ),
                                      );
                                    }
                                    if (Provider.of<LogProvider>(
                                          context,
                                          listen: false,
                                        ).isLogged ==
                                        false) {
                                      Provider.of<LogProvider>(
                                        context,
                                        listen: false,
                                      ).logIn();
                                    }
                                  },
                                  leading: QueryArtworkWidget(
                                    keepOldArtwork: true,
                                    artworkQuality: FilterQuality.high,
                                    artworkFit: BoxFit.fill,
                                    artworkBorder: BorderRadius.circular(5),
                                    artworkHeight: 60,
                                    artworkWidth: 60,
                                    id: song.id,
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
                                  title: Consumer<SongDetailsProvider>(
                                    builder: (context, provider, _) {
                                      return Text(
                                        song.title,
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 12,
                                          color:
                                              provider.songId == song.id
                                                  ? Color(0xFFFD0000)
                                                  : textTheme.titleSmall!.color,
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                      );
                                    },
                                  ),
                                  subtitle: Text(
                                    song.artist ?? "Unknown",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 10,
                                      color: Colors.white,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  trailing: IconButton(
                                    onPressed: () {
                                      customScaffoldMessager(
                                        context,
                                        'Remove from favorites',
                                      );
                                      //--------------------------------------
                                      BlocProvider.of<FavoriteBloc>(
                                        context,
                                        listen: false,
                                      ).add(RemoveSongEvent(songId: song.id));
                                      //---------------------------------------
                                      Provider.of<FavoiteSongProvider>(
                                        context,
                                        listen: false,
                                      ).delete(song.id);
                                    },
                                    icon: Icon(
                                      CupertinoIcons.heart_fill,
                                      color: Color(0xFFFD0000),
                                    ),
                                  ),
                                );
                              },
                            );
                          },
                        ),
                      );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
  //----------------------------------------------------------------------------------------

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
                  child: Text(
                    'Delete All Favorites',
                    style: textTheme.titleMedium,
                  ),
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
                    textAlign: TextAlign.center,
                    'Do you want to delete all songs from your favorites',
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
                            //-------------------------------
                            BlocProvider.of<FavoriteBloc>(
                              context,
                              listen: false,
                            ).add(DeleteAllSongs());
                            //-------------------------------
                            Navigator.of(context).pop();
                          },
                          sizeStyle: CupertinoButtonSize.small,
                          borderRadius: BorderRadius.circular(5),
                          color: Colors.transparent,
                          child: Text(
                            'Delete',
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
