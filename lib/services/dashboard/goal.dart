import 'dart:convert';
import 'dart:developer' as developer;

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';

import '../../utils/network_util.dart';
import '../../utils/utils.dart';
import '../authentication.dart' as authentication;
import '../../constants/constants.dart' as constants;
import 'common/dashboard-utils.dart' as dashboardUtils;
import '../../models/user.dart';
import '../../models/goal/goal_type.dart';
import '../../models/goal/target_type.dart';

class GoalRestData {
  NetworkUtil _netUtil = new NetworkUtil();

  /// Create storage
  final _storage = new FlutterSecureStorage();
  static final _goalURL = authentication.baseURL + "/goals";

  /// Get Goals
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

    // JSON for Get goal [_jsonForGetGoal]
    Map<String, dynamic> _jsonForGetGoal = {
      "startsWithDate": _startsWithDate,
      "endsWithDate": _endsWithDate
    };

    /// Ensure that the wallet is chosen if not empty
    /// If not then use userid
    if (isNotEmpty(_defaultWallet)) {
      _jsonForGetGoal["walletId"] = _defaultWallet;
    } else {
      _jsonForGetGoal["userId"] = _user["userid"];
    }

    developer
        .log("The Map for getting the goal is  ${_jsonForGetGoal.toString()}");

    return _netUtil
        .post(_goalURL,
            body: jsonEncode(_jsonForGetGoal), headers: authentication.headers)
        .then((dynamic res) {
      debugPrint('The response from the goal is $res');
    });
  }

  /// Update Budget
  Future<void> update(
      String budgetId, String walletId, String dateMeantFor, String category,
      {String categoryType}) {
    // JSON for Get budget [_jsonForGetBudget]
    Map<String, dynamic> _jsonForGetBudget = {
      'budgetId': budgetId,
      'walletId': walletId,
      'dateMeantFor': dateMeantFor,
      'category': category
    };

    if (isNotEmpty(categoryType)) {
      _jsonForGetBudget["categoryType"] = categoryType;
    }

    developer.log(
        "The Map for patching the budget is  ${_jsonForGetBudget.toString()}");

    return _netUtil
        .patch(_goalURL,
            body: jsonEncode(_jsonForGetBudget),
            headers: authentication.headers)
        .then((dynamic res) {
      debugPrint('The response from the budget is $res');
    });
  }

  /// Add Goal
  Future<void> add(
      String walletId,
      GoalType goalType,
      TargetType targetType,
      String monthlyContribution,
      String targetAmount,
      String targetDate,
      String targetId) {
    // JSON for Add Goal [_jsonForAddGoal]
    Map<String, dynamic> _jsonForAddGoal = {
      'walletId': walletId,
      'goalType': goalType,
      'targetType': targetType,
      'monthlyContribution': monthlyContribution,
      'targetAmount': targetAmount,
      'targetDate': targetDate,
      'targetId': targetId
    };

    return _netUtil
        .put(_goalURL,
            body: jsonEncode(_jsonForAddGoal), headers: authentication.headers)
        .then((dynamic res) {
      debugPrint('The response from the goal is $res');
    });
  }
}
