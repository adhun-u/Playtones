import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:playtones/bloc/playlist/playlist_bloc.dart';
import 'package:playtones/models/playlist%20model/playlist_model.dart';

List<PlaylistDataModel> _playlists = [];

void addPlaylist(BuildContext context, SongModel song) {
  BlocProvider.of<PlaylistBloc>(
    context,
    listen: false,
  ).add(FetchPlaylistEvent());
  final size = MediaQuery.of(context).size;
  final textTheme = Theme.of(context).textTheme;
  showDialog(
    context: context,
    builder: (context) {
      return Dialog(
        backgroundColor: Colors.grey[900],
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        child: SizedBox(
          height: size.height * 0.5,
          width: size.width - 20,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 10),
                child: Text(
                  'Add to Playlist',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: textTheme.titleSmall!.fontSize,
                    color: textTheme.titleSmall!.color,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 10),
                child: Divider(
                  endIndent: 30,
                  indent: 30,
                  color: Colors.grey[850],
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: BlocBuilder<PlaylistBloc, PlaylistState>(
                    builder: (context, state) {
                      List count = [];
                      if (state is AllPlaylistState &&
                          state.playlists.isEmpty) {
                        return Center(
                          child: Text(
                            'Empty Playlist',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.grey[800],
                            ),
                          ),
                        );
                      }
                      if (state is AllPlaylistState) {
                        _playlists = state.playlists;
                        count = state.counts;
                      }
                      return Theme(
                        data: ThemeData(
                          splashColor: Colors.grey[850],
                          highlightColor: Colors.grey[850],
                        ),
                        child: ListView.builder(
                          itemCount: _playlists.length,
                          itemBuilder: (context, index) {
                            final playlist = _playlists[index];
                            return ListTile(
                              onTap: () {
                                BlocProvider.of<PlaylistBloc>(
                                  context,
                                  listen: false,
                                ).add(
                                  AddSongsToPlaylistEvent(
                                    playlistId: playlist.playlistId,
                                    song: song,
                                  ),
                                );
                                //---------------------------------------
                                Navigator.of(context).pop();
                                //---------------------------------------
                                BlocProvider.of<PlaylistBloc>(
                                  context,
                                  listen: false,
                                ).add(FetchPlaylistEvent());
                                //----------------------------------------
                                BlocProvider.of<PlaylistBloc>(
                                  context,
                                  listen: false,
                                ).add(
                                  GetSongsFromPlaylistEvent(
                                    playlistId: playlist.playlistId,
                                  ),
                                );
                              },
                              title: Center(
                                child: Text(
                                  playlist.playlistName ?? "Unknown",
                                  style: TextStyle(
                                    color: textTheme.titleSmall!.color,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              subtitle: Center(
                                child:
                                    count.isNotEmpty
                                        ? Text(
                                          'Songs ${count[index]}',
                                          style: TextStyle(
                                            fontSize: 10,
                                            color: Colors.grey[700],
                                            fontWeight: FontWeight.bold,
                                          ),
                                          overflow: TextOverflow.ellipsis,
                                        )
                                        : Text(
                                          'Songs 0',
                                          style: TextStyle(
                                            fontSize: 10,
                                            color: Colors.grey[700],
                                            fontWeight: FontWeight.bold,
                                          ),
                                          overflow: TextOverflow.ellipsis,
                                        ),
                              ),
                            );
                          },

                          physics: const BouncingScrollPhysics(),
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
    },
  );
}
