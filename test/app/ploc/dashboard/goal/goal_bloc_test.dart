import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_blitzbudget/app/ploc/dashboard/goal/goal_bloc.dart';
import 'package:mobile_blitzbudget/core/failure/api_failure.dart';
import 'package:mobile_blitzbudget/core/failure/failure.dart';
import 'package:mobile_blitzbudget/domain/entities/goal/goal.dart';
import 'package:mobile_blitzbudget/domain/entities/goal/goal_type.dart';
import 'package:mobile_blitzbudget/domain/entities/goal/target_type.dart';
import 'package:mobile_blitzbudget/domain/entities/response/goal_response.dart';
import 'package:mocktail/mocktail.dart';
import 'package:mobile_blitzbudget/domain/usecases/dashboard/goal/add_goal_use_case.dart'
    as add_goal_usecase;
import 'package:mobile_blitzbudget/domain/usecases/dashboard/goal/delete_goal_use_case.dart'
    as delete_goal_usecase;
import 'package:mobile_blitzbudget/domain/usecases/dashboard/goal/update_goal_use_case.dart'
    as update_goal_usecase;
import 'package:mobile_blitzbudget/domain/usecases/dashboard/goal/fetch_goal_use_case.dart'
    as fetch_goal_usecase;
import 'package:mobile_blitzbudget/app/ploc/dashboard/goal/goal_constants.dart'
    as constants;

class MockAddGoalUsecase extends Mock
    implements add_goal_usecase.AddGoalUseCase {}

class MockDeleteGoalUseCase extends Mock
    implements delete_goal_usecase.DeleteGoalUseCase {}

class MockUpdateGoalUseCase extends Mock
    implements update_goal_usecase.UpdateGoalUseCase {}

class MockFetchGoalUseCase extends Mock
    implements fetch_goal_usecase.FetchGoalUseCase {}

void main() {
  const GOAL_ID = 'goalID';
  const WALLET_ID = 'walletID';
  const TARGET_DATE = 'targetDate';
  const TARGET_ID = 'targetID';

  late MockAddGoalUsecase mockAddGoalUsecase;
  late MockDeleteGoalUseCase mockDeleteGoalUseCase;
  late MockUpdateGoalUseCase mockUpdateGoalUseCase;
  late MockFetchGoalUseCase mockFetchGoalUseCase;
  const positiveMonadResponse = Right<Failure, void>('');
  const addGoal = Goal(
      walletId: WALLET_ID,
      goalId: GOAL_ID,
      goalType: GoalType.buyACar,
      targetType: TargetType.account,
      monthlyContribution: 1,
      targetAmount: 1,
      targetDate: TARGET_DATE,
      targetId: TARGET_ID);

  setUp(() {
    mockAddGoalUsecase = MockAddGoalUsecase();
    mockDeleteGoalUseCase = MockDeleteGoalUseCase();
    mockUpdateGoalUseCase = MockUpdateGoalUseCase();
    mockFetchGoalUseCase = MockFetchGoalUseCase();
  });

  group('Success: GoalBloc', () {
    blocTest<GoalBloc, GoalState>(
      'Emits [Success] states for add goal success',
      build: () {
        when(() => mockAddGoalUsecase.add(addGoal: addGoal))
            .thenAnswer((_) => Future.value(positiveMonadResponse));
        return GoalBloc(
            addGoalUseCase: mockAddGoalUsecase,
            deleteGoalUseCase: mockDeleteGoalUseCase,
            updateGoalUseCase: mockUpdateGoalUseCase,
            fetchGoalUseCase: mockFetchGoalUseCase);
      },
      act: (bloc) => bloc.add(const Add(
          walletId: WALLET_ID,
          goalId: GOAL_ID,
          goalType: GoalType.buyACar,
          targetType: TargetType.account,
          monthlyContribution: 1,
          targetAmount: 1,
          targetDate: TARGET_DATE,
          targetId: TARGET_ID)),
      expect: () => [Loading(), Success()],
    );

    blocTest<GoalBloc, GoalState>(
      'Emits [Success] states for fetch goal success',
      build: () {
        const fetchGoalResponse = Right<Failure, GoalResponse>(GoalResponse());
        when(() => mockFetchGoalUseCase.fetch())
            .thenAnswer((_) => Future.value(fetchGoalResponse));
        return GoalBloc(
            addGoalUseCase: mockAddGoalUsecase,
            deleteGoalUseCase: mockDeleteGoalUseCase,
            updateGoalUseCase: mockUpdateGoalUseCase,
            fetchGoalUseCase: mockFetchGoalUseCase);
      },
      act: (bloc) => bloc.add(Fetch()),
      expect: () => [Loading(), Success()],
    );

    blocTest<GoalBloc, GoalState>(
      'Emits [Success] states for update category id success',
      build: () {
        when(() => mockUpdateGoalUseCase.update(updateGoal: addGoal))
            .thenAnswer((_) => Future.value(positiveMonadResponse));
        return GoalBloc(
            addGoalUseCase: mockAddGoalUsecase,
            deleteGoalUseCase: mockDeleteGoalUseCase,
            updateGoalUseCase: mockUpdateGoalUseCase,
            fetchGoalUseCase: mockFetchGoalUseCase);
      },
      act: (bloc) => bloc.add(const Update(
          walletId: WALLET_ID,
          goalId: GOAL_ID,
          goalType: GoalType.buyACar,
          targetType: TargetType.account,
          monthlyContribution: 1,
          targetAmount: 1,
          targetDate: TARGET_DATE,
          targetId: TARGET_ID)),
      expect: () => [Loading(), Success()],
    );

    blocTest<GoalBloc, GoalState>(
      'Emits [Success] states for delete goal success',
      build: () {
        when(() => mockDeleteGoalUseCase.delete(itemID: GOAL_ID))
            .thenAnswer((_) => Future.value(positiveMonadResponse));
        return GoalBloc(
            addGoalUseCase: mockAddGoalUsecase,
            deleteGoalUseCase: mockDeleteGoalUseCase,
            updateGoalUseCase: mockUpdateGoalUseCase,
            fetchGoalUseCase: mockFetchGoalUseCase);
      },
      act: (bloc) => bloc.add(const Delete(deleteItemId: GOAL_ID)),
      expect: () => [Loading(), Success()],
    );
  });

  group('Error Generic API Failure: GoalBloc', () {
    blocTest<GoalBloc, GoalState>(
      'Emits [Error] states for add goal success',
      build: () {
        final failureMonadResponse = Left<Failure, void>(GenericAPIFailure());
        when(() => mockAddGoalUsecase.add(addGoal: addGoal))
            .thenAnswer((_) => Future.value(failureMonadResponse));
        return GoalBloc(
            addGoalUseCase: mockAddGoalUsecase,
            deleteGoalUseCase: mockDeleteGoalUseCase,
            updateGoalUseCase: mockUpdateGoalUseCase,
            fetchGoalUseCase: mockFetchGoalUseCase);
      },
      act: (bloc) => bloc.add(const Add(
          walletId: WALLET_ID,
          goalId: GOAL_ID,
          goalType: GoalType.buyACar,
          targetType: TargetType.account,
          monthlyContribution: 1,
          targetAmount: 1,
          targetDate: TARGET_DATE,
          targetId: TARGET_ID)),
      expect: () =>
          [Loading(), const Error(message: constants.GENERIC_ERROR_EXCEPTION)],
    );

    blocTest<GoalBloc, GoalState>(
      'Emits [Error] states for fetch goal generic error',
      build: () {
        final fetchGoalResponse =
            Left<Failure, GoalResponse>(GenericAPIFailure());
        when(() => mockFetchGoalUseCase.fetch())
            .thenAnswer((_) => Future.value(fetchGoalResponse));
        return GoalBloc(
            addGoalUseCase: mockAddGoalUsecase,
            deleteGoalUseCase: mockDeleteGoalUseCase,
            updateGoalUseCase: mockUpdateGoalUseCase,
            fetchGoalUseCase: mockFetchGoalUseCase);
      },
      act: (bloc) => bloc.add(Fetch()),
      expect: () =>
          [Loading(), const Error(message: constants.GENERIC_ERROR_EXCEPTION)],
    );

    blocTest<GoalBloc, GoalState>(
      'Emits [Error] states for update category id success',
      build: () {
        final failureMonadResponse = Left<Failure, void>(GenericAPIFailure());
        when(() => mockUpdateGoalUseCase.update(updateGoal: addGoal))
            .thenAnswer((_) => Future.value(failureMonadResponse));
        return GoalBloc(
            addGoalUseCase: mockAddGoalUsecase,
            deleteGoalUseCase: mockDeleteGoalUseCase,
            updateGoalUseCase: mockUpdateGoalUseCase,
            fetchGoalUseCase: mockFetchGoalUseCase);
      },
      act: (bloc) => bloc.add(const Update(
          walletId: WALLET_ID,
          goalId: GOAL_ID,
          goalType: GoalType.buyACar,
          targetType: TargetType.account,
          monthlyContribution: 1,
          targetAmount: 1,
          targetDate: TARGET_DATE,
          targetId: TARGET_ID)),
      expect: () =>
          [Loading(), const Error(message: constants.GENERIC_ERROR_EXCEPTION)],
    );

    blocTest<GoalBloc, GoalState>(
      'Emits [Error] states for delete goal success',
      build: () {
        final failureMonadResponse = Left<Failure, void>(GenericAPIFailure());
        when(() => mockDeleteGoalUseCase.delete(itemID: GOAL_ID))
            .thenAnswer((_) => Future.value(failureMonadResponse));
        return GoalBloc(
            addGoalUseCase: mockAddGoalUsecase,
            deleteGoalUseCase: mockDeleteGoalUseCase,
            updateGoalUseCase: mockUpdateGoalUseCase,
            fetchGoalUseCase: mockFetchGoalUseCase);
      },
      act: (bloc) => bloc.add(const Delete(deleteItemId: GOAL_ID)),
      expect: () =>
          [Loading(), const Error(message: constants.GENERIC_ERROR_EXCEPTION)],
    );
  });

  group('Error Fetch Data Failure: GoalBloc', () {
    blocTest<GoalBloc, GoalState>(
      'Emits [Error] states for add goal success',
      build: () {
        final failureMonadResponse = Left<Failure, void>(FetchDataFailure());
        when(() => mockAddGoalUsecase.add(addGoal: addGoal))
            .thenAnswer((_) => Future.value(failureMonadResponse));
        return GoalBloc(
            addGoalUseCase: mockAddGoalUsecase,
            deleteGoalUseCase: mockDeleteGoalUseCase,
            updateGoalUseCase: mockUpdateGoalUseCase,
            fetchGoalUseCase: mockFetchGoalUseCase);
      },
      act: (bloc) => bloc.add(const Add(
          walletId: WALLET_ID,
          goalId: GOAL_ID,
          goalType: GoalType.buyACar,
          targetType: TargetType.account,
          monthlyContribution: 1,
          targetAmount: 1,
          targetDate: TARGET_DATE,
          targetId: TARGET_ID)),
      expect: () => [Loading(), RedirectToLogin()],
    );

    blocTest<GoalBloc, GoalState>(
      'Emits [Error] states for fetch goal generic error',
      build: () {
        final fetchGoalResponse =
            Left<Failure, GoalResponse>(FetchDataFailure());
        when(() => mockFetchGoalUseCase.fetch())
            .thenAnswer((_) => Future.value(fetchGoalResponse));
        return GoalBloc(
            addGoalUseCase: mockAddGoalUsecase,
            deleteGoalUseCase: mockDeleteGoalUseCase,
            updateGoalUseCase: mockUpdateGoalUseCase,
            fetchGoalUseCase: mockFetchGoalUseCase);
      },
      act: (bloc) => bloc.add(Fetch()),
      expect: () => [Loading(), RedirectToLogin()],
    );

    blocTest<GoalBloc, GoalState>(
      'Emits [Error] states for update category id success',
      build: () {
        final failureMonadResponse = Left<Failure, void>(FetchDataFailure());
        when(() => mockUpdateGoalUseCase.update(updateGoal: addGoal))
            .thenAnswer((_) => Future.value(failureMonadResponse));
        return GoalBloc(
            addGoalUseCase: mockAddGoalUsecase,
            deleteGoalUseCase: mockDeleteGoalUseCase,
            updateGoalUseCase: mockUpdateGoalUseCase,
            fetchGoalUseCase: mockFetchGoalUseCase);
      },
      act: (bloc) => bloc.add(const Update(
          walletId: WALLET_ID,
          goalId: GOAL_ID,
          goalType: GoalType.buyACar,
          targetType: TargetType.account,
          monthlyContribution: 1,
          targetAmount: 1,
          targetDate: TARGET_DATE,
          targetId: TARGET_ID)),
      expect: () => [Loading(), RedirectToLogin()],
    );

    blocTest<GoalBloc, GoalState>(
      'Emits [Error] states for delete goal success',
      build: () {
        final failureMonadResponse = Left<Failure, void>(FetchDataFailure());
        when(() => mockDeleteGoalUseCase.delete(itemID: GOAL_ID))
            .thenAnswer((_) => Future.value(failureMonadResponse));
        return GoalBloc(
            addGoalUseCase: mockAddGoalUsecase,
            deleteGoalUseCase: mockDeleteGoalUseCase,
            updateGoalUseCase: mockUpdateGoalUseCase,
            fetchGoalUseCase: mockFetchGoalUseCase);
      },
      act: (bloc) => bloc.add(const Delete(deleteItemId: GOAL_ID)),
      expect: () => [Loading(), RedirectToLogin()],
    );
  });
}
