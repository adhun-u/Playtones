import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';
import 'package:playtones/bloc/most%20played/most_played_bloc.dart';
import 'package:playtones/bloc/playlist/playlist_bloc.dart';
import 'package:playtones/bloc/recently%20played/recently_played_bloc.dart';
import 'package:playtones/models/playlist%20model/playlist_model.dart';
import 'package:playtones/models/playlist%20model/songs_model.dart';
import 'package:playtones/providers/log_provider.dart';
import 'package:playtones/providers/song_details_provider.dart';
import 'package:playtones/views/other%20screens/empty_screen.dart';
import 'package:playtones/views/now%20playing%20screen/now_playing_screen.dart';
import 'package:playtones/views/playlist%20screen/custom%20playlist/edit_name.dart';
import 'package:provider/provider.dart';

class SongsBasedPlaylist extends StatefulWidget {
  PlaylistDataModel playlistDataModel;
  SongsBasedPlaylist({super.key, required this.playlistDataModel});

  @override
  State<SongsBasedPlaylist> createState() => _SongsBasedPlaylistState();
}

class _SongsBasedPlaylistState extends State<SongsBasedPlaylist> {
  @override
  void initState() {
    super.initState();
    BlocProvider.of<PlaylistBloc>(context, listen: false).add(
      GetSongsFromPlaylistEvent(
        playlistId: widget.playlistDataModel.playlistId,
      ),
    );
  }

  List<SongsDataModel> songs = [];

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final textTheme = Theme.of(context).textTheme;
    return Scaffold(
      extendBody: true,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(height: size.height * 0.06),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                icon: Icon(CupertinoIcons.back, color: Colors.white, size: 30),
              ),
              Text(
                widget.playlistDataModel.playlistName ?? "Unknown",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
                overflow: TextOverflow.ellipsis,
              ),
              PopupMenuButton(
                itemBuilder: (context) {
                  return [
                    PopupMenuItem(
                      onTap:
                          () => PersistentNavBarNavigator.pushNewScreen(
                            context,
                            screen: EditNameScreen(
                              playlistModel: widget.playlistDataModel,
                            ),
                          ),
                      child: Text(
                        'Edit',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.grey[700],
                        ),
                      ),
                    ),
                    PopupMenuItem(
                      onTap: () {
                        //////////////
                        BlocProvider.of<PlaylistBloc>(
                          context,
                          listen: false,
                        ).add(
                          DeletePlaylistEvent(
                            playlistId: widget.playlistDataModel.playlistId,
                          ),
                        );
                        ///////////////
                        Navigator.of(context).pop();
                        //////////////
                        BlocProvider.of<PlaylistBloc>(
                          context,
                          listen: false,
                        ).add(FetchPlaylistEvent());
                      },
                      child: Text(
                        'Delete',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.grey[700],
                        ),
                      ),
                    ),
                  ];
                },
              ),
            ],
          ),

          Expanded(
            child: BlocBuilder<PlaylistBloc, PlaylistState>(
              builder: (context, state) {
                if (state is AllSongsFromPlaylist && state.songs.isEmpty) {
                  return const EmptyScreen(text: 'Empty Songs');
                }
                if (state is AllSongsFromPlaylist) {
                  songs = state.songs;
                }
                return Theme(
                  data: ThemeData(
                    splashColor: Colors.grey[850],
                    highlightColor: Colors.grey[850],
                  ),
                  child: ListView.builder(
                    physics: const BouncingScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: songs.length,
                    itemBuilder: (context, index) {
                      return Consumer<SongDetailsProvider>(
                        builder: (context, provider, _) {
                          final song = songs[index];
                          return ListTile(
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
                              ////////////////
                              if (provider.songId == song.songId) {
                                PersistentNavBarNavigator.pushNewScreen(
                                  context,
                                  screen: NowPlayingScreen(),
                                  withNavBar: false,
                                  pageTransitionAnimation:
                                      PageTransitionAnimation.slideUp,
                                );
                              } else {
                                ///////////
                                BlocProvider.of<RecentlyPlayedBloc>(
                                  context,
                                  listen: false,
                                ).add(
                                  AddData(
                                    songId: song.songId,
                                    time: DateTime.now(),
                                    title: song.title,
                                    artist: song.artist,
                                  ),
                                );
                                ///////////
                                BlocProvider.of<MostPlayedBloc>(
                                  context,
                                  listen: false,
                                ).add(
                                  AddMostPlayedSongEvent(
                                    songId: song.songId,
                                    title: song.title,
                                    artist: song.artist,
                                  ),
                                );
                                ////////////
                                BlocProvider.of<PlaylistBloc>(
                                  context,
                                  listen: false,
                                ).add(PlaySongEvent(index: index));
                              }
                            },
                            leading: Consumer<SongDetailsProvider>(
                              builder: (context, songDetailsProvider, _) {
                                return Text(
                                  '${index + 1}',
                                  style: TextStyle(
                                    fontFamily: 'Font',
                                    fontSize: 12,
                                    color:
                                        songDetailsProvider.songId != null &&
                                                songDetailsProvider.songId ==
                                                    song.songId
                                            ? Color(0xFFFD0000)
                                            : Colors.white,
                                  ),
                                );
                              },
                            ),
                            title: Consumer<SongDetailsProvider>(
                              builder: (context, provider, _) {
                                return Text(
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
                                );
                              },
                            ),
                            subtitle: Text(
                              song.artist,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 10,
                                color: textTheme.titleSmall!.color,
                              ),
                            ),
                            trailing: IconButton(
                              onPressed: () {
                                ////////////
                                BlocProvider.of<PlaylistBloc>(
                                  context,
                                  listen: false,
                                ).add(
                                  DeleteSongFromPlaylistEvent(
                                    songId: song.uniqueId ?? '',
                                  ),
                                );
                                /////////////
                                BlocProvider.of<PlaylistBloc>(
                                  context,
                                  listen: false,
                                ).add(
                                  GetSongsFromPlaylistEvent(
                                    playlistId:
                                        widget.playlistDataModel.playlistId,
                                  ),
                                );
                                //////////////
                                BlocProvider.of<PlaylistBloc>(
                                  context,
                                  listen: false,
                                ).add(FetchPlaylistEvent());
                              },
                              icon: Icon(
                                CupertinoIcons.delete,
                                color: Colors.grey[700],
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
    );
  }
}
