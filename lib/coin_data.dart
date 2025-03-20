import 'dart:convert';
import 'package:http/http.dart' as http;

// Liste des devises disponibles
const List<String> currenciesList = [
  'AUD', 'BRL', 'CAD', 'CNY', 'EUR', 'GBP', 'HKD', 'IDR', 'ILS',
  'INR', 'JPY', 'MXN', 'NOK', 'NZD', 'PLN', 'RON', 'RUB', 'SEK',
  'SGD', 'USD', 'ZAR'
];

// Liste des crypto-monnaies disponibles
const List<String> cryptoList = ['BTC', 'ETH', 'LTC'];

// Paramètres de l'API
const apiKey = '0dcda496-39e6-4e0a-981a-3eb58848e628';
const coinAPIURL = 'https://api-realtime.exrates.coinapi.io/v1';

class CoinData {
  // Récupère les taux de change pour toutes les crypto-monnaies
  Future<Map<String, double>> getAllExchangeRates(String currency) async {
    Map<String, double> rates = {};

    // Récupère le taux pour chaque crypto
    for (String crypto in cryptoList) {
      try {
        rates[crypto] = await _fetchRate(crypto, currency);
      } catch (e) {
        rates[crypto] = 0.0;
      }
    }

    return rates;
  }

  // Récupère un taux de change spécifique depuis l'API
  Future<double> _fetchRate(String crypto, String currency) async {
    // URL et headers pour l'API
    final url = Uri.parse('$coinAPIURL/exchangerate/$crypto/$currency');
    final headers = {'X-CoinAPI-Key': apiKey, 'Accept': 'application/json'};

    try {
      // Appel API
      final response = await http.get(url, headers: headers);

      if (response.statusCode == 200) {
        // Décode la réponse
        final data = jsonDecode(response.body);

        // Retourne le taux si présent
        if (data.containsKey('rate')) {
          return data['rate'].toDouble();
        }
      }

      // En cas d'erreur
      return 0.0;
    } catch (e) {
      // Log l'erreur et retourne 0
      print('Erreur API: $e');
      return 0.0;
    }
  }
}