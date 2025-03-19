import 'dart:io';

import 'package:bitcoin_ticker/coin_data.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class PriceScreen extends StatefulWidget {
  @override
  _PriceScreenState createState() => _PriceScreenState();
}

class _PriceScreenState extends State<PriceScreen> {
  // Devise sélectionnée par défaut
  String selectedCurrency = 'USD';
  // Map qui stocke les taux de change pour chaque crypto-monnaie
  Map<String, double> rates = {};
  // Indicateur de chargement pour l'interface utilisateur
  bool isLoading = false;

  // Méthode asynchrone qui récupère les taux de change actuels
  void getRatesData() async {
    // Active l'indicateur de chargement
    setState(() {
      isLoading = true;
    });
    try {
      // Crée une instance de CoinData pour accéder aux données
      CoinData coinData = CoinData();
      // Récupère les nouveaux taux de change pour la devise sélectionnée
      var newRates = await coinData.getRates(selectedCurrency);
      // Met à jour l'état avec les nouveaux taux et désactive le chargement
      setState(() {
        rates = newRates;
        isLoading = false;
      });
    } catch (e) {
      // En cas d'erreur, affiche l'erreur et désactive le chargement
      print(e);
      setState(() {
        isLoading = false;
      });
    }
  }

  // Méthode appelée lors de l'initialisation du widget
  @override
  void initState() {
    super.initState();
    // Charge les données dès le démarrage
    getRatesData();
  }

  CupertinoPicker iOSPicker() {
    List<Text> pickerItems = [];

    for (String currency in currenciesList) {
      var newItem = Text(currency);

      pickerItems.add(newItem);
    }

    return CupertinoPicker(
      backgroundColor: Colors.lightBlue,
      itemExtent: 32,
      onSelectedItemChanged: (selectedIndex) {
        setState(() {
          // Met à jour la devise sélectionnée avec la nouvelle valeur du picker
          selectedCurrency = currenciesList[selectedIndex];
          // Déclenche une nouvelle requête pour obtenir les taux de change mis à jour
          getRatesData();
        });
      },
      children: pickerItems,
    );
  }

  DropdownButton<String> androidDropdown() {
    List<DropdownMenuItem<String>> dropdownItems = [];

    for (String currency in currenciesList) {
      var newItem = DropdownMenuItem(
        child: Text(currency),
        value: currency,
      );

      dropdownItems.add(newItem);
    }

    return DropdownButton<String>(
      value: selectedCurrency,
      items: dropdownItems,
      onChanged: (value) {
        setState(() {
          // Met à jour la devise sélectionnée avec la nouvelle valeur du dropdown
          selectedCurrency = value!;
          // Déclenche une nouvelle requête pour obtenir les taux de change mis à jour
          getRatesData();
        });
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
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Column(
            // Étend les éléments sur toute la largeur disponible
            crossAxisAlignment: CrossAxisAlignment.stretch,
            // Transforme chaque crypto-monnaie de la liste en un widget Card
            children: cryptoList.map((crypto) {
              return Padding(
                padding: EdgeInsets.fromLTRB(18.0, 18.0, 18.0, 0),
                child: Card(
                  color: Colors.lightBlueAccent,
                  elevation: 5.0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 28.0),
                    child: isLoading
                        // Affiche un indicateur de chargement circulaire blanc pendant le chargement des données
                        ? Center(child: CircularProgressIndicator(color: Colors.white))
                        // Affiche le taux de change formaté une fois les données chargées
                        : Text(
                            // Formate le texte avec le symbole de la crypto, le taux (avec 2 décimales) et la devise
                            // Si le taux n'est pas disponible (null), affiche '?' comme valeur par défaut
                            '1 $crypto = ${rates[crypto]?.toStringAsFixed(2) ?? '?'} $selectedCurrency',
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
