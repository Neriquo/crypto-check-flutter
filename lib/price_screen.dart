import 'dart:convert';

import 'package:flutter/material.dart';
import 'coin_data.dart';
import 'package:flutter/cupertino.dart';
import 'dart:io' show Platform;
import 'package:http/http.dart' as http;

const apikey = '74555F25-A689-4FA4-9D1F-EAE171B65553';
const url = 'https://rest.coinapi.io/v1/exchangerate/BTC';
const urlLtc = 'https://rest.coinapi.io/v1/exchangerate/LTC';
const urlEth = 'https://rest.coinapi.io/v1/exchangerate/ETH';

class PriceScreen extends StatefulWidget {
  @override
  _PriceScreenState createState() => _PriceScreenState();
}

class _PriceScreenState extends State<PriceScreen> {
  String selectedCurrency = 'USD';
  double prix;
  double eth;
  double ltc;

  @override
  initState() {
    // TODO: implement initState
    super.initState();
    priceBitcoin();
    priceEth();
    priceLtc();
  }

  void priceBitcoin() async {
    http.Response response =
        await http.get(Uri.parse('$url/$selectedCurrency?apikey=$apikey'));

    if (response.statusCode == 200) {
      String data = response.body;
      var decodeJson = jsonDecode(data);
      double rateB = decodeJson['rate'];

      setState(() {
        prix = rateB;
      });
    }
  }

  void priceEth() async {
    http.Response response =
        await http.get(Uri.parse('$urlEth/$selectedCurrency?apikey=$apikey'));

    if (response.statusCode == 200) {
      String data = response.body;
      var decodeJson = jsonDecode(data);
      double ethPrice = decodeJson['rate'];

      setState(() {
        eth = ethPrice;
      });
    }
  }

  void priceLtc() async {
    http.Response response =
        await http.get(Uri.parse('$urlLtc/$selectedCurrency?apikey=$apikey'));

    if (response.statusCode == 200) {
      String data = response.body;
      var decodeJson = jsonDecode(data);
      double ltcPrice = decodeJson['rate'];

      setState(() {
        ltc = ltcPrice;
      });
    }
  }

  DropdownButton androidDropDown() {
    return DropdownButton(
      items: getDropDownItems(),
      onChanged: (value) {
        setState(() async {
          selectedCurrency = value;
          priceBitcoin();
          priceEth();
          priceLtc();
        });
      },
      value: selectedCurrency,
    );
  }

  //android
  List<DropdownMenuItem> getDropDownItems() {
    List<DropdownMenuItem> dropDownItems = [];

    for (String currency in currenciesList) {
      var newItem = DropdownMenuItem(
        child: Text(currency),
        value: currency,
      );

      dropDownItems.add(newItem);
    }

    return dropDownItems;
  }

  CupertinoPicker iosPicker() {
    return CupertinoPicker(
      itemExtent: 32,
      onSelectedItemChanged: (value) {
        setState(() {
          //selectedCurrency = value;
        });
      },
      children: getPickerItems(),
    );
  }

  //ios
  List getPickerItems() {
    List<Text> pickerItems = [];
    for (String currency in currenciesList) {
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
                  '1 BTC = ${prix.toInt()} $selectedCurrency',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 20.0,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
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
                  '1 ETH = ${eth.toInt()} $selectedCurrency',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 20.0,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
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
                  '1 LTC = ${ltc.toInt()} $selectedCurrency',
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
            child: Platform.isIOS ? iosPicker() : androidDropDown(),
          ),
        ],
      ),
    );
  }
}
