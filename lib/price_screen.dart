import 'dart:io';
import 'dart:convert';
import 'package:bitcoin_ticker/coin_data.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class PriceScreen extends StatefulWidget {
  @override
  _PriceScreenState createState() => _PriceScreenState();
}

class _PriceScreenState extends State<PriceScreen> {
  String? selectedCurrency = 'USD';
  String bitcoinValue =
      '?'; //Initialisation du parametre de conversion lors du lancement de l'application

  //Ici la méthode pour récupérer les données de l'API
  Future<void> getBitcoinRate() async {
    final url =
        'https://rest.coinapi.io/v1/exchangerate/BTC/$selectedCurrency?apikey=6515abc3-eefa-47a1-a408-c0fefa09bfe3';

    try {
      http.Response response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        var decodedData = jsonDecode(response
            .body); //L'api émet une réponse en json, on va devoir donc le décoder pour recuperer seulement la valeur qui nous faut à savoir le 'rate'
        setState(() {
          bitcoinValue = decodedData['rate']
              .toString(); //Recuperer ici le taux de conversion émi par le json dans la variable
        });
      } else {
        setState(() {
          bitcoinValue =
              'Erreur : ${response.statusCode}'; //try catch ici pour gérer les erreurs si la recuération de la valeur a echoué
        });
      }
    } catch (e) {
      setState(() {
        bitcoinValue = 'Erreur lors de la conversion';
      });
    }
  }

  @override
  void initState() {
    super.initState();
    getBitcoinRate(); //J'appelle ici l'api afin de récuperer la réponse traduite
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
        getBitcoinRate(); // Mise à jour du prix après changement
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
        getBitcoinRate(); // Mise à jour du prix après changement
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Bitcoin check'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.fromLTRB(18.0, 18.0, 18.0, 0),
            child: Card(
              color: Colors.lightBlueAccent,
              elevation: 5.0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 28.0),
                child: Text(
                  '1 BTC = $bitcoinValue $selectedCurrency', //Affiche dynamiquement le message en fonction de la valeur et de la monnaie choisie
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 20.0,
                    color: Colors.white,
                  ),
                ),
              ),
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
