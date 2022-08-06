import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_blitzbudget/data/model/budget/budget_model.dart';
import 'package:mobile_blitzbudget/data/utils/data_utils.dart';
import 'package:mobile_blitzbudget/domain/entities/budget/budget.dart';

import '../../../fixtures/fixture_reader.dart';

void main() {
  final budgetModelAsString = fixture('models/get/budget/budget_model.json');
  final budgetModelAsJSON = jsonDecode(budgetModelAsString);
  final budgetModel = BudgetModel(
      walletId: budgetModelAsJSON['pk'],
      budgetId: budgetModelAsJSON['sk'],
      planned: parseDynamicAsDouble(budgetModelAsJSON['planned']),
      category: budgetModelAsJSON['category'],
      creationDate: budgetModelAsJSON['creation_date']);
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
      final updateBudgetModelAsString = fixture(
          'responses/dashboard/budget/update/update_budget_amount_info.json');
      final updateBudgetModelAsJSON = jsonDecode(updateBudgetModelAsString);
      final budgetModel = BudgetModel(
          walletId: updateBudgetModelAsJSON['body-json']['pk'],
          budgetId: updateBudgetModelAsJSON['body-json']['sk'],
          planned: parseDynamicAsDouble(
              updateBudgetModelAsJSON['body-json']['planned']),
          category: updateBudgetModelAsJSON['body-json']['category'],
          creationDate: updateBudgetModelAsJSON['body-json']['creation_date']);
      expect(
          budgetModel.toJSON(), equals(updateBudgetModelAsJSON['body-json']));
    });
  });
}
