import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_blitzbudget/data/model/recurring-transaction/recurring_transaction_model.dart';
import 'package:mobile_blitzbudget/data/utils/data_utils.dart';
import 'package:mobile_blitzbudget/domain/entities/recurring-transaction/recurring_transaction.dart';

import '../../../fixtures/fixture_reader.dart';

void main() {
  final recurringTransactionModelAsString = fixture(
      'models/get/recurring-transaction/recurring_transaction_model.json');
  final recurringTransactionModelAsJSON =
      jsonDecode(recurringTransactionModelAsString);
  final tags = (recurringTransactionModelAsJSON['tags'])
      ?.map<String>(parseDynamicAsString)
      ?.toList();
  final recurringTransactionModel = RecurringTransactionModel(
      walletId: recurringTransactionModelAsJSON['walletId'],
      accountId: recurringTransactionModelAsJSON['account'],
      recurringTransactionId:
          recurringTransactionModelAsJSON['recurringTransactionsId'],
      amount: parseDynamicAsDouble(recurringTransactionModelAsJSON['amount']),
      description: recurringTransactionModelAsJSON['description'],
      recurrence: parseDynamicAsRecurrence(
          recurringTransactionModelAsJSON['recurrence']),
      categoryType: parseDynamicAsCategoryType(
          recurringTransactionModelAsJSON['category_type']),
      categoryName: recurringTransactionModelAsJSON['category_name'],
      category: recurringTransactionModelAsJSON['category'],
      tags: tags,
      nextScheduled: recurringTransactionModelAsJSON['next_scheduled'],
      creationDate: recurringTransactionModelAsJSON['creation_date']);
  test(
    'Should be a subclass of RecurringTransaction entity',
    () async {
      // assert
      expect(recurringTransactionModel, isA<RecurringTransaction>());
    },
  );

  group('fromJson', () {
    test('Should return a valid model when the JSON is parsed with all data',
        () async {
      final recurringTransactionModelConverted =
          RecurringTransactionModel.fromJSON(recurringTransactionModelAsJSON);
      expect(recurringTransactionModelConverted,
          equals(recurringTransactionModel));
    });
  });

  group('toJson', () {
    test('Should return a JSON map containing the proper data', () async {
      final addRecurringTransactionModelAsString = fixture(
          'models/add/recurring-transaction/recurring_transaction_model.json');
      final addRecurringTransactionModelAsJSON =
          jsonDecode(addRecurringTransactionModelAsString);
      expect(recurringTransactionModel.toJSON(),
          equals(addRecurringTransactionModelAsJSON));
    });
  });
}
