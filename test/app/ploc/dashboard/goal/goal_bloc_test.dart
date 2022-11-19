import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_blitzbudget/app/ploc/dashboard/goal/goal_bloc.dart';
import 'package:mobile_blitzbudget/app/ploc/dashboard/goal/goal_constants.dart'
    as constants;
import 'package:mobile_blitzbudget/core/failure/api_failure.dart';
import 'package:mobile_blitzbudget/core/failure/failure.dart';
import 'package:mobile_blitzbudget/domain/entities/goal/goal.dart';
import 'package:mobile_blitzbudget/domain/entities/response/goal_response.dart';
import 'package:mobile_blitzbudget/domain/usecases/dashboard/goal/add_goal_use_case.dart'
    as add_goal_usecase;
import 'package:mobile_blitzbudget/domain/usecases/dashboard/goal/delete_goal_use_case.dart'
    as delete_goal_usecase;
import 'package:mobile_blitzbudget/domain/usecases/dashboard/goal/fetch_goal_use_case.dart'
    as fetch_goal_usecase;
import 'package:mobile_blitzbudget/domain/usecases/dashboard/goal/update_goal_use_case.dart'
    as update_goal_usecase;
import 'package:mocktail/mocktail.dart';

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
  const CREATION_DATE = 'CREATIONDATE';
  const CURRENT_AMOUNT = 20.1;
  const GOAL_NAME = 'GOALNAME';
  const UPDATE_DATE = 'UPDATEDATE';

  late MockAddGoalUsecase mockAddGoalUsecase;
  late MockDeleteGoalUseCase mockDeleteGoalUseCase;
  late MockUpdateGoalUseCase mockUpdateGoalUseCase;
  late MockFetchGoalUseCase mockFetchGoalUseCase;
  const positiveMonadResponse = Right<Failure, void>('');
  const addGoal = Goal(
    targetAmount: 1,
    targetDate: TARGET_DATE,
    currentAmount: CURRENT_AMOUNT,
    goalName: GOAL_NAME,
  );
  const updateGoal = Goal(
      walletId: WALLET_ID,
      goalId: GOAL_ID,
      targetAmount: 1,
      targetDate: TARGET_DATE,
      creationDate: CREATION_DATE,
      currentAmount: CURRENT_AMOUNT,
      goalAchieved: true,
      goalName: GOAL_NAME,
      updateDate: UPDATE_DATE);

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
        targetAmount: 1,
        targetDate: TARGET_DATE,
        currentAmount: CURRENT_AMOUNT,
        goalName: GOAL_NAME,
      )),
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
        when(() => mockUpdateGoalUseCase.update(updateGoal: updateGoal))
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
          targetAmount: 1,
          targetDate: TARGET_DATE,
          creationDate: CREATION_DATE,
          currentAmount: CURRENT_AMOUNT,
          goalAchieved: true,
          goalName: GOAL_NAME,
          updateDate: UPDATE_DATE)),
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
        targetAmount: 1,
        targetDate: TARGET_DATE,
        currentAmount: CURRENT_AMOUNT,
        goalName: GOAL_NAME,
      )),
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
        when(() => mockUpdateGoalUseCase.update(updateGoal: updateGoal))
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
          targetAmount: 1,
          targetDate: TARGET_DATE,
          creationDate: CREATION_DATE,
          currentAmount: CURRENT_AMOUNT,
          goalAchieved: true,
          goalName: GOAL_NAME,
          updateDate: UPDATE_DATE)),
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
        targetAmount: 1,
        targetDate: TARGET_DATE,
        currentAmount: CURRENT_AMOUNT,
        goalName: GOAL_NAME,
      )),
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
        when(() => mockUpdateGoalUseCase.update(updateGoal: updateGoal))
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
          targetAmount: 1,
          targetDate: TARGET_DATE,
          creationDate: CREATION_DATE,
          currentAmount: CURRENT_AMOUNT,
          goalAchieved: true,
          goalName: GOAL_NAME,
          updateDate: UPDATE_DATE)),
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
