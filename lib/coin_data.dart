import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

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

// Liste des crypto
const List<String> cryptoList = [
  'BTC',
  'ETH',
  'LTC',
  'XRP',
  'SOL',
];

// Map des couleurs associées a chaque crypto
final Map<String, Color> cryptoColors = {
  'BTC': Color(0xFFF7931A),
  'ETH': Color(0xFF627EEA),
  'LTC': Color(0xFFB8B8B8),
  'XRP': Color(0xFF23292F),
  'SOL': Color(0xFF00FFBD),
};

//Appel API
const coinAPIURL = 'https://rest.coinapi.io/v1/exchangerate';
const apiKey = 'daff2485-4b40-46b7-8d52-61a341d9a696';

class CoinData {
  Future<dynamic> getCoinData(String selectedCurrency) async {
    Map<String, String> cryptoPrices = {};

    for (String crypto in cryptoList) {
      String requestURL =
          '$coinAPIURL/$crypto/$selectedCurrency?apikey=$apiKey';
      http.Response response = await http.get(Uri.parse(requestURL));

      if (response.statusCode == 200) {
        var decodedData = jsonDecode(response.body);
        double price = decodedData['rate'];
        cryptoPrices[crypto] = price.toStringAsFixed(0);
      } else {
        print(response.statusCode);
        throw 'Problem with the get request';
      }
    }

    return cryptoPrices;
  }
}
