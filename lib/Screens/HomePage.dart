import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  static const String id = 'home_page';
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  static List<int> snakePosition = [45, 65, 85, 105, 125];

  static Random random = new Random();
  static int food = 113;
  int numberOfSquares;
  static int totalSquares;

  var boxColor;

  String direction = 'down';

  bool hasGameStarted = false;
  Timer timer;

  void generateNewFood() {
    setState(() {
      food = random.nextInt(totalSquares + 1);
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    timer.cancel();
    super.dispose();
  }

  void updateSnake() {
    setState(() {
      switch (direction) {
        case 'down':
          if (snakePosition.last + 20 > totalSquares) {
            snakePosition.add(snakePosition.last + 20 - totalSquares);
          } else {
            snakePosition.add(snakePosition.last + 20);
          }
          break;
        case 'up':
          if (snakePosition.last - 20 < 0) {
            snakePosition.add(snakePosition.last - 20 + totalSquares);
          } else {
            snakePosition.add(snakePosition.last - 20);
          }
          break;
        case 'left':
          if (snakePosition.last % 20 == 0) {
            snakePosition.add(snakePosition.last - 1 + 20);
          } else {
            snakePosition.add(snakePosition.last - 1);
          }
          break;
        case 'right':
          if ((snakePosition.last + 1) % 20 == 0) {
            snakePosition.add(snakePosition.last + 1 - 20);
          } else {
            snakePosition.add(snakePosition.last + 1);
          }
      }
      if (snakePosition.last == food) {
        generateNewFood();
      } else {
        snakePosition.removeAt(0);
      }
    });
  }

  bool gameOver() {
    for (int i = 0; i < snakePosition.length - 1; i++) {
      for (int j = i + 1; j < snakePosition.length; j++) {
        if (snakePosition[i] == snakePosition[j]) {
          return true;
        }
      }
    }
    return false;
  }

  void showGameOverDialog() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Game Over'),
            actions: <Widget>[
              FlatButton(
                child: Text('Play Again'),
                onPressed: () {
                  startGame();
                  Navigator.of(context).pop();
                },
              )
            ],
          );
        });
  }

  void startGame() {
    snakePosition = [45, 65, 85, 105, 125];
    food = 113;
    const duration = const Duration(milliseconds: 300);
    Timer.periodic(duration, (Timer timer) {
      this.timer = timer;
      updateSnake();
      if (gameOver()) {
        timer.cancel();
        showGameOverDialog();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final _height = MediaQuery.of(context).size.height;
    // print(MediaQuery.of(context).devicePixelRatio);
    final _width = MediaQuery.of(context).size.width;
    // print((_width * 0.065).toInt());

    // total number of squares in each row
    numberOfSquares = 20;

    // total number of squares to be displayed
    totalSquares = 580;

    if (!hasGameStarted) {
      startGame();
      hasGameStarted = true;
    }

    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Column(
          children: <Widget>[
            Expanded(
              child: GestureDetector(
                onHorizontalDragUpdate: (details) {
                  if (direction != 'left' && details.delta.dx > 0) {
                    direction = 'right';
                  } else if (direction != 'right' && details.delta.dx < 0) {
                    direction = 'left';
                  }
                },
                onVerticalDragUpdate: (details) {
                  if (direction != 'up' && details.delta.dy > 0) {
                    direction = 'down';
                  } else if (direction != 'down' && details.delta.dy < 0) {
                    direction = 'up';
                  }
                },
                child: GridView.builder(
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: totalSquares,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: numberOfSquares),
                    itemBuilder: (BuildContext context, int index) {
                      if (snakePosition.contains(index)) {
                        boxColor = Colors.white;
                      } else if (food == index) {
                        boxColor = Colors.green[400];
                      } else {
                        boxColor = Colors.grey[900];
                      }

                      return Padding(
                        padding: const EdgeInsets.all(2.0),
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius:
                                BorderRadius.all(Radius.circular(3.5)),
                            color: boxColor,
                          ),
                        ),
                      );
                    }),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
