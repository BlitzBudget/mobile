import 'dart:convert';
import 'dart:developer' as developer;

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';

import '../../data/utils/network_helper.dart';
import '../../utils/utils.dart';
import '../remote/authentication_remote_data_source.dart' as authentication;
import '../../app/constants/constants.dart' as constants;
import '../../utils/dashboard-utils.dart' as dashboardUtils;
import '../../data/model/user.dart';

abstract class BankAccountRemoteDataSource {
  Future<void> update(BankAccount updateBankAccount);

  Future<void> add(BankAccount addBankAccount);

  Future<void> delete(String walletId, String account);
}

class _BankAccountRemoteDataSourceImpl implements BankAccountRemoteDataSource {
  NetworkUtil _netUtil = new NetworkUtil();

  /// Create storage
  final _storage = new FlutterSecureStorage();
  static final _bankAccountURL = authentication.baseURL + "/bank-accounts";
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
