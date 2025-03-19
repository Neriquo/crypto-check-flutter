enum Currency {
  AUD,
  BRL,
  CAD,
  CNY,
  EUR,
  GBP,
  HKD,
  IDR,
  ILS,
  INR,
  JPY,
  MXN,
  NOK,
  NZD,
  PLN,
  RON,
  RUB,
  SEK,
  SGD,
  USD,
  ZAR
}

enum Crypto {
  BTC,
  ETH,
  LTC,
}

List<Currency> get currenciesList => Currency.values;

List<Crypto> get cryptoList => Crypto.values;

class CoinData {}
