import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'price_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(
    SystemUiOverlayStyle(
      statusBarColor: Colors.transparent, // Barre d'état transparente
      statusBarIconBrightness: Brightness.light, // Icônes claires dans la barre d'état
    ),
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Coin Ticker',
      theme: ThemeData(
        primaryColor: Color(0xFF1A237E),
        colorScheme: ColorScheme.fromSwatch().copyWith(
          secondary: Color(0xFF0D47A1),
          primary: Color(0xFF1A237E),
        ),
        scaffoldBackgroundColor: Colors.white,
        fontFamily: 'Poppins',
        textTheme: TextTheme(
          titleLarge: TextStyle(  // Remplace headline6
            fontWeight: FontWeight.w600,
            fontSize: 20.0,
          ),
          bodyMedium: TextStyle(  // Remplace bodyText2
            fontSize: 14.0,
          ),
        ),
        appBarTheme: AppBarTheme(
          elevation: 0,
          backgroundColor: Colors.transparent,
        ),
      ),
      home: PriceScreen(),
    );
  }
}