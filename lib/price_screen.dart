import 'package:coin_tracker/models/coin_model.dart';
import 'package:coin_tracker/utilities/coin_data.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'dart:io' show Platform;

class PriceScreen extends StatefulWidget {
  @override
  _PriceScreenState createState() => _PriceScreenState();
}

class _PriceScreenState extends State<PriceScreen> {
  String selectedCurrency = 'USD';

  //TODO: 2. Remove everything from the coinsList
  List<CoinModel> coinsList = [];

  //TODO: 3. Create a function of type Future, called getCoinsValue
  Future getCoinsValue() async {
    //TODO: 3.1 Use a try and catch block just make sure the code won't crash your app. Use the following links to learn more about Exception Handling in Dart.
    // https://medium.com/run-dart/dart-dartlang-introduction-exception-handling-f9f088906f7c
    // https://www.tutorialspoint.com/dart_programming/dart_programming_exceptions.htm
    try {

      //TODO: 3.2 create a variable called data and assign it to what getCoinData from CoinData class returns
      CoinData coinData = CoinData();
      var data = await coinData.getCoinData(selectedCurrency);

      //TODO: 3.3 If the data was not null, call the setState function, and inside the function assign data to the coins List.
      if (data==null){
        setState((){
          coinsList = data;
          return;
        });
      }
    } catch(e){
      print(e);
    }
  }

  //TODO: 4. override the initState function, and inside the function call the getCoinsValue function.
  @override
  void initState() {
    super.initState();
    getCoinsValue();
  }

  CupertinoPicker getCupertinoPicker() {
    List<Text> pickerItems = [];
    for (String currency in currenciesList) {
      pickerItems.add(Text(currency));
    }
    return CupertinoPicker(
      itemExtent: 32,
      onSelectedItemChanged: (selectedIndex) {
        //TODO: 6. Call the getCoinsValue, when an item is selected from the picker
        setState(() {
          selectedCurrency = currenciesList[selectedIndex];
          //TODO: 5. Call the getCoinsValue, when an item is selected from the dropdown menu
          getCoinsValue();
        });
      },
      children: pickerItems,
    );
  }

  InputDecorator getDropdownButton() {
    List<DropdownMenuItem<String>> dropdownItems = [];
    for (String currency in currenciesList) {
      var newItem = DropdownMenuItem(
        child: Text(currency),
        value: currency,
      );
      dropdownItems.add(newItem);
    }

    return InputDecorator(
      decoration: const InputDecoration(
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.white24),
        ),
        contentPadding: EdgeInsets.symmetric(horizontal: 16),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          isExpanded: true,
          value: selectedCurrency,
          items: dropdownItems,
          onChanged: (value) {
            setState(() {
              selectedCurrency = value!;
              //TODO: 5. Call the getCoinsValue, when an item is selected from the dropdown menu
              getCoinsValue();
            });
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Expanded(
                flex: 5,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset('images/coin.png', width: 100),
                    const SizedBox(height: 16),
                    const Text(
                      'Coin Tracker',
                      style: TextStyle(fontSize: 28),
                    ),
                  ],
                )),
            Expanded(
              flex: 6,
              child: ListView.separated(
                itemBuilder: (BuildContext context, int index) {
                  return ListTile(
                    leading: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Image.asset(
                          //TODO: 7. use toLowerCase function on icon to lower case the icon name
                          'images/${coinsList[index].icon.toLowerCase()}.png',
                          width: 60,
                        ),
                        const SizedBox(width: 12),
                        Column(
                          children: [
                            const Text('1', style: TextStyle(fontSize: 18)),
                            Text(
                              coinsList[index].name,
                              style: const TextStyle(color: Colors.white24),
                            ),
                          ],
                        )
                      ],
                    ),
                    trailing: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          NumberFormat("#,###.0")
                              .format(coinsList[index].price),
                          style: const TextStyle(fontSize: 18),
                        ),
                        Text(
                          selectedCurrency,
                          style: const TextStyle(color: Colors.white24),
                        ),
                      ],
                    ),
                  );
                },
                separatorBuilder: (BuildContext context, int index) =>
                    const Divider(),
                itemCount: coinsList.length,
              ),
            ),
            Container(
              padding:
                  EdgeInsets.symmetric(horizontal: Platform.isIOS ? 0 : 8.0),
              height: Platform.isIOS ? 150 : 60,
              child:
                  Platform.isIOS ? getCupertinoPicker() : getDropdownButton(),
            ),
          ],
        ),
      ),
    );
  }
}
