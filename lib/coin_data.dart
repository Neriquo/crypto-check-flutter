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

const coinAPIURL = 'https://rest.coinapi.io/v1/exchangerate';
const apiKey = '8ee72fec-5874-4421-909e-2fea2e75ce16';

class CoinData {
  Future<dynamic> getCoinData(String crypto, String currency) async {
    String url = '$coinAPIURL/$crypto/$currency?apikey=$apiKey';
    http.Response response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      var decodedData = jsonDecode(response.body);
      return decodedData;
    } else {
      print(response.statusCode);
      throw 'Problème avec la requête API';
    }
  }

  Future<Map<String, double>> getAllCryptoRates(String currency) async {
    Map<String, double> cryptoRates = {};

    for (String crypto in cryptoList) {
      var data = await getCoinData(crypto, currency);
      cryptoRates[crypto] = data['rate'];
    }

    return cryptoRates;
  }
}