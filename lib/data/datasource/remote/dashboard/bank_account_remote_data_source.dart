import 'dart:convert';
import 'dart:developer' as developer;

import 'package:flutter/foundation.dart';
import 'package:mobile_blitzbudget/core/network/http_client.dart';
import 'package:mobile_blitzbudget/data/model/bank-account/bank_account_model.dart';

import '../../../constants/constants.dart' as constants;

abstract class BankAccountRemoteDataSource {
  Future<void> update(BankAccountModel updateBankAccount);

  Future<void> add(BankAccountModel addBankAccount);

  Future<void> delete(String walletId, String account);
}

class BankAccountRemoteDataSourceImpl implements BankAccountRemoteDataSource {
  final HttpClient httpClient;

  BankAccountRemoteDataSourceImpl({@required this.httpClient});

  /// Update BankAccount
  @override
  Future<void> update(BankAccountModel updateBankAccount) {
    developer.log(
        'The Map for patching the bankAccount is  ${updateBankAccount.toString()}');

    return httpClient
        .patch(constants.bankAccountURL,
            body: jsonEncode(updateBankAccount.toJSON()),
            headers: constants.headers)
        .then((dynamic res) {
      debugPrint('The response from the bankAccount is $res');
      //TODO
    });
  }

  /// Add BankAccount
  @override
  Future<void> add(BankAccountModel addBankAccount) {
    return httpClient
        .put(constants.bankAccountURL,
            body: jsonEncode(addBankAccount.toJSON()),
            headers: constants.headers)
        .then((dynamic res) {
      debugPrint('The response from the bankAccount is $res');
      //TODO
    });
  }

  /// Delete Wallet
  @override
  Future<void> delete(String walletId, String account) {
    // JSON for Get wallet [_jsonForGetWallet]
    var _jsonForDeleteCategory = <String, dynamic>{
      'walletId': walletId,
      'account': account
    };

    return httpClient
        .post(constants.deleteBankAccountURL,
            body: jsonEncode(_jsonForDeleteCategory),
            headers: constants.headers)
        .then((dynamic res) {
      debugPrint('The response from the budget is $res');
      //TODO
    });
  }
}
