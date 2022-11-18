import 'package:flutter/material.dart';
import 'crypto_element.dart';

import 'coin_data.dart';
import 'package:flutter/cupertino.dart';
import 'dart:io' show Platform;

import 'networking.dart';

const bitcoinQuty = 1;

class PriceScreen extends StatefulWidget {
  @override
  _PriceScreenState createState() => _PriceScreenState();
}

class _PriceScreenState extends State<PriceScreen> {
  String selectedCurrency = 'USD';
  String selectedCrypto;
  String time;
  String asset_id_base;
  String asset_id_quote;
  List cryptoData;

  @override
  void initState() {
    super.initState();

    getCrypto();
  }

  getCrypto() async {
    cryptoData = await Networking().getCoinValues(selectedCurrency);
  }

  DropdownButton androidDrupdown() {
    return DropdownButton(
      items: getDropdownItems(),
      onChanged: (value) async {
        setState(() {
          selectedCurrency = value;
        });
        cryptoData = await Networking().getCoinValues(selectedCurrency);
      },
      value: selectedCurrency,
    );
  }

  //ANDROID
  List<DropdownMenuItem> getDropdownItems() {
    List<DropdownMenuItem> dropdownItems = [];
    for (int i = 0; i < currenciesList.length; i++) {
      //ou for (String currency in currenciesList)
      String currency = currenciesList[i];

      var newItem = DropdownMenuItem(child: Text(currency), value: currency);

      dropdownItems.add(newItem);
    }

    return dropdownItems;
  }

  CupertinoPicker iOSPicker() {
    return CupertinoPicker(
        itemExtent: 32,
        onSelectedItemChanged: (value) {
          setState(() {
            //selectedCurrency = value;
          });
        },
        children: getPickerItems());
  }

  //IOS
  List getPickerItems() {
    List<Text> pickerItems = [];

    for (int i = 0; i < currenciesList.length; i++) {
      //ou for (String currency in currenciesList)
      String currency = currenciesList[i];

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
        centerTitle: true,
        backgroundColor: Colors.lightBlue,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              for (var i = 0; i < cryptoList.length; i++)
                CryptoElement(
                  btcValue: cryptoData != null ? cryptoData[i]['rate'] : 0,
                  asset_id_quote:
                      cryptoData != null ? cryptoData[i]['asset_id_quote'] : '',
                  crypto: cryptoList[i],
                ),
            ],
          ),
          Container(
            height: 150.0,
            alignment: Alignment.center,
            padding: EdgeInsets.only(bottom: 30.0),
            color: Colors.lightBlue,
            child: Platform.isIOS ? iOSPicker() : androidDrupdown(),
          ),
        ],
      ),
    );
  }
}
