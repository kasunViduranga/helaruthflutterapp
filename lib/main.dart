import 'package:flutter/material.dart';
import 'package:helaruth/pages/splash_screen.dart';

void main() {
  runApp(const HelaruthApp());
}

class HelaruthApp extends StatelessWidget {
  const HelaruthApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'හෙලරුත්',
      theme: ThemeData(
        primaryColor: const Color(0xFF4286F5),
        scaffoldBackgroundColor: Colors.white,
        fontFamily: 'IskoolaPota',
      ),
      home: const SplashScreen(),
    );
  }
}