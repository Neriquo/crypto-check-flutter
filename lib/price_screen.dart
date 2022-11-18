import 'package:bitcoin_ticker/coin_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'dart:io' show Platform;
import 'networking.dart';
import 'constants.dart';

class PriceScreen extends StatefulWidget {
  @override
  State<PriceScreen> createState() => _PriceScreenState();
}

class _PriceScreenState extends State<PriceScreen> {



  String selectedCurrency = 'USD';
  double prixBit;
  double prixEth;
  double prixLtc;


  @override
  void initState() {
    super.initState();
    print('init');
    crypto(selectedCurrency);
  }
  void updateUi(var cryptoData, var cryptoData2, var cryptoDataLtc) {
    setState(() {
      if (cryptoData == null) {
        prixBit = 0;
        print(cryptoData);
        return;
      } else {

        prixBit = cryptoData['rate'];
        print(prixBit);
      }

      if (cryptoData2 == null) {
        prixEth = 0;
        print(cryptoData2);
        return;
      } else {

        prixEth = cryptoData2['rate'];
        print(prixEth);
      }

      if (cryptoDataLtc == null) {
        prixLtc = 0;
        print(cryptoDataLtc);
        return;
      } else {

        prixLtc = cryptoDataLtc['rate'];
        print(prixLtc);
      }

      //weatherIcon = weather.getWeatherIcon(id);
      //weatherMessage = weather.getMessage(temp.toInt());
    });
  }

  void crypto(String selectedCurrency) async {
print('crypto');
print('$url/v1/exchangerate/$bitcoin/$selectedCurrency?$apiKey');
      NetworkHelper networkHelper = NetworkHelper(url :
          '$url/v1/exchangerate/$bitcoin/$selectedCurrency?$apiKey'
      );
      var cryptoData = await networkHelper.getData();
      print(cryptoData);
      //updateUi(cryptoData);

      NetworkHelper networkHelper2 = NetworkHelper(url :
         '$url/v1/exchangerate/$ether/$selectedCurrency?$apiKey'
      );
      var cryptoData2 = await networkHelper2.getData();
      print(cryptoData2);

      NetworkHelper networkHelperLtc = NetworkHelper(url :
          '$url/v1/exchangerate/LTC/$selectedCurrency?$apiKey'
      );
      var cryptoDataLtc = await networkHelperLtc.getData();
      print(cryptoDataLtc);
      updateUi(cryptoData, cryptoData2, cryptoDataLtc);
    }


    //Android
    List<DropdownMenuItem> getDropdownItems() {
      List<DropdownMenuItem> dropdownItems = [];
      for (int i = 0; i < currenciesList.length; i++) {
        String currency = currenciesList[i];
        var newItem = DropdownMenuItem(
          child: Text(currency),
          value: currency,
        );

        dropdownItems.add(newItem);
      }
      return dropdownItems;
    }

    DropdownButton androidDropdown() {
      return DropdownButton(items: getDropdownItems(), onChanged: (value) async{
        setState(() {
          selectedCurrency = value;
        });
        await crypto(selectedCurrency);
      }, value: selectedCurrency,);
    }


    //IOS
    List getPickerItems() {
      List<Text> pickerItems = [];

      for (int i = 0; i < currenciesList.length; i++) {
        String currency = currenciesList[i];


        var newItem = Text(currency);

        pickerItems.add(newItem);
      }
      return pickerItems;
    }


    CupertinoPicker iOSPicker() {
      return CupertinoPicker(
        itemExtent: 32,
        onSelectedItemChanged: (value) {
          print(value);
          setState(() {
            //selectedCurrency = value;
          });
        },
        children:
        getPickerItems(),
      );
    }

    @override
    Widget build(BuildContext context) {
      return Scaffold(
        appBar: AppBar(
          title: Text('🤑 Coin Ticker'),
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.fromLTRB(18.0, 18.0, 18.0, 0),
              child: Card(
                color: Colors.lightBlueAccent,
                elevation: 5.0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: Padding(
                  padding: EdgeInsets.symmetric(
                      vertical: 15.0, horizontal: 28.0),
                  child: Text(
                    '1 BTC = ${prixBit.toInt()} $selectedCurrency',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 20.0,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),


            Padding(
              padding: EdgeInsets.fromLTRB(18.0, 18.0, 18.0, 0),
              child: Card(
                color: Colors.lightBlueAccent,
                elevation: 5.0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: Padding(
                  padding: EdgeInsets.symmetric(
                      vertical: 15.0, horizontal: 28.0),
                  child: Text(
                    '1 ETC = ${prixEth.toInt()} $selectedCurrency',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 20.0,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),

            Padding(
              padding: EdgeInsets.fromLTRB(18.0, 18.0, 18.0, 0),
              child: Card(
                color: Colors.lightBlueAccent,
                elevation: 5.0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: Padding(
                  padding: EdgeInsets.symmetric(
                      vertical: 15.0, horizontal: 28.0),
                  child: Text(
                    '1 LTC = ${prixLtc.toInt()} $selectedCurrency',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 20.0,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),


            Container(
              margin: EdgeInsets.fromLTRB(0, 216, 0, 0),
              //alignment: FractionalOffset.bottomCenter,
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

