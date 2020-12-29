import 'dart:convert';
import 'dart:developer' as developer;

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';

import '../../../utils/network_helper.dart';
import '../../utils/utils.dart';
import '../datasource/remote/authentication_remote_data_source.dart'
    as authentication;
import '../../app/constants/constants.dart' as constants;
import '../../utils/dashboard-utils.dart' as dashboardUtils;
import '../../../model/user.dart';
import '../../data/model/budget/budget.dart';

abstract class BudgetRemoteDataSource {
  Future<void> get();

  Future<void> update(Budget updateBudget);

  Future<void> add(Budget addBudget);
}

class _BudgetRemoteDataSourceImpl implements BudgetRemoteDataSource {
  NetworkUtil _netUtil = new NetworkUtil();

  /// Create storage
  final _storage = new FlutterSecureStorage();
  static final _budgetURL = authentication.baseURL + "/budgets";

  /// Get Budgets
  @override
  Future<void> get() async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();

    /// Get from shared preferences
    final String _defaultWallet = _prefs.getString(constants.defaultWallet);
    final String _startsWithDate =
        await dashboardUtils.fetchStartsWithDate(_prefs);
    final String _endsWithDate = await dashboardUtils.fetchEndsWithDate(_prefs);

    // Read [_userAttributes] from User Attributes
    final String _userAttributes =
        await _storage.read(key: constants.userAttributes);
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

    return _netUtil
        .post(_budgetURL,
            body: jsonEncode(_jsonForGetBudget),
            headers: authentication.headers)
        .then((dynamic res) {
      debugPrint('The response from the budget is $res');
      //TODO
    });
  }

  /// Update Budget
  @override
  Future<void> update(Budget updateBudget) {
    developer
        .log("The Map for patching the budget is  ${updateBudget.toString()}");

    return _netUtil
        .patch(_budgetURL,
            body: jsonEncode(updateBudget.toJSON()),
            headers: authentication.headers)
        .then((dynamic res) {
      debugPrint('The response from the budget is $res');
      //TODO
    });
  }

  /// Add Budget
  @override
  Future<void> add(Budget addBudget) {
    return _netUtil
        .put(_budgetURL,
            body: jsonEncode(addBudget.toJSON()),
            headers: authentication.headers)
        .then((dynamic res) {
      debugPrint('The response from the budget is $res');
      //TODO
    });
  }
}
