import 'dart:math';
import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:marquee/marquee.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';
import 'package:playtones/bloc/resume%20play/resume_play_bloc.dart';
import 'package:playtones/providers/song_details_provider.dart';
import 'package:playtones/services/database/save_songs_db.dart';
import 'package:playtones/views/now%20playing%20screen/now_playing_screen.dart';
import 'package:playtones/views/other%20screens/volume_screen.dart';
import 'package:provider/provider.dart';

Widget customBottomSheet(BuildContext context, AnimationController controller) {
  late SongDetailsProvider provider = Provider.of<SongDetailsProvider>(
    context,
    listen: false,
  );
  final size = MediaQuery.of(context).size;
  final textTheme = Theme.of(context).textTheme;

  return GestureDetector(
    onTap: () {
      PersistentNavBarNavigator.pushNewScreen(
        context,
        screen: const NowPlayingScreen(),
        pageTransitionAnimation: PageTransitionAnimation.slideUp,
      );
    },
    child: Container(
      height: size.height - 790,
      width: size.width - 30,
      decoration: BoxDecoration(
        color: Colors.grey[900],
        borderRadius: BorderRadius.circular(10),
      ),
      child: SingleChildScrollView(
        physics: const NeverScrollableScrollPhysics(),
        child: Column(
          children: [
            ListTile(
              leading: Consumer<SongDetailsProvider>(
                builder: (context, provider, _) {
                  return AnimatedBuilder(
                    animation: controller,
                    builder: (context, child) {
                      if (provider.isPlaying) {
                        controller.repeat();
                      } else if (!provider.isPlaying) {
                        controller.stop();
                      }
                      return Transform.rotate(
                        angle: controller.value * 2 * pi,
                        child: child,
                      );
                    },
                    child: QueryArtworkWidget(
                      keepOldArtwork: true,
                      artworkClipBehavior: Clip.antiAlias,
                      artworkBorder: BorderRadius.circular(30),
                      id: provider.songId ?? 0,
                      type: ArtworkType.AUDIO,
                      nullArtworkWidget: CircleAvatar(
                        radius: 25,
                        backgroundImage: const AssetImage(
                          'assets/music-player.png',
                        ),
                      ),
                    ),
                  );
                },
              ),
              title: Consumer<SongDetailsProvider>(
                builder: (context, provider, _) {
                  return Container(
                    color: Colors.grey[900],
                    height: 40,
                    width: 0,
                    child:
                        provider.songTitle != null &&
                                provider.songTitle!.length >= 18
                            ? Align(
                              alignment: AlignmentDirectional.centerStart,
                              child: Marquee(
                                blankSpace: 30,
                                pauseAfterRound: const Duration(seconds: 2),
                                fadingEdgeEndFraction: 0.1,
                                fadingEdgeStartFraction: 0.1,
                                velocity: 30,
                                text: provider.songTitle ?? "Unknown",
                                style: TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                  color: textTheme.titleSmall!.color,
                                ),
                              ),
                            )
                            : Align(
                              alignment: AlignmentDirectional.centerStart,
                              child: Text(
                                provider.songTitle ?? "Unknown",
                                style: TextStyle(
                                  fontSize: 10,
                                  fontFamily: 'Font',
                                  color: textTheme.titleSmall!.color,
                                ),
                              ),
                            ),
                  );
                },
              ),
              subtitle: Consumer<SongDetailsProvider>(
                builder: (context, provider, _) {
                  return Text(
                    provider.artist ?? "Unknown",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 9,
                      overflow: TextOverflow.ellipsis,
                      color: textTheme.titleSmall!.color,
                    ),
                  );
                },
              ),
              trailing: SizedBox(
                width: size.width * 0.26,
                child: Row(
                  children: [
                    IconButton(
                      onPressed: () {
                        PersistentNavBarNavigator.pushNewScreen(
                          context,
                          screen: VolumeScreen(),
                          withNavBar: true,
                          pageTransitionAnimation:
                              PageTransitionAnimation.slideUp,
                        );
                      },
                      highlightColor: Colors.grey[800],
                      icon: const Icon(Icons.speaker, color: Colors.grey),
                    ),
                    Consumer<SongDetailsProvider>(
                      builder: (context, songsProvider, _) {
                        return IconButton(
                          onPressed: () async {
                            final data = await SaveSongsDb().getSavedSong();
                            if (data != null) {
                              BlocProvider.of<ResumePlayBloc>(
                                context,
                                listen: false,
                              ).add(PlayWhereStoppedEvent());
                            }
                            if (provider.isPlaying) {
                              provider.audioPlayer.pause();
                            } else {
                              provider.audioPlayer.play();
                            }
                          },
                          highlightColor: Colors.grey[800],
                          icon:
                              songsProvider.isPlaying
                                  ? const Icon(
                                    Icons.pause_outlined,
                                    color: Colors.grey,
                                  )
                                  : const Icon(
                                    Icons.play_arrow_rounded,
                                    color: Colors.grey,
                                  ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 5, right: 5),
              child: Consumer<SongDetailsProvider>(
                builder: (context, provider, _) {
                  return ProgressBar(
                    progressBarColor: Color(0xFFFD0000),
                    baseBarColor: Colors.grey[800],
                    barHeight: 2,
                    thumbRadius: 0,
                    thumbGlowRadius: 0,
                    progress: provider.currentPosition ?? Duration.zero,
                    total: provider.totalDuration ?? Duration.zero,
                    onSeek: null,
                  );
                },
              ),
            ),
          ],
        ),
      ),
    ),
  );
}
