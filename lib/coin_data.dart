import 'dart:convert';
import 'package:http/http.dart' as http;

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
  final String apiKey = '0dabd3e3-5b4b-4f84-b64a-700b7a311a23';
  final String apiURL = 'https://rest.coinapi.io/v1/exchangerate';

  Future<double?> getCryptoRate(String crypto, String currency) async {
    try {
      String url = '$apiURL/$crypto/$currency?apikey=$apiKey';

      http.Response response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        return data['rate'];
      } else {
        print('Request failed with status: ${response.statusCode}.');
        return null;
      }
    } catch (e) {
      print('Error fetching crypto rate: $e');
      return null;
    }
  }

  Future<Map<String, double?>> getAllCryptoRates(String currency) async {
    Map<String, double?> rates = {};

    for (String crypto in cryptoList) {
      rates[crypto] = await getCryptoRate(crypto, currency);
    }

    return rates;
  }
}