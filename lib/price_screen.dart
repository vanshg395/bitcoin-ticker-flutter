import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

import 'coin_data.dart';

class PriceScreen extends StatefulWidget {
  @override
  _PriceScreenState createState() => _PriceScreenState();
}

class _PriceScreenState extends State<PriceScreen> {
  String chosenCurrency = 'USD';
  double btcExchangeRate;
  double ethExchangeRate;
  double ltcExchangeRate;

  @override
  void initState() {
    super.initState();
    calculateRate();
  }

  Future<void> calculateRate() async {
    final btcResponse = await http.get(
        'https://apiv2.bitcoinaverage.com/indices/global/ticker/BTC$chosenCurrency');
    final btcResponseBody = json.decode(btcResponse.body);

    final ethResponse = await http.get(
        'https://apiv2.bitcoinaverage.com/indices/global/ticker/ETH$chosenCurrency');
    final ethResponseBody = json.decode(ethResponse.body);

    final ltcResponse = await http.get(
        'https://apiv2.bitcoinaverage.com/indices/global/ticker/LTC$chosenCurrency');
    final ltcResponseBody = json.decode(ltcResponse.body);

    setState(() {
      btcExchangeRate = btcResponseBody['ask'];
      ethExchangeRate = ethResponseBody['ask'];
      ltcExchangeRate = ltcResponseBody['ask'];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Coin Ticker'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Column(
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
                    padding:
                        EdgeInsets.symmetric(vertical: 15.0, horizontal: 28.0),
                    child: Text(
                      '1 BTC = ${btcExchangeRate ?? '?'} $chosenCurrency',
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
                    padding:
                        EdgeInsets.symmetric(vertical: 15.0, horizontal: 28.0),
                    child: Text(
                      '1 ETH = ${ethExchangeRate ?? '?'} $chosenCurrency',
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
                    padding:
                        EdgeInsets.symmetric(vertical: 15.0, horizontal: 28.0),
                    child: Text(
                      '1 LTC = ${ltcExchangeRate ?? '?'} $chosenCurrency',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 20.0,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          Container(
            height: 150.0,
            alignment: Alignment.center,
            padding: EdgeInsets.only(bottom: 30.0),
            color: Colors.lightBlue,
            child: Platform.isAndroid
                ? DropdownButton(
                    value: chosenCurrency,
                    items: currenciesList.map((currency) {
                      return DropdownMenuItem(
                        child: Text(currency),
                        value: currency,
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        chosenCurrency = value;
                        calculateRate();
                      });
                    },
                  )
                : CupertinoPicker(
                    scrollController:
                        FixedExtentScrollController(initialItem: 19),
                    backgroundColor: Colors.lightBlue,
                    itemExtent: 30,
                    onSelectedItemChanged: (value) {
                      chosenCurrency = currenciesList[value];
                      calculateRate();
                    },
                    children: currenciesList
                        .map((currency) => Text(currency))
                        .toList(),
                  ),
          ),
        ],
      ),
    );
  }
}
