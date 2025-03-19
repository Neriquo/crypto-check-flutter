import 'dart:io';
import 'package:bitcoin_ticker/coin_data.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class PriceScreen extends StatefulWidget {
  @override
  _PriceScreenState createState() => _PriceScreenState();
}

class _PriceScreenState extends State<PriceScreen> {
  String selectedCurrency = 'USD';
  bool isLoading = false;
  Map<String, double> cryptoRates = {};
  double opacity = 0.8;

  @override
  void initState() {
    super.initState();
    getCryptoData();

    // Effet de pulsation simple sans AnimationController
    Future.delayed(Duration(milliseconds: 800), () {
      if (mounted) {
        pulseEffect();
      }
    });
  }

  // Fonction simple pour créer un effet de pulsation sans controller
  void pulseEffect() {
    if (!mounted) return;

    setState(() {
      opacity = opacity == 0.8 ? 1.0 : 0.8;
    });

    Future.delayed(Duration(milliseconds: 800), () {
      if (mounted) {
        pulseEffect();
      }
    });
  }

  void getCryptoData() async {
    setState(() {
      isLoading = true;
    });

    try {
      CoinData coinData = CoinData();
      var rates = await coinData.getAllCryptoRates(selectedCurrency);

      setState(() {
        cryptoRates = rates;
        isLoading = false;
      });
    } catch (e) {
      print(e);
      setState(() {
        isLoading = false;
      });

      // Message d'erreur simple
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erreur de connexion à l\'API: $e'),
          backgroundColor: Colors.redAccent,
          duration: Duration(seconds: 3),
        ),
      );
    }
  }

  CupertinoPicker iOSPicker() {
    List<Text> pickerItems = [];

    for (String currency in currenciesList) {
      pickerItems.add(Text(
        currency,
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ));
    }

    return CupertinoPicker(
      backgroundColor: Colors.lightBlue.shade600,
      itemExtent: 32,
      onSelectedItemChanged: (selectedIndex) {
        setState(() {
          selectedCurrency = currenciesList[selectedIndex];
          getCryptoData();
        });
      },
      children: pickerItems,
    );
  }

  DropdownButton<String> androidDropdown() {
    List<DropdownMenuItem<String>> dropdownItems = [];

    for (String currency in currenciesList) {
      dropdownItems.add(DropdownMenuItem(
        child: Text(
          currency,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        value: currency,
      ));
    }

    return DropdownButton<String>(
      value: selectedCurrency,
      items: dropdownItems,
      dropdownColor: Colors.lightBlue.shade600,
      elevation: 8,
      icon: Icon(Icons.arrow_drop_down, color: Colors.white),
      underline: Container(
        height: 2,
        color: Colors.white,
      ),
      onChanged: (value) {
        setState(() {
          selectedCurrency = value!;
          getCryptoData();
        });
      },
    );
  }

  Widget getLoadingCard(String crypto) {
    return Opacity(
      opacity: opacity,
      child: Card(
        color: Colors.lightBlueAccent,
        elevation: 5.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 25.0, horizontal: 28.0),
          child: Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  '1 $crypto = ',
                  style: TextStyle(
                    fontSize: 20.0,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(width: 8),
                Container(
                  width: 100,
                  height: 20,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                SizedBox(width: 8),
                Text(
                  selectedCurrency,
                  style: TextStyle(
                    fontSize: 20.0,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget getCryptoCard(String crypto, double? rate) {
    // Couleurs et icônes différentes selon la cryptomonnaie
    Color cardColor;
    IconData cryptoIcon;

    if (crypto == 'BTC') {
      cardColor = Colors.amber.shade700;
      cryptoIcon = Icons.currency_bitcoin;
    } else if (crypto == 'ETH') {
      cardColor = Colors.purple.shade600;
      cryptoIcon = Icons.diamond_outlined;
    } else if (crypto == 'LTC') {
      cardColor = Colors.blueGrey.shade600;
      cryptoIcon = Icons.attach_money;
    } else {
      cardColor = Colors.lightBlueAccent;
      cryptoIcon = Icons.money;
    }

    return Card(
      color: cardColor,
      elevation: 8.0,
      shadowColor: cardColor.withOpacity(0.5),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 25.0, horizontal: 20.0),
        child: Row(
          children: [
            Icon(
              cryptoIcon,
              color: Colors.white,
              size: 36,
            ),
            SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    crypto,
                    style: TextStyle(
                      fontSize: 16.0,
                      color: Colors.white.withOpacity(0.9),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(height: 6),
                  Row(
                    children: [
                      Text(
                        '1 = ',
                        style: TextStyle(
                          fontSize: 22.0,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        '${rate?.toStringAsFixed(2) ?? '?'} $selectedCurrency',
                        style: TextStyle(
                          fontSize: 22.0,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> getCryptoCards() {
    List<Widget> cryptoCards = [];

    for (String crypto in cryptoList) {
      cryptoCards.add(
        Padding(
          padding: EdgeInsets.fromLTRB(18.0, 18.0, 18.0, 0),
          child: isLoading
              ? getLoadingCard(crypto)
              : getCryptoCard(crypto, cryptoRates[crypto]),
        ),
      );
    }

    return cryptoCards;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: Text(
          'Crypto Market',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            letterSpacing: 1.0,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.lightBlue.shade600,
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: getCryptoData,
            tooltip: 'Rafraîchir',
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            // En-tête simplifié
            Container(
              color: Colors.lightBlue.shade600,
              padding: EdgeInsets.only(bottom: 20, left: 20, right: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Cours actuels',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.white.withOpacity(0.85),
                      fontWeight: FontWeight.w700,F
                    ),
                  ),
                  SizedBox(height: 5),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Devise: $selectedCurrency',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          children: [
                            Icon(Icons.access_time, color: Colors.white, size: 16),
                            SizedBox(width: 4),
                            Text(
                              'Live',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Liste de cryptomonnaies
            Expanded(
              child: ListView(
                padding: EdgeInsets.only(top: 10),
                children: getCryptoCards(),
              ),
            ),

            // Sélecteur de devise simplifié
            Container(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              decoration: BoxDecoration(
                color: Colors.lightBlue.shade600,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 5,
                    spreadRadius: 0,
                    offset: Offset(0, -1),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 10, bottom: 8),
                    child: Text(
                      'Choisir une devise :',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                        fontSize: 20,
                      ),
                    ),
                  ),
                  Container(
                    height: 80.0,
                    alignment: Alignment.center,
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    child: Platform.isIOS ? iOSPicker() : androidDropdown(),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}