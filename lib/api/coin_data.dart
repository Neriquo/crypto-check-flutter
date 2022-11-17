import 'package:bitcoin_ticker/api/api.dart';
import 'package:bitcoin_ticker/network/Networking.dart';

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
  'ZAR',
  'PKR'
];

const List<String> cryptoList = [
  'BTC',
  'ETH',
  'LTC',
];

class CoinData {
  Future<String> getExchangeRate(
      String sourceCurrency, String destinationCurrency) async {
    String apiURL =
        '$coinApiBaseURL$sourceCurrency/$destinationCurrency?apikey=$apiKey';

    print(apiURL);

    Networking helper = await Networking(apiURL);

    var coinData = await helper.getData();
    return (coinData['rate']).toStringAsFixed(2);
  }
}
