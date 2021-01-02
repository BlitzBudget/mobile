import 'dart:convert';
import 'dart:developer' as developer;

import 'package:flutter/foundation.dart';
import 'package:mobile_blitzbudget/core/network/http_client.dart';
import 'package:mobile_blitzbudget/data/constants/constants.dart' as constants;
import 'package:mobile_blitzbudget/data/model/wallet/wallet_model.dart';
import 'package:mobile_blitzbudget/utils/utils.dart';

abstract class WalletRemoteDataSource {
  Future<void> get(String startsWithDate, String endsWithDate,
      String defaultWallet, String userId);

  Future<void> update(WalletModel updateWallet);

  Future<void> delete(String walletId, String userId);

  Future<void> add(String userId, String currency);
}

class WalletRemoteDataSourceImpl implements WalletRemoteDataSource {
  final HTTPClient httpClient;

  WalletRemoteDataSourceImpl({@required this.httpClient});

  /// Get Wallet
  @override
  Future<List<WalletModel>> get(String startsWithDate, String endsWithDate,
      String defaultWallet, String userId) async {
    var contentBody = <String, dynamic>{
      'startsWithDate': startsWithDate,
      'endsWithDate': endsWithDate
    };

    if (isNotEmpty(defaultWallet)) {
      contentBody['walletId'] = defaultWallet;
    } else {
      contentBody['userId'] = userId;
    }
    return httpClient
        .post(constants.walletURL,
            body: jsonEncode(contentBody), headers: constants.headers)
        .then((dynamic res) {
      debugPrint('The response from the wallet is $res');
      //TODO
      return;
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
      debugPrint('The response from the update wallet is $res');
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
      debugPrint('The response from the delete wallet is $res');
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
      debugPrint('The response from the add wallet is $res');
    });
  }
}
