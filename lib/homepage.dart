import 'dart:async';

import 'package:bubble_trouble_clone/ball.dart';
import 'package:bubble_trouble_clone/button.dart';
import 'package:bubble_trouble_clone/missile.dart';
import 'package:bubble_trouble_clone/player.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

enum Direction { left, right }

class _HomePageState extends State<HomePage> {
  // TODO:
  // 1. add button to restart game
  // 2. replace purple box with my choice
  // 3. Show Win window

  // map variables
  static const double leftMax = -1, rightMax = 1;

  // player variables
  double playerXPos = 0, playerXStride = 0.1;

  // missile variables
  static const double missileInitHeight = 10;
  double missileXPos = 0,
      missileYPos = 1,
      missileHeight = missileInitHeight,
      missileWidth = 2,
      missileYStride = 10;
  bool midShot = false;

  // ball variables
  double ballXPos = 0.5, ballYPos = 1, ballXStride = 0.005;
  Direction ballDirection = Direction.left;

  void startgame() {
    double time = 0;
    double height = 0;
    double velocity = 60; // how strong the jump is
    double acceleration = -5 * 2;

    Timer.periodic(
      const Duration(milliseconds: 10),
      (timer) {
        // h = v * t + 1/2 * a * t * t
        height = velocity * time + 1 / 2 * acceleration * time * time;

        // if the ball reaches the ground, reset the jump
        if (height < 0) {
          time = 0;
          height = 0;
        }

        setState(() {
          ballYPos = heightToAlignmentPos(height);
        });

        // Change ball direction when ball hit the wall
        if (ballXPos - ballXStride < leftMax) {
          ballDirection = Direction.right;
        } else if (ballXPos + ballXStride > rightMax) {
          ballDirection = Direction.left;
        }

        // Move the ball in the corresponding direction
        if (ballDirection == Direction.left) {
          setState(() {
            ballXPos -= ballXStride;
          });
        } else {
          setState(() {
            ballXPos += ballXStride;
          });
        }

        if (playerDies()) {
          timer.cancel();
          _showDialog();
        }

        time += 0.1;
      },
    );
  }

  void _showDialog() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            backgroundColor: Colors.grey[700],
            title: const Center(
              child: Text(
                "You dead bro",
                style: TextStyle(color: Colors.white),
              ),
            ),
          );
        });
  }

  void moveLeft() {
    setState(() {
      if (playerXPos - playerXStride >= leftMax) {
        playerXPos -= playerXStride;
        if (!midShot) {
          missileXPos = playerXPos;
        }
      }
    });
  }

  void moveRight() {
    setState(() {
      if (playerXPos + playerXStride <= rightMax) {
        playerXPos += playerXStride;
        if (!midShot) {
          missileXPos = playerXPos;
        }
      }
    });
  }

  void fireMissile() {
    if (midShot == false) {
      Timer.periodic(const Duration(milliseconds: 20), (timer) {
        midShot = true;
        // pink area is 3:1 to grey area
        if (missileHeight > MediaQuery.of(context).size.height * 3 / 4) {
          // stop missile
          resetMissile();
          timer.cancel();
        } else {
          setState(() {
            missileHeight += missileYStride;
          });
        }

        if (ballYPos > heightToAlignmentPos(missileHeight) &&
            (ballXPos - missileXPos).abs() < 0.03) {
          resetMissile();
          ballXPos = 5;
          timer.cancel();
        }
      });
    }
  }

  double heightToAlignmentPos(double height) {
    double totalHeight = MediaQuery.of(context).size.height * 3 / 4;
    double position = 1 - 2 * height / totalHeight;
    return position;
  }

  bool playerDies() {
    if ((ballXPos - playerXPos).abs() < 0.05 && ballYPos > 0.95) {
      return true;
    } else {
      return false;
    }
  }

  void resetMissile() {
    midShot = false;

    setState(() {
      missileXPos = playerXPos;
      missileHeight = missileInitHeight;
    });
  }

  @override
  Widget build(BuildContext context) {
    return RawKeyboardListener(
      focusNode: FocusNode(),
      autofocus: true,
      onKey: (RawKeyEvent event) {
        if (event.isKeyPressed(LogicalKeyboardKey.arrowLeft)) {
          moveLeft();
        } else if (event.isKeyPressed(LogicalKeyboardKey.arrowRight)) {
          moveRight();
        } else if (event.isKeyPressed(LogicalKeyboardKey.space)) {
          fireMissile();
        }
      },
      child: Column(
        children: [
          Expanded(
            flex: 3,
            child: Container(
              color: Colors.pink[100],
              child: Center(
                child: Stack(
                  children: [
                    MyBall(
                      ballXPos: ballXPos,
                      ballYPos: ballYPos,
                    ),
                    MyMissile(
                        missileXPos: missileXPos,
                        missileYPos: missileYPos,
                        missileWidth: missileWidth,
                        missileHeight: missileHeight),
                    MyPlayer(
                      playerXPos: playerXPos,
                    ),
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            child: Container(
              color: Colors.grey,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  MyButton(
                    icon: Icons.play_arrow,
                    tapHandler: startgame,
                  ),
                  MyButton(
                    icon: Icons.arrow_back,
                    tapHandler: moveLeft,
                  ),
                  MyButton(
                    icon: Icons.arrow_upward,
                    tapHandler: fireMissile,
                  ),
                  MyButton(
                    icon: Icons.arrow_forward,
                    tapHandler: moveRight,
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
