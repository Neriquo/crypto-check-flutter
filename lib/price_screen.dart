import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'coin_data.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:crypto_font_icons/crypto_font_icons.dart'; // Import correct

class PriceScreen extends StatefulWidget {
  @override
  _PriceScreenState createState() => _PriceScreenState();
}

class _PriceScreenState extends State<PriceScreen> {
  String? selectedCurrency = 'USD';
  Map<String, String> cryptoPrices = {};

  Future<void> getCryptoPrices() async {
    Map<String, String> prices = {};

    for (String crypto in cryptoList) {
      String apiKey =
          '20bbf5f8-d6f8-4a97-8daf-ca022f0a2282'; // **REMPLACEZ PAR VOTRE CLÉ API !**
      String currency = selectedCurrency!;

      Uri url = Uri.parse(
          'https://rest.coinapi.io/v1/exchangerate/$crypto/$currency?apikey=$apiKey');

      http.Response response = await http.get(url);

      if (response.statusCode == 200) {
        String data = response.body;
        var decodedData = jsonDecode(data);
        double rate = decodedData['rate'];
        prices[crypto] = rate.toStringAsFixed(0);
      } else {
        print('Erreur API pour $crypto: ${response.statusCode}');
        prices[crypto] = 'Erreur';
      }
    }
    setState(() {
      cryptoPrices = prices;
    });
  }

  @override
  void initState() {
    super.initState();
    getCryptoPrices();
  }

  CupertinoPicker iOSPicker() {
    List<Text> pickerItems = [];
    for (String currency in currenciesList) {
      pickerItems.add(Text(currency));
    }
    return CupertinoPicker(
      backgroundColor: Colors.blueGrey[700],
      itemExtent: 32,
      onSelectedItemChanged: (selectedIndex) {
        selectedCurrency = currenciesList[selectedIndex];
        getCryptoPrices();
      },
      children: pickerItems,
    );
  }

  DropdownButton<String> androidDropdown() {
    List<DropdownMenuItem<String>> dropdownItems = [];
    for (String currency in currenciesList) {
      dropdownItems
          .add(DropdownMenuItem(value: currency, child: Text(currency)));
    }
    return DropdownButton<String>(
      dropdownColor: Colors.grey[200], // Couleur du dropdown Android
      value: selectedCurrency,
      items: dropdownItems,
      onChanged: (value) {
        setState(() {
          selectedCurrency = value;
          getCryptoPrices();
        });
      },
    );
  }

  // Fonction pour obtenir la couleur associée à une cryptomonnaie
  Color getCryptoColor(String cryptoCurrency) {
    switch (cryptoCurrency) {
      case 'BTC':
        return Colors.orange;
      case 'ETH':
        return Colors.blueGrey; // ou Colors.blue[800]
      case 'LTC':
        return Colors.grey;
      default:
        return Colors.black; // Couleur par défaut
    }
  }

  Padding makeCard(String cryptoCurrency) {
    String price = cryptoPrices[cryptoCurrency] ?? '?';
    Color cryptoColor = getCryptoColor(cryptoCurrency); // Obtenir la couleur

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 18.0, vertical: 10.0),
      child: Card(
        color: cryptoColor.withOpacity(0.15), // Appliquer une couleur de fond légère
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 20.0), // Ajuster le padding
          child: Row( // Utiliser Row pour l'icône et le texte côte à côte
            children: [
              Icon(
                // Utilisez CryptoFontIcons directement :
                cryptoCurrency == 'BTC' ? CryptoFontIcons.BTC :
                cryptoCurrency == 'ETH' ? CryptoFontIcons.ETH :
                cryptoCurrency == 'LTC' ? CryptoFontIcons.LTC :
                Icons.error, // Icône par défaut si la crypto n'est pas trouvée.

                color: cryptoColor, // Utiliser la couleur de la crypto
                size: 40.0, // Taille de l'icône
              ),
              SizedBox(width: 20.0), // Espacement entre l'icône et le texte
              Expanded( // Expanded pour que le texte prenne la place restante
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start, // Aligner le texte à gauche
                  children: [
                    Text(
                      cryptoCurrency,
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    SizedBox(height: 8.0), // Réduire l'espacement
                    Text(
                      '$price $selectedCurrency',
                      style: Theme.of(context).textTheme.bodyLarge,
                      // textAlign n'est plus nécessaire ici car le texte est aligné à gauche
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Crypto Price Check'),
        centerTitle: true,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Expanded(
            child: ListView(
              padding: EdgeInsets.only(top: 20.0),
              children: [
                makeCard('BTC'),
                makeCard('ETH'),
                makeCard('LTC'),
              ],
            ),
          ),
          Container(
            height: 150.0,
            alignment: Alignment.center,
            padding: EdgeInsets.only(bottom: 30.0),
            color: Colors.blueGrey[700],
            child: Platform.isIOS ? iOSPicker() : androidDropdown(),
          ),
        ],
      ),
    );
  }
}