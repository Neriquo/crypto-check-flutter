import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'coin_data.dart';

class PriceScreen extends StatefulWidget {
  @override
  _PriceScreenState createState() => _PriceScreenState();
}

class _PriceScreenState extends State<PriceScreen> {
  String selectedCurrency = 'USD';
  Map<String, double?> cryptoRates = {};
  bool isLoading = false;

  CoinData coinData = CoinData();

  @override
  void initState() {
    super.initState();
    getCryptoData();
  }

  void getCryptoData() async {
    setState(() {
      isLoading = true;
    });

    try {
      Map<String, double?> rates = await coinData.getAllCryptoRates(selectedCurrency);

      setState(() {
        cryptoRates = rates;
        isLoading = false;
      });
    } catch (e) {
      print('Error: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  Widget _buildCurrencyPicker() {
    if (Platform.isIOS) {
      return Container(
        height: 120.0,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20.0),
            topRight: Radius.circular(20.0),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 10,
              offset: Offset(0, -5),
            ),
          ],
        ),
        child: CupertinoPicker(
          backgroundColor: Colors.white,
          itemExtent: 32,
          onSelectedItemChanged: (selectedIndex) {
            setState(() {
              selectedCurrency = currenciesList[selectedIndex];
              getCryptoData();
            });
          },
          children: currenciesList.map((currency) => Text(
            currency,
            style: TextStyle(
              color: Colors.black87,
              fontWeight: FontWeight.w600,
            ),
          )).toList(),
        ),
      );
    } else {
      return Container(
        padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 5.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(30.0),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 5,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: DropdownButtonHideUnderline(
          child: DropdownButton<String>(
            value: selectedCurrency,
            icon: Icon(
              Icons.keyboard_arrow_down_rounded,
              color: Colors.lightBlue,
            ),
            elevation: 16,
            style: TextStyle(color: Colors.black87, fontWeight: FontWeight.w600),
            items: currenciesList.map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
            onChanged: (String? value) {
              setState(() {
                selectedCurrency = value!;
                getCryptoData();
              });
            },
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF1A237E), Color(0xFF0D47A1)],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: <Widget>[
              // Header
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Coin Ticker',
                      style: TextStyle(
                        fontSize: 28.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    _buildCurrencyPicker(),
                  ],
                ),
              ),

              // Date and refresh button
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Dernière mise à jour: ${DateTime.now().day}/${DateTime.now().month}/${DateTime.now().year}',
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 14.0,
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.refresh, color: Colors.white),
                      onPressed: getCryptoData,
                    ),
                  ],
                ),
              ),

              SizedBox(height: 20.0),

              // Crypto cards
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30.0),
                      topRight: Radius.circular(30.0),
                    ),
                  ),
                  child: isLoading
                      ? Center(
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
                    ),
                  )
                      : ListView(
                    padding: EdgeInsets.all(20.0),
                    children: cryptoList.map((crypto) {
                      return CryptoCard(
                        cryptoCurrency: crypto,
                        selectedCurrency: selectedCurrency,
                        rate: cryptoRates[crypto],
                        isLoading: isLoading,
                      );
                    }).toList(),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CryptoCard extends StatelessWidget {
  const CryptoCard({
    required this.cryptoCurrency,
    required this.selectedCurrency,
    required this.rate,
    required this.isLoading,
  });

  final String cryptoCurrency;
  final String selectedCurrency;
  final double? rate;
  final bool isLoading;

  Color _getCardColor() {
    switch (cryptoCurrency) {
      case 'BTC':
        return Color(0xFFF7931A);
      case 'ETH':
        return Color(0xFF627EEA);
      case 'LTC':
        return Color(0xFF345D9D);
      default:
        return Color(0xFF3F51B5);
    }
  }

  String _getCryptoIcon() {
    switch (cryptoCurrency) {
      case 'BTC':
        return '₿';
      case 'ETH':
        return 'Ξ';
      case 'LTC':
        return 'Ł';
      default:
        return '₡';
    }
  }

  String _getCryptoName() {
    switch (cryptoCurrency) {
      case 'BTC':
        return 'Bitcoin';
      case 'ETH':
        return 'Ethereum';
      case 'LTC':
        return 'Litecoin';
      default:
        return cryptoCurrency;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 15.0),
      child: Card(
        elevation: 8.0,
        shadowColor: _getCardColor().withOpacity(0.3),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0),
        ),
        child: Container(
          padding: EdgeInsets.all(20.0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20.0),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Colors.white,
                _getCardColor().withOpacity(0.15),
              ],
            ),
          ),
          child: Row(
            children: [
              // Crypto icon
              Container(
                width: 60.0,
                height: 60.0,
                decoration: BoxDecoration(
                  color: _getCardColor(),
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(
                    _getCryptoIcon(),
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 28.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              SizedBox(width: 15.0),
              // Crypto details
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _getCryptoName(),
                      style: TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    SizedBox(height: 5.0),
                    Text(
                      cryptoCurrency,
                      style: TextStyle(
                        fontSize: 14.0,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),
              // Price
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    isLoading
                        ? '...'
                        : '${rate?.toStringAsFixed(2) ?? 'Erreur'}',
                    style: TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  SizedBox(height: 5.0),
                  Text(
                    selectedCurrency,
                    style: TextStyle(
                      fontSize: 14.0,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}