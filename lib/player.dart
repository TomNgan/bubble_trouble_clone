import 'package:flutter/material.dart';

class MyPlayer extends StatelessWidget {
  const MyPlayer({Key? key, required this.playerXPos}) : super(key: key);

  static const double bottomMax = 1;
  static const double roundRadius = 10;
  static const double playerHeight = 50;
  static const double playerWidth = 50;

  final double playerXPos;

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment(playerXPos, bottomMax),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(roundRadius),
        child: Container(
          color: Colors.deepPurple,
          height: playerHeight,
          width: playerWidth,
        ),
      ),
    );
  }
}
