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
import '../../models/transaction/transaction.dart';

class TransactionRestData {
  NetworkUtil _netUtil = new NetworkUtil();

  /// Create storage
  final _storage = new FlutterSecureStorage();
  static final _transactionURL = authentication.baseURL + "/transactions";

  /// Get Transaction
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

    // JSON for Get transaction [_jsonForGetTransaction]
    Map<String, dynamic> _jsonForGetTransaction = {
      "startsWithDate": _startsWithDate,
      "endsWithDate": _endsWithDate
    };

    /// Ensure that the wallet is chosen if not empty
    /// If not then use userid
    if (isNotEmpty(_defaultWallet)) {
      _jsonForGetTransaction["walletId"] = _defaultWallet;
    } else {
      _jsonForGetTransaction["userId"] = _user["userid"];
    }

    developer.log(
        "The Map for getting the transaction is  ${_jsonForGetTransaction.toString()}");

    return _netUtil
        .post(_transactionURL,
            body: jsonEncode(_jsonForGetTransaction),
            headers: authentication.headers)
        .then((dynamic res) {
      debugPrint('The response from the transaction is $res');
            //TODO
    });
  }

  /// Update Transaction
  Future<void> update(Transaction updateTransaction) {
    developer.log(
        "The Map for patching the transaction is  ${updateTransaction.toString()}");

    return _netUtil
        .patch(_transactionURL,
            body: jsonEncode(updateTransaction.toJSON()),
            headers: authentication.headers)
        .then((dynamic res) {
      debugPrint('The response from the transaction is $res');
            //TODO
    });
  }

  /// Add Transaction
  Future<void> add(Transaction addTransaction) {
    return _netUtil
        .put(_transactionURL,
            body: jsonEncode(addTransaction.toJSON()),
            headers: authentication.headers)
        .then((dynamic res) {
      debugPrint('The response from the transaction is $res');
            //TODO
    });
  }
}
