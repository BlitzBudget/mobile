import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_blitzbudget/app/ploc/dashboard/budget/budget_bloc.dart';
import 'package:mobile_blitzbudget/app/ploc/dashboard/budget/budget_constants.dart'
    as constants;
import 'package:mobile_blitzbudget/core/failure/api_failure.dart';
import 'package:mobile_blitzbudget/core/failure/failure.dart';
import 'package:mobile_blitzbudget/domain/entities/budget/budget.dart';
import 'package:mobile_blitzbudget/domain/entities/category/category_type.dart';
import 'package:mobile_blitzbudget/domain/entities/response/budget_response.dart';
import 'package:mobile_blitzbudget/domain/usecases/dashboard/budget/add_budget_use_case.dart'
    as add_budget_usecase;
import 'package:mobile_blitzbudget/domain/usecases/dashboard/budget/delete_budget_use_case.dart'
    as delete_budget_usecase;
import 'package:mobile_blitzbudget/domain/usecases/dashboard/budget/fetch_budget_use_case.dart'
    as fetch_budget_usecase;
import 'package:mobile_blitzbudget/domain/usecases/dashboard/budget/update_budget_use_case.dart'
    as update_budget_usecase;
import 'package:mocktail/mocktail.dart';

class MockAddBudgetUsecase extends Mock
    implements add_budget_usecase.AddBudgetUseCase {}

class MockDeleteBudgetUseCase extends Mock
    implements delete_budget_usecase.DeleteBudgetUseCase {}

class MockUpdateBudgetUseCase extends Mock
    implements update_budget_usecase.UpdateBudgetUseCase {}

class MockFetchBudgetUseCase extends Mock
    implements fetch_budget_usecase.FetchBudgetUseCase {}

void main() {
  const BUDGET_ID = 'budgetID';
  const WALLET_ID = 'walletID';
  const CATEGORY_ID = 'CategoryID';
  const DATE_MEANT_FOR = 'dateMeantFor';

  late MockAddBudgetUsecase mockAddBudgetUsecase;
  late MockDeleteBudgetUseCase mockDeleteBudgetUseCase;
  late MockUpdateBudgetUseCase mockUpdateBudgetUseCase;
  late MockFetchBudgetUseCase mockFetchBudgetUseCase;
  const positiveMonadResponse = Right<Failure, void>('');
  const addBudget = Budget(
      walletId: WALLET_ID,
      planned: 1,
      categoryId: CATEGORY_ID,
      budgetId: BUDGET_ID);

  setUp(() {
    mockAddBudgetUsecase = MockAddBudgetUsecase();
    mockDeleteBudgetUseCase = MockDeleteBudgetUseCase();
    mockUpdateBudgetUseCase = MockUpdateBudgetUseCase();
    mockFetchBudgetUseCase = MockFetchBudgetUseCase();
  });

  group('Success: BudgetBloc', () {
    blocTest<BudgetBloc, BudgetState>(
      'Emits [Success] states for add budget success',
      build: () {
        when(() => mockAddBudgetUsecase.add(addBudget: addBudget))
            .thenAnswer((_) => Future.value(positiveMonadResponse));
        return BudgetBloc(
            addBudgetUseCase: mockAddBudgetUsecase,
            deleteBudgetUseCase: mockDeleteBudgetUseCase,
            updateBudgetUseCase: mockUpdateBudgetUseCase,
            fetchBudgetUseCase: mockFetchBudgetUseCase);
      },
      act: (bloc) => bloc.add(const Add(
          walletId: WALLET_ID,
          planned: 1,
          dateMeantFor: DATE_MEANT_FOR,
          categoryId: CATEGORY_ID,
          categoryType: CategoryType.expense,
          budgetId: BUDGET_ID,
          used: 0)),
      expect: () => [Loading(), Success()],
    );

    blocTest<BudgetBloc, BudgetState>(
      'Emits [Success] states for fetch budget success',
      build: () {
        const fetchBudgetResponse =
            Right<Failure, BudgetResponse>(BudgetResponse());
        when(() => mockFetchBudgetUseCase.fetch())
            .thenAnswer((_) => Future.value(fetchBudgetResponse));
        return BudgetBloc(
            addBudgetUseCase: mockAddBudgetUsecase,
            deleteBudgetUseCase: mockDeleteBudgetUseCase,
            updateBudgetUseCase: mockUpdateBudgetUseCase,
            fetchBudgetUseCase: mockFetchBudgetUseCase);
      },
      act: (bloc) => bloc.add(Fetch()),
      expect: () => [Loading(), Success()],
    );

    blocTest<BudgetBloc, BudgetState>(
      'Emits [Success] states for update category id success',
      build: () {
        when(() => mockUpdateBudgetUseCase.updateCategoryId(
                categoryId: CATEGORY_ID, budgetId: BUDGET_ID))
            .thenAnswer((_) => Future.value(positiveMonadResponse));
        return BudgetBloc(
            addBudgetUseCase: mockAddBudgetUsecase,
            deleteBudgetUseCase: mockDeleteBudgetUseCase,
            updateBudgetUseCase: mockUpdateBudgetUseCase,
            fetchBudgetUseCase: mockFetchBudgetUseCase);
      },
      act: (bloc) => bloc.add(const UpdateCategoryId(
          budgetId: BUDGET_ID, categoryId: CATEGORY_ID, walletId: WALLET_ID)),
      expect: () => [Loading(), Success()],
    );

    blocTest<BudgetBloc, BudgetState>(
      'Emits [Success] states for planned success',
      build: () {
        when(() => mockUpdateBudgetUseCase.updatePlanned(
                planned: 1, budgetId: BUDGET_ID))
            .thenAnswer((_) => Future.value(positiveMonadResponse));
        return BudgetBloc(
            addBudgetUseCase: mockAddBudgetUsecase,
            deleteBudgetUseCase: mockDeleteBudgetUseCase,
            updateBudgetUseCase: mockUpdateBudgetUseCase,
            fetchBudgetUseCase: mockFetchBudgetUseCase);
      },
      act: (bloc) => bloc.add(const UpdatePlanned(
          budgetId: BUDGET_ID, walletId: WALLET_ID, planned: 1)),
      expect: () => [Loading(), Success()],
    );

    blocTest<BudgetBloc, BudgetState>(
      'Emits [Success] states for delete budget success',
      build: () {
        when(() => mockDeleteBudgetUseCase.delete(itemID: BUDGET_ID))
            .thenAnswer((_) => Future.value(positiveMonadResponse));
        return BudgetBloc(
            addBudgetUseCase: mockAddBudgetUsecase,
            deleteBudgetUseCase: mockDeleteBudgetUseCase,
            updateBudgetUseCase: mockUpdateBudgetUseCase,
            fetchBudgetUseCase: mockFetchBudgetUseCase);
      },
      act: (bloc) => bloc.add(const Delete(deleteItemId: BUDGET_ID)),
      expect: () => [Loading(), Success()],
    );
  });

  group('Error Generic API Failure: BudgetBloc', () {
    blocTest<BudgetBloc, BudgetState>(
      'Emits [Error] states for add budget success',
      build: () {
        final failureMonadResponse = Left<Failure, void>(GenericAPIFailure());
        when(() => mockAddBudgetUsecase.add(addBudget: addBudget))
            .thenAnswer((_) => Future.value(failureMonadResponse));
        return BudgetBloc(
            addBudgetUseCase: mockAddBudgetUsecase,
            deleteBudgetUseCase: mockDeleteBudgetUseCase,
            updateBudgetUseCase: mockUpdateBudgetUseCase,
            fetchBudgetUseCase: mockFetchBudgetUseCase);
      },
      act: (bloc) => bloc.add(const Add(
          walletId: WALLET_ID,
          planned: 1,
          dateMeantFor: DATE_MEANT_FOR,
          categoryId: CATEGORY_ID,
          categoryType: CategoryType.expense,
          budgetId: BUDGET_ID,
          used: 0)),
      expect: () =>
          [Loading(), const Error(message: constants.GENERIC_ERROR_EXCEPTION)],
    );

    blocTest<BudgetBloc, BudgetState>(
      'Emits [Error] states for fetch budget generic error',
      build: () {
        final fetchBudgetResponse =
            Left<Failure, BudgetResponse>(GenericAPIFailure());
        when(() => mockFetchBudgetUseCase.fetch())
            .thenAnswer((_) => Future.value(fetchBudgetResponse));
        return BudgetBloc(
            addBudgetUseCase: mockAddBudgetUsecase,
            deleteBudgetUseCase: mockDeleteBudgetUseCase,
            updateBudgetUseCase: mockUpdateBudgetUseCase,
            fetchBudgetUseCase: mockFetchBudgetUseCase);
      },
      act: (bloc) => bloc.add(Fetch()),
      expect: () =>
          [Loading(), const Error(message: constants.GENERIC_ERROR_EXCEPTION)],
    );

    blocTest<BudgetBloc, BudgetState>(
      'Emits [Error] states for update category id success',
      build: () {
        final failureMonadResponse = Left<Failure, void>(GenericAPIFailure());
        when(() => mockUpdateBudgetUseCase.updateCategoryId(
                categoryId: CATEGORY_ID, budgetId: BUDGET_ID))
            .thenAnswer((_) => Future.value(failureMonadResponse));
        return BudgetBloc(
            addBudgetUseCase: mockAddBudgetUsecase,
            deleteBudgetUseCase: mockDeleteBudgetUseCase,
            updateBudgetUseCase: mockUpdateBudgetUseCase,
            fetchBudgetUseCase: mockFetchBudgetUseCase);
      },
      act: (bloc) => bloc.add(const UpdateCategoryId(
          budgetId: BUDGET_ID, categoryId: CATEGORY_ID, walletId: WALLET_ID)),
      expect: () =>
          [Loading(), const Error(message: constants.GENERIC_ERROR_EXCEPTION)],
    );

    blocTest<BudgetBloc, BudgetState>(
      'Emits [Error] states for planned success',
      build: () {
        final failureMonadResponse = Left<Failure, void>(GenericAPIFailure());
        when(() => mockUpdateBudgetUseCase.updatePlanned(
                planned: 1, budgetId: BUDGET_ID))
            .thenAnswer((_) => Future.value(failureMonadResponse));
        return BudgetBloc(
            addBudgetUseCase: mockAddBudgetUsecase,
            deleteBudgetUseCase: mockDeleteBudgetUseCase,
            updateBudgetUseCase: mockUpdateBudgetUseCase,
            fetchBudgetUseCase: mockFetchBudgetUseCase);
      },
      act: (bloc) => bloc.add(const UpdatePlanned(
          budgetId: BUDGET_ID, walletId: WALLET_ID, planned: 1)),
      expect: () =>
          [Loading(), const Error(message: constants.GENERIC_ERROR_EXCEPTION)],
    );

    blocTest<BudgetBloc, BudgetState>(
      'Emits [Error] states for delete budget success',
      build: () {
        final failureMonadResponse = Left<Failure, void>(GenericAPIFailure());
        when(() => mockDeleteBudgetUseCase.delete(itemID: BUDGET_ID))
            .thenAnswer((_) => Future.value(failureMonadResponse));
        return BudgetBloc(
            addBudgetUseCase: mockAddBudgetUsecase,
            deleteBudgetUseCase: mockDeleteBudgetUseCase,
            updateBudgetUseCase: mockUpdateBudgetUseCase,
            fetchBudgetUseCase: mockFetchBudgetUseCase);
      },
      act: (bloc) => bloc.add(const Delete(deleteItemId: BUDGET_ID)),
      expect: () =>
          [Loading(), const Error(message: constants.GENERIC_ERROR_EXCEPTION)],
    );
  });

  group('Error Fetch Data Failure: BudgetBloc', () {
    blocTest<BudgetBloc, BudgetState>(
      'Emits [Error] states for add budget success',
      build: () {
        final failureMonadResponse = Left<Failure, void>(FetchDataFailure());
        when(() => mockAddBudgetUsecase.add(addBudget: addBudget))
            .thenAnswer((_) => Future.value(failureMonadResponse));
        return BudgetBloc(
            addBudgetUseCase: mockAddBudgetUsecase,
            deleteBudgetUseCase: mockDeleteBudgetUseCase,
            updateBudgetUseCase: mockUpdateBudgetUseCase,
            fetchBudgetUseCase: mockFetchBudgetUseCase);
      },
      act: (bloc) => bloc.add(const Add(
          walletId: WALLET_ID,
          planned: 1,
          dateMeantFor: DATE_MEANT_FOR,
          categoryId: CATEGORY_ID,
          categoryType: CategoryType.expense,
          budgetId: BUDGET_ID,
          used: 0)),
      expect: () => [Loading(), RedirectToLogin()],
    );

    blocTest<BudgetBloc, BudgetState>(
      'Emits [Error] states for fetch budget generic error',
      build: () {
        final fetchBudgetResponse =
            Left<Failure, BudgetResponse>(FetchDataFailure());
        when(() => mockFetchBudgetUseCase.fetch())
            .thenAnswer((_) => Future.value(fetchBudgetResponse));
        return BudgetBloc(
            addBudgetUseCase: mockAddBudgetUsecase,
            deleteBudgetUseCase: mockDeleteBudgetUseCase,
            updateBudgetUseCase: mockUpdateBudgetUseCase,
            fetchBudgetUseCase: mockFetchBudgetUseCase);
      },
      act: (bloc) => bloc.add(Fetch()),
      expect: () => [Loading(), RedirectToLogin()],
    );

    blocTest<BudgetBloc, BudgetState>(
      'Emits [Error] states for update category id success',
      build: () {
        final failureMonadResponse = Left<Failure, void>(FetchDataFailure());
        when(() => mockUpdateBudgetUseCase.updateCategoryId(
                categoryId: CATEGORY_ID, budgetId: BUDGET_ID))
            .thenAnswer((_) => Future.value(failureMonadResponse));
        return BudgetBloc(
            addBudgetUseCase: mockAddBudgetUsecase,
            deleteBudgetUseCase: mockDeleteBudgetUseCase,
            updateBudgetUseCase: mockUpdateBudgetUseCase,
            fetchBudgetUseCase: mockFetchBudgetUseCase);
      },
      act: (bloc) => bloc.add(const UpdateCategoryId(
          budgetId: BUDGET_ID, categoryId: CATEGORY_ID, walletId: WALLET_ID)),
      expect: () => [Loading(), RedirectToLogin()],
    );

    blocTest<BudgetBloc, BudgetState>(
      'Emits [Error] states for planned success',
      build: () {
        final failureMonadResponse = Left<Failure, void>(FetchDataFailure());
        when(() => mockUpdateBudgetUseCase.updatePlanned(
                planned: 1, budgetId: BUDGET_ID))
            .thenAnswer((_) => Future.value(failureMonadResponse));
        return BudgetBloc(
            addBudgetUseCase: mockAddBudgetUsecase,
            deleteBudgetUseCase: mockDeleteBudgetUseCase,
            updateBudgetUseCase: mockUpdateBudgetUseCase,
            fetchBudgetUseCase: mockFetchBudgetUseCase);
      },
      act: (bloc) => bloc.add(const UpdatePlanned(
          budgetId: BUDGET_ID, walletId: WALLET_ID, planned: 1)),
      expect: () => [Loading(), RedirectToLogin()],
    );

    blocTest<BudgetBloc, BudgetState>(
      'Emits [Error] states for delete budget success',
      build: () {
        final failureMonadResponse = Left<Failure, void>(FetchDataFailure());
        when(() => mockDeleteBudgetUseCase.delete(itemID: BUDGET_ID))
            .thenAnswer((_) => Future.value(failureMonadResponse));
        return BudgetBloc(
            addBudgetUseCase: mockAddBudgetUsecase,
            deleteBudgetUseCase: mockDeleteBudgetUseCase,
            updateBudgetUseCase: mockUpdateBudgetUseCase,
            fetchBudgetUseCase: mockFetchBudgetUseCase);
      },
      act: (bloc) => bloc.add(const Delete(deleteItemId: BUDGET_ID)),
      expect: () => [Loading(), RedirectToLogin()],
    );
  });
}
