import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_blitzbudget/core/failure/api_failure.dart';
import 'package:mobile_blitzbudget/core/failure/failure.dart';
import 'package:mobile_blitzbudget/data/model/goal/goal_model.dart';
import 'package:mobile_blitzbudget/data/utils/data_utils.dart';
import 'package:mobile_blitzbudget/domain/repositories/dashboard/goal_repository.dart';
import 'package:mobile_blitzbudget/domain/usecases/dashboard/goal/add_goal_use_case.dart';
import 'package:mockito/mockito.dart';

import '../../../../fixtures/fixture_reader.dart';

class MockGoalRepository extends Mock implements GoalRepository {}

void main() {
  AddGoalUseCase addGoalUseCase;
  MockGoalRepository mockGoalRepository;

  final goalModelAsString =
      fixture('models/get/goal/emergency_fund_model.json');
  final goalModelAsJSON = jsonDecode(goalModelAsString);
  final goal = GoalModel(
      walletId: goalModelAsJSON['walletId'],
      goalId: goalModelAsJSON['goalId'],
      goalType: parseDynamicAsGoalType(goalModelAsJSON['goal_type']),
      targetType: parseDynamicAsTargetType(goalModelAsJSON['target_type']),
      monthlyContribution:
          parseDynamicAsDouble(goalModelAsJSON['monthly_contribution']),
      targetAmount: parseDynamicAsDouble(goalModelAsJSON['final_amount']),
      targetDate: goalModelAsJSON['preferable_target_date'],
      targetId: goalModelAsJSON['target_id']);

  setUp(() {
    mockGoalRepository = MockGoalRepository();
    addGoalUseCase = AddGoalUseCase(goalRepository: mockGoalRepository);
  });

  group('Add', () {
    test('Success', () async {
      const Either<Failure, void> addGoalMonad = Right<Failure, void>('');

      when(mockGoalRepository.add(goal))
          .thenAnswer((_) => Future.value(addGoalMonad));

      final goalResponse = await addGoalUseCase.add(addGoal: goal);

      expect(goalResponse.isRight(), true);
      verify(mockGoalRepository.add(goal));
    });

    test('Failure', () async {
      final Either<Failure, void> addGoalMonad =
          Left<Failure, void>(FetchDataFailure());

      when(mockGoalRepository.add(goal))
          .thenAnswer((_) => Future.value(addGoalMonad));

      final goalResponse = await addGoalUseCase.add(addGoal: goal);

      expect(goalResponse.isLeft(), true);
      verify(mockGoalRepository.add(goal));
    });
  });
}
