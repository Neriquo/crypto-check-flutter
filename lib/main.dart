import 'package:flutter/material.dart';
import 'price_screen.dart';

// Point d'entrée principal de l'application
void main() => runApp(MyApp());

// Widget racine de l'application
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // Supprime la bannière "Debug" dans le coin supérieur droit
      debugShowCheckedModeBanner: false,

      // Titre de l'application (affiché dans le gestionnaire de tâches du système)
      title: 'Bitcoin Ticker',

      // Configuration du thème global de l'application
      theme: ThemeData.dark().copyWith(
        // Couleur principale utilisée dans l'application (notamment pour la barre d'app)
        primaryColor: Colors.blue,

        // Couleur de fond de l'écran principal
        scaffoldBackgroundColor: Color(0xFF1F2937), // Gris foncé bleuté

        // Schéma de couleurs pour les widgets interactifs et décoratifs
        colorScheme: ColorScheme.dark(
          primary: Colors.blue,       // Couleur principale (boutons, sélections)
          secondary: Colors.lightBlue, // Couleur d'accentuation (éléments secondaires)
        ),
      ),

      // Écran principal de l'application
      home: PriceScreen(),
    );
  }
}