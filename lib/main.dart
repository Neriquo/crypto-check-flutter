import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'price_screen.dart';

void main() {
  // Configuration de base
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
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
        primaryColor: Colors.lightBlue.shade600,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.lightBlue.shade600,
          secondary: Colors.lightBlueAccent,
        ),
        scaffoldBackgroundColor: Colors.grey[100],
        fontFamily: 'Roboto',
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.lightBlue.shade600,
          elevation: 0,
          systemOverlayStyle: SystemUiOverlayStyle.light,
        ),
      ),
      home: PriceScreen(),
    );
  }
}