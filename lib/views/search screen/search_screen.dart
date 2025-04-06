import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';
import 'package:playtones/bloc/most%20played/most_played_bloc.dart';
import 'package:playtones/bloc/recently%20played/recently_played_bloc.dart';
import 'package:playtones/providers/log_provider.dart';
import 'package:playtones/providers/search_provider.dart';
import 'package:playtones/providers/song_details_provider.dart';
import 'package:playtones/views/now%20playing%20screen/now_playing_screen.dart';
import 'package:playtones/views/songs%20screen.dart/songs_screen.dart';
import 'package:playtones/views/other%20screens/empty_screen.dart';
import 'package:playtones/views/widgets/deleting_popup.dart';
import 'package:provider/provider.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final controller = TextEditingController();
  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    late final provider = Provider.of<SearchProvider>(context, listen: false);
    final textTheme = Theme.of(context).textTheme;
    final size = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          toolbarHeight: size.height * 0.1,
          leading: IconButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            iconSize: 30,
            icon: const Icon(CupertinoIcons.back, color: Colors.white),
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 30),
              child: SizedBox(
                height: size.height * 0.07,
                width: size.width * 0.80,
                child: Theme(
                  data: ThemeData(
                    textSelectionTheme: TextSelectionThemeData(
                      cursorColor: Color(0xFFFD0000),
                      selectionHandleColor: Color(0xFFFD0000),
                    ),
                  ),
                  child: SearchBar(
                    overlayColor: WidgetStatePropertyAll(Colors.grey[900]),
                    backgroundColor: WidgetStatePropertyAll(Colors.grey[900]),
                    hintText: 'Search Songs',
                    leading: Icon(
                      CupertinoIcons.search,
                      color: Colors.grey[700],
                    ),
                    textStyle: WidgetStatePropertyAll(textTheme.titleSmall),
                    focusNode: FocusNode(),
                    shape: WidgetStatePropertyAll(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    hintStyle: WidgetStatePropertyAll(
                      TextStyle(
                        fontSize: textTheme.titleSmall!.fontSize,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey[800],
                      ),
                    ),
                    onChanged: (value) {
                      provider.search(value);
                      controller.text = value;
                    },
                    onTapOutside: (event) {
                      FocusScope.of(context).unfocus();
                    },
                  ),
                ),
              ),
            ),
          ],
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 18),
              child: Text(
                'Search Result ',
                style: TextStyle(
                  fontFamily: 'Font',
                  fontSize: textTheme.titleSmall!.fontSize,
                  color: Colors.grey[700],
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(top: 10),
                child: Consumer2<SearchProvider, SongDetailsProvider>(
                  builder: (context, provider, songProvider, _) {
                    if (provider.searchedSongs.isEmpty) {
                      return EmptyScreen(text: 'No results');
                    }
                    return Theme(
                      data: ThemeData(
                        splashColor: Colors.grey[850],
                        highlightColor: Colors.grey[850],
                      ),
                      child: ListView.builder(
                        itemCount: provider.searchedSongs.length,
                        physics: const BouncingScrollPhysics(),
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.only(left: 10, right: 10),
                            child: Theme(
                              data: ThemeData(
                                splashColor: Colors.transparent,
                                splashFactory: NoSplash.splashFactory,
                                highlightColor: Colors.transparent,
                              ),
                              child: ListTile(
                                onTap: () {
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
                                  //-----------------------------------------
                                  if (songProvider.songId ==
                                      provider.searchedSongs[index].id) {
                                    PersistentNavBarNavigator.pushNewScreen(
                                      context,
                                      screen: const NowPlayingScreen(),
                                      withNavBar: false,
                                      pageTransitionAnimation:
                                          PageTransitionAnimation.slideUp,
                                    );
                                  } else {
                                    //---------------------------------------------
                                    Provider.of<SearchProvider>(
                                      context,
                                      listen: false,
                                    ).playSong(provider.searchedSongs[index]);
                                    //-----------------------------------------------
                                    BlocProvider.of<RecentlyPlayedBloc>(
                                      context,
                                      listen: false,
                                    ).add(
                                      AddData(
                                        songId:
                                            provider.searchedSongs[index].id,
                                        time: DateTime.now(),
                                        title:
                                            provider.searchedSongs[index].title,
                                        artist:
                                            provider
                                                .searchedSongs[index]
                                                .artist ??
                                            "Unknown",
                                      ),
                                    );
                                    //------------------------------------------------
                                    BlocProvider.of<RecentlyPlayedBloc>(
                                      context,
                                      listen: false,
                                    ).add(GetSongsEvent());
                                    //--------------------------------------------------
                                    BlocProvider.of<MostPlayedBloc>(
                                      context,
                                      listen: false,
                                    ).add(
                                      AddMostPlayedSongEvent(
                                        songId:
                                            provider.searchedSongs[index].id,
                                        title:
                                            provider.searchedSongs[index].title,
                                        artist:
                                            provider
                                                .searchedSongs[index]
                                                .artist ??
                                            "Unknown",
                                      ),
                                    );
                                    //-----------------------------------------------------
                                    BlocProvider.of<MostPlayedBloc>(
                                      context,
                                      listen: false,
                                    ).add(GetMostPlayedSongEvent());
                                  }
                                },
                                leading: QueryArtworkWidget(
                                  keepOldArtwork: true,
                                  artworkQuality: FilterQuality.high,
                                  artworkFit: BoxFit.fill,
                                  artworkBorder: BorderRadius.circular(5),
                                  artworkHeight: 60,
                                  artworkWidth: 60,
                                  id:
                                      provider.searchedSongs[index].albumId ??
                                      0,
                                  type: ArtworkType.ALBUM,
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
                                title: RichText(
                                  text: TextSpan(
                                    children:
                                        provider.searchedSongs[index].title
                                            .split('')
                                            .map((char) {
                                              bool hasCharacter =
                                                  controller.text.contains(
                                                    char.toLowerCase(),
                                                  ) ||
                                                  controller.text.contains(
                                                    char.toUpperCase(),
                                                  );
                                              return TextSpan(
                                                text: char,
                                                style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize:
                                                      textTheme
                                                          .titleSmall!
                                                          .fontSize,
                                                  color:
                                                      hasCharacter
                                                          ? Color(0xFFFD0000)
                                                          : Colors.white,
                                                ),
                                              );
                                            })
                                            .toList(),
                                  ),
                                ),
                                subtitle: Text(
                                  provider.searchedSongs[index].artist ??
                                      "Unknown",
                                  style: TextStyle(
                                    fontSize: 10,
                                    color: Colors.grey[700],
                                    fontWeight: FontWeight.bold,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),

                                trailing: Theme(
                                  data: ThemeData(
                                    splashColor: Colors.transparent,
                                    splashFactory: NoSplash.splashFactory,
                                    highlightColor: Colors.transparent,
                                  ),
                                  child: customPopup(context, [
                                    PopupMenuItem(
                                      child: ListTile(
                                        leading: const Icon(CupertinoIcons.add),
                                        title: Text(
                                          'Add to Playlist',
                                          style: textTheme.titleSmall,
                                        ),
                                      ),
                                    ),
                                    PopupMenuItem(
                                      child: ListTile(
                                        leading: const Icon(Icons.short_text),
                                        title: Text(
                                          'Details',
                                          style: textTheme.titleSmall,
                                        ),
                                      ),
                                    ),
                                    PopupMenuItem(
                                      //------------------------------------------
                                      onTap:
                                          () => deleteSong(
                                            provider.searchedSongs[index],
                                            context,
                                          ),
                                      //------------------------------------------
                                      child: ListTile(
                                        leading: const Icon(
                                          CupertinoIcons.delete,
                                          color: Color(0xFFFD0000),
                                        ),
                                        title: Text(
                                          'Delete',
                                          style: TextStyle(
                                            fontSize:
                                                textTheme.titleSmall!.fontSize,
                                            color: Color(0xFFFD0000),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ]),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
