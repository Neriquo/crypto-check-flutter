import 'package:flutter/material.dart';
import 'price_screen.dart';
import 'package:flutter/cupertino.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Bitcoin Ticker',
      theme: ThemeData(
        primarySwatch: Colors.blueGrey,
        scaffoldBackgroundColor: Colors.grey[200],
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.blueGrey[700],
          titleTextStyle: TextStyle(
            color: Colors.white,
            fontSize: 22.0,
            fontWeight: FontWeight.bold,
          ),
          iconTheme: IconThemeData(color: Colors.white),
        ),
        cardTheme: CardTheme(
          elevation: 4.0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.0),
          ),
          color: Colors.white,
          shadowColor: Colors.grey[400],
        ),
        textTheme: TextTheme(
          bodyLarge: TextStyle(fontSize: 20.0, color: Colors.blueGrey[800]),
          bodyMedium: TextStyle(fontSize: 18.0, color: Colors.blueGrey[700]),
          titleLarge: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold, color: Colors.blueGrey[900]),
        ),
        cupertinoOverrideTheme: CupertinoThemeData(
          primaryColor: Colors.blueGrey,
        ),
      ),
      home: PriceScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}