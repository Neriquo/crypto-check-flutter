import 'dart:convert';
import 'package:http/http.dart' as http;

class NetworkService {
  static const String _baseUrl = 'https://rest.coinapi.io/v1';
  static const String _apiKey = '2014b27c-c055-4b0e-8e4a-338dee2618c2';

  Future<double> getCryptoPrice(String cryptoSymbol, String currency) async {
    final response = await http.get(
      Uri.parse('$_baseUrl/exchangerate/$cryptoSymbol/$currency'),
      headers: {'X-CoinAPI-Key': _apiKey},
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['rate'].toDouble();
    } else {
      throw Exception('Erreur API');
    }
  }
}
