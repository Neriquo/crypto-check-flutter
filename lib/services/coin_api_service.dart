// Import des packages nécessaires pour les requêtes HTTP et le décodage JSON
import 'dart:convert';
import 'package:http/http.dart' as http;

// Clé d'API pour l'authentification auprès de CoinAPI
const apiKey = '1a680c3c-a502-40eb-aef5-58d666fbad56';
// URL de base de l'API pour obtenir les taux de change
const coinApiUrl = 'https://rest.coinapi.io/v1/exchangerate';

// Service pour interagir avec l'API de crypto-monnaies
class CoinApiService {
  // Méthode pour obtenir le taux de change entre une crypto-monnaie et une devise
  // Paramètres:
  //   - crypto: le symbole de la crypto-monnaie (ex: BTC, ETH)
  //   - currency: le code de la devise (ex: USD, EUR)
  Future<double> getExchangeRate(String crypto, String currency) async {
    // Effectue une requête GET vers l'API avec les paramètres appropriés
    final response = await http.get(
      Uri.parse('$coinApiUrl/$crypto/$currency'),
      headers: {'X-CoinAPI-Key': apiKey},
    );

    // Vérifie si la requête a réussi (code 200)
    if (response.statusCode == 200) {
      // Décode la réponse JSON et retourne le taux de change
      var decodedData = jsonDecode(response.body);
      return decodedData['rate'];
    } else {
      // Lance une exception en cas d'échec de la requête
      throw Exception('Failed to get exchange rate');
    }
  }
}