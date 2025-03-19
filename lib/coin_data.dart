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
  String apiKey = '8d250158-ab16-47c2-a951-722ba728b5dc';

  Future<Map<String, String>> getCryptoRates(String selectedCurrency) async {
    Map<String, String> cryptoRates = {};

    for (String crypto in cryptoList) {
      cryptoRates[crypto] = '?';

      String url =
          'https://rest.coinapi.io/v1/exchangerate/$crypto/$selectedCurrency';

      try {
        Map<String, String> headers = {
          "X-CoinAPI-Key": apiKey,
          "Accept": "application/json",
        };

        print('Tentative de requête pour $crypto vers $selectedCurrency');
        http.Response response =
            await http.get(Uri.parse(url), headers: headers);

        print('Status code: ${response.statusCode}');
        print('Body: ${response.body}');

        if (response.statusCode == 200) {
          var decodedData = jsonDecode(response.body);
          if (decodedData.containsKey('rate')) {
            double rate = decodedData['rate'];
            cryptoRates[crypto] = rate.toStringAsFixed(2);
          } else {
            print('La clé rate n\'existe pas dans la réponse pour $crypto');
            cryptoRates[crypto] = 'N/A';
          }
        } else {
          print('Erreur de la requête pour $crypto: ${response.statusCode}');
          try {
            var errorBody = jsonDecode(response.body);
            print('Message d\'erreur: ${errorBody.toString()}');
          } catch (e) {
            print('Pas de corps JSON dans la réponse d\'erreur');
          }
          cryptoRates[crypto] = 'Erreur ${response.statusCode}';
        }
      } catch (e) {
        print('Exception pour $crypto: $e');
        cryptoRates[crypto] = 'Erreur';
      }
    }

    return cryptoRates;
  }
}
