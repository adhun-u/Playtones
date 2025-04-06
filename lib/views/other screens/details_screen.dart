import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:on_audio_query/on_audio_query.dart';

class DetailsScreen extends StatelessWidget {
  final SongModel song;
  const DetailsScreen({super.key, required this.song});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final textTheme = Theme.of(context).textTheme;
    return SizedBox(
      height: size.height,
      width: size.width,
      child: Scaffold(
        body: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 30, left: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    IconButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      icon: Icon(CupertinoIcons.back, color: Colors.white),
                      iconSize: 30,
                    ),
                  ],
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 60, bottom: 10),
                    child: Text(
                      'Album Cover',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        fontSize: textTheme.titleMedium!.fontSize,
                      ),
                    ),
                  ),
                ],
              ),
              QueryArtworkWidget(
                id: song.id,
                type: ArtworkType.AUDIO,
                artworkQuality: FilterQuality.high,
                quality: 100,
                size: 200,
                artworkBorder: BorderRadius.circular(10),
                artworkHeight: size.height * 0.3,
                artworkWidth: size.width * 0.7,
                nullArtworkWidget: Container(
                  height: size.height * 0.3,
                  width: size.width * 0.7,
                  decoration: BoxDecoration(
                    color: Colors.grey[900],
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(Icons.music_note, size: 40, color: Colors.white),
                ),
              ),
              row('Song title', song.title, size),
              row('Song artist', song.artist ?? "Unknown", size),
              row('Path', song.data, size),
              Padding(
                padding: EdgeInsets.only(top: 35),
                child: row('Album', song.album ?? "Unknown", size),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

Widget row(String text, String subtitle, Size size) {
  return Padding(
    padding: const EdgeInsets.only(left: 60, top: 20),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              text,
              style: TextStyle(
                color: Colors.grey,
                fontWeight: FontWeight.bold,
                fontSize: 10,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            SizedBox(
              height: 35,
              width: size.width * 0.7,
              child: Text(
                subtitle,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  fontSize: 12,
                  overflow: TextOverflow.visible,
                ),
              ),
            ),
          ],
        ),
      ],
    ),
  );
}
