import 'package:flutter/material.dart';

class ChooseCurrencyList extends StatefulWidget {
  const ChooseCurrencyList({
    Key? key,
  }) : super(key: key);

  @override
  _CurrencyListState createState() => _CurrencyListState();
}

class _CurrencyListState extends State<ChooseCurrencyList> {
  @override
  Widget build(BuildContext context) {
    var dropdownValue = 'One';

    return Scaffold(
        body: Center(
            child: ElevatedButton(
                onPressed: () {},
                child: DropdownButton<String>(
                  value: dropdownValue,
                  icon: const Icon(Icons.arrow_downward),
                  elevation: 16,
                  style: const TextStyle(color: Colors.deepPurple),
                  underline: Container(
                    height: 2,
                    color: Colors.deepPurpleAccent,
                  ),
                  onChanged: (String? newValue) {
                    setState(() {
                      dropdownValue = newValue!;
                    });
                  },
                  items: <String>['One', 'Two', 'Three', 'Four']
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                ))));
  }
}
