import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_blitzbudget/data/model/transaction/transaction_model.dart';
import 'package:mobile_blitzbudget/data/utils/data_utils.dart';
import 'package:mobile_blitzbudget/domain/entities/transaction/transaction.dart';

import '../../../fixtures/fixture_reader.dart';

void main() {
  final transactionModelAsString =
      fixture('models/get/transaction/transaction_model.json');
  final transactionModelAsJSON =
      jsonDecode(transactionModelAsString) as Map<String, dynamic>;
  final tags = (transactionModelAsJSON['tags'] as List)
      ?.map((dynamic item) => item as String)
      ?.toList();
  final transactionModel = TransactionModel(
      walletId: transactionModelAsJSON['walletId'] as String,
      accountId: transactionModelAsJSON['account'] as String,
      transactionId: transactionModelAsJSON['transactionId'] as String,
      amount: parseDynamicAsDouble(transactionModelAsJSON['amount']),
      description: transactionModelAsJSON['description'] as String,
      recurrence:
          parseDynamicAsRecurrence(transactionModelAsJSON['recurrence']),
      categoryType:
          parseDynamicAsCategoryType(transactionModelAsJSON['category_type']),
      categoryName: transactionModelAsJSON['category_name'] as String,
      tags: tags,
      categoryId: transactionModelAsJSON['category'] as String,
      dateMeantFor: transactionModelAsJSON['date_meant_for'] as String);
  test(
    'Should be a subclass of Transaction entity',
    () async {
      // assert
      expect(transactionModel, isA<Transaction>());
    },
  );

  group('fromJson', () {
    test('Should return a valid model when the JSON is parsed with all data',
        () async {
      final transactionModelConverted =
          TransactionModel.fromJSON(transactionModelAsJSON);
      expect(transactionModelConverted, equals(transactionModel));
    });
  });

  group('toJson', () {
    test('Should return a JSON map containing the proper data', () async {
      final addTransactionModelAsString =
          fixture('models/add/transaction/transaction_model.json');
      final addTransactionModelAsJSON =
          jsonDecode(addTransactionModelAsString) as Map<String, dynamic>;
      expect(transactionModel.toJSON(), equals(addTransactionModelAsJSON));
    });
  });
}
