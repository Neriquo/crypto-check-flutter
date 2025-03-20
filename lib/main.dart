import 'package:flutter/material.dart';
import 'price_screen.dart';

// Point d'entrée de l'application
void main() => runApp(MyApp());

// Widget racine de l'application
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.dark().copyWith(
        primaryColor: Colors.lightBlue,
        scaffoldBackgroundColor: Colors.white,
      ),
      home: PriceScreen(),
    );
  }
}