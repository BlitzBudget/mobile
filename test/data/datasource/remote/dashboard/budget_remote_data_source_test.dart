import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_blitzbudget/core/network/http_client.dart';
import 'package:mobile_blitzbudget/data/constants/constants.dart' as constants;
import 'package:mobile_blitzbudget/data/datasource/remote/dashboard/budget_remote_data_source.dart';
import 'package:mobile_blitzbudget/data/model/budget/budget_model.dart';
import 'package:mobile_blitzbudget/data/utils/data_utils.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../fixtures/fixture_reader.dart';

class MockHTTPClientImpl extends Mock implements HTTPClientImpl {}

void main() {
  late BudgetRemoteDataSourceImpl dataSource;
  HTTPClientImpl? mockHTTPClientImpl;

  setUp(() {
    mockHTTPClientImpl = MockHTTPClientImpl();
    dataSource = BudgetRemoteDataSourceImpl(httpClient: mockHTTPClientImpl);
  });

  group('Attempt to fetch all budgets', () {
    test('Should fetch all budgets with wallet id', () async {
      final fetchBudgetAsString =
          fixture('responses/dashboard/budget/fetch_budget_info.json');
      final fetchBudgetAsJSON = jsonDecode(fetchBudgetAsString);
      final startsWithDate = DateTime.now().toIso8601String();
      final endsWithDate = startsWithDate;
      final defaultWallet = fetchBudgetAsJSON[0]['pk'];
      final contentBody = <String, dynamic>{
        'starts_with_date': startsWithDate,
        'ends_with_date': endsWithDate,
        'pk': defaultWallet
      };
      // arrange
      when(() => mockHTTPClientImpl!.post(constants.budgetURL,
              body: jsonEncode(contentBody), headers: constants.headers))
          .thenAnswer((_) async => fetchBudgetAsJSON);
      // act
      final budget = await dataSource.fetch(
          startsWithDate: startsWithDate,
          endsWithDate: endsWithDate,
          defaultWallet: defaultWallet);
      // assert
      verify(() => mockHTTPClientImpl!.post(constants.budgetURL,
          body: jsonEncode(contentBody), headers: constants.headers));

      expect(
          budget.budgets!.first.budgetId, equals(fetchBudgetAsJSON[0]['sk']));
    });
  });

  group('Attempt to add a budget', () {
    test(
      'Should add a budget',
      () async {
        final addBudgetAsString =
            fixture('responses/dashboard/budget/add_budget_info.json');
        final addBudgetAsJSON = jsonDecode(addBudgetAsString);
        final budget = BudgetModel(
            walletId: addBudgetAsJSON['body-json']['pk'],
            budgetId: addBudgetAsJSON['body-json']['sk'],
            planned:
                parseDynamicAsDouble(addBudgetAsJSON['body-json']['planned']),
            category: addBudgetAsJSON['body-json']['category'],
            creationDate: addBudgetAsJSON['body-json']['creation_date']);
        // arrange
        when(() => mockHTTPClientImpl!.put(constants.budgetURL,
                body: jsonEncode(budget.toJSON()), headers: constants.headers))
            .thenAnswer((_) async => addBudgetAsJSON);
        // act
        await dataSource.add(budget);
        // assert
        verify(() => mockHTTPClientImpl!.put(constants.budgetURL,
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
        final updateAmountAsJSON = jsonDecode(updateAmountAsString);
        final budget = BudgetModel(
            walletId: updateAmountAsJSON['body-json']['pk'],
            budgetId: updateAmountAsJSON['body-json']['sk'],
            planned: parseDynamicAsDouble(
                updateAmountAsJSON['body-json']['planned']));
        // arrange
        when(() => mockHTTPClientImpl!.patch(constants.budgetURL,
                body: jsonEncode(budget.toJSON()), headers: constants.headers))
            .thenAnswer((_) async => updateAmountAsJSON);
        // act
        await dataSource.update(budget);
        // assert
        verify(() => mockHTTPClientImpl!.patch(constants.budgetURL,
            body: jsonEncode(budget.toJSON()), headers: constants.headers));
      },
    );

    test(
      'Should update a budgets category',
      () async {
        final updateDescriptionAsString = fixture(
            'responses/dashboard/budget/update/update_budget_category_info.json');
        final updateDescriptionAsJSON = jsonDecode(updateDescriptionAsString);
        final budget = BudgetModel(
            walletId: updateDescriptionAsJSON['body-json']['pk'],
            budgetId: updateDescriptionAsJSON['body-json']['sk'],
            category: updateDescriptionAsJSON['body-json']['category']);
        // arrange
        when(() => mockHTTPClientImpl!.patch(constants.budgetURL,
                body: jsonEncode(budget.toJSON()), headers: constants.headers))
            .thenAnswer((_) async => updateDescriptionAsJSON);
        // act
        await dataSource.update(budget);
        // assert
        verify(() => mockHTTPClientImpl!.patch(constants.budgetURL,
            body: jsonEncode(budget.toJSON()), headers: constants.headers));
      },
    );
  });
}
