import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';
import 'package:playtones/bloc/playlist/playlist_bloc.dart';
import 'package:playtones/models/playlist%20model/playlist_model.dart';
import 'package:playtones/views/playlist%20screen/custom%20playlist/songs_based_playlist.dart';

class EditNameScreen extends StatefulWidget {
  final PlaylistDataModel playlistModel;
  const EditNameScreen({super.key, required this.playlistModel});

  @override
  State<EditNameScreen> createState() => _EditNameScreenState();
}

class _EditNameScreenState extends State<EditNameScreen> {
  late TextEditingController _textController;

  @override
  void initState() {
    super.initState();
    _textController = TextEditingController(
      text: widget.playlistModel.playlistName,
    );
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 20),
      child: SafeArea(
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.black,
            leading: IconButton(
              onPressed: () {
                PersistentNavBarNavigator.pop(context);
              },
              iconSize: 30,
              icon: Icon(CupertinoIcons.back, color: Colors.white),
            ),
            actions: [
              IconButton(
                onPressed: () {
                  if (_textController.text.trim().isNotEmpty) {
                    BlocProvider.of<PlaylistBloc>(context, listen: false).add(
                      RenamePlaylistEvent(
                        id: widget.playlistModel.playlistId,
                        newName: _textController.text.trim(),
                      ),
                    );
                    ////////////////////
                    BlocProvider.of<PlaylistBloc>(
                      context,
                      listen: false,
                    ).add(FetchPlaylistEvent());
                    ///////////////////
                    Navigator.of(context).pop();
                    //////////////////
                    Navigator.of(context).pushReplacement(
                      CupertinoPageRoute(
                        builder:
                            (context) => SongsBasedPlaylist(
                              playlistDataModel: PlaylistDataModel(
                                playlistName: _textController.text.trim(),
                                playlistId: widget.playlistModel.playlistId,
                              ),
                            ),
                      ),
                    );
                  }
                },
                iconSize: 30,
                icon: Icon(
                  CupertinoIcons.check_mark_circled,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          body: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 20,
                  horizontal: 20,
                ),
                child: Theme(
                  data: ThemeData(
                    textSelectionTheme: TextSelectionThemeData(
                      selectionHandleColor: const Color(0xFFFD0000),
                      cursorColor: const Color(0xFFFD0000),
                    ),
                  ),
                  child: TextField(
                    controller: _textController,
                    focusNode: FocusNode(),
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                    onTapOutside: (event) {
                      FocusScope.of(context).unfocus();
                    },
                    decoration: InputDecoration(
                      helperText: 'Enter new name',
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: const Color(0xFFFD0000)),
                      ),
                      border: UnderlineInputBorder(
                        borderSide: BorderSide(color: const Color(0xFFFD0000)),
                      ),
                      disabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: const Color(0xFFFD0000)),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
