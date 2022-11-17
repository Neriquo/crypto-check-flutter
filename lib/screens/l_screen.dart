import 'package:bitcoin_ticker/api/coin_data.dart';
import 'package:bitcoin_ticker/screens/price_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class LoadingScreen extends StatefulWidget {
  @override
  _LoadingScreenState createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> {
  @override
  void initState() {
    super.initState();
    getCoinData();
  }

  void getCoinData() async {
    CoinData _obj = CoinData();
    var coinBTCData = await _obj.getExchangeRate('BTC', currenciesList[0]);
    var coinETHData = await _obj.getExchangeRate('ETH', currenciesList[0]);
    var coinLTCData = await _obj.getExchangeRate('LTC', currenciesList[0]);
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) {
          return PriceScreen(
            coinBTCData: coinBTCData,
            coinETHData: coinETHData,
            coinLTCData: coinLTCData,
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text("🤑 Bitcoin Ticker")),
      ),
      body: Center(
        child: SpinKitDoubleBounce(
          color: Colors.white,
          size: 100.0,
        ),
      ),
    );
  }
}