import 'dart:io';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'coin_data.dart';

class PriceScreen extends StatefulWidget {
  @override
  _PriceScreenState createState() => _PriceScreenState();
}

class _PriceScreenState extends State<PriceScreen> {
  String selectedCurrency = 'USD';

  // stocke les prix récupérés pour chaque crypto
  Map<String, String> coinValues = {};

  // instance de la classe CoinData
  CoinData coinData = CoinData();

  @override
  void initState() {
    super.initState();
    getData();
  }

  // méthode pour récupérer les prix depuis l'API
  void getData() async {
    for (String crypto in cryptoList) {
      String rate = await coinData.getCoinData(crypto, selectedCurrency);
      setState(() {
        coinValues[crypto] = rate;
      });
    }
  }

  // menu déroulant de selection des devises
  DropdownButton<String> androidDropdown() {
    List<DropdownMenuItem<String>> dropdownItems = [];
    for (String currency in currenciesList) {
      dropdownItems.add(
        DropdownMenuItem(
          child: Text(
            currency,
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 20.0,
            ),
          ),
          value: currency,
        ),
      );
    }

    return DropdownButton<String>(
      dropdownColor: Colors.lightBlue, // rend le menu déroulant light blue
      style: TextStyle(
        // la couleur du texte selectionné rest noir
        color: Colors.black,
      ),
      value: selectedCurrency,
      items: dropdownItems,
      onChanged: (value) {
        setState(() {
          selectedCurrency = value!;
          getData(); // recharge les données lors du changement de devise
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    // génère une liste de widgets pour chaque crypto
    List<Widget> cryptoCards = [];
    for (String crypto in cryptoList) {
      cryptoCards.add(
        CryptoCard(
          cryptoCurrency: crypto,
          currencyValue: coinValues[crypto] ?? '?',
          selectedCurrency: selectedCurrency,
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Coin Ticker 💹',
          style: TextStyle(
              color: Colors.white, fontWeight: FontWeight.bold, fontSize: 25.0),
        ),
        backgroundColor: Colors.lightBlue.shade100,
        centerTitle: true,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: cryptoCards,
          ),
          Container(
            height: 150.0,
            alignment: Alignment.center,
            padding: EdgeInsets.only(bottom: 30.0),
            color: Colors.lightBlue.shade100,
            child: androidDropdown(),
          ),
        ],
      ),
    );
  }
}

// widget réutilisable affichant les cartes de cryptos
class CryptoCard extends StatelessWidget {
  CryptoCard(
      {required this.currencyValue,
      required this.selectedCurrency,
      required this.cryptoCurrency});

  final String currencyValue;
  final String selectedCurrency;
  final String cryptoCurrency;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 18.0),
      child: Card(
        color: Colors.lightBlueAccent,
        elevation: 5.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 28.0),
          child: Text(
            '1 $cryptoCurrency = $currencyValue $selectedCurrency',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 20.0,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}
