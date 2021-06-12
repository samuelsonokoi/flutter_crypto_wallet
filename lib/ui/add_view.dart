import 'package:crypto_wallet/net/flutterfire.dart';
import 'package:flutter/material.dart';

import 'home_page.dart';

class AddView extends StatefulWidget {
  AddView({Key? key}) : super(key: key);

  @override
  _AddViewState createState() => _AddViewState();
}

class _AddViewState extends State<AddView> {
  // define the list of coins
  List<String> coins = [
    'bitcoin',
    'ethereum',
    'dogecoin',
    'tether',
  ];

  // default dropdown value
  String dropdownValue = 'bitcoin';

  // text editing controller
  TextEditingController _amountController = TextEditingController();

  var shouldNavigate;

  @override
  Widget build(BuildContext context) {
    return Material(
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              DropdownButton<String>(
                items: coins.map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                value: dropdownValue,
                onChanged: (String? value) => {
                  setState(() {
                    dropdownValue = value!;
                  })
                },
              ),
              Container(
                width: MediaQuery.of(context).size.width / 1.3,
                child: TextFormField(
                  controller: _amountController,
                  decoration: InputDecoration(
                    labelText: 'Coin Amount',
                    labelStyle: TextStyle(
                      color: Colors.blue,
                      fontSize: 25,
                    ),
                  ),
                  keyboardType: TextInputType.numberWithOptions(),
                  style: TextStyle(
                    color: Colors.blue,
                    fontSize: 30,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Container(
                width: MediaQuery.of(context).size.width / 3.5,
                height: 45,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.blue,
                ),
                child: MaterialButton(
                  onPressed: () async => {
                    // display spinner while loading
                    Center(
                      child: CircularProgressIndicator(),
                    ),
                    // perform addCoin action
                    await addCoin(dropdownValue, _amountController.text),
                    // navigate to home page if successful.
                    Navigator.of(context).pop(context),
                  },
                  child: Text(
                    'Add',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                    ),
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
