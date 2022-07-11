import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_blitzbudget/app/ploc/dashboard/recurring-transaction/recurring_transaction_bloc.dart';
import 'package:mobile_blitzbudget/app/ploc/dashboard/recurring-transaction/recurring_transaction_constants.dart'
    as constants;
import 'package:mobile_blitzbudget/core/failure/api_failure.dart';
import 'package:mobile_blitzbudget/core/failure/failure.dart';
import 'package:mobile_blitzbudget/domain/entities/transaction/recurrence.dart';
import 'package:mobile_blitzbudget/domain/usecases/dashboard/recurring-transaction/delete_recurring_transaction_use_case.dart'
    as delete_recurring_transaction_usecase;
import 'package:mobile_blitzbudget/domain/usecases/dashboard/recurring-transaction/update_recurring_transaction_use_case.dart'
    as update_recurring_transaction_use_case;
import 'package:mocktail/mocktail.dart';

class MockDeleteRecurringTransactionUseCase extends Mock
    implements
        delete_recurring_transaction_usecase.DeleteRecurringTransactionUseCase {
}

class MockUpdateRecurringTransactionUseCase extends Mock
    implements
        update_recurring_transaction_use_case
            .UpdateRecurringTransactionUseCase {}

void main() {
  const RECURRING_TRANSACTION_ID = 'recurringTransactionID';
  const DESCRIPTION = 'description';
  const ACCOUNT_ID = 'accountId';
  const CATEGORY_ID = 'categoryID';
  final tags = {'1', '2', '3'}.toList();

  late MockDeleteRecurringTransactionUseCase
      mockDeleteRecurringTransactionUseCase;
  late MockUpdateRecurringTransactionUseCase
      mockUpdateRecurringTransactionUseCase;
  const positiveMonadResponse = Right<Failure, void>('');

  setUp(() {
    mockDeleteRecurringTransactionUseCase =
        MockDeleteRecurringTransactionUseCase();
    mockUpdateRecurringTransactionUseCase =
        MockUpdateRecurringTransactionUseCase();
  });

  group('Success: RecurringTransactionBloc', () {
    blocTest<RecurringTransactionBloc, RecurringTransactionState>(
      'Emits [Success] states for update account id success',
      build: () {
        when(() => mockUpdateRecurringTransactionUseCase.updateAccountId(
                accountId: ACCOUNT_ID,
                recurringTransactionId: RECURRING_TRANSACTION_ID))
            .thenAnswer((_) => Future.value(positiveMonadResponse));
        return RecurringTransactionBloc(
          deleteRecurringTransactionUseCase:
              mockDeleteRecurringTransactionUseCase,
          updateRecurringTransactionUseCase:
              mockUpdateRecurringTransactionUseCase,
        );
      },
      act: (bloc) => bloc.add(const UpdateAccountID(
          accountId: ACCOUNT_ID,
          recurringTransactionId: RECURRING_TRANSACTION_ID)),
      expect: () => [Loading(), Success()],
    );

    blocTest<RecurringTransactionBloc, RecurringTransactionState>(
      'Emits [Success] states for update account amount success',
      build: () {
        when(() => mockUpdateRecurringTransactionUseCase.updateAmount(
                newAmount: 1, recurringTransactionId: RECURRING_TRANSACTION_ID))
            .thenAnswer((_) => Future.value(positiveMonadResponse));
        return RecurringTransactionBloc(
          deleteRecurringTransactionUseCase:
              mockDeleteRecurringTransactionUseCase,
          updateRecurringTransactionUseCase:
              mockUpdateRecurringTransactionUseCase,
        );
      },
      act: (bloc) => bloc.add(const UpdateAmount(
          amount: 1, recurringTransactionId: RECURRING_TRANSACTION_ID)),
      expect: () => [Loading(), Success()],
    );

    blocTest<RecurringTransactionBloc, RecurringTransactionState>(
      'Emits [Success] states for update category id success',
      build: () {
        when(() => mockUpdateRecurringTransactionUseCase.updateCategoryId(
                categoryId: CATEGORY_ID,
                recurringTransactionId: RECURRING_TRANSACTION_ID))
            .thenAnswer((_) => Future.value(positiveMonadResponse));
        return RecurringTransactionBloc(
          deleteRecurringTransactionUseCase:
              mockDeleteRecurringTransactionUseCase,
          updateRecurringTransactionUseCase:
              mockUpdateRecurringTransactionUseCase,
        );
      },
      act: (bloc) => bloc.add(const UpdateCategoryID(
          categoryID: CATEGORY_ID,
          recurringTransactionId: RECURRING_TRANSACTION_ID)),
      expect: () => [Loading(), Success()],
    );

    blocTest<RecurringTransactionBloc, RecurringTransactionState>(
      'Emits [Success] states for update description success',
      build: () {
        when(() => mockUpdateRecurringTransactionUseCase.updateDescription(
                description: DESCRIPTION,
                recurringTransactionId: RECURRING_TRANSACTION_ID))
            .thenAnswer((_) => Future.value(positiveMonadResponse));
        return RecurringTransactionBloc(
          deleteRecurringTransactionUseCase:
              mockDeleteRecurringTransactionUseCase,
          updateRecurringTransactionUseCase:
              mockUpdateRecurringTransactionUseCase,
        );
      },
      act: (bloc) => bloc.add(const UpdateDescription(
          description: DESCRIPTION,
          recurringTransactionId: RECURRING_TRANSACTION_ID)),
      expect: () => [Loading(), Success()],
    );

    blocTest<RecurringTransactionBloc, RecurringTransactionState>(
      'Emits [Success] states for update recurrence success',
      build: () {
        when(() => mockUpdateRecurringTransactionUseCase.updateRecurrence(
                recurrence: Recurrence.biMonthly,
                recurringTransactionId: RECURRING_TRANSACTION_ID))
            .thenAnswer((_) => Future.value(positiveMonadResponse));
        return RecurringTransactionBloc(
          deleteRecurringTransactionUseCase:
              mockDeleteRecurringTransactionUseCase,
          updateRecurringTransactionUseCase:
              mockUpdateRecurringTransactionUseCase,
        );
      },
      act: (bloc) => bloc.add(const UpdateRecurrence(
          recurrence: Recurrence.biMonthly,
          recurringTransactionId: RECURRING_TRANSACTION_ID)),
      expect: () => [Loading(), Success()],
    );

    blocTest<RecurringTransactionBloc, RecurringTransactionState>(
      'Emits [Success] states for update tags success',
      build: () {
        when(() => mockUpdateRecurringTransactionUseCase.updateTags(
                tags: tags, recurringTransactionId: RECURRING_TRANSACTION_ID))
            .thenAnswer((_) => Future.value(positiveMonadResponse));
        return RecurringTransactionBloc(
          deleteRecurringTransactionUseCase:
              mockDeleteRecurringTransactionUseCase,
          updateRecurringTransactionUseCase:
              mockUpdateRecurringTransactionUseCase,
        );
      },
      act: (bloc) => bloc.add(UpdateTags(
          tags: tags, recurringTransactionId: RECURRING_TRANSACTION_ID)),
      expect: () => [Loading(), Success()],
    );

    blocTest<RecurringTransactionBloc, RecurringTransactionState>(
      'Emits [Success] states for delete recurringTransaction success',
      build: () {
        when(() => mockDeleteRecurringTransactionUseCase.delete(
                itemID: RECURRING_TRANSACTION_ID))
            .thenAnswer((_) => Future.value(positiveMonadResponse));
        return RecurringTransactionBloc(
          deleteRecurringTransactionUseCase:
              mockDeleteRecurringTransactionUseCase,
          updateRecurringTransactionUseCase:
              mockUpdateRecurringTransactionUseCase,
        );
      },
      act: (bloc) => bloc.add(const Delete(itemID: RECURRING_TRANSACTION_ID)),
      expect: () => [Loading(), Success()],
    );
  });

  group('Error Generic API Failure: RecurringTransactionBloc', () {
    blocTest<RecurringTransactionBloc, RecurringTransactionState>(
      'Emits [Error] states for update category id success',
      build: () {
        final failureMonadResponse = Left<Failure, void>(GenericAPIFailure());
        when(() => mockUpdateRecurringTransactionUseCase.updateAccountId(
                accountId: ACCOUNT_ID,
                recurringTransactionId: RECURRING_TRANSACTION_ID))
            .thenAnswer((_) => Future.value(failureMonadResponse));
        return RecurringTransactionBloc(
          deleteRecurringTransactionUseCase:
              mockDeleteRecurringTransactionUseCase,
          updateRecurringTransactionUseCase:
              mockUpdateRecurringTransactionUseCase,
        );
      },
      act: (bloc) => bloc.add(const UpdateAccountID(
          accountId: ACCOUNT_ID,
          recurringTransactionId: RECURRING_TRANSACTION_ID)),
      expect: () =>
          [Loading(), const Error(message: constants.GENERIC_ERROR_EXCEPTION)],
    );

    blocTest<RecurringTransactionBloc, RecurringTransactionState>(
      'Emits [Error] states for update account amount success',
      build: () {
        final failureMonadResponse = Left<Failure, void>(GenericAPIFailure());
        when(() => mockUpdateRecurringTransactionUseCase.updateAmount(
                newAmount: 1, recurringTransactionId: RECURRING_TRANSACTION_ID))
            .thenAnswer((_) => Future.value(failureMonadResponse));
        return RecurringTransactionBloc(
          deleteRecurringTransactionUseCase:
              mockDeleteRecurringTransactionUseCase,
          updateRecurringTransactionUseCase:
              mockUpdateRecurringTransactionUseCase,
        );
      },
      act: (bloc) => bloc.add(const UpdateAmount(
          amount: 1, recurringTransactionId: RECURRING_TRANSACTION_ID)),
      expect: () =>
          [Loading(), const Error(message: constants.GENERIC_ERROR_EXCEPTION)],
    );

    blocTest<RecurringTransactionBloc, RecurringTransactionState>(
      'Emits [Error] states for update category id success',
      build: () {
        final failureMonadResponse = Left<Failure, void>(GenericAPIFailure());
        when(() => mockUpdateRecurringTransactionUseCase.updateCategoryId(
                categoryId: CATEGORY_ID,
                recurringTransactionId: RECURRING_TRANSACTION_ID))
            .thenAnswer((_) => Future.value(failureMonadResponse));
        return RecurringTransactionBloc(
          deleteRecurringTransactionUseCase:
              mockDeleteRecurringTransactionUseCase,
          updateRecurringTransactionUseCase:
              mockUpdateRecurringTransactionUseCase,
        );
      },
      act: (bloc) => bloc.add(const UpdateCategoryID(
          categoryID: CATEGORY_ID,
          recurringTransactionId: RECURRING_TRANSACTION_ID)),
      expect: () =>
          [Loading(), const Error(message: constants.GENERIC_ERROR_EXCEPTION)],
    );

    blocTest<RecurringTransactionBloc, RecurringTransactionState>(
      'Emits [error] states for update description success',
      build: () {
        final failureMonadResponse = Left<Failure, void>(GenericAPIFailure());
        when(() => mockUpdateRecurringTransactionUseCase.updateDescription(
                description: DESCRIPTION,
                recurringTransactionId: RECURRING_TRANSACTION_ID))
            .thenAnswer((_) => Future.value(failureMonadResponse));
        return RecurringTransactionBloc(
          deleteRecurringTransactionUseCase:
              mockDeleteRecurringTransactionUseCase,
          updateRecurringTransactionUseCase:
              mockUpdateRecurringTransactionUseCase,
        );
      },
      act: (bloc) => bloc.add(const UpdateDescription(
          description: DESCRIPTION,
          recurringTransactionId: RECURRING_TRANSACTION_ID)),
      expect: () =>
          [Loading(), const Error(message: constants.GENERIC_ERROR_EXCEPTION)],
    );

    blocTest<RecurringTransactionBloc, RecurringTransactionState>(
      'Emits [Error] states for update recurrence success',
      build: () {
        final failureMonadResponse = Left<Failure, void>(GenericAPIFailure());
        when(() => mockUpdateRecurringTransactionUseCase.updateRecurrence(
                recurrence: Recurrence.biMonthly,
                recurringTransactionId: RECURRING_TRANSACTION_ID))
            .thenAnswer((_) => Future.value(failureMonadResponse));
        return RecurringTransactionBloc(
          deleteRecurringTransactionUseCase:
              mockDeleteRecurringTransactionUseCase,
          updateRecurringTransactionUseCase:
              mockUpdateRecurringTransactionUseCase,
        );
      },
      act: (bloc) => bloc.add(const UpdateRecurrence(
          recurrence: Recurrence.biMonthly,
          recurringTransactionId: RECURRING_TRANSACTION_ID)),
      expect: () =>
          [Loading(), const Error(message: constants.GENERIC_ERROR_EXCEPTION)],
    );

    blocTest<RecurringTransactionBloc, RecurringTransactionState>(
      'Emits [Error] states for update tags success',
      build: () {
        final failureMonadResponse = Left<Failure, void>(GenericAPIFailure());
        when(() => mockUpdateRecurringTransactionUseCase.updateTags(
                tags: tags, recurringTransactionId: RECURRING_TRANSACTION_ID))
            .thenAnswer((_) => Future.value(failureMonadResponse));
        return RecurringTransactionBloc(
          deleteRecurringTransactionUseCase:
              mockDeleteRecurringTransactionUseCase,
          updateRecurringTransactionUseCase:
              mockUpdateRecurringTransactionUseCase,
        );
      },
      act: (bloc) => bloc.add(UpdateTags(
          tags: tags, recurringTransactionId: RECURRING_TRANSACTION_ID)),
      expect: () =>
          [Loading(), const Error(message: constants.GENERIC_ERROR_EXCEPTION)],
    );

    blocTest<RecurringTransactionBloc, RecurringTransactionState>(
      'Emits [Error] states for delete recurringTransaction success',
      build: () {
        final failureMonadResponse = Left<Failure, void>(GenericAPIFailure());
        when(() => mockDeleteRecurringTransactionUseCase.delete(
                itemID: RECURRING_TRANSACTION_ID))
            .thenAnswer((_) => Future.value(failureMonadResponse));
        return RecurringTransactionBloc(
          deleteRecurringTransactionUseCase:
              mockDeleteRecurringTransactionUseCase,
          updateRecurringTransactionUseCase:
              mockUpdateRecurringTransactionUseCase,
        );
      },
      act: (bloc) => bloc.add(const Delete(itemID: RECURRING_TRANSACTION_ID)),
      expect: () =>
          [Loading(), const Error(message: constants.GENERIC_ERROR_EXCEPTION)],
    );
  });

  group('Error Fetch Data Failure: RecurringTransactionBloc', () {
    blocTest<RecurringTransactionBloc, RecurringTransactionState>(
      'Emits [Error] states for update category id success',
      build: () {
        final failureMonadResponse = Left<Failure, void>(FetchDataFailure());
        when(() => mockUpdateRecurringTransactionUseCase.updateAccountId(
                accountId: ACCOUNT_ID,
                recurringTransactionId: RECURRING_TRANSACTION_ID))
            .thenAnswer((_) => Future.value(failureMonadResponse));
        return RecurringTransactionBloc(
          deleteRecurringTransactionUseCase:
              mockDeleteRecurringTransactionUseCase,
          updateRecurringTransactionUseCase:
              mockUpdateRecurringTransactionUseCase,
        );
      },
      act: (bloc) => bloc.add(const UpdateAccountID(
          accountId: ACCOUNT_ID,
          recurringTransactionId: RECURRING_TRANSACTION_ID)),
      expect: () => [Loading(), RedirectToLogin()],
    );

    blocTest<RecurringTransactionBloc, RecurringTransactionState>(
      'Emits [Success] states for update account amount success',
      build: () {
        final failureMonadResponse = Left<Failure, void>(FetchDataFailure());
        when(() => mockUpdateRecurringTransactionUseCase.updateAmount(
                newAmount: 1, recurringTransactionId: RECURRING_TRANSACTION_ID))
            .thenAnswer((_) => Future.value(failureMonadResponse));
        return RecurringTransactionBloc(
          deleteRecurringTransactionUseCase:
              mockDeleteRecurringTransactionUseCase,
          updateRecurringTransactionUseCase:
              mockUpdateRecurringTransactionUseCase,
        );
      },
      act: (bloc) => bloc.add(const UpdateAmount(
          amount: 1, recurringTransactionId: RECURRING_TRANSACTION_ID)),
      expect: () => [Loading(), RedirectToLogin()],
    );

    blocTest<RecurringTransactionBloc, RecurringTransactionState>(
      'Emits [Error] states for update category id success',
      build: () {
        final failureMonadResponse = Left<Failure, void>(FetchDataFailure());
        when(() => mockUpdateRecurringTransactionUseCase.updateCategoryId(
                categoryId: CATEGORY_ID,
                recurringTransactionId: RECURRING_TRANSACTION_ID))
            .thenAnswer((_) => Future.value(failureMonadResponse));
        return RecurringTransactionBloc(
          deleteRecurringTransactionUseCase:
              mockDeleteRecurringTransactionUseCase,
          updateRecurringTransactionUseCase:
              mockUpdateRecurringTransactionUseCase,
        );
      },
      act: (bloc) => bloc.add(const UpdateCategoryID(
          categoryID: CATEGORY_ID,
          recurringTransactionId: RECURRING_TRANSACTION_ID)),
      expect: () => [Loading(), RedirectToLogin()],
    );

    blocTest<RecurringTransactionBloc, RecurringTransactionState>(
      'Emits [Success] states for update description success',
      build: () {
        final failureMonadResponse = Left<Failure, void>(FetchDataFailure());
        when(() => mockUpdateRecurringTransactionUseCase.updateDescription(
                description: DESCRIPTION,
                recurringTransactionId: RECURRING_TRANSACTION_ID))
            .thenAnswer((_) => Future.value(failureMonadResponse));
        return RecurringTransactionBloc(
          deleteRecurringTransactionUseCase:
              mockDeleteRecurringTransactionUseCase,
          updateRecurringTransactionUseCase:
              mockUpdateRecurringTransactionUseCase,
        );
      },
      act: (bloc) => bloc.add(const UpdateDescription(
          description: DESCRIPTION,
          recurringTransactionId: RECURRING_TRANSACTION_ID)),
      expect: () => [Loading(), RedirectToLogin()],
    );

    blocTest<RecurringTransactionBloc, RecurringTransactionState>(
      'Emits [Error] states for update recurrence success',
      build: () {
        final failureMonadResponse = Left<Failure, void>(FetchDataFailure());
        when(() => mockUpdateRecurringTransactionUseCase.updateRecurrence(
                recurrence: Recurrence.biMonthly,
                recurringTransactionId: RECURRING_TRANSACTION_ID))
            .thenAnswer((_) => Future.value(failureMonadResponse));
        return RecurringTransactionBloc(
          deleteRecurringTransactionUseCase:
              mockDeleteRecurringTransactionUseCase,
          updateRecurringTransactionUseCase:
              mockUpdateRecurringTransactionUseCase,
        );
      },
      act: (bloc) => bloc.add(const UpdateRecurrence(
          recurrence: Recurrence.biMonthly,
          recurringTransactionId: RECURRING_TRANSACTION_ID)),
      expect: () => [Loading(), RedirectToLogin()],
    );

    blocTest<RecurringTransactionBloc, RecurringTransactionState>(
      'Emits [Error] states for update tags success',
      build: () {
        final failureMonadResponse = Left<Failure, void>(FetchDataFailure());
        when(() => mockUpdateRecurringTransactionUseCase.updateTags(
                tags: tags, recurringTransactionId: RECURRING_TRANSACTION_ID))
            .thenAnswer((_) => Future.value(failureMonadResponse));
        return RecurringTransactionBloc(
          deleteRecurringTransactionUseCase:
              mockDeleteRecurringTransactionUseCase,
          updateRecurringTransactionUseCase:
              mockUpdateRecurringTransactionUseCase,
        );
      },
      act: (bloc) => bloc.add(UpdateTags(
          tags: tags, recurringTransactionId: RECURRING_TRANSACTION_ID)),
      expect: () => [Loading(), RedirectToLogin()],
    );

    blocTest<RecurringTransactionBloc, RecurringTransactionState>(
      'Emits [Error] states for delete recurringTransaction success',
      build: () {
        final failureMonadResponse = Left<Failure, void>(FetchDataFailure());
        when(() => mockDeleteRecurringTransactionUseCase.delete(
                itemID: RECURRING_TRANSACTION_ID))
            .thenAnswer((_) => Future.value(failureMonadResponse));
        return RecurringTransactionBloc(
          deleteRecurringTransactionUseCase:
              mockDeleteRecurringTransactionUseCase,
          updateRecurringTransactionUseCase:
              mockUpdateRecurringTransactionUseCase,
        );
      },
      act: (bloc) => bloc.add(const Delete(itemID: RECURRING_TRANSACTION_ID)),
      expect: () => [Loading(), RedirectToLogin()],
    );
  });
}
