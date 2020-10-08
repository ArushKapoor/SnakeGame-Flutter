import 'package:flutter/material.dart';
import 'package:snake_game/Screens/HomePage.dart';
import 'package:snake_game/Screens/IntroPage.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      routes: {
        IntroPage.id: (context) => IntroPage(),
        HomePage.id: (context) => HomePage(),
      },
      initialRoute: IntroPage.id,
    );
  }
}
