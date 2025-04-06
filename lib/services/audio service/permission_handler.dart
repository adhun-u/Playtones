import 'dart:developer';
import 'dart:io';
import 'package:permission_handler/permission_handler.dart';

//For asking permission
Future<void> askPermission() async {
  try {
    final status = await Permission.storage.request();
    if (status.isDenied || status.isPermanentlyDenied) {
      exit(0);
    }
  } catch (e) {
    log('Something went wrong $e');
  }
}
