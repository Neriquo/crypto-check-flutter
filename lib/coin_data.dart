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
  String apiKey = 'a02c661f-97f4-4f76-8e7c-ac3b7a1a8d9e';
  String apiURL = 'https://rest.coinapi.io/v1/exchangerate';

  // taux de change depuis l'API
  Future<String> getCoinData(String crypto, String currency) async {
    String requestURL = '$apiURL/$crypto/$currency?apikey=$apiKey';

    http.Response response = await http.get(Uri.parse(requestURL));
    var decodedData = jsonDecode(response.body);

    double rate = decodedData['rate'];
    return rate.toStringAsFixed(2); // retourne le taux avec 2 décimales
  }
}
