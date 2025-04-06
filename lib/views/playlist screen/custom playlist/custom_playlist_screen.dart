import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';
import 'package:playtones/bloc/playlist/playlist_bloc.dart';
import 'package:playtones/models/playlist%20model/playlist_model.dart';
import 'package:playtones/views/other%20screens/empty_screen.dart';
import 'package:playtones/views/playlist%20screen/custom%20playlist/create_playlist_screen.dart';
import 'package:playtones/views/playlist%20screen/custom%20playlist/songs_based_playlist.dart';

class CustomPlaylistScreen extends StatefulWidget {
  const CustomPlaylistScreen({super.key});

  @override
  State<CustomPlaylistScreen> createState() => _CustomPlaylistScreenState();
}

class _CustomPlaylistScreenState extends State<CustomPlaylistScreen> {
  late TextEditingController controller;

  @override
  void initState() {
    super.initState();
    controller = TextEditingController();
    ////////////////////////////////
    BlocProvider.of<PlaylistBloc>(
      context,
      listen: false,
    ).add(FetchPlaylistEvent());
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  List<PlaylistDataModel> playlists = [];
  List<int> lastSongIds = [];
  List<int> counts = [];

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final textTheme = Theme.of(context).textTheme;
    return Scaffold(
      extendBody: true,
      body: Column(
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
                    'Your Playlist',
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
                  splashFactory: NoSplash.splashFactory,
                  splashColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                ),
                child: Padding(
                  padding: const EdgeInsets.only(right: 10),
                  child: IconButton(
                    onPressed: () {
                      PersistentNavBarNavigator.pushNewScreen(
                        context,
                        screen: CreatePlaylistScreen(),
                      );
                    },
                    icon: Icon(CupertinoIcons.add, color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
          Expanded(
            child: BlocBuilder<PlaylistBloc, PlaylistState>(
              builder: (context, state) {
                if (state is AllPlaylistState && state.playlists.isEmpty) {
                  return const EmptyScreen(text: 'Empty Playlists');
                }
                if (state is AllPlaylistState) {
                  playlists = state.playlists;
                  counts = state.counts;
                  lastSongIds = state.lastSongIds;
                }
                return Theme(
                  data: ThemeData(
                    splashColor: Colors.grey[850],
                    highlightColor: Colors.grey[850],
                  ),
                  child: ListView.separated(
                    physics: const BouncingScrollPhysics(),
                    itemCount: playlists.length,
                    itemBuilder: (context, index) {
                      final playlist = playlists[index];
                      return ListTile(
                        onTap: () {
                          /////////////
                          PersistentNavBarNavigator.pushNewScreen(
                            context,
                            screen: SongsBasedPlaylist(
                              playlistDataModel: playlist,
                            ),
                          );
                        },
                        leading: QueryArtworkWidget(
                          keepOldArtwork: true,
                          artworkQuality: FilterQuality.high,
                          artworkFit: BoxFit.fill,
                          artworkBorder: BorderRadius.circular(5),
                          artworkHeight: 60,
                          artworkWidth: 60,
                          id: lastSongIds.isNotEmpty ? lastSongIds[index] : 0,
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
                          playlist.playlistName ?? "Unknown",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                          overflow: TextOverflow.clip,
                        ),
                        subtitle:
                            counts.isNotEmpty
                                ? Text(
                                  'Songs ${counts[index]}',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                  overflow: TextOverflow.ellipsis,
                                )
                                : const Text(
                                  'Songs 0',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                  overflow: TextOverflow.ellipsis,
                                ),
                      );
                    },
                    separatorBuilder: (context, index) {
                      return Divider(
                        indent: 20,
                        endIndent: 20,
                        color: Colors.grey[900],
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
