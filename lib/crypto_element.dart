import 'package:flutter/material.dart';
import 'price_screen.dart';

class CryptoElement extends StatelessWidget {
  const CryptoElement({
    Key key,
    @required this.btcValue,
    @required this.asset_id_quote,
    @required this.crypto,
  }) : super(key: key);

  final double btcValue;
  final String asset_id_quote;
  final String crypto;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(18.0, 15.0, 18.0, 0),
      child: Card(
        color: Colors.lightBlueAccent,
        elevation: 5.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 28.0),
          child: Text(
            //getCoinValue(selectedCurrency).;
            '$bitcoinQuty $crypto = ${btcValue.toInt()} $asset_id_quote',
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
