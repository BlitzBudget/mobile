import 'dart:convert';
import 'dart:developer' as developer;

import 'package:flutter/foundation.dart';
import 'package:mobile_blitzbudget/core/network/http_client.dart';
import 'package:mobile_blitzbudget/core/utils/utils.dart';
import 'package:mobile_blitzbudget/data/constants/constants.dart' as constants;
import 'package:mobile_blitzbudget/data/model/response/dashboard/wallet_response_model.dart';
import 'package:mobile_blitzbudget/data/model/wallet/wallet_model.dart';

abstract class WalletRemoteDataSource {
  Future<WalletResponseModel> fetch(
      {required String startsWithDate,
      required String endsWithDate,
      required String? defaultWallet});

  Future<void> update(WalletModel updateWallet);

  Future<void> delete({required String walletId, required String? userId});

  Future<void> add(
      {required String? userId,
      required String? currency,
      required String? name});
}

class WalletRemoteDataSourceImpl implements WalletRemoteDataSource {
  WalletRemoteDataSourceImpl({required this.httpClient});

  final HTTPClient? httpClient;

  /// Get Wallet
  @override
  Future<WalletResponseModel> fetch(
      {required String startsWithDate,
      required String endsWithDate,
      required String? defaultWallet}) async {
    final contentBody = <String, dynamic>{
      'starts_with_date': startsWithDate,
      'ends_with_date': endsWithDate
    };

    if (isNotEmpty(defaultWallet)) {
      contentBody['pk'] = defaultWallet;
    }

    return httpClient!
        .post(constants.walletURL,
            body: jsonEncode(contentBody), headers: constants.headers)
        .then<WalletResponseModel>((dynamic res) {
      debugPrint('The response from the wallet is $res');
      return WalletResponseModel.fromJSON(res);
    });
  }

  /// Update Wallet
  @override
  Future<void> update(WalletModel updateWallet) {
    developer
        .log('The Map for patching the budget is  ${updateWallet.toString()}');

    return httpClient!
        .patch(constants.walletURL,
            body: jsonEncode(updateWallet.toJSON()), headers: constants.headers)
        .then((dynamic res) {
      debugPrint('The response from the update wallet is $res');
    });
  }

  /// Delete Wallet
  @override
  Future<void> delete({required String walletId, required String? userId}) {
    // JSON for Get wallet [_jsonForGetWallet]
    final _jsonForDeleteWallet = <String, dynamic>{
      'pk': walletId,
      'deleteAccount': false,
      'referenceNumber': userId
    };

    return httpClient!
        .post(constants.walletURL,
            body: jsonEncode(_jsonForDeleteWallet), headers: constants.headers)
        .then((dynamic res) {
      debugPrint('The response from the delete wallet is $res');
    });
  }

  /// Add Wallet
  @override
  Future<void> add(
      {required String? userId,
      required String? currency,
      required String? name}) {
    // JSON for Get budget [_jsonForAddWallet]
    final _jsonForAddWallet = <String, dynamic>{
      'pk': userId,
      'wallet_currency': currency,
      'wallet_name': name,
    };

    return httpClient!
        .put(constants.walletURL,
            body: jsonEncode(_jsonForAddWallet), headers: constants.headers)
        .then((dynamic res) {
      debugPrint('The response from the add wallet is $res');
    });
  }
}
