import 'package:flutter/material.dart';
import 'screens/splash_screen.dart';

void main() {
  runApp(const RecipeReciveApp());
}

class RecipeReciveApp extends StatelessWidget {
  const RecipeReciveApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'RecipeRecive',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF9C27B0),
        ),
        fontFamily: 'Roboto',
      ),
      home: const SplashScreen(),
    );
  }
}