import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';
import 'package:playtones/bloc/playlist/playlist_bloc.dart';

class CreatePlaylistScreen extends StatefulWidget {
  const CreatePlaylistScreen({super.key});

  @override
  State<CreatePlaylistScreen> createState() => _CreatePlaylistScreenState();
}

class _CreatePlaylistScreenState extends State<CreatePlaylistScreen> {
  TextEditingController textController = TextEditingController();
  @override
  void dispose() {
    textController.dispose();
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
                  if (textController.text.trim().isNotEmpty) {
                    BlocProvider.of<PlaylistBloc>(context, listen: false).add(
                      CreatePlaylistEvent(name: textController.text.trim()),
                    );
                    //--------------------------------------------------------
                    BlocProvider.of<PlaylistBloc>(
                      context,
                      listen: false,
                    ).add(FetchPlaylistEvent());
                    PersistentNavBarNavigator.pop(context);
                  }
                },
                iconSize: 30,
                icon: Icon(Icons.check, color: Colors.white),
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
                    controller: textController,
                    focusNode: FocusNode(),
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                    onTapOutside: (event) {
                      FocusScope.of(context).unfocus();
                    },
                    decoration: InputDecoration(
                      helperText: 'Enter playlist name',
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
