import 'package:flutter/cupertino.dart';
import 'package:playtones/views/search%20screen/search_screen.dart';

class SearchNav extends StatelessWidget {
  const SearchNav({super.key});

  @override
  Widget build(BuildContext context) {
    final searchKey = GlobalKey<NavigatorState>();
    return Navigator(
      key: searchKey,
      onGenerateRoute: (settings) {
        return CupertinoPageRoute(
          settings: settings,
          builder: (context) => SearchScreen(),
        );
      },
    );
  }
}
