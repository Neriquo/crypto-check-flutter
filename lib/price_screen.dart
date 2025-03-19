import 'dart:io';

import 'package:bitcoin_ticker/coin_data.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:async';

class PriceScreen extends StatefulWidget {
  @override
  _PriceScreenState createState() => _PriceScreenState();
}

class _PriceScreenState extends State<PriceScreen> with SingleTickerProviderStateMixin {
  String selectedCurrency = 'USD';
  Map<String, double?> coinValues = {};
  bool isLoading = false;

  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;

  /// Initialise l'état du widget et lance le chargement des données
  /// Configure les animations de transition pour les cartes de crypto
  @override
  void initState() {
    super.initState();

    _fadeController = AnimationController(
      duration: Duration(milliseconds: 500),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.3, end: 1.0).animate(
      CurvedAnimation(
        parent: _fadeController,
        curve: Curves.easeIn,
      ),
    );

    getData();
  }

  /// Libère les ressources utilisées par les contrôleurs d'animation
  /// Appelé automatiquement lorsque le widget est retiré de l'arbre
  @override
  void dispose() {
    _fadeController.dispose();
    super.dispose();
  }

  /// Récupère les taux de change des cryptomonnaies via l'API
  /// Met à jour l'état avec les nouvelles valeurs et gère l'animation
  /// de transition entre les différents états
  void getData() async {
    _fadeController.reset();

    setState(() {
      isLoading = true;
    });

    try {
      var data = await CoinData().getAllCoinPrices(selectedCurrency);

      setState(() {
        coinValues = data;
        isLoading = false;
      });

      _fadeController.forward();
    } catch (e) {
      print(e);
      setState(() {
        isLoading = false;
      });

      _fadeController.forward();
    }
  }

  /// Crée un sélecteur de devise de style iOS (CupertinoPicker)
  /// Permet à l'utilisateur de choisir la devise de référence pour
  /// l'affichage des taux de cryptomonnaies
  Widget iOSPicker() {
    List<Widget> pickerItems = [];

    for (String currency in currenciesList) {
      var newItem = Text(
        currency,
        style: TextStyle(
          color: Colors.black87,
          fontSize: 20.0,
          fontWeight: FontWeight.w600,
        ),
      );
      pickerItems.add(newItem);
    }

    int initialItem = currenciesList.indexOf(selectedCurrency);
    if (initialItem < 0) initialItem = 0;

    return Container(
      height: 120,
      child: CupertinoPicker(
        backgroundColor: Colors.transparent,
        itemExtent: 45.0,
        magnification: 1.2,
        diameterRatio: 1.1,
        selectionOverlay: Container(
          decoration: BoxDecoration(
            border: Border(
              top: BorderSide(color: Colors.blue.shade300, width: 1.0),
              bottom: BorderSide(color: Colors.blue.shade300, width: 1.0),
            ),
          ),
        ),
        looping: true,
        scrollController: FixedExtentScrollController(initialItem: initialItem),
        onSelectedItemChanged: (selectedIndex) {
          setState(() {
            selectedCurrency = currenciesList[selectedIndex];
            getData();
          });
        },
        children: pickerItems,
      ),
    );
  }

  /// Génère une liste de cartes pour chaque cryptomonnaie
  /// Chaque carte affiche le symbole, l'icône et le taux de change actuel
  /// Les couleurs sont personnalisées en fonction de la cryptomonnaie
  List<Widget> getCryptoCards() {
    List<Widget> cryptoCards = [];

    Map<String, Color> cryptoColors = {
      'BTC': Color(0xFFF7931A), // Bitcoin Orange
      'ETH': Color(0xFF627EEA), // Ethereum Blue
      'LTC': Color(0xFF345D9D), // Litecoin Blue
    };

    Map<String, IconData> cryptoIcons = {
      'BTC': Icons.currency_bitcoin,
      'ETH': Icons.diamond,
      'LTC': Icons.monetization_on,
    };

    for (String crypto in cryptoList) {
      final color = cryptoColors[crypto] ?? Colors.blueAccent;

      cryptoCards.add(
        FadeTransition(
          opacity: _fadeAnimation,
          child: Padding(
            padding: EdgeInsets.fromLTRB(18.0, 18.0, 18.0, 0),
            child: Card(
              elevation: 4.0,
              shadowColor: color.withOpacity(0.3),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0),
                side: BorderSide(
                  color: color.withOpacity(0.3),
                  width: 1,
                ),
              ),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15.0),
                  color: Colors.white,
                ),
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 28.0),
                  child: Row(
                    children: [
                      Container(
                        padding: EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: color.withOpacity(0.1),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          cryptoIcons[crypto] ?? Icons.currency_exchange,
                          color: color,
                          size: 30,
                        ),
                      ),
                      SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              crypto,
                              style: TextStyle(
                                fontSize: 18.0,
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                              ),
                            ),
                            SizedBox(height: 4),
                            Text(
                              isLoading
                                  ? 'Chargement...'
                                  : '${coinValues[crypto]?.toStringAsFixed(2) ?? '?'} $selectedCurrency',
                              style: TextStyle(
                                fontSize: 24.0,
                                fontWeight: FontWeight.bold,
                                color: color,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      );
    }

    return cryptoCards;
  }

  /// Construit l'interface utilisateur principale
  /// Organise les cartes de cryptomonnaies et le sélecteur de devise
  /// dans une mise en page cohérente
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Crypto Check',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            letterSpacing: 0.5,
          ),
        ),
        elevation: 0,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: getCryptoCards(),
          ),
          Container(
            height: 150.0,
            alignment: Alignment.center,
            padding: EdgeInsets.only(bottom: 30.0),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.1),
                  spreadRadius: 1,
                  blurRadius: 5,
                  offset: Offset(0, -3),
                ),
              ],
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
            ),
            child: iOSPicker(),
          ),
        ],
      ),
    );
  }
}