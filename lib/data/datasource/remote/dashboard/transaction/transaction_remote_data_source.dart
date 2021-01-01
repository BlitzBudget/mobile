import 'dart:convert';
import 'dart:developer' as developer;

import 'package:mobile_blitzbudget/core/network/http_client.dart';
import 'package:mobile_blitzbudget/data/constants/constants.dart' as constants;
import 'package:mobile_blitzbudget/data/model/transaction/transaction_model.dart';
import 'package:flutter/foundation.dart';

abstract class TransactionRemoteDataSource {
  Future<void> get(Map<String, dynamic> contentBody);

  Future<void> update(TransactionModel updateTransaction);

  Future<void> add(TransactionModel addTransaction);
}

class TransactionRemoteDataSourceImpl implements TransactionRemoteDataSource {
  final HTTPClient httpClient;

  TransactionRemoteDataSourceImpl(this.httpClient);

  /// Get Transaction
  @override
  Future<void> get(Map<String, dynamic> contentBody) async {
    developer.log(
        'The Map for getting the transaction is  ${contentBody.toString()}');

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
      debugPrint('The response from the transaction is $res');
      //TODO
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
      debugPrint('The response from the transaction is $res');
      //TODO
    });
  }
}
