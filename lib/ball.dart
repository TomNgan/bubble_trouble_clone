import 'package:flutter/material.dart';

class MyBall extends StatelessWidget {
  const MyBall({Key? key, required this.ballXPos, required this.ballYPos})
      : super(key: key);

  final double ballXPos, ballYPos;

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment(ballXPos, ballYPos),
      child: Container(
          width: 20,
          height: 20,
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.brown,
          )),
    );
  }
}
