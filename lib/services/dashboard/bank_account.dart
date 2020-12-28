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

class BankAccountRestData {
  NetworkUtil _netUtil = new NetworkUtil();

  /// Create storage
  final _storage = new FlutterSecureStorage();
  static final _bankAccountURL = authentication.baseURL + "/bank-accounts";

  /// Update BankAccount
  Future<void> update(String bankAccountId, String walletId,
      String dateMeantFor, String category,
      {String categoryType, String plannedAmount}) {
    // JSON for Get bankAccount [_jsonForUpdateBankAccount]
    Map<String, dynamic> _jsonForUpdateBankAccount = {
      'bankAccountId': bankAccountId,
      'walletId': walletId,
      'dateMeantFor': dateMeantFor,
      'category': category
    };

    if (isNotEmpty(categoryType)) {
      _jsonForUpdateBankAccount["categoryType"] = categoryType;
    }

    if (isNotEmpty(plannedAmount)) {
      _jsonForUpdateBankAccount["planned"] = plannedAmount;
    }

    developer.log(
        "The Map for patching the bankAccount is  ${_jsonForUpdateBankAccount.toString()}");

    return _netUtil
        .patch(_bankAccountURL,
            body: jsonEncode(_jsonForUpdateBankAccount),
            headers: authentication.headers)
        .then((dynamic res) {
      debugPrint('The response from the bankAccount is $res');
    });
  }

  /// Add BankAccount
  Future<void> add(String walletId, String dateMeantFor, String category,
      {String categoryType}) {
    // JSON for Get bankAccount [_jsonForAddBankAccount]
    Map<String, dynamic> _jsonForAddBankAccount = {
      'walletId': walletId,
      'dateMeantFor': dateMeantFor,
      'category': category,
      'planned': 0,
    };

    if (isNotEmpty(categoryType)) {
      _jsonForAddBankAccount["categoryType"] = categoryType;
    }

    return _netUtil
        .put(_bankAccountURL,
            body: jsonEncode(_jsonForAddBankAccount),
            headers: authentication.headers)
        .then((dynamic res) {
      debugPrint('The response from the bankAccount is $res');
    });
  }
}
