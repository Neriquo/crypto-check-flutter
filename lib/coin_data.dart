import 'dart:convert';
import 'package:bitcoin_ticker/networking.dart';

const List<String> currenciesList = [
  'AUD',
  'BRL',
  'CAD',
  'CNY',
  'EUR',
  'GBP',
  'HKD',
  'IDR',
  'ILS',
  'INR',
  'JPY',
  'MXN',
  'NOK',
  'NZD',
  'PLN',
  'RON',
  'RUB',
  'SEK',
  'SGD',
  'USD',
  'ZAR'
];

const List<String> cryptoList = [
  'BTC',
  'ETH',
  'LTC',
];
const apiKey = '02C1DCAC-849D-4F1D-BA4D-B7F0F7FAFDCA';
const url = 'https://rest.coinapi.io/v1/exchangerate/BTC';

class CoinData {
    Future GetValue(curren) async {
      NetworkHelper networkHelper = NetworkHelper(
        '$url/$curren?apikey=$apiKey'
      );
      var coinValue = await networkHelper.getData();
      return coinValue;
  }

}
