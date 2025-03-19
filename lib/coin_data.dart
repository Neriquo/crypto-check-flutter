enum Currencie {
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

List<String> get currenciesList => Currencie.values.map((value) => value.name).toList();

List<String> get cryptoList => Crypto.values.map((value) => value.name).toList();

class CoinData {}
