import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:just_audio/just_audio.dart';
import 'package:marquee/marquee.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:playtones/bloc/favorites/favorite_bloc.dart';
import 'package:playtones/bloc/recently%20played/recently_played_bloc.dart';
import 'package:playtones/bloc/resume%20play/resume_play_bloc.dart';
import 'package:playtones/models/favorites%20model/favorite.dart';
import 'package:playtones/models/save%20song%20model/save_song_model.dart';
import 'package:playtones/providers/audio_features_provider.dart';
import 'package:playtones/providers/favoite_song_provider.dart';
import 'package:playtones/providers/log_provider.dart';
import 'package:playtones/providers/song_details_provider.dart';
import 'package:playtones/services/audio%20service/audio_service.dart';
import 'package:playtones/services/database/save_songs_db.dart';
import 'package:playtones/views/lyrics%20screen/lyrics_screen.dart';
import 'package:provider/provider.dart';

class NowPlayingScreen extends StatefulWidget {
  const NowPlayingScreen({super.key});

  @override
  State<NowPlayingScreen> createState() => _NowPlayingScreenState();
}

class _NowPlayingScreenState extends State<NowPlayingScreen> {
  SaveSongModel? saveSongModel;
  @override
  void initState() {
    getSavedSong();
    super.initState();
  }

  void getSavedSong() async {
    saveSongModel = await SaveSongsDb().getSavedSong();
  }

  @override
  Widget build(BuildContext context) {
    late SongDetailsProvider provider = Provider.of<SongDetailsProvider>(
      context,
      listen: false,
    );
    final textTheme = Theme.of(context).textTheme;
    final size = MediaQuery.of(context).size;
    return SizedBox(
      height: size.height,
      width: size.width,
      child: Scaffold(
        backgroundColor: Color.fromARGB(0, 255, 75, 75),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 30, left: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    icon: const Icon(
                      CupertinoIcons.chevron_down,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),

            Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 90),
                  child: Consumer<SongDetailsProvider>(
                    builder: (context, provider, _) {
                      return QueryArtworkWidget(
                        keepOldArtwork: true,
                        artworkFit: BoxFit.fill,
                        artworkQuality: FilterQuality.high,
                        size: 300,
                        quality: 100,
                        artworkHeight: size.height * 0.30,
                        artworkWidth: size.width - 120,
                        artworkBorder: BorderRadius.circular(5),
                        id: provider.songId ?? 0,
                        type: ArtworkType.AUDIO,
                        nullArtworkWidget: Container(
                          width: size.width - 120,
                          height: size.height * 0.30,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.grey[950],
                          ),
                          child: const Icon(
                            Icons.music_note_rounded,
                            color: Colors.white,
                            size: 100,
                          ),
                        ),
                      );
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 40, right: 20, top: 20),
                  child: ListTile(
                    title: SizedBox(
                      height: 50,
                      width: 200,
                      child: Consumer<SongDetailsProvider>(
                        builder: (context, provider, _) {
                          final songProvider =
                              Provider.of<SongDetailsProvider>(
                                context,
                                listen: false,
                              ).songTitle;
                          return provider.songTitle != null &&
                                  provider.songTitle!.length >= 18
                              ? Marquee(
                                pauseAfterRound: const Duration(seconds: 2),
                                startAfter: const Duration(seconds: 2),
                                text: songProvider ?? "Unknown",
                                style: textTheme.titleMedium,
                                fadingEdgeStartFraction: 0.05,
                                fadingEdgeEndFraction: 0.05,
                                blankSpace: 100,
                                velocity: 30,
                              )
                              : Container(
                                height: 20,
                                width: 200,
                                alignment: AlignmentDirectional.centerStart,
                                child: Text(
                                  provider.songTitle ?? "Unknown",
                                  style: textTheme.titleMedium,
                                ),
                              );
                        },
                      ),
                    ),

                    subtitle: Consumer<SongDetailsProvider>(
                      builder: (context, provider, _) {
                        return Text(
                          provider.artist ?? "Unknown",
                          style: TextStyle(
                            overflow: TextOverflow.ellipsis,
                            fontWeight: FontWeight.bold,
                            fontSize: 10,
                            color: Colors.grey,
                          ),
                        );
                      },
                    ),

                    trailing: IconButton(
                      onPressed: () {
                        //----------------------------------------------------
                        if (Provider.of<FavoiteSongProvider>(
                          context,
                          listen: false,
                        ).favorites.any((model) {
                          return model.songId == provider.songId;
                        })) {
                          //-----------------------------------------------------
                          if (provider.songId != null) {
                            BlocProvider.of<FavoriteBloc>(
                              context,
                              listen: false,
                            ).add(RemoveSongEvent(songId: provider.songId!));
                            //-------------------------------------------------------
                            Provider.of<FavoiteSongProvider>(
                              context,
                              listen: false,
                            ).delete(provider.songId!);
                          }
                        } else {
                          //////////////////////////////////////
                          if (provider.songId != null) {
                            BlocProvider.of<FavoriteBloc>(
                              context,
                              listen: false,
                            ).add(AddSongs(songId: provider.songId!));
                            //////////////////////////////////////////
                            final model = FavoriteModel(
                              songId: provider.songId!,
                            );
                            Provider.of<FavoiteSongProvider>(
                              context,
                              listen: false,
                            ).addToList(model);
                            /////////////////////////////////////
                          }
                        }
                      },
                      icon: Consumer2<FavoiteSongProvider, SongDetailsProvider>(
                        builder: (
                          context,
                          favoriteSongProvider,
                          songProvider,
                          _,
                        ) {
                          bool isTrue = favoriteSongProvider.favorites.any(
                            (model) => model.songId == songProvider.songId,
                          );
                          return AnimatedSwitcher(
                            duration: const Duration(milliseconds: 200),
                            child: Icon(
                              isTrue ? Icons.favorite : Icons.favorite_border,
                              color:
                                  isTrue ? Color(0xFFFD0000) : Colors.grey[700],
                              size: 25,
                              key: ValueKey<bool>(isTrue),
                            ),
                            transitionBuilder: (child, animation) {
                              return ScaleTransition(
                                scale: animation,
                                child: child,
                              );
                            },
                          );
                        },
                      ),
                    ),
                  ),
                ),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Consumer<AudioFeaturesProvider>(
                      builder: (context, audioFeaturesProvider, _) {
                        return IconButton(
                          onPressed: () {
                            //----------------------------------------------------
                            if (audioFeaturesProvider.isSuffle) {
                              Provider.of<AudioFeaturesProvider>(
                                context,
                                listen: false,
                              ).suffleMode(false);
                            }
                            Provider.of<AudioFeaturesProvider>(
                              context,
                              listen: false,
                            ).changeLoopMode();
                          },
                          iconSize: 25,
                          icon: Icon(
                            audioFeaturesProvider.loop == LoopMode.off
                                ? Icons.repeat
                                : Icons.repeat_one,
                            color:
                                audioFeaturesProvider.loop == LoopMode.off
                                    ? textTheme.titleSmall!.color
                                    : Color(0xFFFD0000),
                          ),
                        );
                      },
                    ),
                    Row(
                      children: [
                        IconButton(
                          onPressed: () {
                            Provider.of<AudioFeaturesProvider>(
                              context,
                              listen: false,
                            ).increaseSpeed();
                          },
                          iconSize: 25,
                          icon: const Icon(
                            Icons.speed,
                            color: Color(0xFFFD0000),
                          ),
                        ),
                        Consumer<AudioFeaturesProvider>(
                          builder: (context, audioFeaturesProvider, _) {
                            return Text(
                              '${audioFeaturesProvider.speedOfAudio}x',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: textTheme.titleSmall!.color,
                                fontSize: textTheme.bodySmall!.fontSize,
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                    IconButton(
                      onPressed:
                          () => Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) {
                                return LyricsScreen(songId: provider.songId);
                              },
                              barrierDismissible: true,
                            ),
                          ),
                      iconSize: 25,
                      icon: const Icon(
                        Icons.lyrics_outlined,
                        color: Colors.white,
                      ),
                    ),
                    Consumer<AudioFeaturesProvider>(
                      builder: (context, audioFeaturesProvider, _) {
                        return IconButton(
                          onPressed: () {
                            //---------------------------------------------------
                            if (audioFeaturesProvider.isSuffle == false) {
                              if (audioFeaturesProvider.loop == LoopMode.one) {
                                Provider.of<AudioFeaturesProvider>(
                                  context,
                                  listen: false,
                                ).changeLoopMode();
                                //---------------------------------------------
                              }
                              Provider.of<AudioFeaturesProvider>(
                                context,
                                listen: false,
                              ).suffleMode(true);
                              //------------------------------------------------
                            } else {
                              Provider.of<AudioFeaturesProvider>(
                                context,
                                listen: false,
                              ).suffleMode(false);
                            }
                            //-------------------------------------------------
                          },
                          iconSize: 25,
                          icon: Icon(
                            Icons.shuffle,
                            color:
                                audioFeaturesProvider.isSuffle
                                    ? Color(0xFFFD0000)
                                    : Colors.white,
                          ),
                        );
                      },
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 60, right: 60, top: 20),
                  child: Consumer<SongDetailsProvider>(
                    builder: (context, provider, _) {
                      return ProgressBar(
                        progressBarColor: Color(0xFFFD0000),
                        thumbGlowRadius: 0,
                        thumbRadius: 5,
                        bufferedBarColor: Colors.grey[900],
                        thumbColor: Color(0xFFFD0000),
                        baseBarColor: Colors.grey[900],
                        timeLabelTextStyle: textTheme.titleSmall,
                        progress: provider.currentPosition ?? Duration.zero,
                        total: provider.totalDuration ?? Duration.zero,
                        buffered: provider.bufferedDuration,
                        onSeek: (duration) async {
                          await provider.audioPlayer.seek(duration);
                        },
                      );
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 25, top: 30, right: 25),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Consumer<SongDetailsProvider>(
                        builder: (context, provider, _) {
                          return IconButton(
                            onPressed: () async {
                              await AudioService.audioPlayer.seekToPrevious();
                              //-------------------------------------------------
                              BlocProvider.of<RecentlyPlayedBloc>(
                                context,
                                listen: false,
                              ).add(
                                AddData(
                                  songId: provider.songId ?? 0,
                                  time: DateTime.now(),
                                  title: provider.songTitle ?? "Unknown",
                                  artist: provider.artist ?? "Unknown",
                                ),
                              );
                              //-----------------------------------------------
                              await AudioService.audioPlayer.play();
                              //------------------------------------------------
                              BlocProvider.of<RecentlyPlayedBloc>(
                                context,
                                listen: false,
                              ).add(GetSongsEvent());
                            },
                            iconSize: 35,
                            icon: const Icon(
                              Icons.skip_previous_rounded,
                              color: Colors.white,
                            ),
                          );
                        },
                      ),

                      IconButton(
                        onPressed: () {
                          if (provider.currentPosition != null &&
                              provider.currentPosition! >
                                  Duration(
                                    hours: 0,
                                    minutes: 0,
                                    seconds: 0,
                                    milliseconds: 0,
                                    microseconds: 0,
                                  )) {
                            //backward 10 second

                            if (provider.currentPosition! <
                                const Duration(
                                  hours: 0,
                                  minutes: 0,
                                  seconds: 10,
                                )) {
                              provider.audioPlayer.seek(
                                provider.currentPosition! -
                                    provider.currentPosition!,
                              );
                            } else {
                              provider.audioPlayer.seek(
                                provider.currentPosition! -
                                    const Duration(seconds: 10),
                              );
                            }
                          }
                        },
                        icon: Image.asset(
                          filterQuality: FilterQuality.high,
                          color: textTheme.titleSmall!.color,
                          height: 27,
                          width: 27,
                          'icons/back.png',
                        ),
                      ),
                      IconButton(
                        onPressed: () async {
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
                          if (saveSongModel != null) {
                            BlocProvider.of<ResumePlayBloc>(
                              context,
                              listen: false,
                            ).add(PlayWhereStoppedEvent());
                          }
                          if (provider.isPlaying) {
                            await AudioService.audioPlayer.pause();
                          } else {
                            await AudioService.audioPlayer.play();
                          }
                        },
                        icon: CircleAvatar(
                          radius: 35,
                          backgroundColor: Colors.grey[800],
                          child: Consumer<SongDetailsProvider>(
                            builder: (context, provider, _) {
                              return AnimatedSwitcher(
                                duration: const Duration(milliseconds: 200),
                                transitionBuilder: (child, animation) {
                                  return ScaleTransition(
                                    scale: animation,
                                    child: child,
                                  );
                                },
                                child: Icon(
                                  provider.isPlaying
                                      ? Icons.pause_outlined
                                      : Icons.play_arrow_rounded,
                                  color: Colors.white,
                                  size: 40,
                                  key: ValueKey<bool>(provider.isPlaying),
                                ),
                              );
                            },
                          ),
                        ),
                      ),

                      IconButton(
                        onPressed: () {
                          //forward 10 second
                          if (provider.currentPosition != null &&
                              provider.currentPosition! <
                                  provider.totalDuration!) {
                            provider.audioPlayer.seek(
                              provider.currentPosition! +
                                  const Duration(seconds: 10),
                            );
                          }
                        },
                        icon: Image.asset(
                          filterQuality: FilterQuality.high,
                          height: 27,
                          width: 27,
                          color: textTheme.titleSmall!.color,
                          'icons/next.png',
                        ),
                      ),

                      Consumer<SongDetailsProvider>(
                        builder: (context, provider, _) {
                          return IconButton(
                            onPressed: () async {
                              await AudioService.audioPlayer.seekToNext();
                              //-----------------------------------------------
                              BlocProvider.of<RecentlyPlayedBloc>(
                                context,
                                listen: false,
                              ).add(
                                AddData(
                                  songId: provider.songId ?? 0,
                                  time: DateTime.now(),
                                  title: provider.songTitle ?? "Unknown",
                                  artist: provider.artist ?? "Unknown",
                                ),
                              );
                              //------------------------------------------------
                              await AudioService.audioPlayer.play();
                              //------------------------------------------------
                              BlocProvider.of<RecentlyPlayedBloc>(
                                context,
                                listen: false,
                              ).add(GetSongsEvent());
                            },
                            iconSize: 35,
                            icon: const Icon(
                              Icons.skip_next_rounded,
                              color: Colors.white,
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
