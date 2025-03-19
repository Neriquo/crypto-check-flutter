/// Service de récupération des taux de change de cryptomonnaies
/// Utilise l'API CoinAPI pour obtenir les taux actuels
import 'dart:convert';
import 'package:http/http.dart' as http;

/// Liste des devises fiduciaires supportées par l'application
/// Ces codes de devises sont conformes à la norme ISO 4217
const List<String> currenciesList = [
  'AUD', // Dollar australien
  'BRL', // Real brésilien
  'CAD', // Dollar canadien
  'CNY', // Yuan chinois
  'EUR', // Euro
  'GBP', // Livre sterling
  'HKD', // Dollar de Hong Kong
  'IDR', // Roupie indonésienne
  'ILS', // Shekel israélien
  'INR', // Roupie indienne
  'JPY', // Yen japonais
  'MXN', // Peso mexicain
  'NOK', // Couronne norvégienne
  'NZD', // Dollar néo-zélandais
  'PLN', // Złoty polonais
  'RON', // Leu roumain
  'RUB', // Rouble russe
  'SEK', // Couronne suédoise
  'SGD', // Dollar de Singapour
  'USD', // Dollar américain
  'ZAR'  // Rand sud-africain
];

/// Liste des cryptomonnaies supportées par l'application
const List<String> cryptoList = [
  'BTC', // Bitcoin
  'ETH', // Ethereum
  'LTC', // Litecoin
];

/// Clé API pour l'authentification auprès de CoinAPI
/// Note: Dans un environnement de production, cette clé devrait être sécurisée
const apiKey = '41634c16-e102-489a-ad3d-2131a69b2144';

/// URL de base pour les requêtes à l'API CoinAPI
const coinAPIURL = 'https://rest.coinapi.io/v1/exchangerate';

/// Classe gérant les opérations liées aux données de cryptomonnaies
/// Fournit des méthodes pour récupérer les taux de change actuels
class CoinData {
  /// Récupère le prix d'une cryptomonnaie spécifique dans la devise demandée
  /// 
  /// [crypto] : Le symbole de la cryptomonnaie (ex: 'BTC')
  /// [currency] : Le code de la devise (ex: 'USD')
  /// 
  /// Retourne le taux de change ou null en cas d'erreur
  Future<double?> getCoinPrice(String crypto, String currency) async {
    String url = '$coinAPIURL/$crypto/$currency?apikey=$apiKey';

    try {
      // Envoi de la requête HTTP à l'API
      http.Response response = await http.get(Uri.parse(url));

      // Traitement de la réponse
      if (response.statusCode == 200) {
        var decodedData = jsonDecode(response.body);
        return decodedData['rate'];
      } else {
        print('Request failed with status: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('Error fetching data: $e');
      return null;
    }
  }

  /// Récupère les prix de toutes les cryptomonnaies définies 
  /// dans la liste [cryptoList] dans la devise spécifiée
  /// 
  /// [currency] : Le code de la devise (ex: 'USD')
  /// 
  /// Retourne une Map avec les symboles de crypto comme clés
  /// et leurs taux de change comme valeurs
  Future<Map<String, double?>> getAllCoinPrices(String currency) async {
    Map<String, double?> prices = {};

    // Récupération séquentielle des taux pour chaque cryptomonnaie
    for (String crypto in cryptoList) {
      prices[crypto] = await getCoinPrice(crypto, currency);
    }

    return prices;
  }
}