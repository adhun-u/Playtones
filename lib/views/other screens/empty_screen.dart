import 'package:flutter/material.dart';

class EmptyScreen extends StatelessWidget {
  final String text;
  const EmptyScreen({required this.text, super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(child: Image.asset(height: 100, 'icons/empty-box.png')),
          Center(
            child: Padding(
              padding: const EdgeInsets.only(top: 5),
              child: Text(
                text,
                style: TextStyle(
                  fontFamily: 'Font',
                  fontSize: textTheme.titleSmall!.fontSize,
                  color: Colors.grey[850],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
