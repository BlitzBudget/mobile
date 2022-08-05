import 'dart:convert';
import 'dart:developer' as developer;

import 'package:flutter/foundation.dart';
import 'package:mobile_blitzbudget/core/network/http_client.dart';
import 'package:mobile_blitzbudget/core/utils/utils.dart';
import 'package:mobile_blitzbudget/data/constants/constants.dart' as constants;
import 'package:mobile_blitzbudget/data/model/response/dashboard/transaction_response_model.dart';
import 'package:mobile_blitzbudget/data/model/transaction/transaction_model.dart';

abstract class TransactionRemoteDataSource {
  Future<TransactionResponseModel> fetch(
      {required String startsWithDate,
      required String endsWithDate,
      required String? defaultWallet});

  Future<void> update(TransactionModel updateTransaction);

  Future<void> add(TransactionModel addTransaction);
}

class TransactionRemoteDataSourceImpl implements TransactionRemoteDataSource {
  TransactionRemoteDataSourceImpl({required this.httpClient});

  final HTTPClient? httpClient;

  /// Get Transaction
  @override
  Future<TransactionResponseModel> fetch(
      {required String startsWithDate,
      required String endsWithDate,
      required String? defaultWallet}) async {
    final contentBody = <String, dynamic>{
      'starts_with_date': startsWithDate,
      'ends_with_date': endsWithDate
    };

    if (isNotEmpty(defaultWallet)) {
      contentBody['wallet_id'] = defaultWallet;
    }
    return httpClient!
        .post(constants.transactionURL,
            body: jsonEncode(contentBody), headers: constants.headers)
        .then<TransactionResponseModel>((dynamic res) {
      debugPrint('The response from the transaction is $res');
      return TransactionResponseModel.fromJSON(res);
    });
  }

  /// Update Transaction
  @override
  Future<void> update(TransactionModel updateTransaction) {
    developer.log(
        'The Map for patching the transaction is  ${updateTransaction.toString()}');

    return httpClient!
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
    return httpClient!
        .put(constants.transactionURL,
            body: jsonEncode(addTransaction.toJSON()),
            headers: constants.headers)
        .then((dynamic res) {
      debugPrint('The response from the add transaction is $res');
    });
  }
}
