import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_lorem/flutter_lorem.dart';
import 'package:mdi/mdi.dart';

import '../../../utils/utils.dart';
import '../../../utils/widgets.dart';
import '../../../data/dashboard/budget.dart';

class BudgetTab extends StatefulWidget {
  static const title = 'Budget';
  static const androidIcon = Icon(Mdi.sack);
  static const iosIcon = Icon(Mdi.sack);

  @override
  _BudgetTabState createState() => _BudgetTabState();
}

class _BudgetTabState extends State<BudgetTab> {
  /// States
  static const _itemsLength = 20;
  BudgetRestData _budgetRestData = BudgetRestData();

  List<Color> colors;
  List<String> titles;
  List<String> contents;

  @override
  void initState() {
    colors = getRandomColors(_itemsLength);
    titles = List.generate(_itemsLength, (index) => generateRandomHeadline());
    contents =
        List.generate(_itemsLength, (index) => lorem(paragraphs: 1, words: 24));
    super.initState();
  }

  Widget _listBuilder(BuildContext context, int index) {
    if (index >= _itemsLength) return null;

    return SafeArea(
      top: false,
      bottom: false,
      child: Card(
        elevation: 1.5,
        margin: EdgeInsets.fromLTRB(6, 12, 6, 0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(4),
        ),
        child: InkWell(
          /// Make it splash on Android. It would happen automatically if this
          /// was a real card but this is just a demo. Skip the splash on iOS.
          onTap: defaultTargetPlatform == TargetPlatform.iOS ? null : () {},
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  backgroundColor: colors[index],
                  child: Text(
                    titles[index].substring(0, 1),
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                Padding(padding: EdgeInsets.only(left: 16)),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        titles[index],
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Padding(padding: EdgeInsets.only(top: 8)),
                      Text(
                        contents[index],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// ===========================================================================
  /// Non-shared code below because this tab uses different scaffolds.
  /// ===========================================================================

  Widget _buildAndroid(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(BudgetTab.title),
      ),
      body: Container(
        child: ListView.builder(
          itemBuilder: _listBuilder,
        ),
      ),
    );
  }

  Widget _buildIos(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(),
      child: ListView.builder(
        itemBuilder: _listBuilder,
      ),
    );
  }

  @override
  Widget build(context) {
    // Get Budget Data
    _getBudgetData();

    debugPrint("The Budget tab has been clicked");

    return PlatformWidget(
      androidBuilder: _buildAndroid,
      iosBuilder: _buildIos,
    );
  }

  /// Get budget data
  void _getBudgetData() async {
    await _budgetRestData.get();
  }
}
