import 'dart:convert';

import '../coin_data.dart';
import 'package:http/http.dart';

Future<ExchangeRate> getExchangeRateRates(
    Currency currencyFrom,
    Crypto cryptoTo
    ) async {
  Response response = await get(
      Uri.https("api-realtime.exrates.coinapi.io",
          "/v1/exchangerate/${cryptoTo.name}/${currencyFrom.name}",
          {"apikey": "573187c8-0ac5-4027-80f7-7f0ac57f7861"})
  );

  if (response.statusCode != 200) {
    print(response.body);
    throw response.body as Error;
  }

  dynamic data = jsonDecode(response.body);

  Currency? responseCurrency = currenciesList
      .firstWhere((testCurrency) => testCurrency.name == data["asset_id_quote"]);
  Crypto? responseCrypto = cryptoList
      .firstWhere((cryptoTest) => cryptoTest.name == data["asset_id_base"]);

  return new ExchangeRate(DateTime.parse(data["time"]), responseCurrency, responseCrypto, data["rate"]);
}