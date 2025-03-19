import 'package:flutter/material.dart';
import 'coin_data.dart';

class PriceScreen extends StatefulWidget {
  @override
  _PriceScreenState createState() => _PriceScreenState();
}

class _PriceScreenState extends State<PriceScreen> with SingleTickerProviderStateMixin {
  String selectedCurrency = 'USD';
  Map<String, double> cryptoRates = {};
  bool isLoading = false;
  late AnimationController _controller;

  // Couleurs et icônes des cryptomonnaies
  final Map<String, Color> cryptoColors = {
    'BTC': Color(0xFFF7931A), // Bitcoin orange
    'ETH': Color(0xFF627EEA), // Ethereum blue
    'LTC': Color(0xFF345D9D), // Litecoin blue
  };

  final Map<String, String> cryptoNames = {
    'BTC': 'Bitcoin',
    'ETH': 'Ethereum',
    'LTC': 'Litecoin',
  };

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..repeat(reverse: true);
    getCryptoData();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  // Récupère les données des cryptomonnaies
  void getCryptoData() async {
    setState(() {
      isLoading = true;
    });

    try {
      CoinData coinData = CoinData();
      Map<String, double> rates = await coinData.getAllCoinData(selectedCurrency);

      setState(() {
        cryptoRates = rates;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });

      // Affiche une notification d'erreur
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erreur de chargement. Réessayez.'),
          backgroundColor: Colors.red.shade700,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          margin: EdgeInsets.all(16),
          action: SnackBarAction(
            label: 'Réessayer',
            textColor: Colors.white,
            onPressed: getCryptoData,
          ),
        ),
      );
    }
  }

  // Sélecteur de devise
  Widget buildCurrencySelector() {
    // Trouve l'index de la devise sélectionnée
    int selectedIndex = currenciesList.indexOf(selectedCurrency);
    if (selectedIndex < 0) selectedIndex = 0;

    return Container(
      height: 120,
      margin: EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFF1A73E8), Color(0xFF0D47A1)],
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.15),
            blurRadius: 12,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: ShaderMask(
        shaderCallback: (bounds) => LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Colors.transparent, Colors.white, Colors.white, Colors.transparent],
          stops: [0.0, 0.15, 0.85, 1.0],
        ).createShader(bounds),
        blendMode: BlendMode.dstIn,
        child: ListWheelScrollView.useDelegate(
          controller: FixedExtentScrollController(initialItem: selectedIndex),
          itemExtent: 40,
          perspective: 0.003,
          diameterRatio: 1.8,
          physics: FixedExtentScrollPhysics(),
          magnification: 1.1,
          useMagnifier: true,
          onSelectedItemChanged: (index) {
            setState(() {
              selectedCurrency = currenciesList[index];
              getCryptoData();
            });
          },
          childDelegate: ListWheelChildBuilderDelegate(
            childCount: currenciesList.length,
            builder: (context, index) {
              bool isSelected = currenciesList[index] == selectedCurrency;
              return Center(
                child: Text(
                  currenciesList[index],
                  style: TextStyle(
                    fontSize: isSelected ? 24 : 18,
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                    color: Colors.white,
                    letterSpacing: 1.0,
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  // Cartes de cryptomonnaies
  Widget buildCryptoCard(String crypto) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Container(
          margin: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                cryptoColors[crypto] ?? Theme.of(context).primaryColor,
                (cryptoColors[crypto] ?? Theme.of(context).primaryColor).withOpacity(0.8),
              ],
            ),
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: (cryptoColors[crypto] ?? Theme.of(context).primaryColor).withOpacity(0.3),
                blurRadius: 12 + (_controller.value * 4),
                offset: Offset(0, 6),
                spreadRadius: -2,
              ),
            ],
          ),
          child: Padding(
            padding: EdgeInsets.all(20),
            child: Column(
              children: [
                Row(
                  children: [
                    // Logo et nom de la crypto
                    CircleAvatar(
                      backgroundColor: Colors.white24,
                      radius: 20,
                      child: Text(
                        crypto.substring(0, 1),
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                    ),
                    SizedBox(width: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          crypto,
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          cryptoNames[crypto] ?? "",
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.white70,
                          ),
                        ),
                      ],
                    ),
                    Spacer(),
                    // Prix
                    isLoading
                        ? Container(
                      width: 30,
                      height: 30,
                      padding: EdgeInsets.all(6),
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 2.0,
                      ),
                    )
                        : Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          '${cryptoRates[crypto]?.toStringAsFixed(2) ?? '?'}',
                          style: TextStyle(
                            fontSize: 20,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          selectedCurrency,
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.white70,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF8F9FF),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          'Crypto Tracker',
          style: TextStyle(
            color: Color(0xFF1A73E8),
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh, color: Color(0xFF1A73E8)),
            onPressed: getCryptoData,
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: <Widget>[
            // En-tête
            Padding(
              padding: EdgeInsets.fromLTRB(20, 20, 20, 5),
              child: Text(
                'Prix en temps réel',
                style: TextStyle(
                  fontSize: 16,
                  color: Color(0xFF1A73E8),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),

            // Cartes des cryptomonnaies
            Expanded(
              child: ListView(
                padding: EdgeInsets.symmetric(vertical: 16),
                physics: BouncingScrollPhysics(),
                children: cryptoList.map((crypto) => buildCryptoCard(crypto)).toList(),
              ),
            ),

            // Sélecteur de devise
            Padding(
              padding: EdgeInsets.only(top: 10, bottom: 20),
              child: Column(
                children: [
                  Text(
                    'Faire défiler pour changer de devise',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey.shade700,
                    ),
                  ),
                  SizedBox(height: 15),
                  buildCurrencySelector(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}