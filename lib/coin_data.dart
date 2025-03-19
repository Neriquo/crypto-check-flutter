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

const apiKey = 'afdec510-5e67-404c-9581-47153cc0063c';
const coinAPIURL = 'rest.coinapi.io';
const apiPath = '/v1/exchangerate';

class CoinData {
  Future<double> getCryptoRate(String crypto, String currency) async {
    final uri = Uri.https(coinAPIURL, '$apiPath/$crypto/$currency');
    print('Requesting: $uri');

    try {
      final response = await http.get(
        uri,
        headers: {
          'X-CoinAPI-Key': apiKey,
        },
      );
      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        var decodedData = jsonDecode(response.body);
        return decodedData['rate'];
      } else {
        print('Request failed with status: ${response.statusCode}');
        throw 'Problem with the get request';
      }
    } catch (e) {
      print('Error in getCryptoRate: $e');
      rethrow;
    }
  }

  Future<Map<String, double>> getAllCryptoRates(String currency) async {
    Map<String, double> rates = {};
    for (String crypto in cryptoList) {
      try {
        double rate = await getCryptoRate(crypto, currency);
        rates[crypto] = rate;
      } catch (e) {
        print('Error getting rate for $crypto: $e');
        rates[crypto] = 0.0;
      }
    }
    return rates;
  }
}
