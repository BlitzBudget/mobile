import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_blitzbudget/data/model/budget/budget_model.dart';
import 'package:mobile_blitzbudget/data/model/response/dashboard/budget_response_model.dart';
import 'package:mobile_blitzbudget/domain/entities/budget/budget.dart';
import 'package:mobile_blitzbudget/domain/entities/response/budget_response.dart';

import '../../../../fixtures/fixture_reader.dart';

void main() {
  final budgetResponseModelAsString =
      fixture('responses/dashboard/budget/fetch_budget_info.json');
  final budgetResponseModelAsJSON = jsonDecode(budgetResponseModelAsString);

  /// Convert budgets from the response JSON to List<Budget>
  /// If Empty then return an empty object list
  final budgetResponseModel = convertToResponseModel(budgetResponseModelAsJSON);

  test(
    'Should be a subclass of BudgetModel entity',
    () async {
      // assert
      expect(budgetResponseModel, isA<BudgetResponse>());
    },
  );

  group('fromJson', () {
    test('Should return a valid model when the JSON is parsed with all data',
        () async {
      final budgetModelConverted =
          BudgetResponseModel.fromJSON(budgetResponseModelAsJSON);
      expect(budgetModelConverted, equals(budgetResponseModel));
    });

    test(
        'Should return a valid model when the JSON is parsed with empty budget data',
        () async {
      final budgetResponseModelWithEmptyBudgetAsString = fixture(
          'responses/partially-emtpy/budget/empty_budget_budget_info.json');
      final budgetResponseModelWithEmptyBudgetAsJSON =
          jsonDecode(budgetResponseModelWithEmptyBudgetAsString);

      /// Convert budgets from the response JSON to List<Budget>
      /// If Empty then return an empty object list
      final budgetResponseModelWithEmptyBudgetConverted =
          convertToResponseModel(budgetResponseModelWithEmptyBudgetAsJSON);
      final budgetResponseModelWithEmptyBudgetFromJSON =
          BudgetResponseModel.fromJSON(
              budgetResponseModelWithEmptyBudgetAsJSON);
      expect(budgetResponseModelWithEmptyBudgetFromJSON,
          equals(budgetResponseModelWithEmptyBudgetConverted));
    });
  });
}

BudgetResponseModel convertToResponseModel(
    List<dynamic> budgetResponseModelAsJSON) {
  /// Convert budgets from the response JSON to List<Budget>
  /// If Empty then return an empty object list
  final convertedBudgets = List<Budget>.from(budgetResponseModelAsJSON
      .map<dynamic>((dynamic model) => BudgetModel.fromJSON(model)));

  final budgetResponseModel = BudgetResponseModel(budgets: convertedBudgets);
  return budgetResponseModel;
}
