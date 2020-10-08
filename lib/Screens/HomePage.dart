import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  static const String id = 'home_page';
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<int> snakePosition = [45, 65, 85, 105, 125];

  static Random random = new Random();
  int food = 113;
  int numberOfSquares;
  static int totalSquares;

  var boxColor;

  String direction = 'down';

  void generateNewFood() {
    setState(() {
      food = random.nextInt(totalSquares + 1);
    });
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

  void startGame() {
    snakePosition = [45, 65, 85, 105, 125];
    const duration = const Duration(milliseconds: 300);
    Timer.periodic(duration, (Timer timer) {
      updateSnake();
    });
  }

  @override
  Widget build(BuildContext context) {
    final _height = MediaQuery.of(context).size.height;
    final _width = MediaQuery.of(context).size.width;
    // print((_width * 0.065).toInt());

    // total number of squares in each row
    numberOfSquares = (_width * 0.065).toInt();

    // total number of squares to be displayed
    totalSquares = 580;

    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Column(
          children: <Widget>[
            Expanded(
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

                    return GestureDetector(
                      onHorizontalDragUpdate: (details) {
                        if (direction != 'left' && details.delta.dx > 0) {
                          direction = 'right';
                        } else if (direction != 'right' &&
                            details.delta.dx < 0) {
                          direction = 'left';
                        }
                      },
                      onVerticalDragUpdate: (details) {
                        if (direction != 'up' && details.delta.dy > 0) {
                          direction = 'down';
                        } else if (direction != 'down' &&
                            details.delta.dy < 0) {
                          direction = 'up';
                        }
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(2.0),
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius:
                                BorderRadius.all(Radius.circular(3.5)),
                            color: boxColor,
                          ),
                        ),
                      ),
                    );
                  }),
            ),
            Padding(
              padding: const EdgeInsets.only(
                  left: 10.0, top: 20.0, right: 10.0, bottom: 10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  GestureDetector(
                    onTap: startGame,
                    child: Container(
                      child: Text(
                        'Start',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                  Container(
                    child: Text(
                      '@CreatedByArush',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
