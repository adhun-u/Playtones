import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';
import 'package:playtones/bloc/fetch%20artist/fetch_artist_bloc.dart';
import 'package:playtones/bloc/most%20played/most_played_bloc.dart';
import 'package:playtones/bloc/recently%20played/recently_played_bloc.dart';
import 'package:playtones/providers/log_provider.dart';
import 'package:playtones/providers/song_details_provider.dart';
import 'package:playtones/views/now%20playing%20screen/now_playing_screen.dart';
import 'package:provider/provider.dart';

class SpecifiedScreenArtist extends StatelessWidget {
  const SpecifiedScreenArtist({super.key});

  @override
  Widget build(BuildContext context) {
    late SongDetailsProvider provider = Provider.of<SongDetailsProvider>(
      context,
      listen: false,
    );
    final size = MediaQuery.of(context).size;
    final textTheme = Theme.of(context).textTheme;
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          iconSize: 30,
          icon: const Icon(CupertinoIcons.back, color: Colors.white),
        ),
      ),
      body: BlocBuilder<FetchArtistBloc, FetchArtistState>(
        builder: (context, state) {
          if (state is ArtistBasedSongState) {
            return Stack(
              children: [
                Container(
                  height: size.height,
                  width: size.width,
                  color: Colors.black,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 30, left: 30),
                      child: QueryArtworkWidget(
                        keepOldArtwork: true,
                        id: state.artistId,
                        type: ArtworkType.ARTIST,
                        artworkBorder: BorderRadius.circular(10),
                        artworkHeight: size.height * 0.17,
                        artworkWidth: size.width * 0.4,
                        nullArtworkWidget: Container(
                          width: size.width * 0.4,
                          height: size.height * 0.17,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.grey[800],
                          ),
                          child: const Icon(
                            Icons.album,
                            color: Colors.white,
                            size: 50,
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 40, top: 30),
                      child: Text(
                        state.songs[0].artist ?? "Unknown",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: textTheme.titleMedium!.fontSize,
                          overflow: TextOverflow.fade,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 20),
                      child: Theme(
                        data: ThemeData(
                          splashColor: Colors.grey[850],
                          highlightColor: Colors.grey[850],
                        ),
                        child: ListView.builder(
                          physics: const BouncingScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: state.songs.length,
                          itemBuilder: (context, index) {
                            final song = state.songs[index];
                            return ListTile(
                              onTap: () {
                                //Defined the function at the bottom of file
                                isLogged(context);
                                //-----------------------------------------
                                if (provider.songId == song.id) {
                                  PersistentNavBarNavigator.pushNewScreen(
                                    context,
                                    withNavBar: false,
                                    screen: NowPlayingScreen(),
                                    pageTransitionAnimation:
                                        PageTransitionAnimation.slideUp,
                                  );
                                } else {
                                  BlocProvider.of<FetchArtistBloc>(
                                    context,
                                    listen: false,
                                  ).add(PlaysongEvent(index: index));
                                  //----------------------------------------
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
                                  //----------------------------------------
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
                                  //--------------------------------------
                                  BlocProvider.of<MostPlayedBloc>(
                                    context,
                                    listen: false,
                                  ).add(GetMostPlayedSongEvent());
                                }
                              },
                              leading: Consumer<SongDetailsProvider>(
                                builder: (context, provider, _) {
                                  return Text(
                                    '${index + 1}',
                                    style: TextStyle(
                                      fontFamily: 'Font',
                                      fontSize: 12,
                                      color:
                                          provider.songId == song.id
                                              ? Color(0xFFFD0000)
                                              : textTheme.titleSmall!.color,
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
                                  color: textTheme.titleSmall!.color,
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            );
          }
          return Container();
        },
      ),
    );
  }

  //-------------------------------------------------------------------------
  void isLogged(BuildContext context) {
    if (Provider.of<LogProvider>(context, listen: false).isLogged == false) {
      Provider.of<LogProvider>(context, listen: false).logIn();
    }
  }
}
