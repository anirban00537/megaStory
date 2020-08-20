import 'package:flutter/material.dart';
import 'package:megaStory/screens/splashScreen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SplashScreen(),
      theme: ThemeData(
        // primaryColor: Colors.purple[800],
        primaryColor: Colors.white,
      ),
    );
  }
}
