import 'services/networking.dart';

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
  'XRP',
  'BCH',
  'ADA',
  'DOT',
  'LINK',
  'XLM',
  'DOGE',
];

class CoinData {
  Future<dynamic> getCoinData(String crypto, String currency) async {
    NetworkHelper networkHelper = NetworkHelper(
      url: '$coinApiURL/$crypto/$currency',
    );

    var coinData = await networkHelper.getData();
    return coinData;
  }

  Future<Map<String, double>> getAllCryptoData(String currency) async {
    Map<String, double> cryptoRates = {};

    for (String crypto in cryptoList) {
      try {
        var data = await getCoinData(crypto, currency);
        cryptoRates[crypto] = data['rate'];
      } catch (e) {
        print('Error fetching data for $crypto: $e');
        cryptoRates[crypto] = 0.0;
      }
    }

    return cryptoRates;
  }
}