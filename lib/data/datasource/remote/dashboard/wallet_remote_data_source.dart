import 'dart:convert';
import 'dart:developer' as developer;

import 'package:flutter/foundation.dart';
import 'package:mobile_blitzbudget/core/network/http_client.dart';
import 'package:mobile_blitzbudget/data/constants/constants.dart' as constants;
import 'package:mobile_blitzbudget/data/model/wallet/wallet_model.dart';

abstract class WalletRemoteDataSource {
  Future<void> get(Map<String, dynamic> contentBody);

  Future<void> update(WalletModel updateWallet);

  Future<void> delete(String walletId, String userId);

  Future<void> add(String userId, String currency);
}

class WalletRemoteDataSourceImpl implements WalletRemoteDataSource {
  final HttpClient httpClient;

  WalletRemoteDataSourceImpl(this.httpClient);

  /// Get Wallet
  @override
  Future<void> get(Map<String, dynamic> contentBody) async {
    developer
        .log('The Map for getting the wallet is  ${contentBody.toString()}');

    return httpClient
        .post(constants.walletURL,
            body: jsonEncode(contentBody), headers: constants.headers)
        .then((dynamic res) {
      debugPrint('The response from the wallet is $res');
      //TODO
    });
  }

  /// Update Wallet
  @override
  Future<void> update(WalletModel updateWallet) {
    developer
        .log('The Map for patching the budget is  ${updateWallet.toString()}');

    return httpClient
        .patch(constants.walletURL,
            body: jsonEncode(updateWallet.toJSON()), headers: constants.headers)
        .then((dynamic res) {
      debugPrint('The response from the budget is $res');
      //TODO
    });
  }

  /// Delete Wallet
  @override
  Future<void> delete(String walletId, String userId) {
    // JSON for Get wallet [_jsonForGetWallet]
    var _jsonForDeleteWallet = <String, dynamic>{
      'walletId': walletId,
      'deleteAccount': false,
      'referenceNumber': userId
    };

    return httpClient
        .post(constants.walletURL,
            body: jsonEncode(_jsonForDeleteWallet), headers: constants.headers)
        .then((dynamic res) {
      debugPrint('The response from the budget is $res');
      //TODO
    });
  }

  /// Add Wallet
  @override
  Future<void> add(String userId, String currency) {
    // JSON for Get budget [_jsonForAddWallet]
    var _jsonForAddWallet = <String, dynamic>{
      'userId': userId,
      'currency': currency,
    };

    return httpClient
        .put(constants.walletURL,
            body: jsonEncode(_jsonForAddWallet), headers: constants.headers)
        .then((dynamic res) {
      debugPrint('The response from the budget is $res');
      //TODO
    });
  }
}
