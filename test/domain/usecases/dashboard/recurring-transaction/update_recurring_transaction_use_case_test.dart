import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_blitzbudget/core/failure/api_failure.dart';
import 'package:mobile_blitzbudget/core/failure/failure.dart';
import 'package:mobile_blitzbudget/core/failure/generic_failure.dart';
import 'package:mobile_blitzbudget/data/model/recurring-transaction/recurring_transaction_model.dart';
import 'package:mobile_blitzbudget/data/utils/data_utils.dart';
import 'package:mobile_blitzbudget/domain/entities/recurring-transaction/recurring_transaction.dart';
import 'package:mobile_blitzbudget/domain/repositories/dashboard/common/default_wallet_repository.dart';
import 'package:mobile_blitzbudget/domain/repositories/dashboard/transaction/recurring_transaction_repository.dart';
import 'package:mobile_blitzbudget/domain/usecases/dashboard/recurring-transaction/update_recurring_transaction_use_case.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../fixtures/fixture_reader.dart';

class MockRecurringTransactionRepository extends Mock
    implements RecurringTransactionRepository {}

class MockDefaultWalletRepository extends Mock
    implements DefaultWalletRepository {}

void main() {
  late UpdateRecurringTransactionUseCase updateRecurringTransactionUseCase;
  MockRecurringTransactionRepository? mockRecurringTransactionRepository;
  MockDefaultWalletRepository? mockDefaultWalletRepository;

  final recurringTransactionModelAsString = fixture(
      'models/get/recurring-transaction/recurring_transaction_model.json');
  final recurringTransactionModelAsJSON =
      jsonDecode(recurringTransactionModelAsString);
  final tags = (recurringTransactionModelAsJSON['tags'])
      ?.map<String>(parseDynamicAsString)
      ?.toList();
  final recurringTransaction = RecurringTransactionModel(
      walletId: recurringTransactionModelAsJSON['walletId'],
      accountId: recurringTransactionModelAsJSON['account'],
      recurringTransactionId:
          recurringTransactionModelAsJSON['recurringTransactionsId'],
      amount: parseDynamicAsDouble(recurringTransactionModelAsJSON['amount']),
      description: recurringTransactionModelAsJSON['description'],
      recurrence: parseDynamicAsRecurrence(
          recurringTransactionModelAsJSON['recurrence']),
      categoryType: parseDynamicAsCategoryType(
          recurringTransactionModelAsJSON['category_type']),
      categoryName: recurringTransactionModelAsJSON['category_name'],
      category: recurringTransactionModelAsJSON['category'],
      tags: tags,
      nextScheduled: recurringTransactionModelAsJSON['next_scheduled'],
      creationDate: recurringTransactionModelAsJSON['creation_date']);

  setUp(() {
    mockRecurringTransactionRepository = MockRecurringTransactionRepository();
    mockDefaultWalletRepository = MockDefaultWalletRepository();
    updateRecurringTransactionUseCase = UpdateRecurringTransactionUseCase(
        recurringTransactionRepository: mockRecurringTransactionRepository,
        defaultWalletRepository: mockDefaultWalletRepository);
  });

  group('Update RecurringTransaction', () {
    test('Success', () async {
      const Either<Failure, void> updateRecurringTransactionMonad =
          Right<Failure, void>('');

      when(() =>
              mockRecurringTransactionRepository!.update(recurringTransaction))
          .thenAnswer((_) => Future.value(updateRecurringTransactionMonad));

      final recurringTransactionResponse =
          await updateRecurringTransactionUseCase.update(
              updateRecurringTransaction: recurringTransaction);

      expect(recurringTransactionResponse.isRight(), true);
      verify(() =>
          mockRecurringTransactionRepository!.update(recurringTransaction));
    });

    test('Failure', () async {
      final Either<Failure, void> updateRecurringTransactionMonad =
          Left<Failure, void>(FetchDataFailure());

      when(() =>
              mockRecurringTransactionRepository!.update(recurringTransaction))
          .thenAnswer((_) => Future.value(updateRecurringTransactionMonad));

      final recurringTransactionResponse =
          await updateRecurringTransactionUseCase.update(
              updateRecurringTransaction: recurringTransaction);

      expect(recurringTransactionResponse.isLeft(), true);
      verify(() =>
          mockRecurringTransactionRepository!.update(recurringTransaction));
    });
  });

  group('UpdateAmount', () {
    final recurringTransactionModel = RecurringTransaction(
        walletId: recurringTransactionModelAsJSON['walletId'],
        recurringTransactionId: recurringTransactionModelAsJSON['accountId'],
        amount:
            parseDynamicAsDouble(recurringTransactionModelAsJSON['amount']));

    test('Success', () async {
      const Either<Failure, void> updateBudgetMonad = Right<Failure, void>('');
      final Either<Failure, String> dateStringMonad =
          Right<Failure, String>(recurringTransactionModel.walletId!);

      when(() => mockDefaultWalletRepository!.readDefaultWallet())
          .thenAnswer((_) => Future.value(dateStringMonad));
      when(() => mockRecurringTransactionRepository!
              .update(recurringTransactionModel))
          .thenAnswer((_) => Future.value(updateBudgetMonad));

      final recurringTransactionResponse =
          await updateRecurringTransactionUseCase.updateAmount(
              recurringTransactionId:
                  recurringTransactionModel.recurringTransactionId,
              newAmount: recurringTransactionModel.amount);

      expect(recurringTransactionResponse.isRight(), true);
      verify(() => mockRecurringTransactionRepository!
          .update(recurringTransactionModel));
    });

    test('Failure Response: Failure', () async {
      final Either<Failure, void> updateBudgetMonad =
          Left<Failure, void>(FetchDataFailure());
      final Either<Failure, String> dateStringMonad =
          Right<Failure, String>(recurringTransactionModel.walletId!);

      when(() => mockDefaultWalletRepository!.readDefaultWallet())
          .thenAnswer((_) => Future.value(dateStringMonad));
      when(() => mockRecurringTransactionRepository!
              .update(recurringTransactionModel))
          .thenAnswer((_) => Future.value(updateBudgetMonad));

      final recurringTransactionResponse =
          await updateRecurringTransactionUseCase.updateAmount(
              recurringTransactionId:
                  recurringTransactionModel.recurringTransactionId,
              newAmount: recurringTransactionModel.amount);
      final f = recurringTransactionResponse.fold(
          (failure) => failure, (_) => GenericFailure());

      expect(f, equals(FetchDataFailure()));
      expect(recurringTransactionResponse.isLeft(), true);
      verify(() => mockRecurringTransactionRepository!
          .update(recurringTransactionModel));
    });

    test('Read Wallet Id Failure: Failure', () async {
      final Either<Failure, void> updateBudgetMonad =
          Left<Failure, void>(FetchDataFailure());
      final Either<Failure, String> dateStringMonad =
          Left<Failure, String>(FetchDataFailure());

      when(() => mockDefaultWalletRepository!.readDefaultWallet())
          .thenAnswer((_) => Future.value(dateStringMonad));
      when(() => mockRecurringTransactionRepository!
              .update(recurringTransactionModel))
          .thenAnswer((_) => Future.value(updateBudgetMonad));

      final recurringTransactionResponse =
          await updateRecurringTransactionUseCase.updateAmount(
              recurringTransactionId:
                  recurringTransactionModel.recurringTransactionId,
              newAmount: recurringTransactionModel.amount);
      final f = recurringTransactionResponse.fold(
          (failure) => failure, (_) => GenericFailure());

      expect(f, equals(EmptyResponseFailure()));
      expect(recurringTransactionResponse.isLeft(), true);
      verifyNever(() => mockRecurringTransactionRepository!
          .update(recurringTransactionModel));
    });
  });

  group('UpdateDescription', () {
    final recurringTransactionModel = RecurringTransaction(
        walletId: recurringTransactionModelAsJSON['walletId'],
        recurringTransactionId: recurringTransactionModelAsJSON['accountId'],
        description: recurringTransactionModelAsJSON['description']);

    test('Success', () async {
      const Either<Failure, void> updateBudgetMonad = Right<Failure, void>('');
      final Either<Failure, String> dateStringMonad =
          Right<Failure, String>(recurringTransactionModel.walletId!);

      when(() => mockDefaultWalletRepository!.readDefaultWallet())
          .thenAnswer((_) => Future.value(dateStringMonad));
      when(() => mockRecurringTransactionRepository!
              .update(recurringTransactionModel))
          .thenAnswer((_) => Future.value(updateBudgetMonad));

      final recurringTransactionResponse =
          await updateRecurringTransactionUseCase.updateDescription(
              recurringTransactionId:
                  recurringTransactionModel.recurringTransactionId,
              description: recurringTransactionModel.description);

      expect(recurringTransactionResponse.isRight(), true);
      verify(() => mockRecurringTransactionRepository!
          .update(recurringTransactionModel));
    });

    test('Failure Response: Failure', () async {
      final Either<Failure, void> updateBudgetMonad =
          Left<Failure, void>(FetchDataFailure());
      final Either<Failure, String> dateStringMonad =
          Right<Failure, String>(recurringTransactionModel.walletId!);

      when(() => mockDefaultWalletRepository!.readDefaultWallet())
          .thenAnswer((_) => Future.value(dateStringMonad));
      when(() => mockRecurringTransactionRepository!
              .update(recurringTransactionModel))
          .thenAnswer((_) => Future.value(updateBudgetMonad));

      final recurringTransactionResponse =
          await updateRecurringTransactionUseCase.updateDescription(
              recurringTransactionId:
                  recurringTransactionModel.recurringTransactionId,
              description: recurringTransactionModel.description);
      final f = recurringTransactionResponse.fold(
          (failure) => failure, (_) => GenericFailure());

      expect(f, equals(FetchDataFailure()));
      expect(recurringTransactionResponse.isLeft(), true);
      verify(() => mockRecurringTransactionRepository!
          .update(recurringTransactionModel));
    });

    test('Read Wallet Id Failure: Failure', () async {
      final Either<Failure, void> updateBudgetMonad =
          Left<Failure, void>(FetchDataFailure());
      final Either<Failure, String> dateStringMonad =
          Left<Failure, String>(FetchDataFailure());

      when(() => mockDefaultWalletRepository!.readDefaultWallet())
          .thenAnswer((_) => Future.value(dateStringMonad));
      when(() => mockRecurringTransactionRepository!
              .update(recurringTransactionModel))
          .thenAnswer((_) => Future.value(updateBudgetMonad));

      final recurringTransactionResponse =
          await updateRecurringTransactionUseCase.updateDescription(
              recurringTransactionId:
                  recurringTransactionModel.recurringTransactionId,
              description: recurringTransactionModel.description);
      final f = recurringTransactionResponse.fold(
          (failure) => failure, (_) => GenericFailure());

      expect(f, equals(EmptyResponseFailure()));
      expect(recurringTransactionResponse.isLeft(), true);
      verifyNever(() => mockRecurringTransactionRepository!
          .update(recurringTransactionModel));
    });
  });

  group('UpdateAccountId', () {
    final recurringTransactionModel = RecurringTransaction(
        walletId: recurringTransactionModelAsJSON['walletId'],
        recurringTransactionId: recurringTransactionModelAsJSON['accountId'],
        accountId: recurringTransactionModelAsJSON['account']);

    test('Success', () async {
      const Either<Failure, void> updateBudgetMonad = Right<Failure, void>('');
      final Either<Failure, String> dateStringMonad =
          Right<Failure, String>(recurringTransactionModel.walletId!);

      when(() => mockDefaultWalletRepository!.readDefaultWallet())
          .thenAnswer((_) => Future.value(dateStringMonad));
      when(() => mockRecurringTransactionRepository!
              .update(recurringTransactionModel))
          .thenAnswer((_) => Future.value(updateBudgetMonad));

      final recurringTransactionResponse =
          await updateRecurringTransactionUseCase.updateAccountId(
              recurringTransactionId:
                  recurringTransactionModel.recurringTransactionId,
              accountId: recurringTransactionModel.accountId);

      expect(recurringTransactionResponse.isRight(), true);
      verify(() => mockRecurringTransactionRepository!
          .update(recurringTransactionModel));
    });

    test('Failure Response: Failure', () async {
      final Either<Failure, void> updateBudgetMonad =
          Left<Failure, void>(FetchDataFailure());
      final Either<Failure, String> dateStringMonad =
          Right<Failure, String>(recurringTransactionModel.walletId!);

      when(() => mockDefaultWalletRepository!.readDefaultWallet())
          .thenAnswer((_) => Future.value(dateStringMonad));
      when(() => mockRecurringTransactionRepository!
              .update(recurringTransactionModel))
          .thenAnswer((_) => Future.value(updateBudgetMonad));

      final recurringTransactionResponse =
          await updateRecurringTransactionUseCase.updateAccountId(
              recurringTransactionId:
                  recurringTransactionModel.recurringTransactionId,
              accountId: recurringTransactionModel.accountId);
      final f = recurringTransactionResponse.fold(
          (failure) => failure, (_) => GenericFailure());

      expect(f, equals(FetchDataFailure()));
      expect(recurringTransactionResponse.isLeft(), true);
      verify(() => mockRecurringTransactionRepository!
          .update(recurringTransactionModel));
    });

    test('Read Wallet Id Failure: Failure', () async {
      final Either<Failure, void> updateBudgetMonad =
          Left<Failure, void>(FetchDataFailure());
      final Either<Failure, String> dateStringMonad =
          Left<Failure, String>(FetchDataFailure());

      when(() => mockDefaultWalletRepository!.readDefaultWallet())
          .thenAnswer((_) => Future.value(dateStringMonad));
      when(() => mockRecurringTransactionRepository!
              .update(recurringTransactionModel))
          .thenAnswer((_) => Future.value(updateBudgetMonad));

      final recurringTransactionResponse =
          await updateRecurringTransactionUseCase.updateAccountId(
              recurringTransactionId:
                  recurringTransactionModel.recurringTransactionId,
              accountId: recurringTransactionModel.accountId);
      final f = recurringTransactionResponse.fold(
          (failure) => failure, (_) => GenericFailure());

      expect(f, equals(EmptyResponseFailure()));
      expect(recurringTransactionResponse.isLeft(), true);
      verifyNever(() => mockRecurringTransactionRepository!
          .update(recurringTransactionModel));
    });
  });

  group('UpdateCategoryId', () {
    final recurringTransactionModel = RecurringTransaction(
        walletId: recurringTransactionModelAsJSON['walletId'],
        recurringTransactionId: recurringTransactionModelAsJSON['accountId'],
        category: recurringTransactionModelAsJSON['category']);

    test('Success', () async {
      const Either<Failure, void> updateBudgetMonad = Right<Failure, void>('');
      final Either<Failure, String> dateStringMonad =
          Right<Failure, String>(recurringTransactionModel.walletId!);

      when(() => mockDefaultWalletRepository!.readDefaultWallet())
          .thenAnswer((_) => Future.value(dateStringMonad));
      when(() => mockRecurringTransactionRepository!
              .update(recurringTransactionModel))
          .thenAnswer((_) => Future.value(updateBudgetMonad));

      final recurringTransactionResponse =
          await updateRecurringTransactionUseCase.updateCategoryId(
              recurringTransactionId:
                  recurringTransactionModel.recurringTransactionId,
              categoryId: recurringTransactionModel.category);

      expect(recurringTransactionResponse.isRight(), true);
      verify(() => mockRecurringTransactionRepository!
          .update(recurringTransactionModel));
    });

    test('Failure Response: Failure', () async {
      final Either<Failure, void> updateBudgetMonad =
          Left<Failure, void>(FetchDataFailure());
      final Either<Failure, String> dateStringMonad =
          Right<Failure, String>(recurringTransactionModel.walletId!);

      when(() => mockDefaultWalletRepository!.readDefaultWallet())
          .thenAnswer((_) => Future.value(dateStringMonad));
      when(() => mockRecurringTransactionRepository!
              .update(recurringTransactionModel))
          .thenAnswer((_) => Future.value(updateBudgetMonad));

      final recurringTransactionResponse =
          await updateRecurringTransactionUseCase.updateCategoryId(
              recurringTransactionId:
                  recurringTransactionModel.recurringTransactionId,
              categoryId: recurringTransactionModel.category);
      final f = recurringTransactionResponse.fold(
          (failure) => failure, (_) => GenericFailure());

      expect(f, equals(FetchDataFailure()));
      expect(recurringTransactionResponse.isLeft(), true);
      verify(() => mockRecurringTransactionRepository!
          .update(recurringTransactionModel));
    });

    test('Read Wallet Id Failure: Failure', () async {
      final Either<Failure, void> updateBudgetMonad =
          Left<Failure, void>(FetchDataFailure());
      final Either<Failure, String> dateStringMonad =
          Left<Failure, String>(FetchDataFailure());

      when(() => mockDefaultWalletRepository!.readDefaultWallet())
          .thenAnswer((_) => Future.value(dateStringMonad));
      when(() => mockRecurringTransactionRepository!
              .update(recurringTransactionModel))
          .thenAnswer((_) => Future.value(updateBudgetMonad));

      final recurringTransactionResponse =
          await updateRecurringTransactionUseCase.updateCategoryId(
              recurringTransactionId:
                  recurringTransactionModel.recurringTransactionId,
              categoryId: recurringTransactionModel.category);
      final f = recurringTransactionResponse.fold(
          (failure) => failure, (_) => GenericFailure());

      expect(f, equals(EmptyResponseFailure()));
      expect(recurringTransactionResponse.isLeft(), true);
      verifyNever(() => mockRecurringTransactionRepository!
          .update(recurringTransactionModel));
    });
  });

  group('UpdateRecurrence', () {
    final recurringTransactionModel = RecurringTransaction(
        walletId: recurringTransactionModelAsJSON['walletId'],
        recurringTransactionId: recurringTransactionModelAsJSON['accountId'],
        recurrence: parseDynamicAsRecurrence(
            recurringTransactionModelAsJSON['recurrence']));

    test('Success', () async {
      const Either<Failure, void> updateBudgetMonad = Right<Failure, void>('');
      final Either<Failure, String> dateStringMonad =
          Right<Failure, String>(recurringTransactionModel.walletId!);

      when(() => mockDefaultWalletRepository!.readDefaultWallet())
          .thenAnswer((_) => Future.value(dateStringMonad));
      when(() => mockRecurringTransactionRepository!
              .update(recurringTransactionModel))
          .thenAnswer((_) => Future.value(updateBudgetMonad));

      final recurringTransactionResponse =
          await updateRecurringTransactionUseCase.updateRecurrence(
              recurringTransactionId:
                  recurringTransactionModel.recurringTransactionId,
              recurrence: recurringTransactionModel.recurrence);

      expect(recurringTransactionResponse.isRight(), true);
      verify(() => mockRecurringTransactionRepository!
          .update(recurringTransactionModel));
    });

    test('Failure Response: Failure', () async {
      final Either<Failure, void> updateBudgetMonad =
          Left<Failure, void>(FetchDataFailure());
      final Either<Failure, String> dateStringMonad =
          Right<Failure, String>(recurringTransactionModel.walletId!);

      when(() => mockDefaultWalletRepository!.readDefaultWallet())
          .thenAnswer((_) => Future.value(dateStringMonad));
      when(() => mockRecurringTransactionRepository!
              .update(recurringTransactionModel))
          .thenAnswer((_) => Future.value(updateBudgetMonad));

      final recurringTransactionResponse =
          await updateRecurringTransactionUseCase.updateRecurrence(
              recurringTransactionId:
                  recurringTransactionModel.recurringTransactionId,
              recurrence: recurringTransactionModel.recurrence);
      final f = recurringTransactionResponse.fold(
          (failure) => failure, (_) => GenericFailure());

      expect(f, equals(FetchDataFailure()));
      expect(recurringTransactionResponse.isLeft(), true);
      verify(() => mockRecurringTransactionRepository!
          .update(recurringTransactionModel));
    });

    test('Read Wallet Id Failure: Failure', () async {
      final Either<Failure, void> updateBudgetMonad =
          Left<Failure, void>(FetchDataFailure());
      final Either<Failure, String> dateStringMonad =
          Left<Failure, String>(FetchDataFailure());

      when(() => mockDefaultWalletRepository!.readDefaultWallet())
          .thenAnswer((_) => Future.value(dateStringMonad));
      when(() => mockRecurringTransactionRepository!
              .update(recurringTransactionModel))
          .thenAnswer((_) => Future.value(updateBudgetMonad));

      final recurringTransactionResponse =
          await updateRecurringTransactionUseCase.updateRecurrence(
              recurringTransactionId:
                  recurringTransactionModel.recurringTransactionId,
              recurrence: recurringTransactionModel.recurrence);
      final f = recurringTransactionResponse.fold(
          (failure) => failure, (_) => GenericFailure());

      expect(f, equals(EmptyResponseFailure()));
      expect(recurringTransactionResponse.isLeft(), true);
      verifyNever(() => mockRecurringTransactionRepository!
          .update(recurringTransactionModel));
    });
  });

  group('UpdateTags', () {
    final recurringTransactionModel = RecurringTransaction(
        walletId: recurringTransactionModelAsJSON['walletId'],
        recurringTransactionId: recurringTransactionModelAsJSON['accountId'],
        tags: tags);

    test('Success', () async {
      const Either<Failure, void> updateBudgetMonad = Right<Failure, void>('');
      final Either<Failure, String> dateStringMonad =
          Right<Failure, String>(recurringTransactionModel.walletId!);

      when(() => mockDefaultWalletRepository!.readDefaultWallet())
          .thenAnswer((_) => Future.value(dateStringMonad));
      when(() => mockRecurringTransactionRepository!
              .update(recurringTransactionModel))
          .thenAnswer((_) => Future.value(updateBudgetMonad));

      final recurringTransactionResponse =
          await updateRecurringTransactionUseCase.updateTags(
              recurringTransactionId:
                  recurringTransactionModel.recurringTransactionId,
              tags: recurringTransactionModel.tags);

      expect(recurringTransactionResponse.isRight(), true);
      verify(() => mockRecurringTransactionRepository!
          .update(recurringTransactionModel));
    });

    test('Failure Response: Failure', () async {
      final Either<Failure, void> updateBudgetMonad =
          Left<Failure, void>(FetchDataFailure());
      final Either<Failure, String> dateStringMonad =
          Right<Failure, String>(recurringTransactionModel.walletId!);

      when(() => mockDefaultWalletRepository!.readDefaultWallet())
          .thenAnswer((_) => Future.value(dateStringMonad));
      when(() => mockRecurringTransactionRepository!
              .update(recurringTransactionModel))
          .thenAnswer((_) => Future.value(updateBudgetMonad));

      final recurringTransactionResponse =
          await updateRecurringTransactionUseCase.updateTags(
              recurringTransactionId:
                  recurringTransactionModel.recurringTransactionId,
              tags: recurringTransactionModel.tags);
      final f = recurringTransactionResponse.fold(
          (failure) => failure, (_) => GenericFailure());

      expect(f, equals(FetchDataFailure()));
      expect(recurringTransactionResponse.isLeft(), true);
      verify(() => mockRecurringTransactionRepository!
          .update(recurringTransactionModel));
    });

    test('Read Wallet Id Failure: Failure', () async {
      final Either<Failure, void> updateBudgetMonad =
          Left<Failure, void>(FetchDataFailure());
      final Either<Failure, String> dateStringMonad =
          Left<Failure, String>(FetchDataFailure());

      when(() => mockDefaultWalletRepository!.readDefaultWallet())
          .thenAnswer((_) => Future.value(dateStringMonad));
      when(() => mockRecurringTransactionRepository!
              .update(recurringTransactionModel))
          .thenAnswer((_) => Future.value(updateBudgetMonad));

      final recurringTransactionResponse =
          await updateRecurringTransactionUseCase.updateTags(
              recurringTransactionId:
                  recurringTransactionModel.recurringTransactionId,
              tags: recurringTransactionModel.tags);
      final f = recurringTransactionResponse.fold(
          (failure) => failure, (_) => GenericFailure());

      expect(f, equals(EmptyResponseFailure()));
      expect(recurringTransactionResponse.isLeft(), true);
      verifyNever(() => mockRecurringTransactionRepository!
          .update(recurringTransactionModel));
    });
  });
}
