import 'package:bitcoin_ticker/coin_data.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

const apiKey = 'apikey=4C1F385C-FE21-4AD5-8B18-42320200D789';
const url = 'https://rest.coinapi.io';

class Networking {
  Future<List> getCoinValues(String selectedCurrency) async {
    List cryptosData = [];

    for (String crypto in cryptoList) {
      var data = await getData(crypto, selectedCurrency);

      cryptosData.add(data);
    }

    return cryptosData;
  }

  Future getData(crypto, selectedCurrency) async {
    http.Response response = await http.get(
        Uri.parse('$url/v1/exchangerate/$crypto/$selectedCurrency?$apiKey'));
    print('$url/v1/exchangerate/$crypto/$selectedCurrency?$apiKey');

    if (response.statusCode == 200) {
      String data = response.body;
      var decodedJson = jsonDecode(data);

      return decodedJson;
    } else {
      print(response.statusCode);
    }
  }
}
