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
  Map<String, String> cryptoRates = {};

  @override
  void initState() {
    super.initState();
    updateRates();
  }

  void updateRates() async {
    try {
      var rates = await CoinData().getAllCryptoData(selectedCurrency);
      setState(() {
        cryptoRates = {};
        for (var crypto in cryptoList) {
          double rate = rates[crypto] ?? 0.0;
          cryptoRates[crypto] = rate.toStringAsFixed(2);
        }
      });
    } catch (e) {
      print('Erreur de chargement des données : $e');
    }
  }

  CupertinoPicker iOSPicker() {
    List<Text> pickerItems = currenciesList.map((c) => Text(c)).toList();

    return CupertinoPicker(
      backgroundColor: Colors.lightBlue,
      itemExtent: 32,
      onSelectedItemChanged: (selectedIndex) {
        setState(() {
          selectedCurrency = currenciesList[selectedIndex];
        });
        updateRates();
      },
      children: pickerItems,
    );
  }

  DropdownButton<String> androidDropdown() {
    List<DropdownMenuItem<String>> dropdownItems = currenciesList
        .map((c) => DropdownMenuItem(value: c, child: Text(c)))
        .toList();

    return DropdownButton<String>(
      value: selectedCurrency,
      items: dropdownItems,
      onChanged: (value) {
        setState(() {
          selectedCurrency = value!;
        });
        updateRates();
      },
    );
  }

  List<Widget> getCryptoCards() {
    List<Widget> cards = [];

    for (String crypto in cryptoList) {
      String rate = cryptoRates[crypto] ?? '?';

      cards.add(
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18.0, vertical: 6.0),
          child: Card(
            color: Colors.lightBlueAccent,
            elevation: 5.0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15.0),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 28.0),
              child: Text(
                '1 $crypto = $rate $selectedCurrency',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ),
      );

    }

    return cards;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Crypto Check'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Expanded(
            child: ListView(
              children: getCryptoCards(),
            ),
          ),
          Container(
            height: 150.0,
            alignment: Alignment.center,
            padding: EdgeInsets.only(bottom: 30.0),
            color: Colors.lightBlue,
            child: Platform.isIOS ? iOSPicker() : androidDropdown(),
          ),
        ],
      ),
    );
  }
}
