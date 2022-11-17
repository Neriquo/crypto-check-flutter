import 'package:flutter/material.dart';
import 'crypto_element.dart';
import 'api.dart';
import 'coin_data.dart';
import 'package:flutter/cupertino.dart';
import 'dart:io' show Platform;

import 'networking.dart';

const apiKey = 'apikey=2B4F7D25-AF57-41C0-B06A-1B240259EA9B';
const url = 'https://rest.coinapi.io';
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
  double btcValue;
  double ethValue;
  double ltcValue;

  @override
  void initState() {
    super.initState();

    getCoinValues(selectedCurrency);
  }

  void updateUi(var btcData, var ethData, var ltcData) {
    setState(() {
      if (btcData == null || ethData == null || ltcData == null) {
        time = '';
        asset_id_base = 'Error';
        asset_id_quote = 'Error';
        btcValue = 0;
        ethValue = 0;
        ltcValue = 0;

        return;
      }
      time = btcData['time'];
      asset_id_base = btcData['asset_id_base'];
      asset_id_quote = btcData['asset_id_quote'];

      btcValue = btcData['rate'];

      ethValue = ethData['rate'];

      ltcValue = ltcData['rate'];
    });
  }

  void getCoinValues(String selectedCurrency) async {
    Networking networkBtc =
        Networking(url: '$url/v1/exchangerate/BTC/$selectedCurrency?$apiKey');

    var btcData = await networkBtc.getData();

    Networking networkEth =
        Networking(url: '$url/v1/exchangerate/ETH/$selectedCurrency?$apiKey');

    var ethData = await networkEth.getData();

    Networking networkLtc =
        Networking(url: '$url/v1/exchangerate/LTC/$selectedCurrency?$apiKey');

    var ltcData = await networkLtc.getData();

    updateUi(btcData, ethData, ltcData);
  }

  DropdownButton androidDrupdown() {
    return DropdownButton(
      items: getDropdownItems(),
      onChanged: (value) async {
        setState(() {
          selectedCurrency = value;
        });
        await getCoinValues(selectedCurrency);
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
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          CryptoElement(btcValue: btcValue, asset_id_quote: asset_id_quote),
          CryptoElement(btcValue: ethValue, asset_id_quote: asset_id_quote),
          CryptoElement(btcValue: ltcValue, asset_id_quote: asset_id_quote),
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
