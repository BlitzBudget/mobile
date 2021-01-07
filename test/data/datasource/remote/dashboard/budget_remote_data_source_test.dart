import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_blitzbudget/core/network/http_client.dart';
import 'package:mobile_blitzbudget/data/constants/constants.dart' as constants;

import 'package:mobile_blitzbudget/data/datasource/remote/dashboard/budget_remote_data_source.dart';
import 'package:mobile_blitzbudget/data/model/budget/budget_model.dart';

import 'package:mobile_blitzbudget/data/utils/data_utils.dart';
import 'package:mockito/mockito.dart';

import '../../../../fixtures/fixture_reader.dart';

class MockHTTPClientImpl extends Mock implements HTTPClientImpl {}

void main() {
  BudgetRemoteDataSourceImpl dataSource;
  HTTPClientImpl mockHTTPClientImpl;

  setUp(() {
    mockHTTPClientImpl = MockHTTPClientImpl();
    dataSource = BudgetRemoteDataSourceImpl(httpClient: mockHTTPClientImpl);
  });

  group('Attempt to add a budget', () {
    test(
      'Should add a budget',
      () async {
        final addBudgetAsString =
            fixture('responses/dashboard/budget/add_budget_info.json');
        final addBudgetAsJSON =
            jsonDecode(addBudgetAsString) as Map<String, dynamic>;
        final budget = BudgetModel(
            walletId: addBudgetAsJSON['body-json']['walletId'] as String,
            budgetId: addBudgetAsJSON['body-json']['accountId'] as String,
            categoryType: parseDynamicAsCategoryType(
                addBudgetAsJSON['body-json']['categoryType']),
            planned:
                parseDynamicAsDouble(addBudgetAsJSON['body-json']['planned']),
            dateMeantFor:
                addBudgetAsJSON['body-json']['dateMeantFor'] as String);
        // arrange
        when(mockHTTPClientImpl.put(constants.budgetURL,
                body: jsonEncode(budget.toJSON()), headers: constants.headers))
            .thenAnswer((_) async => addBudgetAsJSON);
        // act
        await dataSource.add(budget);
        // assert
        verify(mockHTTPClientImpl.put(constants.budgetURL,
            body: jsonEncode(budget.toJSON()), headers: constants.headers));
      },
    );
  });

  group('Attempt to update a budget', () {
    test(
      'Should update a budgets amount',
      () async {
        final updateAmountAsString = fixture(
            'responses/dashboard/budget/update/update_budget_amount_info.json');
        final updateAmountAsJSON =
            jsonDecode(updateAmountAsString) as Map<String, dynamic>;
        final budget = BudgetModel(
            walletId: updateAmountAsJSON['body-json']['walletId'] as String,
            budgetId: updateAmountAsJSON['body-json']['budgetId'] as String,
            planned: parseDynamicAsDouble(
                updateAmountAsJSON['body-json']['planned']));
        // arrange
        when(mockHTTPClientImpl.patch(constants.budgetURL,
                body: jsonEncode(budget.toJSON()), headers: constants.headers))
            .thenAnswer((_) async => updateAmountAsJSON);
        // act
        await dataSource.update(budget);
        // assert
        verify(mockHTTPClientImpl.patch(constants.budgetURL,
            body: jsonEncode(budget.toJSON()), headers: constants.headers));
      },
    );

    test(
      'Should update a budgets category',
      () async {
        final updateDescriptionAsString = fixture(
            'responses/dashboard/budget/update/update_budget_category_info.json');
        final updateDescriptionAsJSON =
            jsonDecode(updateDescriptionAsString) as Map<String, dynamic>;
        final budget = BudgetModel(
            walletId:
                updateDescriptionAsJSON['body-json']['walletId'] as String,
            budgetId:
                updateDescriptionAsJSON['body-json']['budgetId'] as String,
            category:
                updateDescriptionAsJSON['body-json']['category'] as String);
        // arrange
        when(mockHTTPClientImpl.patch(constants.budgetURL,
                body: jsonEncode(budget.toJSON()), headers: constants.headers))
            .thenAnswer((_) async => updateDescriptionAsJSON);
        // act
        await dataSource.update(budget);
        // assert
        verify(mockHTTPClientImpl.patch(constants.budgetURL,
            body: jsonEncode(budget.toJSON()), headers: constants.headers));
      },
    );
  });
}
