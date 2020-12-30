import 'dart:convert';
import 'dart:developer' as developer;

import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../../../utils/network_helper.dart';
import '../../app/constants/constants.dart' as constants;
import '../../utils/dashboard-utils.dart' as dashboardUtils;
import '../../utils/utils.dart';
import '../datasource/remote/authentication_remote_data_source.dart'
    as authentication;

abstract class BankAccountRemoteDataSource {
  Future<void> update(BankAccount updateBankAccount);

  Future<void> add(BankAccount addBankAccount);

  Future<void> delete(String walletId, String account);
}

class _BankAccountRemoteDataSourceImpl implements BankAccountRemoteDataSource {
  NetworkUtil _netUtil = new NetworkUtil();

  /// Create storage
  final _storage = new FlutterSecureStorage();
  static final _bankAccountURL = authentication.baseURL + "/bank-a‚ccounts";
  static final _deleteBankAccountURL = _bankAccountURL + '/delete';

  /// Update BankAccount
  @override
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
  @override
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
  @override
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
