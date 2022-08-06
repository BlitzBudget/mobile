import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_blitzbudget/core/failure/api_failure.dart';
import 'package:mobile_blitzbudget/core/failure/failure.dart';
import 'package:mobile_blitzbudget/data/model/goal/goal_model.dart';
import 'package:mobile_blitzbudget/data/utils/data_utils.dart';
import 'package:mobile_blitzbudget/domain/repositories/dashboard/goal_repository.dart';
import 'package:mobile_blitzbudget/domain/usecases/dashboard/goal/add_goal_use_case.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../fixtures/fixture_reader.dart';

class MockGoalRepository extends Mock implements GoalRepository {}

void main() {
  late AddGoalUseCase addGoalUseCase;
  MockGoalRepository? mockGoalRepository;

  final goalModelAsString =
      fixture('models/get/goal/emergency_fund_model.json');
  final goalModelAsJSON = jsonDecode(goalModelAsString);
  final goal = GoalModel(
      walletId: parseDynamicAsString(goalModelAsJSON['pk']),
      goalId: parseDynamicAsString(goalModelAsJSON['sk']),
      currentAmount: parseDynamicAsDouble(goalModelAsJSON['current_amount']),
      goalName: parseDynamicAsString(goalModelAsJSON['goal_name']),
      goalAchieved: parseDynamicAsBool(goalModelAsJSON['goal_achieved']),
      targetAmount: parseDynamicAsDouble(goalModelAsJSON['target_amount']),
      targetDate: parseDynamicAsString(goalModelAsJSON['target_date']),
      creationDate: parseDynamicAsString(goalModelAsJSON['creation_date']),
      updateDate: parseDynamicAsString(goalModelAsJSON['updated_date']));

  setUp(() {
    mockGoalRepository = MockGoalRepository();
    addGoalUseCase = AddGoalUseCase(goalRepository: mockGoalRepository);
  });

  group('Add', () {
    test('Success', () async {
      const Either<Failure, void> addGoalMonad = Right<Failure, void>('');

      when(() => mockGoalRepository!.add(goal))
          .thenAnswer((_) => Future.value(addGoalMonad));

      final goalResponse = await addGoalUseCase.add(addGoal: goal);

      expect(goalResponse.isRight(), true);
      verify(() => mockGoalRepository!.add(goal));
    });

    test('Failure', () async {
      final Either<Failure, void> addGoalMonad =
          Left<Failure, void>(FetchDataFailure());

      when(() => mockGoalRepository!.add(goal))
          .thenAnswer((_) => Future.value(addGoalMonad));

      final goalResponse = await addGoalUseCase.add(addGoal: goal);

      expect(goalResponse.isLeft(), true);
      verify(() => mockGoalRepository!.add(goal));
    });
  });
}
