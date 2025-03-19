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

const apiKey = '614ec714-b2b0-4d2a-898d-9b9539d903e1';
const coinAPIURL = 'https://rest.coinapi.io/v1/exchangerate';

class CoinData {
  // Method to get exchange rate for a specific crypto and currency
  Future<double> getCoinData(String crypto, String currency) async {
    String requestURL = '$coinAPIURL/$crypto/$currency?apikey=$apiKey';

    http.Response response = await http.get(Uri.parse(requestURL));

    if (response.statusCode == 200) {
      var decodedData = jsonDecode(response.body);
      double rate = decodedData['rate'];
      return rate;
    } else {
      print('Request failed with status: ${response.statusCode}');
      print('Response body: ${response.body}');
      throw 'Problem with the get request';
    }
  }

  // Method to get exchange rates for all cryptos in a specific currency
  Future<Map<String, double>> getAllCoinData(String currency) async {
    Map<String, double> cryptoRates = {};

    for (String crypto in cryptoList) {
      try {
        double rate = await getCoinData(crypto, currency);
        cryptoRates[crypto] = rate;
      } catch (e) {
        cryptoRates[crypto] = 0.0;
        print('Error fetching rate for $crypto: $e');
      }
    }

    return cryptoRates;
  }
}