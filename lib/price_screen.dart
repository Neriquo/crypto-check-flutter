import 'dart:io';
import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'coin_data.dart';

class PriceScreen extends StatefulWidget {
  @override
  _PriceScreenState createState() => _PriceScreenState();
}

class _PriceScreenState extends State<PriceScreen> {
  String? selectedCurrency = 'USD';
  Map<String, String> cryptoRates = {
    'BTC': '?',
    'ETH': '?',
    'LTC': '?',
  };

  final String apiKey = '8cbb330c-19dc-4007-b632-b7edb84a46df';

  // Fonction pour récupérer les taux des cryptomonnaies
  Future<void> getCryptoRates() async {
    Map<String, String> rates = {};
    for (String crypto in cryptoList) {
      String url =
          'https://rest.coinapi.io/v1/exchangerate/$crypto/$selectedCurrency?apikey=$apiKey';
      try {
        http.Response response = await http.get(Uri.parse(url));
        if (response.statusCode == 200) {
          var decodedData = jsonDecode(response.body);
          double rate = decodedData['rate'];
          rates[crypto] = rate.toStringAsFixed(2); // Formate à deux décimales
        } else {
          rates[crypto] = 'Erreur : ${response.statusCode}';
        }
      } catch (e) {
        rates[crypto] = 'Erreur réseau';
      }
    }
    setState(() {
      cryptoRates = rates;
    });
  }

  @override
  void initState() {
    super.initState();
    getCryptoRates(); // Récupère les données au démarrage
  }

  CupertinoPicker iOSPicker() {
    List<Text> pickerItems = [];
    for (String currency in currenciesList) {
      pickerItems.add(Text(currency));
    }

    return CupertinoPicker(
      backgroundColor: Colors.lightBlue,
      itemExtent: 32,
      onSelectedItemChanged: (selectedIndex) {
        setState(() {
          selectedCurrency = currenciesList[selectedIndex];
        });
        getCryptoRates(); // Met à jour les données après sélection
      },
      children: pickerItems,
    );
  }

  DropdownButton<String> androidDropdown() {
    List<DropdownMenuItem<String>> dropdownItems = [];
    for (String currency in currenciesList) {
      dropdownItems.add(DropdownMenuItem(
        child: Text(currency),
        value: currency,
      ));
    }

    return DropdownButton<String>(
      value: selectedCurrency,
      items: dropdownItems,
      onChanged: (value) {
        setState(() {
          selectedCurrency = value;
        });
        getCryptoRates(); // Met à jour les données après sélection
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Bitcoin Check'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Column(
            children: cryptoList.map((crypto) {
              return Padding(
                padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 18.0),
                child: Card(
                  color: Colors.lightBlueAccent,
                  elevation: 5.0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: Padding(
                    padding:
                        EdgeInsets.symmetric(vertical: 15.0, horizontal: 28.0),
                    child: Text(
                      '1 $crypto = ${cryptoRates[crypto]} $selectedCurrency',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 20.0,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              );
            }).toList(),
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
