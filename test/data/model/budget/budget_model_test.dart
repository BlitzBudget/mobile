import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_blitzbudget/data/model/budget/budget_model.dart';
import 'package:mobile_blitzbudget/data/utils/data_utils.dart';
import 'package:mobile_blitzbudget/domain/entities/budget/budget.dart';

import '../../../fixtures/fixture_reader.dart';

void main() {
  final budgetModelAsString = fixture('models/get/budget/budget_model.json');
  final budgetModelAsJSON =
      jsonDecode(budgetModelAsString);
  final budgetModel = BudgetModel(
      walletId: budgetModelAsJSON['walletId'],
      budgetId: budgetModelAsJSON['budgetId'],
      planned: parseDynamicAsDouble(budgetModelAsJSON['planned']),
      category: budgetModelAsJSON['category'],
      categoryType:
          parseDynamicAsCategoryType(budgetModelAsJSON['category_type']),
      dateMeantFor: budgetModelAsJSON['date_meant_for']);
  test(
    'Should be a subclass of Budget entity',
    () async {
      // assert
      expect(budgetModel, isA<Budget>());
    },
  );

  group('fromJson', () {
    test('Should return a valid model when the JSON is parsed with all data',
        () async {
      final budgetModelConverted = BudgetModel.fromJSON(budgetModelAsJSON);
      expect(budgetModelConverted, equals(budgetModel));
    });
  });

  group('toJson', () {
    test('Should return a JSON map containing the proper data', () async {
      final addBudgetModelAsString =
          fixture('models/add/budget/budget_model.json');
      final addBudgetModelAsJSON =
          jsonDecode(addBudgetModelAsString);
      expect(budgetModel.toJSON(), equals(addBudgetModelAsJSON));
    });
  });
}
