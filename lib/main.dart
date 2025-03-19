import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'price_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  // Configure l'apparence de la barre de statut
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarIconBrightness: Brightness.dark,
    systemNavigationBarColor: Colors.white,
    systemNavigationBarIconBrightness: Brightness.dark,
  ));

  // Force l'orientation portrait pour une expérience mobile optimale
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]).then((_) {
    runApp(MyApp());
  });
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'CryptoTracker',
      theme: ThemeData(
        primaryColor: Color(0xFF1A73E8),
        colorScheme: ColorScheme.light(
          primary: Color(0xFF1A73E8),
          secondary: Color(0xFF5BB974),
          surface: Colors.white,
          background: Color(0xFFF8FAFF),
        ),
        scaffoldBackgroundColor: Color(0xFFF8FAFF),
        fontFamily: 'Poppins',
        appBarTheme: AppBarTheme(
          centerTitle: true,
          elevation: 0,
          systemOverlayStyle: SystemUiOverlayStyle.light,
          backgroundColor: Colors.white,
          iconTheme: IconThemeData(
            color: Color(0xFF1A73E8),
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
        cardTheme: CardTheme(
          elevation: 5,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        textTheme: TextTheme(
          titleLarge: TextStyle(
            fontWeight: FontWeight.bold,
            color: Color(0xFF1A73E8),
          ),
          bodyMedium: TextStyle(
            color: Color(0xFF424242),
          ),
        ),
      ),
      home: PriceScreen(),
    );
  }
}