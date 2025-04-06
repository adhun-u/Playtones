import 'package:flutter/material.dart';
import 'package:playtones/services/database/is_logged.dart';

class LogProvider extends ChangeNotifier {
  bool isLogged = false;

  LogProvider() {
    getData();
  }

  void logIn() {
    if (isLogged == false) {
      isLogged = true;
      isEntered(true);
      notifyListeners();
    }
  }

  void getData() async {
    final data = await getLoggedData();
    if (data != null) {
      isLogged = data;
      notifyListeners();
    }
  }
}
