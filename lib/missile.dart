import 'package:flutter/material.dart';

class MyMissile extends StatelessWidget {
  const MyMissile(
      {Key? key,
      required this.missileXPos,
      required this.missileYPos,
      required this.missileWidth,
      required this.missileHeight})
      : super(key: key);

  final double missileXPos, missileYPos, missileWidth, missileHeight;

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment(missileXPos, missileYPos),
      child: Container(
        width: missileWidth,
        height: missileHeight,
        color: Colors.grey,
      ),
    );
  }
}
