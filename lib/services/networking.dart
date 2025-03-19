import 'dart:convert';
import 'package:http/http.dart' as http;

const apiKey = '00e648bd-b5fc-41bc-8e7a-ab8ddd231818';
const coinApiURL = 'https://rest.coinapi.io/v1/exchangerate';

class NetworkHelper {
  final String url;

  NetworkHelper({required this.url});

  Future<dynamic> getData() async {
    http.Response response = await http.get(
      Uri.parse(url),
      headers: {'X-CoinAPI-Key': apiKey},
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      print('Request failed with status: ${response.statusCode}');
      print('Response body: ${response.body}');
      throw Exception('Failed to load data');
    }
  }
}