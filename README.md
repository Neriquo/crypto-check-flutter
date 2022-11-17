# Step 1 - Set Up The Project

Go to https://github.com/Neriquo/bitcoin-ticker-flutter and clone the starting project to your local computer. Open it using Android Studio and take a look around the project.

# Step 2 - Register for a coinapi.io API key

Go to https://www.coinapi.io/Pricing and create a FREE account

# Step 3 - Take a look at the documentation

Go to https://docs.coinapi.io/ and take a look at the documentation but mostly the exchange rates : https://docs.coinapi.io/#exchange-rates

# Step 4 - Fetch the current price of bitcoin (BTC) in US dollars (USD)

The value we're interested from the API is the rate of Bitcoin in USD.

You'll want to write all the networking/request/parsing code inside a method called getCoinData() in the CoinData class in the coin_data.dart file.

Goal: By the end of this challenge, this is the functionality you should end up with:

![image](https://github.com/Neriquo/bitcoin-ticker-flutter/blob/main-challenge/images/1.gif?raw=true)

NOTE: The CupertinoPicker/DropdownMenu is not supposed to work yet.

Hint: You'll need the [http](https://pub.dev/packages/http#-installing-tab-) and [dart:convert](https://api.dart.dev/stable/2.2.0/dart-convert/dart-convert-library.html) packages.

# Step 5 - Display the latest price of 1 Bitcoin (BTC) in any currency selected by the user.

You'll need to look inside the **onChanged** for the **DropdownButton** and the **onSelectedItemChanged** for the **CupertinoPicker** to see what the user selected as the currency.

The [coinapi.io](https://docs.coinapi.io/#get-specific-rate-get) API supports all the currencies in our *currenciesList*.

Goal: By the end of this challenge, this is the functionality you should end up with:

![image](https://github.com/Neriquo/bitcoin-ticker-flutter/blob/main-challenge/images/2.gif?raw=true)

# Step 6 - Display the latest price of multiple cryptocurrencies in any currency selected by the user.

If you look inside the coin_data.dart file, you'll find a const called cryptoList. This contains a List of Strings that represent 3 cryptocurrency symbols. BTC - Bitcoin, ETH - Ethereum and LTC - Litecoin.

Goal: By the end of this challenge, this is the functionality you should end up with:

![image](https://github.com/Neriquo/bitcoin-ticker-flutter/blob/main-challenge/images/3.gif?raw=true)
