import 'package:flutter/material.dart';
import 'coin_data.dart';
import 'dart:math' as math;

class PriceScreen extends StatefulWidget {
  @override
  _PriceScreenState createState() => _PriceScreenState();
}

class _PriceScreenState extends State<PriceScreen> with SingleTickerProviderStateMixin {
  String selectedCurrency = 'USD';
  Map<String, double> cryptoRates = {};
  bool isLoading = false;
  late AnimationController _controller;

  // Couleurs et informations des cryptomonnaies
  final Map<String, Color> cryptoColors = {
    'BTC': Color(0xFFFF9500),
    'ETH': Color(0xFF6374C3),
    'LTC': Color(0xFF4D7BD1),
  };

  final Map<String, String> cryptoNames = {
    'BTC': 'Bitcoin',
    'ETH': 'Ethereum',
    'LTC': 'Litecoin',
  };

  final Map<String, String> cryptoSymbols = {
    'BTC': '₿',
    'ETH': 'Ξ',
    'LTC': 'Ł',
  };

  final Map<String, String> cryptoDescriptions = {
    'BTC': 'La première cryptomonnaie',
    'ETH': 'Plateforme de contrats intelligents',
    'LTC': 'Alternative rapide au Bitcoin',
  };

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 2000),
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
          content: Text('Impossible de charger les données. Vérifiez votre connexion.'),
          backgroundColor: Colors.red.shade800,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          margin: EdgeInsets.all(16),
          duration: Duration(seconds: 4),
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
      margin: EdgeInsets.symmetric(horizontal: 24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF3B7DED), Color(0xFF0D47A1)],
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Color(0xFF3B7DED).withOpacity(0.4),
            blurRadius: 16,
            offset: Offset(0, 8),
            spreadRadius: -4,
          ),
        ],
      ),
      child: Stack(
        children: [
          // Éléments décoratifs
          Positioned(
            right: 20,
            top: 15,
            child: Icon(Icons.currency_exchange, color: Colors.white.withOpacity(0.15), size: 40),
          ),
          Positioned(
            left: 15,
            bottom: 15,
            child: Icon(Icons.attach_money, color: Colors.white.withOpacity(0.15), size: 28),
          ),

          // Liste des devises
          ShaderMask(
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
                    child: AnimatedDefaultTextStyle(
                      duration: Duration(milliseconds: 200),
                      style: TextStyle(
                        fontSize: isSelected ? 24 : 18,
                        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                        color: Colors.white,
                        letterSpacing: 1.0,
                      ),
                      child: Text(currenciesList[index]),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Cartes de cryptomonnaies
  Widget buildCryptoCard(String crypto) {
    // Génère un décalage aléatoire pour créer un effet de mouvement différent pour chaque carte
    final double offsetValue = math.Random(crypto.hashCode).nextDouble() * 0.3;

    return InkWell(
      onTap: () {
        // Affiche un dialogue avec des informations supplémentaires
        showCryptoDetails(crypto);
      },
      borderRadius: BorderRadius.circular(20),
      splashColor: cryptoColors[crypto]?.withOpacity(0.3),
      highlightColor: cryptoColors[crypto]?.withOpacity(0.1),
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          // Animation décalée pour chaque carte
          final animValue = math.sin((_controller.value + offsetValue) * math.pi * 2) * 0.5 + 0.5;

          return Container(
            margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  cryptoColors[crypto] ?? Theme.of(context).primaryColor,
                  (cryptoColors[crypto] ?? Theme.of(context).primaryColor).withOpacity(0.8),
                ],
              ),
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: (cryptoColors[crypto] ?? Theme.of(context).primaryColor).withOpacity(0.4),
                  blurRadius: 10 + (animValue * 6),
                  offset: Offset(0, 6),
                  spreadRadius: -2,
                ),
              ],
            ),
            child: Stack(
              children: [
                // Symbole en arrière-plan
                Positioned(
                  right: 10,
                  top: 0,
                  bottom: 0,
                  child: Center(
                    child: Text(
                      cryptoSymbols[crypto] ?? "",
                      style: TextStyle(
                        fontSize: 80,
                        color: Colors.white.withOpacity(0.15),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),

                // Contenu principal
                Padding(
                  padding: EdgeInsets.all(20),
                  child: Row(
                    children: [
                      // Logo et nom de la crypto
                      CircleAvatar(
                        backgroundColor: Colors.white24,
                        radius: 24,
                        child: Text(
                          cryptoSymbols[crypto] ?? crypto.substring(0, 1),
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),
                        ),
                      ),
                      SizedBox(width: 15),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
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
                          ? SizedBox(
                        width: 30,
                        height: 30,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2.0,
                        ),
                      )
                          : Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Row(
                            children: [
                              Icon(
                                Icons.arrow_upward,
                                color: Colors.white70,
                                size: 14,
                              ),
                              SizedBox(width: 4),
                              Text(
                                '${cryptoRates[crypto]?.toStringAsFixed(2) ?? '?'}',
                                style: TextStyle(
                                  fontSize: 22,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
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
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  // Dialogue d'informations détaillées sur la crypto
  void showCryptoDetails(String crypto) {
    showModalBottomSheet(
        context: context,
        backgroundColor: Colors.transparent,
        isScrollControlled: true,
        builder: (context) {
          return Container(
            height: MediaQuery.of(context).size.height * 0.6,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 20,
                  spreadRadius: 0,
                  offset: Offset(0, -2),
                ),
              ],
            ),
            child: Column(
              children: [
                // Poignée de glissement
                Container(
                  margin: EdgeInsets.only(top: 12),
                  height: 4,
                  width: 40,
                  decoration: BoxDecoration(
                    color: Colors.grey.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),

                // En-tête
                Padding(
                  padding: EdgeInsets.fromLTRB(20, 20, 20, 10),
                  child: Row(
                    children: [
                      CircleAvatar(
                        backgroundColor: cryptoColors[crypto],
                        radius: 30,
                        child: Text(
                          cryptoSymbols[crypto] ?? crypto.substring(0, 1),
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 24,
                          ),
                        ),
                      ),
                      SizedBox(width: 15),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            cryptoNames[crypto] ?? crypto,
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                          Text(
                            crypto,
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                      Spacer(),
                      Text(
                        '${cryptoRates[crypto]?.toStringAsFixed(2) ?? '?'} $selectedCurrency',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: cryptoColors[crypto],
                        ),
                      ),
                    ],
                  ),
                ),

                Divider(height: 30),

                // Contenu
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'À propos',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      SizedBox(height: 10),
                      Text(
                        cryptoDescriptions[crypto] ?? 'Cryptomonnaie populaire basée sur la blockchain.',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.black54,
                          height: 1.5,
                        ),
                      ),

                      SizedBox(height: 24),

                      Text(
                        'Statistiques',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      SizedBox(height: 16),

                      // Statistiques fictives
                      buildStatItem(
                          Icons.show_chart,
                          'Capitalisation',
                          crypto == 'BTC' ? '850 Milliards USD' :
                          crypto == 'ETH' ? '320 Milliards USD' :
                          '10 Milliards USD'
                      ),

                      buildStatItem(
                          Icons.trending_up,
                          'Volume (24h)',
                          crypto == 'BTC' ? '28 Milliards USD' :
                          crypto == 'ETH' ? '15 Milliards USD' :
                          '1.2 Milliards USD'
                      ),

                      buildStatItem(
                          Icons.stacked_line_chart,
                          'Variation (24h)',
                          crypto == 'BTC' ? '+2.4%' :
                          crypto == 'ETH' ? '+3.5%' :
                          '+1.8%',
                          valueColor: Colors.green
                      ),
                    ],
                  ),
                ),

                Spacer(),

                // Bouton
                Padding(
                  padding: EdgeInsets.all(24),
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: cryptoColors[crypto],
                      foregroundColor: Colors.white,
                      padding: EdgeInsets.symmetric(vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      elevation: 0,
                    ),
                    child: Center(
                      child: Text(
                        'Fermer',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        }
    );
  }

  // Élément de statistique pour la fiche détaillée
  Widget buildStatItem(IconData icon, String label, String value, {Color? valueColor}) {
    return Padding(
      padding: EdgeInsets.only(bottom: 16),
      child: Row(
        children: [
          Icon(icon, color: Colors.grey.shade600, size: 20),
          SizedBox(width: 12),
          Text(
            label,
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey.shade700,
            ),
          ),
          Spacer(),
          Text(
            value,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: valueColor ?? Colors.black87,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF8FAFF),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: RichText(
          text: TextSpan(
            children: [
              TextSpan(
                text: 'Crypto',
                style: TextStyle(
                  color: Color(0xFF1A73E8),
                  fontWeight: FontWeight.bold,
                  fontSize: 22,
                ),
              ),
              TextSpan(
                text: 'Tracker',
                style: TextStyle(
                  color: Colors.black54,
                  fontWeight: FontWeight.w500,
                  fontSize: 22,
                ),
              ),
            ],
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh, color: Color(0xFF1A73E8)),
            onPressed: getCryptoData,
            tooltip: 'Actualiser les prix',
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: <Widget>[
            // En-tête avec date
            Padding(
              padding: EdgeInsets.fromLTRB(20, 10, 20, 5),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.access_time,
                    size: 16,
                    color: Colors.grey.shade600,
                  ),
                  SizedBox(width: 6),
                  Text(
                    '${DateTime.now().day}/${DateTime.now().month}/${DateTime.now().year} - ${DateTime.now().hour}:${DateTime.now().minute < 10 ? '0${DateTime.now().minute}' : DateTime.now().minute}',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ],
              ),
            ),

            // Cartes des cryptomonnaies
            Expanded(
              child: ListView(
                padding: EdgeInsets.symmetric(vertical: 10),
                physics: BouncingScrollPhysics(),
                children: cryptoList.map((crypto) => buildCryptoCard(crypto)).toList(),
              ),
            ),

            // Sélecteur de devise
            Padding(
              padding: EdgeInsets.only(top: 5, bottom: 20),
              child: Column(
                children: [
                  Text(
                    'Faire défiler pour changer de devise',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey.shade600,
                    ),
                  ),
                  SizedBox(height: 10),
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