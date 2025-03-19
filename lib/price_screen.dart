import 'dart:io';
import 'dart:convert';
import 'package:bitcoin_ticker/coin_data.dart'; //Pour utiliser les valeurs de coin data directement (cryptomonnaies)
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http; //Pour le requetes asynchrone

const String apiKey =
    '6515abc3-eefa-47a1-a408-c0fefa09bfe3'; //J'ai déporté ici la clé api par mesure de sécurité, elle est toujours active

class PriceScreen extends StatefulWidget {
  @override
  _PriceScreenState createState() => _PriceScreenState();
}

class _PriceScreenState extends State<PriceScreen> {
  String? selectedCurrency =
      'USD'; //Par défaut il affichera le taux de conversion en USD
  Map<String, String> cryptoValues = {}; // Initialisation vide

  // Ici la méthode pour récupérer les données de l'API en asynchrone
  Future<void> getCryptoRates() async {
    Map<String, String> updatedCryptoValues = {};

    for (String crypto in cryptoList) {
      //On parcourt directement la liste cryptoList en boucle foreach afin de permettre le rendu dynamique avec le fichier coin_data
      final url =
          'https://rest.coinapi.io/v1/exchangerate/$crypto/$selectedCurrency?apikey=$apiKey'; //url de l'api

      try {
        http.Response response = await http.get(Uri.parse(url));
        if (response.statusCode == 200) {
          var decodedData = jsonDecode(response.body);
          double rawRate = decodedData['rate']; // Extraction du taux brut
          double roundedRate = (rawRate * 100).roundToDouble() /
              100; // Arrondi au centième ici de chacune des valeurs
          updatedCryptoValues[crypto] =
              roundedRate.toString(); // Stockage du taux arrondi
        } else {
          updatedCryptoValues[crypto] =
              'Erreur : ${response.statusCode}'; //try catch ici pour gérer les erreurs si la récupération de la valeur a échoué
        }
      } catch (e) {
        updatedCryptoValues[crypto] = 'Erreur lors de la conversion';
      }
    }

    setState(() {
      cryptoValues = updatedCryptoValues; // Mise à jour des valeurs dans l'état
    });
  }

  @override
  void initState() {
    super.initState();
    getCryptoRates(); //J'appelle ici l'api afin de récuperer la réponse traduite
  }

  CupertinoPicker iOSPicker() {
    List<Text> pickerItems = [];
    for (String currency in currenciesList) {
      pickerItems.add(Text(currency));
    }

    return CupertinoPicker(
      backgroundColor: Colors.lightBlue,
      itemExtent: 32,
      onSelectedItemChanged: (selectedIndex) {
        setState(() {
          selectedCurrency = currenciesList[selectedIndex];
        });
        getCryptoRates(); // Mise à jour des prix après changement de monnaie
      },
      children: pickerItems,
    );
  }

  DropdownButton<String> androidDropdown() {
    List<DropdownMenuItem<String>> dropdownItems = [];
    for (String currency in currenciesList) {
      dropdownItems.add(DropdownMenuItem(
        child: Text(currency),
        value: currency,
      ));
    }

    return DropdownButton<String>(
      value: selectedCurrency,
      items: dropdownItems,
      onChanged: (value) {
        setState(() {
          selectedCurrency = value;
        });
        getCryptoRates(); //Mise à jour des prix après le changement de monnaie
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Bitcoin check'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment
            .spaceBetween, //Ici pour afficher dans l'étape 6 les autres cryptomonnaies, j'ai fait en sorte de duppliquer par 3 les 3 blocs texte
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: cryptoList.map((crypto) {
              // Utilisation directe de cryptoList
              return Padding(
                padding: EdgeInsets.fromLTRB(18.0, 18.0, 18.0, 0),
                child: Card(
                  color: Colors.lightBlueAccent,
                  elevation: 5.0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: Padding(
                    padding:
                        EdgeInsets.symmetric(vertical: 15.0, horizontal: 28.0),
                    child: Text(
                      '1 $crypto = ${cryptoValues[crypto] ?? '?'} $selectedCurrency', //Affiche dynamiquement les valeurs pour chaque crypto
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 20.0,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
          Container(
            height: 150.0,
            alignment: Alignment.center,
            padding: EdgeInsets.only(bottom: 30.0),
            color: Colors.lightBlue,
            child: Platform.isIOS ? iOSPicker() : androidDropdown(),
          ),
        ],
      ),
    );
  }
}
