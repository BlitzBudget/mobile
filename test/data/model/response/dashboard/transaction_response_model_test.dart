import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_blitzbudget/data/model/response/dashboard/transaction_response_model.dart';
import 'package:mobile_blitzbudget/data/model/transaction/transaction_model.dart';
import 'package:mobile_blitzbudget/domain/entities/response/transaction_response.dart';
import 'package:mobile_blitzbudget/domain/entities/transaction/transaction.dart';

import '../../../../fixtures/fixture_reader.dart';

void main() {
  final transactionResponseModelAsString =
      fixture('responses/dashboard/transaction/fetch_transaction_info.json');
  final transactionResponseModelAsJSON =
      jsonDecode(transactionResponseModelAsString);

  /// Convert transactions from the response JSON to List<Transaction>
  /// If Empty then return an empty object list
  final transactionResponseModel =
      convertToResponseModel(transactionResponseModelAsJSON);

  test(
    'Should be a subclass of TransactionModel entity',
    () async {
      // assert
      expect(transactionResponseModel, isA<TransactionResponse>());
    },
  );

  group('fromJson', () {
    test('Should return a valid model when the JSON is parsed with all data',
        () async {
      final transactionModelConverted =
          TransactionResponseModel.fromJSON(transactionResponseModelAsJSON);
      expect(transactionModelConverted, equals(transactionResponseModel));
    });

    test(
        'Should return a valid model when the JSON is parsed with empty transaction data',
        () async {
      final transactionResponseModelWithEmptyTransactionAsString = fixture(
          'responses/partially-emtpy/transaction/empty_transaction_transaction_info.json');
      final transactionResponseModelWithEmptyTransactionAsJSON =
          jsonDecode(transactionResponseModelWithEmptyTransactionAsString);

      /// Convert budgets from the response JSON to List<Budget>
      /// If Empty then return an empty object list
      final transactionResponseModelWithEmptyTransactionConverted =
          convertToResponseModel(
              transactionResponseModelWithEmptyTransactionAsJSON);
      final transactionResponseModelWithEmptyTransactionFromJSON =
          TransactionResponseModel.fromJSON(
              transactionResponseModelWithEmptyTransactionAsJSON);
      expect(transactionResponseModelWithEmptyTransactionFromJSON,
          equals(transactionResponseModelWithEmptyTransactionConverted));
    });
  });
}

TransactionResponseModel convertToResponseModel(
    List<dynamic> transactionResponseModelAsJSON) {
  /// Convert transactions from the response JSON to List<Transaction>
  /// If Empty then return an empty object list
  final convertedTransactions = List<Transaction>.from(
      transactionResponseModelAsJSON
          .map<dynamic>((dynamic model) => TransactionModel.fromJSON(model)));

  return TransactionResponseModel(transactions: convertedTransactions);
}
