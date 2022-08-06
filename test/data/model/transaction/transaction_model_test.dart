import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_blitzbudget/data/model/transaction/transaction_model.dart';
import 'package:mobile_blitzbudget/data/utils/data_utils.dart';
import 'package:mobile_blitzbudget/domain/entities/transaction/transaction.dart';

import '../../../fixtures/fixture_reader.dart';

void main() {
  final transactionModelAsString =
      fixture('models/get/transaction/transaction_model.json');
  final transactionModelAsJSON = jsonDecode(transactionModelAsString);
  final tags = (transactionModelAsJSON['tags'])
      ?.map<String>(parseDynamicAsString)
      ?.toList();
  final transactionModel = TransactionModel(
      walletId: transactionModelAsJSON['pk'],
      transactionId: transactionModelAsJSON['sk'],
      amount: parseDynamicAsDouble(transactionModelAsJSON['amount']),
      description: transactionModelAsJSON['description'],
      tags: tags,
      categoryId: transactionModelAsJSON['category_id']);
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
      final addTransactionModelAsJSON = jsonDecode(addTransactionModelAsString);
      expect(transactionModel.toJSON(), equals(addTransactionModelAsJSON));
    });
  });
}
