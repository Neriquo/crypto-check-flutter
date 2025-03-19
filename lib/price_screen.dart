import 'dart:io';
import 'package:bitcoin_ticker/coin_data.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

/// Écran principal de l'application qui affiche les taux de change des cryptomonnaies
class PriceScreen extends StatefulWidget {
  @override
  _PriceScreenState createState() => _PriceScreenState();
}

class _PriceScreenState extends State<PriceScreen> {
  // Devise sélectionnée par défaut
  String selectedCurrency = 'USD';
  
  // Map pour stocker les taux de change (clé: crypto, valeur: taux)
  Map<String, double> cryptoRates = {};
  
  // État de chargement pour l'interface utilisateur
  bool isLoading = false;
  
  // Instance de CoinData pour faire les appels API
  final coinData = CoinData();

  @override
  void initState() {
    super.initState();
    // Charger les taux au démarrage
    getRates();
  }

  /// Récupère les taux de change pour toutes les cryptomonnaies
  /// dans la devise sélectionnée via l'API CoinAPI
  Future<void> getRates() async {
    setState(() {
      isLoading = true; // Afficher l'indicateur de chargement
    });

    try {
      final rates = await coinData.getAllCryptoRates(selectedCurrency);
      setState(() {
        cryptoRates = rates; // Mettre à jour les taux
      });
    } catch (e) {
      // Afficher une notification d'erreur
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error fetching rates: $e'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() {
        isLoading = false; // Cacher l'indicateur de chargement
      });
    }
  }

  /// Construit une carte pour afficher les informations d'une cryptomonnaie
  Widget _buildCryptoCard(String crypto) {
    final rate = cryptoRates[crypto];
    final formattedRate = rate?.toStringAsFixed(2) ?? '-.--';
    
    return Card(
      child: Padding(
        padding: EdgeInsets.all(20.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    _getCryptoIcon(crypto),
                    SizedBox(width: 12),
                    Text(
                      crypto,
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                // Afficher soit le taux, soit un indicateur de chargement
                isLoading
                    ? SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                        ),
                      )
                    : Text(
                        '$formattedRate',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
              ],
            ),
            SizedBox(height: 8),
            Align(
              alignment: Alignment.centerRight,
              child: Text(
                selectedCurrency,
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 14,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Retourne l'icône appropriée pour chaque cryptomonnaie
  Icon _getCryptoIcon(String crypto) {
    switch (crypto) {
      case 'BTC':
        return Icon(Icons.currency_bitcoin, size: 32, color: Colors.orange);
      case 'ETH':
        return Icon(Icons.currency_exchange, size: 32, color: Colors.blue);
      case 'LTC':
        return Icon(Icons.monetization_on, size: 32, color: Colors.grey);
      default:
        return Icon(Icons.currency_bitcoin, size: 32);
    }
  }

  /// Construit le sélecteur de devise avec style personnalisé
  Widget _buildCurrencySelector() {
    if (Platform.isIOS) {
      return Container(
        margin: EdgeInsets.symmetric(horizontal: 16.0),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(12),
        ),
        height: 100.0,
        child: CupertinoPicker(
          backgroundColor: Colors.transparent,
          itemExtent: 32.0,
          onSelectedItemChanged: (selectedIndex) {
            setState(() {
              selectedCurrency = currenciesList[selectedIndex];
              getRates();
            });
          },
          children: currenciesList.map((currency) => Text(currency)).toList(),
        ),
      );
    }

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Theme.of(context).colorScheme.primary.withOpacity(0.5),
          width: 1,
        ),
      ),
      child: DropdownButton<String>(
        value: selectedCurrency,
        isExpanded: true,
        icon: Icon(
          Icons.arrow_drop_down,
          color: Theme.of(context).colorScheme.primary,
        ),
        underline: SizedBox(),
        items: currenciesList.map((String currency) {
          return DropdownMenuItem<String>(
            value: currency,
            child: Text(
              currency,
              style: TextStyle(fontSize: 16),
            ),
          );
        }).toList(),
        onChanged: (value) {
          setState(() {
            selectedCurrency = value!;
            getRates(); // Recharger les taux quand la devise change
          });
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        title: Text(
          'Crypto Tracker',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: getRates, // Bouton pour rafraîchir les taux
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // En-tête du sélecteur de devise
            Padding(
              padding: EdgeInsets.all(16.0),
              child: Row(
                children: [
                  Icon(
                    Icons.currency_exchange,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  SizedBox(width: 8),
                  Text(
                    'Select Currency',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            _buildCurrencySelector(),
            // Liste scrollable des cryptomonnaies
            Expanded(
              child: ListView(
                padding: EdgeInsets.all(16.0),
                children: cryptoList
                    .map((crypto) => Padding(
                          padding: EdgeInsets.only(bottom: 16.0),
                          child: _buildCryptoCard(crypto),
                        ))
                    .toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
