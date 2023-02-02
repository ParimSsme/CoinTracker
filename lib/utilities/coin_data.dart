import 'dart:convert';
import '../constants.dart';
import '../models/coin_model.dart';
import 'package:http/http.dart' as http;

const List<String> currenciesList = [
  'AUD',
  'BRL',
  'CAD',
  'CNY',
  'EUR',
  'GBP',
  'HKD',
  'IDR',
  'ILS',
  'INR',
  'JPY',
  'MXN',
  'NOK',
  'NZD',
  'PLN',
  'RON',
  'RUB',
  'SEK',
  'SGD',
  'USD',
  'ZAR'
];

const List<String> cryptoList = [
  'BTC/Bitcoin',
  'ETH/Ethereum',
  'LTC/Litecoin',
];

class CoinData {
  //This function is used to retrieve the exchange rates for each every coin, including bitcoin, ether, and litecoin
  Future<dynamic> getCoinData(String currency) async {

    List<CoinModel> cryptoPrices = [];

    for (String crypto in cryptoList) {

      http.Response response = await http.get(Uri.parse("$kBaseURL${crypto.split("/")[0]}/$currency?apikey=$kAPIKey"));

      if (response.statusCode == 200) {

        var data = await jsonDecode(response.body);

        CoinModel model = CoinModel(
            icon: crypto.split("/")[0],
            name: crypto.split("/")[1],
            price: data["rate"]
        );

        cryptoPrices.add(model);

      } else {
        print(response.statusCode);
      }
    }

    return cryptoPrices;
  }
}
