import 'dart:convert';
import 'dart:developer' as developer;

import 'package:mobile_blitzbudget/core/network/http_client.dart';
import 'package:mobile_blitzbudget/data/constants/constants.dart' as constants;
import 'package:mobile_blitzbudget/data/model/transaction/transaction_model.dart';
import 'package:flutter/foundation.dart';
import 'package:mobile_blitzbudget/core/utils/utils.dart';

abstract class TransactionRemoteDataSource {
  Future<void> get(String startsWithDate, String endsWithDate,
      String defaultWallet, String userId);

  Future<void> update(TransactionModel updateTransaction);

  Future<void> add(TransactionModel addTransaction);
}

class TransactionRemoteDataSourceImpl implements TransactionRemoteDataSource {
  final HTTPClient httpClient;

  TransactionRemoteDataSourceImpl({@required this.httpClient});

  /// Get Transaction
  @override
  Future<void> get(String startsWithDate, String endsWithDate,
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
        .post(constants.transactionURL,
            body: jsonEncode(contentBody), headers: constants.headers)
        .then((dynamic res) {
      debugPrint('The response from the transaction is $res');
      //TODO
    });
  }

  /// Update Transaction
  @override
  Future<void> update(TransactionModel updateTransaction) {
    developer.log(
        'The Map for patching the transaction is  ${updateTransaction.toString()}');

    return httpClient
        .patch(constants.transactionURL,
            body: jsonEncode(updateTransaction.toJSON()),
            headers: constants.headers)
        .then((dynamic res) {
      debugPrint('The response from the update transaction is $res');
    });
  }

  /// Add Transaction
  @override
  Future<void> add(TransactionModel addTransaction) {
    return httpClient
        .put(constants.transactionURL,
            body: jsonEncode(addTransaction.toJSON()),
            headers: constants.headers)
        .then((dynamic res) {
      debugPrint('The response from the add transaction is $res');
    });
  }
}
