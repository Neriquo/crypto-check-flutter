import 'package:flutter/material.dart';
import 'price_screen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Coin Ticker',
      theme: ThemeData(
        primaryColor: Color(0xFF2962FF), // Material blue
        scaffoldBackgroundColor: Color(0xFFF5F5F7), // Light background
        colorScheme: ColorScheme.light(
          primary: Color(0xFF2962FF),
          secondary: Color(0xFF00B0FF),
          surface: Colors.white,
          background: Color(0xFFF5F5F7),
        ),
        appBarTheme: AppBarTheme(
          backgroundColor: Color(0xFF2962FF),
          elevation: 0,
          centerTitle: true,
        ),
        cardTheme: CardTheme(
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.0),
          ),
          shadowColor: Colors.black26,
        ),
        textTheme: TextTheme(
          bodyMedium: TextStyle(color: Color(0xFF424242)),
          titleLarge: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        fontFamily: 'Poppins',
      ),
      home: PriceScreen(),
    );
  }
}