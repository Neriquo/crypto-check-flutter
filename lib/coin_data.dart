import 'package:bitcoin_ticker/services/coin_api_service.dart';

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

// Classe qui gère la récupération des taux de change pour les crypto-monnaies
class CoinData {
  // Instance du service qui interagit avec l'API de crypto-monnaies
  final coinApiService = CoinApiService();

  // Méthode qui récupère les taux de change pour toutes les crypto-monnaies
  // Paramètre:
  //   - selectedCurrency: la devise sélectionnée (ex: USD, EUR)
  // Retourne une Map avec les taux de change pour chaque crypto-monnaie
  Future<Map<String, double>> getRates(String selectedCurrency) async {
    // Initialisation de la Map qui contiendra les taux de change
    Map<String, double> rates = {};

    // Pour chaque crypto-monnaie dans la liste
    for (String crypto in cryptoList) {
      try {
        // Récupération du taux de change via le service API
        double rate = await coinApiService.getExchangeRate(crypto, selectedCurrency);
        rates[crypto] = rate;
      } catch (e) {
        // En cas d'erreur, on affiche l'erreur et on met le taux à 0
        print(e);
        rates[crypto] = 0.0;
      }
    }
    return rates;
  }
}
