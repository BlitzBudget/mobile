import 'dart:convert';
import 'dart:developer' as developer;

import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../model/user.dart';
import '../../../utils/network_helper.dart';
import '../../app/constants/constants.dart' as constants;
import '../../data/model/wallet/wallet.dart';
import '../../utils/utils.dart';
import '../datasource/remote/authentication_remote_data_source.dart'
    as authentication;

abstract class WalletRemoteDataSource {
  Future<void> get();

  Future<void> update(Wallet updateWallet);

  Future<void> delete(String walletId, String userId);

  Future<void> add(String userId, String currency);
}

class _WalletRemoteDataSourceImpl implements WalletRemoteDataSource {
  NetworkUtil _netUtil = new NetworkUtil();

  /// Create storage
  final _storage = new FlutterSecureStorage();
  static final _walletURL = authentication.baseURL + "/wallet";

  /// Get Wallet
  @override
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
      //TODO
    });
  }

  /// Update Wallet
  @override
  Future<void> update(Wallet updateWallet) {
    developer
        .log("The Map for patching the budget is  ${updateWallet.toString()}");

    return _netUtil
        .patch(_walletURL,
            body: jsonEncode(updateWallet.toJSON()),
            headers: authentication.headers)
        .then((dynamic res) {
      debugPrint('The response from the budget is $res');
      //TODO
    });
  }

  /// Delete Wallet
  @override
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
      //TODO
    });
  }

  /// Add Wallet
  @override
  Future<void> add(String userId, String currency) {
    // JSON for Get budget [_jsonForAddWallet]
    Map<String, dynamic> _jsonForAddWallet = {
      'userId': userId,
      'currency': currency,
    };

    return _netUtil
        .put(_walletURL,
            body: jsonEncode(_jsonForAddWallet),
            headers: authentication.headers)
        .then((dynamic res) {
      debugPrint('The response from the budget is $res');
      //TODO
    });
  }
}
