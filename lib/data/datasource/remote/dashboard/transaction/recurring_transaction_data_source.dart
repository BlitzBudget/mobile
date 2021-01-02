import 'dart:convert';
import 'dart:developer' as developer;

import 'package:flutter/foundation.dart';
import 'package:mobile_blitzbudget/core/network/http_client.dart';
import 'package:mobile_blitzbudget/data/constants/constants.dart' as constants;
import 'package:mobile_blitzbudget/data/model/recurring-transaction/recurring_transaction_model.dart';

abstract class RecurringTransactionRemoteDataSource {
  Future<void> update(RecurringTransactionModel updateRecurringTransaction);
}

class RecurringTransactionRemoteDataSourceImpl
    implements RecurringTransactionRemoteDataSource {
  final HTTPClient httpClient;

  RecurringTransactionRemoteDataSourceImpl(this.httpClient);

  /// Update Transaction
  @override
  Future<void> update(RecurringTransactionModel updateRecurringTransaction) {
    developer.log(
        'The Map for patching the recurring transactions is  ${updateRecurringTransaction.toString()}');

    return httpClient
        .patch(constants.recurringTransactionURL,
            body: jsonEncode(updateRecurringTransaction.toJSON()),
            headers: constants.headers)
        .then((dynamic res) {
      debugPrint('The response from the update recurring transactions is $res');
    });
  }
}
