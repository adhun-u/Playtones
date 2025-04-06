import 'dart:developer';
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:playtones/models/lyrics%20model/lyrics_line_model.dart';
import 'package:playtones/providers/lyrics_provider.dart';
import 'package:playtones/services/database/lyrics.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';

//To share a song
Future<void> shareSong(String filePath) async {
  try {
    final xFile = XFile(filePath);
    await Share.shareXFiles([xFile]);
  } catch (e) {
    log("Error while sending $e");
  }
}

//To fetch lyrics from external storage
Future<void> pickLyrics(int songId, BuildContext context) async {
  List<LyricsLine> lyrics = [];
  try {
    //opening file managet
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.any,
    );
    //Checking if the extension of the file is lrc or not to avoid conflicts
    if (result != null && result.files.single.extension == 'lrc') {
      File file = File(result.files.single.path!);
      String content = file.readAsStringSync();
      List<String> lines = content.split('\n');

      final regEx = RegExp(r"\[(\d+):(\d+\.\d+)\](.*)");
      for (var line in lines) {
        final match = regEx.firstMatch(line);
        if (match != null) {
          final minute = int.parse(match.group(1)!);
          final second = double.parse(match.group(2)!);
          final text = match.group(3)!.trim();
          lyrics.add(
            LyricsLine(
              second: second.toInt(),
              minute: minute,
              text: text,
              songId: songId,
            ),
          );
        }
      }
      //Adding the lyrics to database
      await LyricsDB().addLyrics(lyrics, songId);
    }
    Provider.of<LyricsProvider>(context, listen: false).getLyrics(songId);
  } catch (e) {
    log('error $e');
  }
}
