import 'networking.dart';
import 'dart:convert';

const apiKey = 'FE36CAA9-CBA2-4528-9CB0-BCD1DC9EFCB4';
const url = 'https://www.coinapi.io/Pricing';
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

class CoinData {
  Future getCoursBitcoin(monaie) async {
    Networking network = Networking(
        url:
            'http://rest.coinapi.io/v1/exchangerate/BTC/$monaie?apiKey=$apiKey');
    var coiModel = await network.getData();

    return coiModel;
  }
}
