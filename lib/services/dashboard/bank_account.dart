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
  static final _deleteBankAccountURL = _bankAccountURL + '/delete';

  /// Update BankAccount
  Future<void> update(BankAccount updateBankAccount) {
    developer.log(
        "The Map for patching the bankAccount is  ${updateBankAccount.toString()}");

    return _netUtil
        .patch(_bankAccountURL,
            body: jsonEncode(updateBankAccount.toJSON()),
            headers: authentication.headers)
        .then((dynamic res) {
      debugPrint('The response from the bankAccount is $res');
            //TODO
    });
  }

  /// Add BankAccount
  Future<void> add(BankAccount addBankAccount) {
    return _netUtil
        .put(_bankAccountURL,
            body: jsonEncode(addBankAccount.toJSON()),
            headers: authentication.headers)
        .then((dynamic res) {
      debugPrint('The response from the bankAccount is $res');
            //TODO
    });
  }

  /// Delete Wallet
  Future<void> delete(String walletId, String account) {
    // JSON for Get wallet [_jsonForGetWallet]
    Map<String, dynamic> _jsonForDeleteCategory = {
      "walletId": walletId,
      "account": account
    };

    return _netUtil
        .post(_deleteBankAccountURL,
            body: jsonEncode(_jsonForDeleteCategory),
            headers: authentication.headers)
        .then((dynamic res) {
      debugPrint('The response from the budget is $res');
            //TODO
    });
  }
}
