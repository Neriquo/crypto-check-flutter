import 'dart:convert';

import '../coin_data.dart';
import 'package:http/http.dart';

Future<ExchangeRate> getExchangeRateRates(
    Currency currencyFrom,
    Crypto cryptoTo
    ) async {
  Response response = await get(
      Uri.https("api-realtime.exrates.coinapi.io",
          "/v1/exchangerate/${currencyFrom.name}/${cryptoTo.name}",
          {"apikey": "7d1633b1"})
  );

  if (response.statusCode != 200) {
    print(response.body);
    throw response.body as Error;
  }

  dynamic data = jsonDecode(response.body);

  Currency? responseCurrency = currenciesList
      .firstWhere((testCurrency) => testCurrency.name == data.asset_id_base);
  Crypto? responseCrypto = cryptoList
      .firstWhere((cryptoTest) => data.asset_id_quote);

  return new ExchangeRate(data.date, responseCurrency, responseCrypto, data.rate);
}