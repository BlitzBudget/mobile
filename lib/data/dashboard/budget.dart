import 'dart:convert';
import 'dart:developer' as developer;

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';

import '../../utils/network_util.dart';
import '../../utils/utils.dart';
import '../authentication.dart' as authentication;
import '../../constants.dart';
import '../../models/user.dart';

class BudgetRestData {
  NetworkUtil _netUtil = new NetworkUtil();

  /// Create storage
  final _storage = new FlutterSecureStorage();
  static final _budgetURL = authentication.baseURL + "/budgets";

  /// Get Budgets
  Future<void> get() async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();

    /// Get from shared preferences
    final DateTime _nowDate = new DateTime.now();
    final DateTime _endDate =
        new DateTime(_nowDate.year, _nowDate.month + 1, _nowDate.day);
    final String _defaultWallet = _prefs.getString('defaultWallet');
    final String _startsWithDate = _prefs.getString('startsWithDate') ??
        DateFormat(dateFormatStartAndEndDate).format(_nowDate);
    final String _endsWithDate = _prefs.getString('endsWithDate') ??
        DateFormat(dateFormatStartAndEndDate).format(_endDate);

    // Read [_userAttributes] from User Attributes
    final String _userAttributes = await _storage.read(key: userAttributes);
    // Decode the json user
    Map<String, dynamic> _user = jsonDecode(_userAttributes);
    developer.log('User Attributes retrieved for: ${_user["userid"]}');

    // JSON for Get budget [_jsonForGetBudget]
    Map<String, dynamic> _jsonForGetBudget = {
      "startsWithDate": _startsWithDate,
      "endsWithDate": _endsWithDate
    };

    /// Ensure that the wallet is chosen if not empty
    /// If not then use userid
    if (isNotEmpty(_defaultWallet)) {
      _jsonForGetBudget["walletId"] = _defaultWallet;
    } else {
      _jsonForGetBudget["userId"] = _user["userid"];
    }

    developer.log(
        "The Map for getting the budget is  ${_jsonForGetBudget.toString()}");

    // Set Authorization header
    authentication.headers['Authorization'] =
        await _storage.read(key: authToken);

    developer.log('The response from the budget is ${authentication.headers}');
    return _netUtil
        .post(_budgetURL,
            body: jsonEncode(_jsonForGetBudget),
            headers: authentication.headers)
        .then((dynamic res) {
      debugPrint('The response from the budget is $res');
    });
  }

  /// Update Budget
  Future<void> update() {}

  /// Delete Budget
  Future<void> delete() {}
}
