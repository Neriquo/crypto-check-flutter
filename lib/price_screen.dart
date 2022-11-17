import 'package:bitcoin_ticker/coin_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:bitcoin_ticker/services/networking.dart';
import 'package:bitcoin_ticker/reusable_card.dart';
import 'dart:io' show Platform;

class PriceScreen extends StatefulWidget {
  @override
  _PriceScreenState createState() => _PriceScreenState();
}

class _PriceScreenState extends State<PriceScreen> {
  double rateBTC = 0;
  double rateETH = 0;
  double rateEUR = 0;
  String selectedCurrency = 'USD';

  @override
  void initState() {
    super.initState();
    SetRate('BTC', selectedCurrency);
    SetRate('ETH', selectedCurrency);
    SetRate('EUR', selectedCurrency);
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
          SetRate('BTC', value);
          SetRate('ETH', value);
          SetRate('EUR', value);
        });
      },
    );
  }

  void SetRate(String mainVal, String val) async {
    NetworkHelper networkHelper = NetworkHelper(
        'https://rest.coinapi.io/v1/exchangerate/$mainVal/$val?apiKey=C5FBFAC9-4276-464F-901E-4E536F645047');
    var weatherData = await networkHelper.getData();
    setState(() {
      if (mainVal == 'BTC') {
        this.rateBTC = weatherData['rate'];
      } else if (mainVal == 'ETH') {
        this.rateETH = weatherData['rate'];
      } else if (mainVal == 'EUR') {
        this.rateEUR = weatherData['rate'];
      }
    });
  }

  CupertinoPicker iOSPicker() {
    List<Text> pickerItems = [];

    for (String currency in currenciesList) {
      var newItem = Text(currency);

      pickerItems.add(newItem);
    }

    return CupertinoPicker(
      backgroundColor: Colors.lightBlue,
      itemExtent: 32,
      onSelectedItemChanged: (selectedIndex) {
        print(selectedIndex);
      },
      children: pickerItems,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('🤑 Coin Ticker'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.fromLTRB(18.0, 18.0, 18.0, 0),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  ReusableCard(
                      crypto: "BTC",
                      rateBTC: rateBTC,
                      selectedCurrency: selectedCurrency),
                  ReusableCard(
                      crypto: "ETH",
                      rateBTC: rateETH,
                      selectedCurrency: selectedCurrency),
                  ReusableCard(
                      crypto: "EUR",
                      rateBTC: rateEUR,
                      selectedCurrency: selectedCurrency),
                ],
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
