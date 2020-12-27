import 'dart:convert';
import 'dart:developer' as developer;

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';

import '../../utils/network_util.dart';
import '../../utils/utils.dart';
import '../authentication.dart' as authentication;
import '../../constants.dart' as constants;
import 'common/dashboard-utils.dart' as dashboardUtils;
import '../../models/user.dart';

class WalletRestData {
  NetworkUtil _netUtil = new NetworkUtil();

  /// Create storage
  final _storage = new FlutterSecureStorage();
  static final _walletURL = authentication.baseURL + "/wallet";

  /// Get Wallet
  Future<void> get() async {
    // Read [_userAttributes] from User Attributes
    final String _userAttributes =
        await _storage.read(key: constants.userAttributes);
    // Decode the json user
    Map<String, dynamic> _user = jsonDecode(_userAttributes);
    developer.log('User Attributes retrieved for: ${_user["userid"]}');

    // JSON for Get wallet [_jsonForGetWallet]
    Map<String, dynamic> _jsonForGetWallet = {
      "userId": _user["userid"],
    };

    developer.log(
        "The Map for getting the wallet is  ${_jsonForGetWallet.toString()}");

    return _netUtil
        .post(_walletURL,
            body: jsonEncode(_jsonForGetWallet),
            headers: authentication.headers)
        .then((dynamic res) {
      debugPrint('The response from the wallet is $res');
    });
  }

  /// Update Wallet
  Future<void> update(String walletId, String userId,
      {String name, String currency}) {
    // JSON for Get budget [_jsonForUpdateWallet]
    Map<String, dynamic> _jsonForUpdateWallet = {
      'walletId': walletId,
      'userId': userId
    };

    if (isNotEmpty(name)) {
      _jsonForUpdateWallet["name"] = name;
    }

    if (isNotEmpty(currency)) {
      _jsonForUpdateWallet["currency"] = currency;
    }

    developer.log(
        "The Map for patching the budget is  ${_jsonForUpdateWallet.toString()}");

    return _netUtil
        .patch(_walletURL,
            body: jsonEncode(_jsonForUpdateWallet),
            headers: authentication.headers)
        .then((dynamic res) {
      debugPrint('The response from the budget is $res');
    });
  }

  /// Delete Wallet
  Future<void> delete(String walletId, String userId) {
    // JSON for Get wallet [_jsonForGetWallet]
    Map<String, dynamic> _jsonForDeleteWallet = {
      "walletId": walletId,
      "deleteAccount": false,
      "referenceNumber": userId
    };

    return _netUtil
        .post(_walletURL,
            body: jsonEncode(_jsonForDeleteWallet),
            headers: authentication.headers)
        .then((dynamic res) {
      debugPrint('The response from the budget is $res');
    });
  }
}
