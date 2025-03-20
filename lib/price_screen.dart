import 'package:flutter/material.dart';
import 'coin_data.dart';

class PriceScreen extends StatefulWidget {
  @override
  _PriceScreenState createState() => _PriceScreenState();
}

class _PriceScreenState extends State<PriceScreen> {
  String selectedCurrency = 'USD';
  Map<String, double> cryptoRates = {};
  bool isLoading = false;
  String errorMessage = '';

  @override
  void initState() {
    super.initState();
    getAllRates();
  }

  // Récupère les taux pour toutes les cryptos
  void getAllRates() async {
    setState(() {
      isLoading = true;
      errorMessage = '';
    });

    try {
      // Récupère les taux de change
      final rates = await CoinData().getAllExchangeRates(selectedCurrency);

      setState(() {
        cryptoRates = rates;
        isLoading = false;

        // Vérifie si tous les taux sont à 0
        if (rates.values.every((rate) => rate <= 0)) {
          errorMessage = 'Impossible de récupérer les taux pour $selectedCurrency';
        }
      });
    } catch (e) {
      setState(() {
        isLoading = false;
        errorMessage = 'Erreur: $e';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('🤑 Coin Ticker'),
        actions: [IconButton(icon: Icon(Icons.refresh), onPressed: getAllRates)],
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          // Liste des cartes crypto
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: cryptoList.map((crypto) => _buildCryptoCard(crypto)).toList(),
            ),
          ),

          // Message d'erreur si nécessaire
          if (errorMessage.isNotEmpty)
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: TextButton(
                onPressed: getAllRates,
                child: Text('Réessayer', style: TextStyle(color: Colors.white)),
              ),
            ),

          // Sélecteur de devise
          Container(
            height: 150.0,
            alignment: Alignment.center,
            padding: EdgeInsets.only(bottom: 30.0),
            color: Colors.lightGreen,
            child: DropdownButton<String>(
              value: selectedCurrency,
              items: currenciesList.map((currency) =>
                  DropdownMenuItem(value: currency, child: Text(currency))
              ).toList(),
              onChanged: (value) {
                setState(() {
                  selectedCurrency = value!;
                  getAllRates();
                });
              },
            ),
          ),
        ],
      ),
    );
  }

  // Crée une carte pour afficher le taux d'une crypto
  Widget _buildCryptoCard(String crypto) {
    return Padding(
      padding: EdgeInsets.fromLTRB(18.0, 18.0, 18.0, 0),
      child: Card(
        color: Colors.lightGreen,
        elevation: 5.0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 28.0),
          child: Text(
            isLoading
                ? 'Chargement...'
                : errorMessage.isNotEmpty
                ? 'Erreur de chargement'
                : '1 $crypto = ${cryptoRates[crypto]?.toStringAsFixed(2) ?? '0.00'} $selectedCurrency',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 20.0, color: Colors.white),
          ),
        ),
      ),
    );
  }
}