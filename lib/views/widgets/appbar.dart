import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';
import 'package:playtones/views/search%20screen/search_screen.dart';

class CustomAppBar extends StatelessWidget {
  const CustomAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final size = MediaQuery.of(context).size;
    return AppBar(
      toolbarHeight: size.height * 0.1,
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Playtones',
            style: TextStyle(
              fontSize: Theme.of(context).textTheme.titleLarge!.fontSize,
              fontFamily: 'Font',
              color: Colors.white,
            ),
          ),
          IconButton(
            onPressed: () {
              PersistentNavBarNavigator.pushNewScreen(
                context,
                withNavBar: true,
                screen: SearchScreen(),
                pageTransitionAnimation: PageTransitionAnimation.cupertino,
              );
            },
            iconSize: 30,
            icon: Icon(
              Icons.search_outlined,
              color: textTheme.titleSmall!.color,
            ),
          ),
        ],
      ),
    );
  }
}
