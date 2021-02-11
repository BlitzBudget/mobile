import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_blitzbudget/core/failure/api_failure.dart';
import 'package:mobile_blitzbudget/core/failure/failure.dart';
import 'package:mobile_blitzbudget/data/model/budget/budget_model.dart';
import 'package:mobile_blitzbudget/data/utils/data_utils.dart';
import 'package:mobile_blitzbudget/domain/repositories/dashboard/budget_repository.dart';
import 'package:mobile_blitzbudget/domain/usecases/dashboard/budget/add_budget_use_case.dart';
import 'package:mockito/mockito.dart';

import '../../../../fixtures/fixture_reader.dart';

class MockBudgetRepository extends Mock implements BudgetRepository {}

void main() {
  AddBudgetUseCase addBudgetUseCase;
  MockBudgetRepository mockBudgetRepository;

  final budgetModelAsString = fixture('models/get/budget/budget_model.json');
  final budgetModelAsJSON =
      jsonDecode(budgetModelAsString) as Map<String, dynamic>;
  final budget = BudgetModel(
      walletId: budgetModelAsJSON['walletId'] as String,
      budgetId: budgetModelAsJSON['budgetId'] as String,
      planned: parseDynamicAsDouble(budgetModelAsJSON['planned']),
      category: budgetModelAsJSON['category'] as String,
      categoryType:
          parseDynamicAsCategoryType(budgetModelAsJSON['category_type']),
      dateMeantFor: budgetModelAsJSON['date_meant_for'] as String);

  setUp(() {
    mockBudgetRepository = MockBudgetRepository();
    addBudgetUseCase = AddBudgetUseCase(budgetRepository: mockBudgetRepository);
  });

  group('Add', () {
    test('Success', () async {
      Either<Failure, void> addBudgetMonad = Right<Failure, void>('');

      when(mockBudgetRepository.add(budget))
          .thenAnswer((_) => Future.value(addBudgetMonad));

      final budgetResponse = await addBudgetUseCase.add(addBudget: budget);

      expect(budgetResponse.isRight(), true);
      verify(mockBudgetRepository.add(budget));
    });

    test('Failure', () async {
      Either<Failure, void> addBudgetMonad =
          Left<Failure, void>(FetchDataFailure());

      when(mockBudgetRepository.add(budget))
          .thenAnswer((_) => Future.value(addBudgetMonad));

      final budgetResponse = await addBudgetUseCase.add(addBudget: budget);

      expect(budgetResponse.isLeft(), true);
      verify(mockBudgetRepository.add(budget));
    });
  });
}
