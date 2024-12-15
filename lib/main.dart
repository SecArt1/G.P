import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:gp/startScreen.dart';
import 'package:gp/stillStart.dart';
import 'package:gp/LandingPage.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => SwipeState(),
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: StartScreen(),
    );
  }
}
