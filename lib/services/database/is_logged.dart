import 'package:shared_preferences/shared_preferences.dart';

void isEntered(bool isLogged) async {
  final pref = await SharedPreferences.getInstance();
  await pref.setBool('is_logged', isLogged);
}

Future<bool?> getLoggedData() async {
  final pref = await SharedPreferences.getInstance();
  final data = pref.getBool('is_logged');
  return data;
}
