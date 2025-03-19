import 'dart:io';
import 'package:bitcoin_ticker/coin_data.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class PriceScreen extends StatefulWidget {
  @override
  _PriceScreenState createState() => _PriceScreenState();
}

class _PriceScreenState extends State<PriceScreen> {
  String? selectedCurrency = 'USD';
  Map<String, String> coinValues = {};
  bool isWaiting = false;

  // on envoit une requete API pour chaque crypto avec la devise choisie
  void getData() async {
    isWaiting = true;
    try {
      var data = await CoinData().getCoinData(selectedCurrency!);
      isWaiting = false;
      setState(() {
        coinValues = data;
      });
    } catch (e) {
      print(e);
      isWaiting = false;
    }
  }

  CupertinoPicker iOSPicker() {
    List<Text> pickerItems = [];

    for (String currency in currenciesList) {
      var newItem = Text(currency);
      pickerItems.add(newItem);
    }

    return CupertinoPicker(
      backgroundColor: Colors.black,
      itemExtent: 32,
      onSelectedItemChanged: (selectedIndex) {
        print(selectedIndex);
      },
      children: pickerItems,
    );
  }

  DropdownButton<String> androidDropdown() {
    List<DropdownMenuItem<String>> dropdownItems = [];

    for (String currency in currenciesList) {
      var newItem = DropdownMenuItem(
        child: Text(currency),
        value: currency,
      );
      dropdownItems.add(newItem);
    }

    return DropdownButton<String>(
      value: selectedCurrency,
      items: dropdownItems,
      onChanged: (value) {
        setState(() {
          selectedCurrency = value;
          getData();
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('💲Crypto Check💲'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Column(
            children: [
              // Pour chaque crypto, on affiche une bulle avec le logo, la crypto et sa veleur
              for (String crypto in cryptoList)
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 10.0,horizontal: 20.0),
                  child: Card(
                    color: Colors.white70,
                    elevation: 5.0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: ListTile(
                      leading: Image(
                        image: NetworkImage(imageUrl[cryptoList.indexOf(crypto)]),
                        fit: BoxFit.cover,
                        width: 35.0,
                        height: 35.0,
                      ),
                      title: Text(
                        // lors d'un appel API, on affiche un texte en attendant la réponse de l'API
                        isWaiting
                            ? '1 $crypto = Loading...'
                            : '1 $crypto = ${coinValues[crypto]} $selectedCurrency',
                        textAlign: TextAlign.left,
                        style: TextStyle(
                          fontSize: 18.0,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          ),
          Column(
            children: [
              Text(
                "Change the currency here.",
                style: TextStyle(
                  fontSize: 15.0,
                  color: Colors.white,
                ),
              ),
              Container(
                height: 100.0,
                alignment: Alignment.center,
                padding: EdgeInsets.only(bottom: 30.0),
                color: Colors.grey.shade900,
                child:
                    // si on est sur iOS, on affiche un picker, sinon on affiche un dropdown
                Platform.isIOS ? iOSPicker() : androidDropdown(),
              ),
            ],
          )
        ],
      ),
    );
  }
}