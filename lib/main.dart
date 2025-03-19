import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'price_screen.dart';

void main() {
  // Configure l'apparence de la barre de statut
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarIconBrightness: Brightness.dark,
  ));

  // Force l'orientation portrait pour une expérience mobile optimale
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Crypto Tracker',
      theme: ThemeData(
        primaryColor: Color(0xFF1A73E8),
        scaffoldBackgroundColor: Color(0xFFF8F9FF),
        fontFamily: 'Poppins',
        appBarTheme: AppBarTheme(
          centerTitle: true,
          systemOverlayStyle: SystemUiOverlayStyle.light,
        ),
        textTheme: TextTheme(
          bodyMedium: TextStyle(color: Color(0xFF424242)),
        ),
      ),
      home: PriceScreen(),
    );
  }
}