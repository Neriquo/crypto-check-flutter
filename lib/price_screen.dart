import 'package:bitcoin_ticker/coin_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'dart:io' show Platform;

class PriceScreen extends StatefulWidget {
  @override
  _PriceScreenState createState() => _PriceScreenState();
}

class _PriceScreenState extends State<PriceScreen> {
  double code;
  String selectedCurrency = 'USD';
  CoinData coin = CoinData();
  void initState() {
    super.initState();

    updateUi();
  }

  void updateUi() async {
    var coinData = await coin.getCoursBitcoin(selectedCurrency);

    setState(() {
      print(coinData);
      code = coinData['rate'];
      print(code);
    });
  }

  DropdownButton androidDropdown() {
    return DropdownButton(
        items: getDropdownItems(),
        onChanged: (value) async {
          var coinData = await coin.getCoursBitcoin(value);

          setState(() {
            selectedCurrency = value;
            updateUi();
          });
        },
        value: selectedCurrency);
  }

//Android
  List<DropdownMenuItem> getDropdownItems() {
    List<DropdownMenuItem> dropdownItems = [];

    for (String currency in currenciesList) {
      //String currency = currenciesList[i];

      var newItem = DropdownMenuItem(
        child: Text(currency),
        value: currency,
      );
      dropdownItems.add(newItem);
    }
    return dropdownItems;
  }

  CupertinoPicker iosPicker() {
    return CupertinoPicker(
      itemExtent: 32,
      onSelectedItemChanged: (value) {
        print(value);
        setState(() {});
      },
      children: getPickerItems(),
    );
  }

//IOS
  List getPickerItems() {
    List<Text> pickerItems = [];
    for (String currency in currenciesList) {
      //String currency = currenciesList[i];

      var newItem = Text(currency);
      pickerItems.add(newItem);
    }
    return pickerItems;
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
            child: Card(
              color: Colors.lightBlueAccent,
              elevation: 5.0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 28.0),
                child: Text(
                  '1 BTC = ${code.toInt()} $selectedCurrency',
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
            child: Platform.isIOS ? iosPicker() : androidDropdown(),
          ),
        ],
      ),
    );
  }
}
