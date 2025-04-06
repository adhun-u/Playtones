import 'package:flutter/material.dart';
import 'package:toastification/toastification.dart';

void toast(BuildContext context, String text, IconData icon, Color color) {
  final textTheme = Theme.of(context).textTheme;
  toastification.show(
    context: context,
    type: ToastificationType.success,
    autoCloseDuration: const Duration(seconds: 1),
    title: Text(
      text,
      style: TextStyle(
        fontFamily: 'Font',
        color: Colors.white,
        fontSize: textTheme.titleSmall!.fontSize,
      ),
    ),
    alignment: AlignmentDirectional.bottomCenter,
    borderSide: BorderSide(width: 2),
    backgroundColor: Colors.black,
    foregroundColor: Colors.white,
    closeButton: ToastCloseButton(showType: CloseButtonShowType.always),
    showIcon: true,
    icon: Icon(icon, color: color),
    borderRadius: BorderRadius.circular(10),
  );
}
//--------------------------------------------------------------------------------

void customScaffoldMessager(BuildContext context, String message) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(
        message,
        style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
      ),
      duration: const Duration(seconds: 1),
      backgroundColor: Colors.black,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
    ),
  );
}
