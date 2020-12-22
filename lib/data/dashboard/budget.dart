import 'dart:convert';
import 'dart:developer' as developer;

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';

import '../../utils/network_util.dart';
import '../authentication.dart';
import '../../constants.dart';
import '../../models/user.dart';

class BudgetRestData {
  NetworkUtil _netUtil = new NetworkUtil();
  SharedPreferences _prefs = SharedPreferences.getInstance();

  /// Create storage
  final _storage = new FlutterSecureStorage();

  static final _budgetURL = RestDataSource.baseURL + "/budgets";

  /// Get from shared preferences
  final var nowDate = new DateTime.now();
  final var endDate = new DateTime(now.year, now.month + 1, now.day);
  final String defaultWallet = prefs.getString('defaultWallet');
  final int startsWithDate = prefs.getInt('startsWithDate') ?? DateFormat(dateFormatStartAndEndDate).format(nowDate);
  final int endsWithDate = prefs.getInt('endsWithDate') ?? DateFormat(dateFormatStartAndEndDate).format(endDate);

  /// Get Budgets
  Future<void> get() async {
    // Read value
    final String value = await _storage.read(key: userAttributes);
    // Decode the json user
    Map<String, dynamic> user = jsonDecode(value);
    developer.log('User Attributes retrieved for: ${user["userid"]}');

    // JSON for Get budget [jsonForGetBudget]
    Map<String, dynamic> jsonForGetBudget = {
              "startsWithDate": startsWithDate,
              "endsWithDate": endsWithDate
            };

    /// Ensure that the wallet is chosen if not empty
    /// If not then use userid
    if(isNotEmpty(defaultWallet)) {
        jsonForGetBudget["walletId"] = defaultWallet;
    } else {
       jsonForGetBudget["userId"] = user["userid"];
    }

    debugPrint(" The Map for getting the budget is  ${jsonForGetBudget.toString()}");
    /*return _netUtil
        .get(_budgetURL,
            body: jsonEncode(jsonForGetBudget),
            headers: RestDataSource.headers)
        .then((dynamic res) {

        });*/
  }

  /// Update Budget
  Future<void> update() {}

  /// Delete Budget
  Future<void> delete() {}
}
