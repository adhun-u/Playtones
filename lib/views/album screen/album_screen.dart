import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:marquee/marquee.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';
import 'package:playtones/bloc/fetch_album/fetch_album_bloc.dart';
import 'package:playtones/providers/song_details_provider.dart';
import 'package:playtones/views/album%20screen/specifed_songs_album.dart';
import 'package:playtones/views/other%20screens/loading_screen.dart';
import 'package:playtones/views/widgets/appbar.dart';
import 'package:playtones/views/other%20screens/empty_screen.dart';
import 'package:playtones/views/widgets/snack_bar.dart';
import 'package:provider/provider.dart';

class AlbumScreen extends StatefulWidget {
  const AlbumScreen({super.key});

  @override
  State<AlbumScreen> createState() => _AlbumScreenState();
}

class _AlbumScreenState extends State<AlbumScreen> {
  @override
  void initState() {
    super.initState();
    BlocProvider.of<FetchAlbumBloc>(context, listen: false).add(AlbumFetch());
  }

  List<AlbumModel> _albums = [];

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size(size.width, size.height * 0.1),
        child: const CustomAppBar(),
      ),
      body: Column(
        children: [
          BlocListener<FetchAlbumBloc, FetchAlbumState>(
            listener: (context, state) {
              if (state is ErrorState) {
                customScaffoldMessager(context, state.error);
              }
            },
            child: Center(),
          ),
          Expanded(
            child: BlocBuilder<FetchAlbumBloc, FetchAlbumState>(
              builder: (context, state) {
                if (state is AlbumsLoaded && state.albums.isEmpty) {
                  return EmptyScreen(text: 'Movies are empty');
                }
                if (state is AlbumsLoaded) {
                  _albums = state.albums;
                } else if (state is LoadingState) {
                  return const LoadingScreen();
                }
                return GridView.builder(
                  itemCount: _albums.length,
                  physics: const BouncingScrollPhysics(),
                  padding: EdgeInsets.all(12),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    mainAxisSpacing: 10,
                    crossAxisSpacing: 10,
                    crossAxisCount: 3,
                  ),
                  itemBuilder: (context, index) {
                    final album = _albums[index];
                    return GestureDetector(
                      onTap: () {
                        //Defined the function bottom of the file
                        onTapFunctions(context, album.id);
                      },
                      child: Stack(
                        alignment: AlignmentDirectional.topEnd,
                        children: [
                          GridTile(
                            footer: Center(
                              child:
                                  album.album.length <= 20
                                      ? Padding(
                                        padding: const EdgeInsets.only(
                                          bottom: 5,
                                        ),
                                        child: Text(
                                          album.album,

                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 9,
                                            color: textTheme.titleSmall!.color,
                                            shadows: [
                                              Shadow(
                                                color: Colors.black,
                                                offset: Offset(2, 2),
                                              ),
                                            ],
                                          ),
                                        ),
                                      )
                                      : SizedBox(
                                        height: size.height * 0.03,
                                        width: size.width * 0.27,
                                        child: Marquee(
                                          text: album.album,
                                          startAfter: const Duration(
                                            seconds: 2,
                                          ),
                                          pauseAfterRound: const Duration(
                                            seconds: 2,
                                          ),
                                          velocity: 10,
                                          blankSpace: 50,
                                          fadingEdgeStartFraction: 0.1,
                                          fadingEdgeEndFraction: 0.1,
                                          style: TextStyle(
                                            shadows: [
                                              const Shadow(
                                                color: Colors.black,
                                                blurRadius: 30,
                                              ),
                                              const Shadow(
                                                color: Colors.black,
                                                blurRadius: 30,
                                              ),
                                            ],
                                            fontWeight: FontWeight.bold,
                                            color: textTheme.titleSmall!.color,
                                            fontSize: 9,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                      ),
                            ),
                            child: Opacity(
                              opacity: 0.5,
                              child: QueryArtworkWidget(
                                artworkBorder: BorderRadius.circular(10),
                                artworkHeight: size.height * 0.13,
                                keepOldArtwork: true,
                                artworkWidth: size.width * 0.5,
                                id: album.id,
                                type: ArtworkType.ALBUM,
                                nullArtworkWidget: Container(
                                  width: size.width * 0.5,
                                  height: size.height * 0.13,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: Colors.grey[900],
                                  ),
                                  child: const Icon(
                                    Icons.album,
                                    color: Colors.white,
                                    size: 50,
                                  ),
                                ),
                              ),
                            ),
                          ),

                          Center(
                            child: Consumer<SongDetailsProvider>(
                              builder: (context, provider, _) {
                                return provider.album == album.album &&
                                        provider.isPlaying
                                    ? Icon(
                                      CupertinoIcons.pause_circle,
                                      color: Colors.white,
                                      size: 30,
                                    )
                                    : provider.album == album.album &&
                                        provider.isPlaying == false
                                    ? Icon(
                                      CupertinoIcons.play_circle_fill,
                                      color: Colors.white,
                                      size: 30,
                                    )
                                    : Container();
                              },
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
//----------------------------------------------------------------------------

void onTapFunctions(BuildContext context, int id) {
  BlocProvider.of<FetchAlbumBloc>(
    context,
    listen: false,
  ).add(AlbumBasedEvent(albumId: id));

  PersistentNavBarNavigator.pushNewScreen(
    context,
    withNavBar: true,
    screen: SpecifedSongsAlbum(),
  );
}
