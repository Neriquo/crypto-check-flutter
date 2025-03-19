import 'dart:io';

import 'package:bitcoin_ticker/coin_data.dart';
import 'package:bitcoin_ticker/data/exchanges.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class PriceScreen extends StatefulWidget {
  @override
  _PriceScreenState createState() => _PriceScreenState();
}

class _PriceScreenState extends State<PriceScreen> {
  Currency? selectedCurrency = null;
  Map<Crypto, double> currentRates = Map();

  void setCurrentRates(Crypto crypto, double newRate) {
    setState(() {
      currentRates[crypto] = (newRate * 100).round() / 100.0;
    });
  }

  CupertinoPicker iOSPicker([void onChange(Currency? currency)?]) {
    List<Text> pickerItems = currenciesList
        .map((currency) =>
        Text(currency.name)
    ).toList();

    return CupertinoPicker(
      backgroundColor: Colors.lightBlue,
      itemExtent: 32,
      onSelectedItemChanged: (selectedIndex) {
        if (onChange != null) onChange(currenciesList[selectedIndex]);
      },
      children: pickerItems,
    );
  }

  DropdownButton<Currency> androidDropdown([void onChange(Currency? currency)?]) {
    List<DropdownMenuItem<Currency>> dropdownItems = currenciesList
        .map((currency) =>
        DropdownMenuItem(
          child: Text(currency.name),
          value: currency,
        )
    ).toList();

    return DropdownButton<Currency>(
      hint: Text("select a currency"),
      value: selectedCurrency,
      items: dropdownItems,
      onChanged: (Currency? newValue) {
        setState(() {
          selectedCurrency = newValue;
          if (onChange != null) onChange(newValue);
        });
      },
    );
  }

  Widget cryptoRateDisplayer(Crypto crypto, double rate) {
    return Padding(
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
            '1 ${crypto.name} = ${rate} ${selectedCurrency?.name ?? "no currency selected"}',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 20.0,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }

  void onCurrencyChanged(Currency? currency) {
    if (currency == null) {
      setState(() {
        currentRates = Map();
      });
      return;
    }

    try {
      getExchangeRateRates(currency, Crypto.BTC).then((response) => {
        setCurrentRates(Crypto.BTC, response.rate)
      });
      getExchangeRateRates(currency, Crypto.ETH).then((response) => {
        setCurrentRates(Crypto.ETH, response.rate)
      });
      getExchangeRateRates(currency, Crypto.LTC).then((response) => {
        setCurrentRates(Crypto.LTC, response.rate)
      });
    }
    catch (e) {
      print(e);
    }
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
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              cryptoRateDisplayer(Crypto.BTC, currentRates[Crypto.BTC] ?? 0),
              cryptoRateDisplayer(Crypto.ETH, currentRates[Crypto.ETH] ?? 0),
              cryptoRateDisplayer(Crypto.LTC, currentRates[Crypto.LTC] ?? 0),
            ],
          ),
          Container(
            height: 150.0,
            alignment: Alignment.center,
            padding: EdgeInsets.only(bottom: 30.0),
            color: Colors.lightBlue,
            child: Platform.isIOS
                ? iOSPicker(onCurrencyChanged)
                : androidDropdown(onCurrencyChanged),
          ),
        ],
      ),
    );
  }
}


