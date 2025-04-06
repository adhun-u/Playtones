import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';
import 'package:playtones/bloc/fetch%20artist/fetch_artist_bloc.dart';
import 'package:playtones/bloc/fetch%20audio/fetch_audio_bloc.dart';
import 'package:playtones/bloc/fetch_album/fetch_album_bloc.dart';

//showing the popup for deleting a specific
Future<void> deleteSong(SongModel song, BuildContext context) async {
  final size = MediaQuery.of(context).size;
  final textTheme = Theme.of(context).textTheme;
  showDialog(
    context: context,
    builder: (context) {
      return Dialog(
        child: Container(
          height: size.height * 0.25,
          width: size.width - 60,
          decoration: BoxDecoration(
            color: Colors.grey[900],
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 10),
                child: Text(
                  'Do you want to Delete ?',
                  style: textTheme.titleMedium,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 5),
                child: Divider(
                  endIndent: 10,
                  indent: 10,
                  color: Colors.grey[800],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 10, right: 10),
                child: Text(
                  song.title,
                  style: textTheme.titleMedium,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              SizedBox(
                child: Padding(
                  padding: const EdgeInsets.only(left: 10, right: 10, top: 50),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      CupertinoButton(
                        onPressed: () {
                          PersistentNavBarNavigator.pop(context);
                        },
                        color: Colors.transparent,
                        child: Text(
                          'Cancel',
                          style: TextStyle(
                            fontSize: textTheme.titleMedium!.fontSize,
                            color: textTheme.titleSmall!.color,
                          ),
                        ),
                      ),
                      CupertinoButton(
                        onPressed: () async {
                          File songFile = File(song.data);

                          if (songFile.existsSync()) {
                            songFile.deleteSync();

                            BlocProvider.of<FetchAudioBloc>(
                              context,
                              listen: false,
                            ).add(FetchSongsEvent());

                            BlocProvider.of<FetchAlbumBloc>(
                              context,
                              listen: false,
                            ).add(AlbumFetch());

                            BlocProvider.of<FetchArtistBloc>(
                              context,
                              listen: false,
                            ).add(ArtistFetchEvent());
                          }

                          Navigator.of(context).pop();
                        },
                        sizeStyle: CupertinoButtonSize.small,
                        borderRadius: BorderRadius.circular(5),
                        color: Colors.transparent,
                        child: Text(
                          'Delete',
                          style: TextStyle(
                            fontSize: textTheme.titleMedium!.fontSize,
                            color: Color(0xFFFD0000),
                          ),
                        ),
                      ),
                    ],
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
