import 'package:bitcoin_ticker/services/networking.dart';

const apiKey = 'FE36CAA9-CBA2-4528-9CB0-BCD1DC9EFCB4';
const url = 'https://rest.coinapi.io/v1/exchangerate';
class ExchangeModel {
  Future<dynamic> getCurrency(currency) async {
    NetworkHelper networkHelper = NetworkHelper(
        '$url/BTC/$currency?apikey=$apiKey');

    var exchangeRate = await networkHelper.getData();

    return exchangeRate;
  }

}