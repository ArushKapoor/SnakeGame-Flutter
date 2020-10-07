import 'dart:async';

import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  static const String id = 'home_page';
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    final _height = MediaQuery.of(context).size.height;
    final _width = MediaQuery.of(context).size.width;
    print((_width * 0.065).toInt());

    // total number of squares in each row
    int numberOfSquares = (_width * 0.065).toInt();

    // total number of rows to be displayed
    int numberOfRows = 580;

    List<int> snakePosition = [45, 65, 85, 105, 125];

    int food = 113;

    var boxColor;

    String direction = 'down';
    void _updateSnake() {
      setState(() {
        switch (direction) {
          case 'down':
            if (snakePosition.last + 20 > numberOfRows) {
              snakePosition.add(snakePosition.last + 20 - numberOfRows);
            } else {
              snakePosition.add(snakePosition.last + 20);
            }
            break;
        }
        snakePosition.removeAt(0);
      });
    }

    void _startGame() {
      snakePosition = [45, 65, 85, 105, 125];
      const duration = const Duration(milliseconds: 300);
      Timer.periodic(duration, (Timer timer) {
        _updateSnake();
      });
    }

    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Column(
          children: <Widget>[
            Expanded(
              child: GridView.builder(
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: numberOfRows,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: numberOfSquares),
                  itemBuilder: (BuildContext context, int index) {
                    // if (snakePosition.contains(index)) {
                    //   boxColor = Colors.white;
                    // } else if (food == index) {
                    //   boxColor = Colors.green[400];
                    // } else {
                    //   boxColor = Colors.grey[900];
                    // }

                    if (snakePosition.contains(index))
                      return Padding(
                        padding: const EdgeInsets.all(2.0),
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius:
                                BorderRadius.all(Radius.circular(3.5)),
                            color: Colors.white,
                          ),
                        ),
                      );
                    else if (food == index)
                      return Padding(
                        padding: const EdgeInsets.all(2.0),
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius:
                                BorderRadius.all(Radius.circular(3.5)),
                            color: Colors.green[400],
                          ),
                        ),
                      );
                    else
                      return Padding(
                        padding: const EdgeInsets.all(2.0),
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius:
                                BorderRadius.all(Radius.circular(3.5)),
                            color: Colors.grey[900],
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
                    onTap: _startGame,
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
