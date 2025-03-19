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
  'XRP',
  'SOL',
  'DOGE',
  'SHIB',
];

// la liste des images des crypto
const List<String> imageUrl = [
  "https://cryptologos.cc/logos/bitcoin-btc-logo.png?v=040",
  "https://cryptologos.cc/logos/ethereum-eth-logo.png?v=040",
  "https://cryptologos.cc/logos/litecoin-ltc-logo.png?v=040",
  "https://cryptologos.cc/logos/xrp-xrp-logo.png?v=040",
  "https://cryptologos.cc/logos/solana-sol-logo.png?v=040",
  "https://cryptologos.cc/logos/dogecoin-doge-logo.png?v=040",
  "https://cryptologos.cc/logos/shiba-inu-shib-logo.png?v=040"
];

// on envoit une requete API pour chaque crypto avec la devise choisie
class CoinData {
  Future<Map<String, String>> getCoinData(String selectedCurrency) async {
    Map<String, String> cryptoPrices = {};
    
    for (String crypto in cryptoList) {
      String url = 'https://rest.coinapi.io/v1/exchangerate/$crypto/$selectedCurrency';
      http.Response response = await http.get(
        Uri.parse(url),
        headers: {'X-CoinAPI-Key': 'cdba6bb6-a239-4459-808b-104023561927'}, // Replace with your API key
      );

      if (response.statusCode == 200) {
        var decodedData = jsonDecode(response.body);
        double lastPrice = decodedData['rate'];
        cryptoPrices[crypto] = lastPrice.toStringAsFixed(5);
      } else {
        print(response.statusCode);
        throw Exception('Failed to load coin data');
      }
    }
    
    return cryptoPrices;
  }
}
