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

class ExchangeRate {
  late DateTime date;
  Currency? currencyFrom;
  Crypto? cryptoTo;
  late double rate;

  ExchangeRate(DateTime date, Currency? currencyFrom, Crypto? cryptoTo, double rate) {
    this.date = date;
    this.currencyFrom = currencyFrom;
    this.cryptoTo = cryptoTo;
    this.rate = rate;
  }
}
