import 'networking.dart';

const apiKey = '9ff848fb-7c4c-45de-aea1-8bba8b7dd67b';
const url = 'https://rest.coinapi.io/v1/exchangerate';

class ChangeModele {
  Future<dynamic> changeModele(cryptoCurrency, selectedCurrency) async {
    print('$url/$cryptoCurrency/$selectedCurrency?apikey=$apiKey');
    NetworkHelper networkHelper = NetworkHelper('$url/$cryptoCurrency/$selectedCurrency?apikey=$apiKey');

    var weatherData = await networkHelper.getData();
    return weatherData;
  }
}