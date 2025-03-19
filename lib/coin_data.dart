import 'dart:convert';  // Pour l'encodage/décodage JSON
import 'package:http/http.dart' as http;  // Pour les requêtes HTTP

// Liste des devises supportées par l'API
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

// Liste des crypto-monnaies que nous voulons suivre
const List<String> cryptoList = [
  'BTC',
  'ETH',
  'LTC',
];

// Clé API à remplacer par votre propre clé de coinapi.io
const apiKey = 'd7212f12-2581-444c-8377-2071e25eea88';

// URL de base pour l'API de taux de change
const coinAPIURL = 'https://rest.coinapi.io/v1/exchangerate';

class CoinData {
  // Méthode pour récupérer le taux de change d'une seule crypto-monnaie
  // Prend en paramètres le symbole de la crypto-monnaie et la devise cible
  Future<double> getCoinRate(String crypto, String currency) async {
    // Construction de l'URL de l'API
    String requestURL = '$coinAPIURL/$crypto/$currency?apikey=$apiKey';

    // Envoi de la requête GET à l'API
    http.Response response = await http.get(Uri.parse(requestURL));

    // Vérification du statut de la réponse
    if (response.statusCode == 200) {
      // Décodage de la réponse JSON
      var decodedData = jsonDecode(response.body);
      // Extraction du taux de change
      return decodedData['rate'];
    } else {
      // Affichage du code d'erreur en cas de problème
      print('Erreur: ${response.statusCode}');
      // Lancement d'une exception pour indiquer l'échec
      throw 'Problème avec la requête GET';
    }
  }

  // Méthode pour récupérer les taux de change de toutes les crypto-monnaies
  // Prend en paramètre la devise cible
  Future<Map<String, double>> getAllCoinRates(String currency) async {
    // Map pour stocker les résultats (clé: symbole crypto, valeur: taux)
    Map<String, double> cryptoRates = {};

    // Parcours de toutes les crypto-monnaies
    for (String crypto in cryptoList) {
      try {
        // Récupération du taux pour chaque crypto-monnaie
        double rate = await getCoinRate(crypto, currency);
        // Stockage dans la map
        cryptoRates[crypto] = rate;
      } catch (e) {
        // En cas d'erreur, stockage d'une valeur par défaut (0.0)
        cryptoRates[crypto] = 0.0;
        // Affichage de l'erreur spécifique à cette crypto-monnaie
        print('Erreur pour $crypto: $e');
      }
    }

    // Retourne tous les taux de change
    return cryptoRates;
  }
}