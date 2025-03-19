import 'package:flutter/material.dart';
import 'price_screen.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

void main() => runApp(MyApp());

const apiKey = '8cbb330c-19dc-4007-b632-b7edb84a46df';
final url =
    'https://rest.coinapi.io/v1/exchangerate/BTC/USD?apikey=8cbb330c-19dc-4007-b632-b7edb84a46df';

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.dark().copyWith(
          primaryColor: Colors.lightBlue,
          scaffoldBackgroundColor: Colors.white),
      home: PriceScreen(),
    );
  }
}

class Currency {
  Future<dynamic> getRate() async {
    http.Response response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      var decodedData = jsonDecode(response.body);
      var rate = decodedData['rate'];
      return rate;
    } else {
      print(response.statusCode);
      throw 'Problem with the get request';
    }
  }
}
