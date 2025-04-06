import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:marquee/marquee.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';
import 'package:playtones/bloc/fetch%20artist/fetch_artist_bloc.dart';
import 'package:playtones/providers/song_details_provider.dart';
import 'package:playtones/views/artists%20screen/specified_screen_artist.dart';
import 'package:playtones/views/other%20screens/loading_screen.dart';
import 'package:playtones/views/widgets/appbar.dart';
import 'package:playtones/views/other%20screens/empty_screen.dart';
import 'package:playtones/views/widgets/snack_bar.dart';
import 'package:provider/provider.dart';

class ArtistsScreen extends StatefulWidget {
  const ArtistsScreen({super.key});

  @override
  State<ArtistsScreen> createState() => _ArtistsScreenState();
}

class _ArtistsScreenState extends State<ArtistsScreen> {
  @override
  void initState() {
    super.initState();
    BlocProvider.of<FetchArtistBloc>(context).add(ArtistFetchEvent());
  }

  List<ArtistModel> _artists = [];

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
          BlocListener<FetchArtistBloc, FetchArtistState>(
            listener: (context, state) {
              if (state is ErrorState) {
                customScaffoldMessager(context, state.errorMessage);
              }
            },
            child: Center(),
          ),
          Expanded(
            child: BlocBuilder<FetchArtistBloc, FetchArtistState>(
              builder: (context, state) {
                if (state is ArtistFetchState && state.artists.isEmpty) {
                  return EmptyScreen(text: 'Artists are empty');
                }
                if (state is ArtistFetchState) {
                  _artists = state.artists;
                } else if (state is LoadingState) {
                  return const LoadingScreen();
                }
                return GridView.builder(
                  itemCount: _artists.length,
                  physics: const BouncingScrollPhysics(),
                  padding: EdgeInsets.all(12),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    mainAxisSpacing: 10,
                    crossAxisSpacing: 10,
                    crossAxisCount: 3,
                  ),
                  itemBuilder: (context, index) {
                    final artist = _artists[index];
                    return GestureDetector(
                      onTap: () {
                        /////////////////////////////////////////////////
                        BlocProvider.of<FetchArtistBloc>(
                          context,
                          listen: false,
                        ).add(ArtistBasedSongsEvent(artistId: artist.id));

                        //////////////////////////////////////////////////
                        PersistentNavBarNavigator.pushNewScreen(
                          context,
                          withNavBar: true,
                          screen: SpecifiedScreenArtist(),
                          pageTransitionAnimation:
                              PageTransitionAnimation.cupertino,
                        );
                      },
                      child: Stack(
                        alignment: AlignmentDirectional.topEnd,
                        children: [
                          GridTile(
                            footer: Center(
                              child:
                                  artist.artist.length <= 20
                                      ? Padding(
                                        padding: const EdgeInsets.only(
                                          bottom: 5,
                                        ),
                                        child: Text(
                                          artist.artist,
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
                                          startAfter: const Duration(
                                            seconds: 2,
                                          ),
                                          pauseAfterRound: const Duration(
                                            seconds: 2,
                                          ),
                                          text: artist.artist,
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
                                id: artist.id,
                                type: ArtworkType.ARTIST,
                                nullArtworkWidget: Container(
                                  width: size.width * 0.5,
                                  height: size.height * 0.13,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: Colors.grey[900],
                                  ),
                                  child: const Icon(
                                    CupertinoIcons.person,
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
                                return provider.artist == artist.artist &&
                                        provider.isPlaying
                                    ? Icon(
                                      CupertinoIcons.pause_circle,
                                      color: Colors.white,
                                      size: 30,
                                    )
                                    : provider.artist == artist.artist &&
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
