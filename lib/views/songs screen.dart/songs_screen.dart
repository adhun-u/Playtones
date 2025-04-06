import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';
import 'package:playtones/bloc/favorites/favorite_bloc.dart';
import 'package:playtones/bloc/fetch%20audio/fetch_audio_bloc.dart';
import 'package:playtones/bloc/most%20played/most_played_bloc.dart';
import 'package:playtones/bloc/recently%20played/recently_played_bloc.dart';
import 'package:playtones/models/favorites%20model/favorite.dart';
import 'package:playtones/providers/audio_features_provider.dart';
import 'package:playtones/providers/favoite_song_provider.dart';
import 'package:playtones/providers/log_provider.dart';
import 'package:playtones/providers/song_details_provider.dart';
import 'package:playtones/services/other%20functionalities/functionalities.dart';
import 'package:playtones/views/now%20playing%20screen/now_playing_screen.dart';
import 'package:playtones/views/other%20screens/details_screen.dart';
import 'package:playtones/views/songs%20screen.dart/add_playlist_popup.dart';
import 'package:playtones/views/widgets/appbar.dart';
import 'package:playtones/views/other%20screens/empty_screen.dart';
import 'package:playtones/views/other%20screens/loading_screen.dart';
import 'package:playtones/views/widgets/deleting_popup.dart';
import 'package:playtones/views/widgets/snack_bar.dart';
import 'package:provider/provider.dart';

class SongsScreen extends StatelessWidget {
  const SongsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    late SongDetailsProvider provider = Provider.of<SongDetailsProvider>(
      context,
      listen: false,
    );
    List<FavoriteModel> favoriteProvider =
        Provider.of<FavoiteSongProvider>(context, listen: false).favorites;

    final size = MediaQuery.of(context).size;
    final textTheme = Theme.of(context).textTheme;
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size(size.width, size.height * 0.1),
        child: const CustomAppBar(),
      ),
      body: Column(
        children: [
          BlocListener<FetchAudioBloc, FetchAudioState>(
            listener: (context, state) {
              if (state is FetchErrorState) {
                customScaffoldMessager(context, state.errorMessage);
              }
            },
            child: Container(),
          ),
          Expanded(
            child: BlocBuilder<FetchAudioBloc, FetchAudioState>(
              buildWhen: (previous, current) {
                return current is FetchAudioLoadedState && previous != current;
              },
              builder: (context, state) {
                if (state is FetchAudioLoadedState && state.songs.isEmpty) {
                  return EmptyScreen(text: 'Songs are empty');
                }
                if (state is FetchAudioLoadingState) {
                  return const LoadingScreen();
                } else if (state is FetchAudioLoadedState) {
                  return ListView.builder(
                    physics: const BouncingScrollPhysics(),
                    itemCount: state.songs.length,
                    itemBuilder: (context, index) {
                      final song = state.songs[index];
                      return Padding(
                        padding: const EdgeInsets.only(left: 10, right: 10),
                        child: Consumer<AudioFeaturesProvider>(
                          builder: (context, audioFeatureProvider, _) {
                            return Theme(
                              data: ThemeData(
                                splashColor: Colors.grey[850],
                                highlightColor: Colors.grey[850],
                              ),
                              child: ListTile(
                                onTap: () async {
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
                                  //---------------------------------------------------
                                  if (provider.songId == song.id) {
                                    PersistentNavBarNavigator.pushNewScreen(
                                      context,
                                      screen: NowPlayingScreen(),
                                      pageTransitionAnimation:
                                          PageTransitionAnimation.slideUp,
                                    );
                                  }
                                  //----------------------------------------------------
                                  else {
                                    BlocProvider.of<FetchAudioBloc>(
                                      context,
                                      listen: false,
                                    ).add(PlaysongEvent(index: index));
                                    //-----------------------------------
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
                                    //-----------------------------------------
                                    BlocProvider.of<RecentlyPlayedBloc>(
                                      context,
                                      listen: false,
                                    ).add(GetSongsEvent());
                                    //-----------------------------------------
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
                                    //---------------------------------------
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
                                  id: song.albumId!,
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
                                title: Consumer<SongDetailsProvider>(
                                  builder: (_, songprovider, _) {
                                    return Text(
                                      song.title,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                        color:
                                            songprovider.songId == song.id
                                                ? Color(0xFFFD0000)
                                                : textTheme.titleSmall!.color,
                                      ),
                                    );
                                  },
                                ),
                                subtitle: Text(
                                  song.artist ?? 'Unknown',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 10,
                                    overflow: TextOverflow.ellipsis,
                                    color: Colors.grey[400],
                                  ),
                                ),
                                trailing: customPopup(context, [
                                  PopupMenuItem(
                                    onTap: () => addPlaylist(context, song),
                                    child: ListTile(
                                      leading: Icon(
                                        CupertinoIcons.add,
                                        color: textTheme.titleSmall!.color,
                                      ),
                                      title: Text(
                                        'Add To Playlist',
                                        style: TextStyle(
                                          fontSize:
                                              textTheme.titleSmall!.fontSize,
                                          color: textTheme.titleSmall!.color,
                                        ),
                                      ),
                                    ),
                                  ),
                                  PopupMenuItem(
                                    onTap: () async {
                                      bool alreadyExist = favoriteProvider.any((
                                        model,
                                      ) {
                                        return song.id == model.songId;
                                      });
                                      if (alreadyExist) {
                                        BlocProvider.of<FavoriteBloc>(
                                          context,
                                          listen: false,
                                        ).add(RemoveSongEvent(songId: song.id));
                                        //----------------------------------------
                                        Provider.of<FavoiteSongProvider>(
                                          context,
                                          listen: false,
                                        ).delete(song.id);
                                        //------------------------------------------
                                        customScaffoldMessager(
                                          context,
                                          'Removed from favorites',
                                        );
                                      } else {
                                        //-------------------------------------------
                                        BlocProvider.of<FavoriteBloc>(
                                          context,
                                          listen: false,
                                        ).add(AddSongs(songId: song.id));
                                        //--------------------------------------------
                                        final model = FavoriteModel(
                                          songId: song.id,
                                        );
                                        Provider.of<FavoiteSongProvider>(
                                          context,
                                          listen: false,
                                        ).addToList(model);
                                        //-------------------------------------------
                                        customScaffoldMessager(
                                          context,
                                          'Added to favorites',
                                        );
                                      }
                                    },
                                    child: Consumer<FavoiteSongProvider>(
                                      builder: (context, provider, _) {
                                        return ListTile(
                                          leading: Icon(
                                            Icons.favorite,
                                            color:
                                                provider.favorites.any((model) {
                                                      return song.id ==
                                                          model.songId;
                                                    })
                                                    ? Color(0xFFFD0000)
                                                    : textTheme
                                                        .titleSmall!
                                                        .color,
                                          ),
                                          title: Text(
                                            provider.favorites.any((model) {
                                                  return song.id ==
                                                      model.songId;
                                                })
                                                ? 'Remove'
                                                : 'Favorite',
                                            style: TextStyle(
                                              fontSize:
                                                  textTheme
                                                      .titleSmall!
                                                      .fontSize,
                                              color:
                                                  textTheme.titleSmall!.color,
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                  ),

                                  PopupMenuItem(
                                    onTap: () {
                                      PersistentNavBarNavigator.pushNewScreen(
                                        context,
                                        screen: DetailsScreen(song: song),
                                        withNavBar: true,
                                        pageTransitionAnimation:
                                            PageTransitionAnimation.fade,
                                      );
                                    },
                                    child: ListTile(
                                      leading: const Icon(
                                        Icons.short_text,
                                        color: Colors.white,
                                      ),
                                      title: Text(
                                        'Details',
                                        style: TextStyle(
                                          fontSize:
                                              textTheme.titleSmall!.fontSize,
                                          color: textTheme.titleSmall!.color,
                                        ),
                                      ),
                                    ),
                                  ),
                                  PopupMenuItem(
                                    onTap: () async {
                                      await shareSong(song.data);
                                    },
                                    child: ListTile(
                                      leading: Icon(
                                        Icons.share,
                                        color: textTheme.titleSmall!.color,
                                      ),
                                      title: Text(
                                        'Share',
                                        style: TextStyle(
                                          fontSize:
                                              textTheme.titleSmall!.fontSize,
                                          color: textTheme.titleSmall!.color,
                                        ),
                                      ),
                                    ),
                                  ),

                                  PopupMenuItem(
                                    onTap: () {
                                      deleteSong(song, context);
                                    },
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
                            );
                          },
                        ),
                      );
                    },
                  );
                }
                return Container();
              },
            ),
          ),
        ],
      ),
    );
  }
}

//-----------------------------------------------------------------------------------

Widget customPopup(BuildContext context, List<PopupMenuEntry<dynamic>> items) {
  return PopupMenuButton(
    color: Colors.grey[900],
    itemBuilder: (context) {
      return items;
    },
  );
}
