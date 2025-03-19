import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'dart:io' show Platform;
import 'package:flutter/foundation.dart' show kIsWeb;
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
  Map<String, Color> cryptoColors = {
    'BTC': Color(0xFFF7931A), // Bitcoin orange
    'ETH': Color(0xFF627EEA), // Ethereum blue
    'LTC': Color(0xFF345D9D), // Litecoin blue
  };

  Map<String, IconData> cryptoIcons = {
    'BTC': Icons.currency_bitcoin,
    'ETH': Icons.attach_money,
    'LTC': Icons.monetization_on,
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
      print('Error: $e');
      setState(() {
        isLoading = false;
      });

      // Show error snackbar
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to load data. Please try again.'),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
          action: SnackBarAction(
            label: 'Retry',
            textColor: Colors.white,
            onPressed: getCryptoData,
          ),
        ),
      );
    }
  }

  // Scrollable currency picker (for all platforms)
  Widget getScrollablePicker() {
    // Find the index of the currently selected currency
    int selectedIndex = currenciesList.indexOf(selectedCurrency);
    if (selectedIndex < 0) selectedIndex = 0;

    // Create a scroll controller
    FixedExtentScrollController scrollController = FixedExtentScrollController(
        initialItem: selectedIndex
    );

    return Container(
      height: 150,
      width: MediaQuery.of(context).size.width * 0.7,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Theme.of(context).primaryColor.withOpacity(0.7),
            Theme.of(context).colorScheme.secondary.withOpacity(0.7),
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.15),
            blurRadius: 15,
            offset: Offset(0, 5),
            spreadRadius: 1,
          ),
        ],
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Decorative elements
          Positioned(
            top: 10,
            child: Icon(
              Icons.keyboard_arrow_up,
              color: Colors.white.withOpacity(0.7),
              size: 28,
            ),
          ),
          Positioned(
            bottom: 10,
            child: Icon(
              Icons.keyboard_arrow_down,
              color: Colors.white.withOpacity(0.7),
              size: 28,
            ),
          ),

          // Center highlight
          Positioned(
            child: Container(
              height: 50,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                border: Border(
                  top: BorderSide(color: Colors.white.withOpacity(0.5), width: 1),
                  bottom: BorderSide(color: Colors.white.withOpacity(0.5), width: 1),
                ),
              ),
            ),
          ),

          // Wheel list
          ShaderMask(
            shaderCallback: (Rect bounds) {
              return LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.white.withOpacity(0.1),
                  Colors.white,
                  Colors.white,
                  Colors.white.withOpacity(0.1),
                ],
                stops: [0.0, 0.2, 0.8, 1.0],
              ).createShader(bounds);
            },
            blendMode: BlendMode.dstIn,
            child: ListWheelScrollView.useDelegate(
              controller: scrollController,
              itemExtent: 50,
              perspective: 0.004,
              diameterRatio: 1.8,
              physics: FixedExtentScrollPhysics(),
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

                  return Container(
                    margin: EdgeInsets.symmetric(vertical: 5, horizontal: 20),
                    alignment: Alignment.center,
                    child: Text(
                      currenciesList[index],
                      style: TextStyle(
                        fontSize: isSelected ? 24 : 20,
                        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                        color: Colors.white,
                        letterSpacing: 1,
                        shadows: isSelected ? [
                          Shadow(
                            color: Colors.black26,
                            blurRadius: 2,
                            offset: Offset(0, 1),
                          )
                        ] : null,
                      ),
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

  // Helper method to safely determine which picker to show
  Widget getPlatformSpecificPicker() {
    // Always use the scrollable picker now
    return getScrollablePicker();
  }

  // For iOS picker
  CupertinoPicker getIOSPicker() {
    List<Text> pickerItems = [];

    for (String currency in currenciesList) {
      pickerItems.add(
          Text(
            currency,
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
            ),
          )
      );
    }

    return CupertinoPicker(
      backgroundColor: Theme.of(context).primaryColor.withOpacity(0.8),
      itemExtent: 40.0,
      looping: true,
      diameterRatio: 1.1,
      onSelectedItemChanged: (selectedIndex) {
        setState(() {
          selectedCurrency = currenciesList[selectedIndex];
          getCryptoData();
        });
      },
      children: pickerItems,
    );
  }

  // Creates crypto cards
  List<Widget> getCryptoCards() {
    List<Widget> cryptoCards = [];

    for (String crypto in cryptoList) {
      cryptoCards.add(
        AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              return Padding(
                padding: EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 0),
                child: Card(
                  color: cryptoColors[crypto] ?? Theme.of(context).primaryColor,
                  elevation: 5.0 + (_controller.value * 2.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16.0),
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(20.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Icon(
                              cryptoIcons[crypto] ?? Icons.currency_bitcoin,
                              color: Colors.white,
                              size: 28,
                            ),
                            SizedBox(width: 12),
                            Text(
                              '1 $crypto',
                              style: TextStyle(
                                fontSize: 20.0,
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        isLoading
                            ? SizedBox(
                          width: 24,
                          height: 24,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2.0,
                          ),
                        )
                            : Text(
                          '${cryptoRates[crypto]?.toStringAsFixed(2) ?? '?'} $selectedCurrency',
                          style: TextStyle(
                            fontSize: 20.0,
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }
        ),
      );
    }

    return cryptoCards;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.currency_exchange, size: 28),
            SizedBox(width: 10),
            Text(
              'Coin Ticker',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 22,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: getCryptoData,
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            // Header
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                'Live Cryptocurrency Rates',
                style: TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.w500,
                  color: Colors.black87,
                ),
                textAlign: TextAlign.center,
              ),
            ),

            // Crypto rate cards
            Expanded(
              child: ListView(
                physics: BouncingScrollPhysics(),
                children: getCryptoCards(),
              ),
            ),

            // Currency picker section
            Container(
              margin: EdgeInsets.symmetric(vertical: 24.0, horizontal: 16.0),
              child: Column(
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.currency_exchange,
                          size: 20,
                          color: Theme.of(context).primaryColor,
                        ),
                        SizedBox(width: 8),
                        Text(
                          'Sélectionner la devise',
                          style: TextStyle(
                            fontSize: 16.0,
                            fontWeight: FontWeight.w500,
                            color: Theme.of(context).primaryColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 16.0),
                  getPlatformSpecificPicker(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}