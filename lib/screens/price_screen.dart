import 'dart:io';
import 'package:bitcoin_ticker/api/coin_data.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class PriceScreen extends StatefulWidget {
  PriceScreen({this.coinBTCData, this.coinETHData, this.coinLTCData});

  final coinBTCData;
  final coinETHData;
  final coinLTCData;
  @override
  State<PriceScreen> createState() => _PriceScreenState();
}

class _PriceScreenState extends State<PriceScreen> {
  @override
  void initState() {
    super.initState();
    updateUI(widget.coinBTCData, widget.coinETHData, widget.coinLTCData);
  }

  String selectedCurrency = currenciesList[0];
  String rateBTC = '';
  String rateETH = '';
  String rateLTC = '';

  void updateUI(dynamic dataBTC, dynamic dataETH, dynamic dataLTC) {
    setState(() {
      rateBTC = dataBTC;
      rateETH = dataETH;
      rateLTC = dataLTC;
    });
  }

  DropdownButton androidDropdownButton() {
    List<DropdownMenuItem> menitemList = currenciesList
        .map((currency) =>
        DropdownMenuItem(value: currency, child: Text(currency)))
        .toList();

    return DropdownButton(
      value: selectedCurrency,
      items: menitemList,
      onChanged: (value) async {
        CoinData _obj = CoinData();
        var coinBTCData = await _obj.getExchangeRate('BTC', selectedCurrency);
        var coinETHData = await _obj.getExchangeRate('ETH', selectedCurrency);
        var coinLTCData = await _obj.getExchangeRate('LTC', selectedCurrency);

        setState(() {
          rateBTC = coinBTCData;
          rateETH = coinETHData;
          rateLTC = coinLTCData;
        });
      },
    );
  }

  CupertinoPicker iOSPicker() {
    List<Text> itemList = [];
    for (String currency in currenciesList) {
      var newItem = Text(currency);
      itemList.add(newItem);
    }

    return CupertinoPicker(
      backgroundColor: Colors.lightBlue,
      itemExtent: 32.0,
      onSelectedItemChanged: (selectedIndex) async {
        CoinData _obj = CoinData();
        var coinBTCData =
        await _obj.getExchangeRate('BTC', currenciesList[selectedIndex]);
        var coinETHData =
        await _obj.getExchangeRate('ETH', currenciesList[selectedIndex]);
        var coinLTCData =
        await _obj.getExchangeRate('LTC', currenciesList[selectedIndex]);

        setState(() {
          selectedCurrency = currenciesList[selectedIndex];
          rateBTC = coinBTCData;
          rateETH = coinETHData;
          rateLTC = coinLTCData;
        });
      },
      children: itemList,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              NewCardWidget(
                rateCrypto: rateBTC,
                selectedCurrency: selectedCurrency,
                cryptoCurrency: 'BTC',
              ),
              NewCardWidget(
                rateCrypto: rateETH,
                selectedCurrency: selectedCurrency,
                cryptoCurrency: 'ETH',
              ),
              NewCardWidget(
                rateCrypto: rateLTC,
                selectedCurrency: selectedCurrency,
                cryptoCurrency: 'LTC',
              ),
            ],
          ),
          Container(
            height: 150.0,
            alignment: Alignment.center,
            padding: EdgeInsets.only(bottom: 30.0),
            color: Colors.lightBlue,
            child: Platform.isIOS ? iOSPicker() : androidDropdownButton(),
          ),
        ],
      ),
    );
  }
}

class NewCardWidget extends StatelessWidget {
  const NewCardWidget({
    Key? key,
    required this.rateCrypto,
    required this.selectedCurrency,
    required this.cryptoCurrency,
  }) : super(key: key);

  final String rateCrypto;
  final String selectedCurrency;
  final String cryptoCurrency;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(18.0, 18.0, 18.0, 0.0),
      child: Card(
        color: Colors.lightBlueAccent,
        elevation: 5.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 28.0),
          child: Text(
            '1 $cryptoCurrency = $rateCrypto $selectedCurrency',
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
}