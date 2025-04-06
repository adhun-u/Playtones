import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:playtones/providers/lyrics_provider.dart';
import 'package:playtones/providers/song_details_provider.dart';
import 'package:playtones/services/audio%20service/audio_service.dart';
import 'package:playtones/services/other%20functionalities/functionalities.dart';
import 'package:playtones/views/widgets/snack_bar.dart';
import 'package:provider/provider.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

class LyricsScreen extends StatefulWidget {
  int? songId;
  LyricsScreen({super.key, required this.songId});

  @override
  State<LyricsScreen> createState() => _LyricsScreenState();
}

class _LyricsScreenState extends State<LyricsScreen>
    with SingleTickerProviderStateMixin {
  ItemScrollController itemscrollController = ItemScrollController();
  int lyricIndex = 0;
  @override
  void initState() {
    super.initState();
  }

  void scroll(Duration duration) async {
    lyricIndex = Provider.of<LyricsProvider>(
      context,
      listen: false,
    ).lyrics.indexWhere((lyric) {
      final lyricsDuration = Duration(
        seconds: lyric.second,
        minutes: lyric.minute,
      );
      return lyricsDuration > duration;
    });

    if (lyricIndex > 0) {
      try {
        if (itemscrollController.isAttached) {
          itemscrollController.jumpTo(index: lyricIndex, alignment: 0.5);
        }
      } catch (e) {
        customScaffoldMessager(context, 'Something went wrong');
      }
    }
  }

  late SongDetailsProvider songProvider = Provider.of<SongDetailsProvider>(
    context,
  );

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: SizedBox(
        height: size.height,
        width: size.width,
        child: Column(
          children: [
            Consumer<LyricsProvider>(
              builder: (context, lyricsprovidr, child) {
                lyricsprovidr.getLyrics(songProvider.songId ?? 0);
                return Center();
              },
            ),
            Padding(
              padding: const EdgeInsets.only(top: 30, left: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    iconSize: 30,
                    icon: const Icon(CupertinoIcons.back, color: Colors.white),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 20, left: 15),
              child: ListTile(
                leading: Consumer<SongDetailsProvider>(
                  builder: (context, songProvider, _) {
                    return QueryArtworkWidget(
                      keepOldArtwork: true,
                      artworkQuality: FilterQuality.high,
                      artworkFit: BoxFit.fill,
                      artworkBorder: BorderRadius.circular(5),
                      artworkHeight: 60,
                      artworkWidth: 60,
                      id: songProvider.songId ?? 0,
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
                    );
                  },
                ),
                title: Consumer<SongDetailsProvider>(
                  builder: (context, songProvider, _) {
                    return Text(
                      songProvider.songTitle ?? "Unknown",
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: textTheme.titleSmall!.fontSize,
                        fontWeight: FontWeight.bold,
                        color: textTheme.titleSmall!.color,
                        overflow: TextOverflow.ellipsis,
                      ),
                    );
                  },
                ),
                subtitle: Consumer<SongDetailsProvider>(
                  builder: (context, songProvider, _) {
                    return Text(
                      songProvider.artist ?? "Unknown",
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: textTheme.bodySmall!.fontSize,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey[800],
                        overflow: TextOverflow.ellipsis,
                      ),
                    );
                  },
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 20, right: 20, left: 20),
              child: Container(
                height: size.height * 0.5,
                width: size.width,
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Padding(
                  padding: const EdgeInsets.only(left: 20, right: 20),
                  child:
                      Provider.of<LyricsProvider>(context).lyrics.isEmpty
                          ? Center(
                            child: CupertinoButton(
                              onPressed: () async {
                                await pickLyrics(
                                  songProvider.songId ?? 0,
                                  context,
                                );
                              },
                              color: Colors.grey[900],
                              sizeStyle: CupertinoButtonSize.small,
                              borderRadius: BorderRadius.circular(20),
                              child: Text(
                                'Add Lyrics',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          )
                          : SizedBox(
                            height: size.height * 0.5,
                            width: size.width - 30,
                            child: Consumer<SongDetailsProvider>(
                              builder: (context, songProvider, _) {
                                scroll(
                                  songProvider.currentPosition ?? Duration.zero,
                                );
                                //------------------------------------------
                                return ScrollablePositionedList.builder(
                                  initialAlignment: 0.5,
                                  reverse: true,
                                  itemScrollController: itemscrollController,
                                  physics: const BouncingScrollPhysics(),
                                  itemCount:
                                      Provider.of<LyricsProvider>(
                                        context,
                                        listen: false,
                                      ).lyrics.length,
                                  itemBuilder: (context, index) {
                                    final lyric =
                                        Provider.of<LyricsProvider>(
                                          context,
                                          listen: false,
                                        ).lyrics[index];

                                    return ListTile(
                                      title:
                                          lyricIndex > index
                                              ? Text(
                                                lyric.text,
                                                style: TextStyle(
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.bold,
                                                  color: Color(0xFFFD0000),
                                                ),
                                              )
                                              : Text(
                                                lyric.text,
                                                style: TextStyle(
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.normal,
                                                  color: Colors.grey[700],
                                                ),
                                              ),
                                    );
                                  },
                                );
                              },
                            ),
                          ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 60, right: 60, top: 20),
              child: Consumer<SongDetailsProvider>(
                builder: (context, songProvider, _) {
                  return ProgressBar(
                    progressBarColor: Color(0xFFFD0000),
                    thumbGlowRadius: 0,
                    thumbRadius: 5,
                    bufferedBarColor: Colors.grey[900],
                    thumbColor: Color(0xFFFD0000),
                    baseBarColor: Colors.grey[900],
                    timeLabelTextStyle: textTheme.titleSmall,
                    progress:
                        songProvider.currentPosition ??
                        const Duration(seconds: 0, milliseconds: 0),
                    total:
                        songProvider.totalDuration ??
                        const Duration(seconds: 0, milliseconds: 0),
                    onSeek: (duration) async {
                      await AudioService.audioPlayer.seek(duration);
                    },
                  );
                },
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.only(right: 20),
                  child: Consumer<SongDetailsProvider>(
                    builder: (context, songProvider, _) {
                      return IconButton(
                        onPressed: () {
                          if (songProvider.currentPosition != null &&
                              songProvider.currentPosition! >
                                  Duration(
                                    hours: 0,
                                    minutes: 0,
                                    seconds: 0,
                                    milliseconds: 0,
                                    microseconds: 0,
                                  )) {
                            //backward 10 second
                            if (songProvider.currentPosition! <
                                const Duration(
                                  hours: 0,
                                  minutes: 0,
                                  seconds: 10,
                                )) {
                              songProvider.audioPlayer.seek(
                                songProvider.currentPosition! -
                                    songProvider.currentPosition!,
                              );
                            } else {
                              songProvider.audioPlayer.seek(
                                songProvider.currentPosition! -
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
                      );
                    },
                  ),
                ),

                Consumer<SongDetailsProvider>(
                  builder: (context, songProvider, _) {
                    return IconButton(
                      onPressed: () async {
                        if (songProvider.isPlaying) {
                          await AudioService.audioPlayer.pause();
                        } else {
                          await AudioService.audioPlayer.play();
                        }
                      },
                      icon: CircleAvatar(
                        radius: 35,
                        backgroundColor: Colors.grey[800],
                        child: AnimatedSwitcher(
                          duration: const Duration(milliseconds: 150),
                          transitionBuilder: (child, animation) {
                            return ScaleTransition(
                              scale: animation,
                              child: child,
                            );
                          },
                          child: Icon(
                            songProvider.isPlaying
                                ? Icons.pause
                                : Icons.play_arrow_rounded,
                            color: Colors.white,
                            size: 40,
                            key: ValueKey<bool>(songProvider.isPlaying),
                          ),
                        ),
                      ),
                    );
                  },
                ),

                Padding(
                  padding: const EdgeInsets.only(left: 20),
                  child: Consumer<SongDetailsProvider>(
                    builder: (context, songProvider, _) {
                      return IconButton(
                        onPressed: () {
                          //forward 10 second
                          if (songProvider.currentPosition != null &&
                              songProvider.currentPosition! <
                                  songProvider.totalDuration!) {
                            songProvider.audioPlayer.seek(
                              songProvider.currentPosition! +
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
                      );
                    },
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
