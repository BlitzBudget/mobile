// ignore_for_file: unused_import

import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_blitzbudget/app/ploc/dashboard/transaction/transaction_bloc.dart';
import 'package:mobile_blitzbudget/app/ploc/dashboard/transaction/transaction_constants.dart'
    as constants;
import 'package:mobile_blitzbudget/core/failure/api_failure.dart';
import 'package:mobile_blitzbudget/core/failure/failure.dart';
import 'package:mobile_blitzbudget/domain/entities/category/category_type.dart';
import 'package:mobile_blitzbudget/domain/entities/response/transaction_response.dart';
import 'package:mobile_blitzbudget/domain/entities/transaction/recurrence.dart';
import 'package:mobile_blitzbudget/domain/entities/transaction/transaction.dart';
import 'package:mobile_blitzbudget/domain/usecases/dashboard/transaction/add_transaction_use_case.dart'
    as add_transaction_use_case;
import 'package:mobile_blitzbudget/domain/usecases/dashboard/transaction/delete_transaction_use_case.dart'
    as delete_transaction_use_case;
import 'package:mobile_blitzbudget/domain/usecases/dashboard/transaction/fetch_transaction_use_case.dart'
    as fetch_transaction_use_case;
import 'package:mobile_blitzbudget/domain/usecases/dashboard/transaction/update_transaction_use_case.dart'
    as update_transaction_use_case;
import 'package:mocktail/mocktail.dart';

class MockDeleteTransactionUseCase extends Mock
    implements delete_transaction_use_case.DeleteTransactionUseCase {}

class MockUpdateTransactionUseCase extends Mock
    implements update_transaction_use_case.UpdateTransactionUseCase {}

class MockAddTransactionUseCase extends Mock
    implements add_transaction_use_case.AddTransactionUseCase {}

class MockFetchTransactionUseCase extends Mock
    implements fetch_transaction_use_case.FetchTransactionUseCase {}

void main() {
  const TRANSACTION_ID = 'transactionID';
  const DESCRIPTION = 'description';
  const CATEGORY_ID = 'categoryID';
  const WALLET_ID = 'wallet_id';
  final tags = {'1', '2', '3'}.toList();

  late MockDeleteTransactionUseCase mockDeleteTransactionUseCase;
  late MockUpdateTransactionUseCase mockUpdateTransactionUseCase;
  late MockAddTransactionUseCase mockAddTransactionUseCase;
  late MockFetchTransactionUseCase mockFetchTransactionUseCase;
  const positiveMonadResponse = Right<Failure, void>('');

  setUp(() {
    // Fallback value for Transaction
    registerFallbackValue(const Transaction());
    mockDeleteTransactionUseCase = MockDeleteTransactionUseCase();
    mockUpdateTransactionUseCase = MockUpdateTransactionUseCase();
    mockAddTransactionUseCase = MockAddTransactionUseCase();
    mockFetchTransactionUseCase = MockFetchTransactionUseCase();
  });

  group('Success: TransactionBloc', () {
    const transactionResponse = TransactionResponse();
    blocTest<TransactionBloc, TransactionState>(
      'Emits [Success] states for fetch transaction success',
      build: () {
        const fetchResponse =
            Right<Failure, TransactionResponse>(transactionResponse);
        when(() => mockFetchTransactionUseCase.fetch())
            .thenAnswer((_) => Future.value(fetchResponse));
        return TransactionBloc(
          deleteTransactionUseCase: mockDeleteTransactionUseCase,
          updateTransactionUseCase: mockUpdateTransactionUseCase,
          addTransactionUseCase: mockAddTransactionUseCase,
          fetchTransactionUseCase: mockFetchTransactionUseCase,
        );
      },
      act: (bloc) => bloc.add(const Fetch()),
      expect: () => [
        Loading(),
        const TransactionsFetched(transactionModel: transactionResponse)
      ],
    );

    blocTest<TransactionBloc, TransactionState>(
      'Emits [Success] states for add transaction success',
      build: () {
        const fetchResponse = Right<Failure, void>('');
        when(() => mockAddTransactionUseCase.add(
                addTransaction: any(named: 'addTransaction')))
            .thenAnswer((_) => Future.value(fetchResponse));
        return TransactionBloc(
          deleteTransactionUseCase: mockDeleteTransactionUseCase,
          updateTransactionUseCase: mockUpdateTransactionUseCase,
          addTransactionUseCase: mockAddTransactionUseCase,
          fetchTransactionUseCase: mockFetchTransactionUseCase,
        );
      },
      act: (bloc) => bloc.add(Add(
          walletId: WALLET_ID,
          amount: 1,
          categoryId: CATEGORY_ID,
          transactionId: TRANSACTION_ID,
          description: DESCRIPTION,
          tags: tags)),
      expect: () => [Loading(), Success()],
    );

    blocTest<TransactionBloc, TransactionState>(
      'Emits [Success] states for update account amount success',
      build: () {
        when(() => mockUpdateTransactionUseCase.updateAmount(
                newAmount: 1, transactionId: TRANSACTION_ID))
            .thenAnswer((_) => Future.value(positiveMonadResponse));
        return TransactionBloc(
          deleteTransactionUseCase: mockDeleteTransactionUseCase,
          updateTransactionUseCase: mockUpdateTransactionUseCase,
          addTransactionUseCase: mockAddTransactionUseCase,
          fetchTransactionUseCase: mockFetchTransactionUseCase,
        );
      },
      act: (bloc) => bloc
          .add(const UpdateAmount(amount: 1, transactionId: TRANSACTION_ID)),
      expect: () => [Loading(), Success()],
    );

    blocTest<TransactionBloc, TransactionState>(
      'Emits [Success] states for update category id success',
      build: () {
        when(() => mockUpdateTransactionUseCase.updateCategoryId(
                categoryId: CATEGORY_ID, transactionId: TRANSACTION_ID))
            .thenAnswer((_) => Future.value(positiveMonadResponse));
        return TransactionBloc(
          deleteTransactionUseCase: mockDeleteTransactionUseCase,
          updateTransactionUseCase: mockUpdateTransactionUseCase,
          addTransactionUseCase: mockAddTransactionUseCase,
          fetchTransactionUseCase: mockFetchTransactionUseCase,
        );
      },
      act: (bloc) => bloc.add(const UpdateCategoryID(
          categoryID: CATEGORY_ID, transactionId: TRANSACTION_ID)),
      expect: () => [Loading(), Success()],
    );

    blocTest<TransactionBloc, TransactionState>(
      'Emits [Success] states for update description success',
      build: () {
        when(() => mockUpdateTransactionUseCase.updateDescription(
                description: DESCRIPTION, transactionId: TRANSACTION_ID))
            .thenAnswer((_) => Future.value(positiveMonadResponse));
        return TransactionBloc(
          deleteTransactionUseCase: mockDeleteTransactionUseCase,
          updateTransactionUseCase: mockUpdateTransactionUseCase,
          addTransactionUseCase: mockAddTransactionUseCase,
          fetchTransactionUseCase: mockFetchTransactionUseCase,
        );
      },
      act: (bloc) => bloc.add(const UpdateDescription(
          description: DESCRIPTION, transactionId: TRANSACTION_ID)),
      expect: () => [Loading(), Success()],
    );

    blocTest<TransactionBloc, TransactionState>(
      'Emits [Success] states for update tags success',
      build: () {
        when(() => mockUpdateTransactionUseCase.updateTags(
                tags: tags, transactionId: TRANSACTION_ID))
            .thenAnswer((_) => Future.value(positiveMonadResponse));
        return TransactionBloc(
          deleteTransactionUseCase: mockDeleteTransactionUseCase,
          updateTransactionUseCase: mockUpdateTransactionUseCase,
          addTransactionUseCase: mockAddTransactionUseCase,
          fetchTransactionUseCase: mockFetchTransactionUseCase,
        );
      },
      act: (bloc) =>
          bloc.add(UpdateTags(tags: tags, transactionId: TRANSACTION_ID)),
      expect: () => [Loading(), Success()],
    );

    blocTest<TransactionBloc, TransactionState>(
      'Emits [Success] states for delete transaction success',
      build: () {
        when(() => mockDeleteTransactionUseCase.delete(itemID: TRANSACTION_ID))
            .thenAnswer((_) => Future.value(positiveMonadResponse));
        return TransactionBloc(
          deleteTransactionUseCase: mockDeleteTransactionUseCase,
          updateTransactionUseCase: mockUpdateTransactionUseCase,
          addTransactionUseCase: mockAddTransactionUseCase,
          fetchTransactionUseCase: mockFetchTransactionUseCase,
        );
      },
      act: (bloc) => bloc.add(const Delete(transactionId: TRANSACTION_ID)),
      expect: () => [Loading(), Success()],
    );
  });

  group('Error Generic API Failure: TransactionBloc', () {
    blocTest<TransactionBloc, TransactionState>(
      'Emits [Success] states for fetch transaction success',
      build: () {
        final failureMonadResponse =
            Left<Failure, TransactionResponse>(GenericAPIFailure());
        when(() => mockFetchTransactionUseCase.fetch())
            .thenAnswer((_) => Future.value(failureMonadResponse));
        return TransactionBloc(
          deleteTransactionUseCase: mockDeleteTransactionUseCase,
          updateTransactionUseCase: mockUpdateTransactionUseCase,
          addTransactionUseCase: mockAddTransactionUseCase,
          fetchTransactionUseCase: mockFetchTransactionUseCase,
        );
      },
      act: (bloc) => bloc.add(const Fetch()),
      expect: () =>
          [Loading(), const Error(message: constants.GENERIC_ERROR_EXCEPTION)],
    );

    blocTest<TransactionBloc, TransactionState>(
      'Emits [Success] states for add transaction success',
      build: () {
        final failureMonadResponse =
            Left<Failure, TransactionResponse>(GenericAPIFailure());
        when(() => mockAddTransactionUseCase.add(
                addTransaction: any(named: 'addTransaction')))
            .thenAnswer((_) => Future.value(failureMonadResponse));
        return TransactionBloc(
          deleteTransactionUseCase: mockDeleteTransactionUseCase,
          updateTransactionUseCase: mockUpdateTransactionUseCase,
          addTransactionUseCase: mockAddTransactionUseCase,
          fetchTransactionUseCase: mockFetchTransactionUseCase,
        );
      },
      act: (bloc) => bloc.add(Add(
          walletId: WALLET_ID,
          amount: 1,
          categoryId: CATEGORY_ID,
          transactionId: TRANSACTION_ID,
          description: DESCRIPTION,
          tags: tags)),
      expect: () =>
          [Loading(), const Error(message: constants.GENERIC_ERROR_EXCEPTION)],
    );

    blocTest<TransactionBloc, TransactionState>(
      'Emits [Error] states for update account amount success',
      build: () {
        final failureMonadResponse = Left<Failure, void>(GenericAPIFailure());
        when(() => mockUpdateTransactionUseCase.updateAmount(
                newAmount: 1, transactionId: TRANSACTION_ID))
            .thenAnswer((_) => Future.value(failureMonadResponse));
        return TransactionBloc(
          deleteTransactionUseCase: mockDeleteTransactionUseCase,
          updateTransactionUseCase: mockUpdateTransactionUseCase,
          addTransactionUseCase: mockAddTransactionUseCase,
          fetchTransactionUseCase: mockFetchTransactionUseCase,
        );
      },
      act: (bloc) => bloc
          .add(const UpdateAmount(amount: 1, transactionId: TRANSACTION_ID)),
      expect: () =>
          [Loading(), const Error(message: constants.GENERIC_ERROR_EXCEPTION)],
    );

    blocTest<TransactionBloc, TransactionState>(
      'Emits [Error] states for update category id success',
      build: () {
        final failureMonadResponse = Left<Failure, void>(GenericAPIFailure());
        when(() => mockUpdateTransactionUseCase.updateCategoryId(
                categoryId: CATEGORY_ID, transactionId: TRANSACTION_ID))
            .thenAnswer((_) => Future.value(failureMonadResponse));
        return TransactionBloc(
          deleteTransactionUseCase: mockDeleteTransactionUseCase,
          updateTransactionUseCase: mockUpdateTransactionUseCase,
          addTransactionUseCase: mockAddTransactionUseCase,
          fetchTransactionUseCase: mockFetchTransactionUseCase,
        );
      },
      act: (bloc) => bloc.add(const UpdateCategoryID(
          categoryID: CATEGORY_ID, transactionId: TRANSACTION_ID)),
      expect: () =>
          [Loading(), const Error(message: constants.GENERIC_ERROR_EXCEPTION)],
    );

    blocTest<TransactionBloc, TransactionState>(
      'Emits [error] states for update description success',
      build: () {
        final failureMonadResponse = Left<Failure, void>(GenericAPIFailure());
        when(() => mockUpdateTransactionUseCase.updateDescription(
                description: DESCRIPTION, transactionId: TRANSACTION_ID))
            .thenAnswer((_) => Future.value(failureMonadResponse));
        return TransactionBloc(
          deleteTransactionUseCase: mockDeleteTransactionUseCase,
          updateTransactionUseCase: mockUpdateTransactionUseCase,
          addTransactionUseCase: mockAddTransactionUseCase,
          fetchTransactionUseCase: mockFetchTransactionUseCase,
        );
      },
      act: (bloc) => bloc.add(const UpdateDescription(
          description: DESCRIPTION, transactionId: TRANSACTION_ID)),
      expect: () =>
          [Loading(), const Error(message: constants.GENERIC_ERROR_EXCEPTION)],
    );

    blocTest<TransactionBloc, TransactionState>(
      'Emits [Error] states for update tags success',
      build: () {
        final failureMonadResponse = Left<Failure, void>(GenericAPIFailure());
        when(() => mockUpdateTransactionUseCase.updateTags(
                tags: tags, transactionId: TRANSACTION_ID))
            .thenAnswer((_) => Future.value(failureMonadResponse));
        return TransactionBloc(
          deleteTransactionUseCase: mockDeleteTransactionUseCase,
          updateTransactionUseCase: mockUpdateTransactionUseCase,
          addTransactionUseCase: mockAddTransactionUseCase,
          fetchTransactionUseCase: mockFetchTransactionUseCase,
        );
      },
      act: (bloc) =>
          bloc.add(UpdateTags(tags: tags, transactionId: TRANSACTION_ID)),
      expect: () =>
          [Loading(), const Error(message: constants.GENERIC_ERROR_EXCEPTION)],
    );

    blocTest<TransactionBloc, TransactionState>(
      'Emits [Error] states for delete transaction success',
      build: () {
        final failureMonadResponse = Left<Failure, void>(GenericAPIFailure());
        when(() => mockDeleteTransactionUseCase.delete(itemID: TRANSACTION_ID))
            .thenAnswer((_) => Future.value(failureMonadResponse));
        return TransactionBloc(
          deleteTransactionUseCase: mockDeleteTransactionUseCase,
          updateTransactionUseCase: mockUpdateTransactionUseCase,
          addTransactionUseCase: mockAddTransactionUseCase,
          fetchTransactionUseCase: mockFetchTransactionUseCase,
        );
      },
      act: (bloc) => bloc.add(const Delete(transactionId: TRANSACTION_ID)),
      expect: () =>
          [Loading(), const Error(message: constants.GENERIC_ERROR_EXCEPTION)],
    );
  });

  group('Error Fetch Data Failure: TransactionBloc', () {
    blocTest<TransactionBloc, TransactionState>(
      'Emits [Success] states for fetch transaction success',
      build: () {
        final failureMonadResponse =
            Left<Failure, TransactionResponse>(FetchDataFailure());
        when(() => mockFetchTransactionUseCase.fetch())
            .thenAnswer((_) => Future.value(failureMonadResponse));
        return TransactionBloc(
          deleteTransactionUseCase: mockDeleteTransactionUseCase,
          updateTransactionUseCase: mockUpdateTransactionUseCase,
          addTransactionUseCase: mockAddTransactionUseCase,
          fetchTransactionUseCase: mockFetchTransactionUseCase,
        );
      },
      act: (bloc) => bloc.add(const Fetch()),
      expect: () => [Loading(), RedirectToLogin()],
    );

    blocTest<TransactionBloc, TransactionState>(
      'Emits [Success] states for add transaction success',
      build: () {
        final failureMonadResponse =
            Left<Failure, TransactionResponse>(FetchDataFailure());
        when(() => mockAddTransactionUseCase.add(
                addTransaction: any(named: 'addTransaction')))
            .thenAnswer((_) => Future.value(failureMonadResponse));
        return TransactionBloc(
          deleteTransactionUseCase: mockDeleteTransactionUseCase,
          updateTransactionUseCase: mockUpdateTransactionUseCase,
          addTransactionUseCase: mockAddTransactionUseCase,
          fetchTransactionUseCase: mockFetchTransactionUseCase,
        );
      },
      act: (bloc) => bloc.add(Add(
          walletId: WALLET_ID,
          amount: 1,
          categoryId: CATEGORY_ID,
          transactionId: TRANSACTION_ID,
          description: DESCRIPTION,
          tags: tags)),
      expect: () => [Loading(), RedirectToLogin()],
    );

    blocTest<TransactionBloc, TransactionState>(
      'Emits [Success] states for update account amount success',
      build: () {
        final failureMonadResponse = Left<Failure, void>(FetchDataFailure());
        when(() => mockUpdateTransactionUseCase.updateAmount(
                newAmount: 1, transactionId: TRANSACTION_ID))
            .thenAnswer((_) => Future.value(failureMonadResponse));
        return TransactionBloc(
          deleteTransactionUseCase: mockDeleteTransactionUseCase,
          updateTransactionUseCase: mockUpdateTransactionUseCase,
          addTransactionUseCase: mockAddTransactionUseCase,
          fetchTransactionUseCase: mockFetchTransactionUseCase,
        );
      },
      act: (bloc) => bloc
          .add(const UpdateAmount(amount: 1, transactionId: TRANSACTION_ID)),
      expect: () => [Loading(), RedirectToLogin()],
    );

    blocTest<TransactionBloc, TransactionState>(
      'Emits [Error] states for update category id success',
      build: () {
        final failureMonadResponse = Left<Failure, void>(FetchDataFailure());
        when(() => mockUpdateTransactionUseCase.updateCategoryId(
                categoryId: CATEGORY_ID, transactionId: TRANSACTION_ID))
            .thenAnswer((_) => Future.value(failureMonadResponse));
        return TransactionBloc(
          deleteTransactionUseCase: mockDeleteTransactionUseCase,
          updateTransactionUseCase: mockUpdateTransactionUseCase,
          addTransactionUseCase: mockAddTransactionUseCase,
          fetchTransactionUseCase: mockFetchTransactionUseCase,
        );
      },
      act: (bloc) => bloc.add(const UpdateCategoryID(
          categoryID: CATEGORY_ID, transactionId: TRANSACTION_ID)),
      expect: () => [Loading(), RedirectToLogin()],
    );

    blocTest<TransactionBloc, TransactionState>(
      'Emits [Success] states for update description success',
      build: () {
        final failureMonadResponse = Left<Failure, void>(FetchDataFailure());
        when(() => mockUpdateTransactionUseCase.updateDescription(
                description: DESCRIPTION, transactionId: TRANSACTION_ID))
            .thenAnswer((_) => Future.value(failureMonadResponse));
        return TransactionBloc(
          deleteTransactionUseCase: mockDeleteTransactionUseCase,
          updateTransactionUseCase: mockUpdateTransactionUseCase,
          addTransactionUseCase: mockAddTransactionUseCase,
          fetchTransactionUseCase: mockFetchTransactionUseCase,
        );
      },
      act: (bloc) => bloc.add(const UpdateDescription(
          description: DESCRIPTION, transactionId: TRANSACTION_ID)),
      expect: () => [Loading(), RedirectToLogin()],
    );

    blocTest<TransactionBloc, TransactionState>(
      'Emits [Error] states for update tags success',
      build: () {
        final failureMonadResponse = Left<Failure, void>(FetchDataFailure());
        when(() => mockUpdateTransactionUseCase.updateTags(
                tags: tags, transactionId: TRANSACTION_ID))
            .thenAnswer((_) => Future.value(failureMonadResponse));
        return TransactionBloc(
          deleteTransactionUseCase: mockDeleteTransactionUseCase,
          updateTransactionUseCase: mockUpdateTransactionUseCase,
          addTransactionUseCase: mockAddTransactionUseCase,
          fetchTransactionUseCase: mockFetchTransactionUseCase,
        );
      },
      act: (bloc) =>
          bloc.add(UpdateTags(tags: tags, transactionId: TRANSACTION_ID)),
      expect: () => [Loading(), RedirectToLogin()],
    );

    blocTest<TransactionBloc, TransactionState>(
      'Emits [Error] states for delete transaction success',
      build: () {
        final failureMonadResponse = Left<Failure, void>(FetchDataFailure());
        when(() => mockDeleteTransactionUseCase.delete(itemID: TRANSACTION_ID))
            .thenAnswer((_) => Future.value(failureMonadResponse));
        return TransactionBloc(
          deleteTransactionUseCase: mockDeleteTransactionUseCase,
          updateTransactionUseCase: mockUpdateTransactionUseCase,
          addTransactionUseCase: mockAddTransactionUseCase,
          fetchTransactionUseCase: mockFetchTransactionUseCase,
        );
      },
      act: (bloc) => bloc.add(const Delete(transactionId: TRANSACTION_ID)),
      expect: () => [Loading(), RedirectToLogin()],
    );
  });
}
