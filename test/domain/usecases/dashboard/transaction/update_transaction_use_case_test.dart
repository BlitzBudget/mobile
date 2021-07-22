import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_blitzbudget/core/failure/api_failure.dart';
import 'package:mobile_blitzbudget/core/failure/failure.dart';
import 'package:mobile_blitzbudget/core/failure/generic_failure.dart';
import 'package:mobile_blitzbudget/data/model/transaction/transaction_model.dart';
import 'package:mobile_blitzbudget/data/utils/data_utils.dart';
import 'package:mobile_blitzbudget/domain/entities/transaction/transaction.dart';
import 'package:mobile_blitzbudget/domain/repositories/dashboard/common/default_wallet_repository.dart';
import 'package:mobile_blitzbudget/domain/repositories/dashboard/transaction/transaction_repository.dart';
import 'package:mobile_blitzbudget/domain/usecases/dashboard/transaction/update_transaction_use_case.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../fixtures/fixture_reader.dart';

class MockTransactionRepository extends Mock implements TransactionRepository {}

class MockDefaultWalletRepository extends Mock
    implements DefaultWalletRepository {}

void main() {
  late UpdateTransactionUseCase updateTransactionUseCase;
  MockTransactionRepository? mockTransactionRepository;
  MockDefaultWalletRepository? mockDefaultWalletRepository;

  final transactionModelAsString =
      fixture('models/get/transaction/transaction_model.json');
  final transactionModelAsJSON = jsonDecode(transactionModelAsString);
  final tags = transactionModelAsJSON['tags']
      ?.map<String>(parseDynamicAsString)
      ?.toList();
  final transaction = TransactionModel(
      walletId: transactionModelAsJSON['walletId'],
      accountId: transactionModelAsJSON['account'],
      transactionId: transactionModelAsJSON['transactionId'],
      amount: parseDynamicAsDouble(transactionModelAsJSON['amount']),
      description: transactionModelAsJSON['description'],
      recurrence:
          parseDynamicAsRecurrence(transactionModelAsJSON['recurrence']),
      categoryType:
          parseDynamicAsCategoryType(transactionModelAsJSON['category_type']),
      categoryName: transactionModelAsJSON['category_name'],
      tags: tags,
      categoryId: transactionModelAsJSON['category'],
      dateMeantFor: transactionModelAsJSON['date_meant_for']);

  setUp(() {
    mockTransactionRepository = MockTransactionRepository();
    mockDefaultWalletRepository = MockDefaultWalletRepository();
    updateTransactionUseCase = UpdateTransactionUseCase(
        transactionRepository: mockTransactionRepository,
        defaultWalletRepository: mockDefaultWalletRepository);
  });

  group('Update Transaction', () {
    test('Success', () async {
      const Either<Failure, void> updateTransactionMonad =
          Right<Failure, void>('');

      when(() => mockTransactionRepository!.update(transaction))
          .thenAnswer((_) => Future.value(updateTransactionMonad));

      final transactionResponse =
          await updateTransactionUseCase.update(updateTransaction: transaction);

      expect(transactionResponse.isRight(), true);
      verify(() => mockTransactionRepository!.update(transaction));
    });

    test('Failure', () async {
      final Either<Failure, void> updateTransactionMonad =
          Left<Failure, void>(FetchDataFailure());

      when(() => mockTransactionRepository!.update(transaction))
          .thenAnswer((_) => Future.value(updateTransactionMonad));

      final transactionResponse =
          await updateTransactionUseCase.update(updateTransaction: transaction);

      expect(transactionResponse.isLeft(), true);
      verify(() => mockTransactionRepository!.update(transaction));
    });
  });

  group('UpdateAmount', () {
    final transactionModel = Transaction(
        walletId: transactionModelAsJSON['walletId'],
        transactionId: transactionModelAsJSON['accountId'],
        amount: parseDynamicAsDouble(transactionModelAsJSON['amount']));

    test('Success', () async {
      const Either<Failure, void> updateBudgetMonad = Right<Failure, void>('');
      final Either<Failure, String> dateStringMonad =
          Right<Failure, String>(transactionModel.walletId!);

      when(() => mockDefaultWalletRepository!.readDefaultWallet()).thenAnswer(
          (_) => Future.value(
              dateStringMonad));
      when(() => mockTransactionRepository!.update(transactionModel))
          .thenAnswer((_) => Future.value(updateBudgetMonad));

      final transactionResponse = await updateTransactionUseCase.updateAmount(
          transactionId: transactionModel.transactionId,
          newAmount: transactionModel.amount);

      expect(transactionResponse.isRight(), true);
      verify(() => mockTransactionRepository!.update(transactionModel));
    });

    test('Failure Response: Failure', () async {
      final Either<Failure, void> updateBudgetMonad =
          Left<Failure, void>(FetchDataFailure());
      final Either<Failure, String> dateStringMonad =
          Right<Failure, String>(transactionModel.walletId!);

      when(() => mockDefaultWalletRepository!.readDefaultWallet()).thenAnswer(
          (_) => Future.value(
              dateStringMonad));
      when(() => mockTransactionRepository!.update(transactionModel))
          .thenAnswer((_) => Future.value(updateBudgetMonad));

      final transactionResponse = await updateTransactionUseCase.updateAmount(
          transactionId: transactionModel.transactionId,
          newAmount: transactionModel.amount);
      final f = transactionResponse.fold(
          (failure) => failure, (_) => GenericFailure());

      expect(f, equals(FetchDataFailure()));
      expect(transactionResponse.isLeft(), true);
      verify(() => mockTransactionRepository!.update(transactionModel));
    });

    test('Read Wallet Id Failure: Failure', () async {
      final Either<Failure, void> updateBudgetMonad =
          Left<Failure, void>(FetchDataFailure());
      final Either<Failure, String> dateStringMonad =
          Left<Failure, String>(FetchDataFailure());

      when(() => mockDefaultWalletRepository!.readDefaultWallet())
          .thenAnswer((_) => Future.value(dateStringMonad));
      when(() => mockTransactionRepository!.update(transactionModel))
          .thenAnswer((_) => Future.value(updateBudgetMonad));

      final transactionResponse = await updateTransactionUseCase.updateAmount(
          transactionId: transactionModel.transactionId,
          newAmount: transactionModel.amount);
      final f = transactionResponse.fold(
          (failure) => failure, (_) => GenericFailure());

      expect(f, equals(EmptyResponseFailure()));
      expect(transactionResponse.isLeft(), true);
      verifyNever(() => mockTransactionRepository!.update(transactionModel));
    });
  });

  group('UpdateDescription', () {
    final transactionModel = Transaction(
        walletId: transactionModelAsJSON['walletId'],
        transactionId: transactionModelAsJSON['accountId'],
        description: transactionModelAsJSON['description']);

    test('Success', () async {
      const Either<Failure, void> updateBudgetMonad = Right<Failure, void>('');
      final Either<Failure, String> dateStringMonad =
          Right<Failure, String>(transactionModel.walletId!);

      when(() => mockDefaultWalletRepository!.readDefaultWallet()).thenAnswer(
          (_) => Future.value(dateStringMonad));
      when(() => mockTransactionRepository!.update(transactionModel))
          .thenAnswer((_) => Future.value(updateBudgetMonad));

      final transactionResponse =
          await updateTransactionUseCase.updateDescription(
              transactionId: transactionModel.transactionId,
              description: transactionModel.description);

      expect(transactionResponse.isRight(), true);
      verify(() => mockTransactionRepository!.update(transactionModel));
    });

    test('Failure Response: Failure', () async {
      final Either<Failure, void> updateBudgetMonad =
          Left<Failure, void>(FetchDataFailure());
      final Either<Failure, String> dateStringMonad =
          Right<Failure, String>(transactionModel.walletId!);

      when(() => mockDefaultWalletRepository!.readDefaultWallet()).thenAnswer(
          (_) => Future.value(dateStringMonad));
      when(() => mockTransactionRepository!.update(transactionModel))
          .thenAnswer((_) => Future.value(updateBudgetMonad));

      final transactionResponse =
          await updateTransactionUseCase.updateDescription(
              transactionId: transactionModel.transactionId,
              description: transactionModel.description);
      final f = transactionResponse.fold(
          (failure) => failure, (_) => GenericFailure());

      expect(f, equals(FetchDataFailure()));
      expect(transactionResponse.isLeft(), true);
      verify(() => mockTransactionRepository!.update(transactionModel));
    });

    test('Read Wallet Id Failure: Failure', () async {
      final Either<Failure, void> updateBudgetMonad =
          Left<Failure, void>(FetchDataFailure());
      final Either<Failure, String> dateStringMonad =
          Left<Failure, String>(FetchDataFailure());

      when(() => mockDefaultWalletRepository!.readDefaultWallet())
          .thenAnswer((_) => Future.value(dateStringMonad));
      when(() => mockTransactionRepository!.update(transactionModel))
          .thenAnswer((_) => Future.value(updateBudgetMonad));

      final transactionResponse =
          await updateTransactionUseCase.updateDescription(
              transactionId: transactionModel.transactionId,
              description: transactionModel.description);
      final f = transactionResponse.fold(
          (failure) => failure, (_) => GenericFailure());

      expect(f, equals(EmptyResponseFailure()));
      expect(transactionResponse.isLeft(), true);
      verifyNever(() => mockTransactionRepository!.update(transactionModel));
    });
  });

  group('UpdateAccountId', () {
    final transactionModel = Transaction(
        walletId: transactionModelAsJSON['walletId'],
        transactionId: transactionModelAsJSON['accountId'],
        accountId: transactionModelAsJSON['account']);

    test('Success', () async {
      const Either<Failure, void> updateBudgetMonad = Right<Failure, void>('');
      final Either<Failure, String> dateStringMonad =
          Right<Failure, String>(transactionModel.walletId!);

      when(() => mockDefaultWalletRepository!.readDefaultWallet()).thenAnswer(
          (_) => Future.value(dateStringMonad));
      when(() => mockTransactionRepository!.update(transactionModel))
          .thenAnswer((_) => Future.value(updateBudgetMonad));

      final transactionResponse =
          await updateTransactionUseCase.updateAccountId(
              transactionId: transactionModel.transactionId,
              accountId: transactionModel.accountId);

      expect(transactionResponse.isRight(), true);
      verify(() => mockTransactionRepository!.update(transactionModel));
    });

    test('Failure Response: Failure', () async {
      final Either<Failure, void> updateBudgetMonad =
          Left<Failure, void>(FetchDataFailure());
      final Either<Failure, String> dateStringMonad =
          Right<Failure, String>(transactionModel.walletId!);

      when(() => mockDefaultWalletRepository!.readDefaultWallet()).thenAnswer(
          (_) => Future.value(dateStringMonad));
      when(() => mockTransactionRepository!.update(transactionModel))
          .thenAnswer((_) => Future.value(updateBudgetMonad));

      final transactionResponse =
          await updateTransactionUseCase.updateAccountId(
              transactionId: transactionModel.transactionId,
              accountId: transactionModel.accountId);
      final f = transactionResponse.fold(
          (failure) => failure, (_) => GenericFailure());

      expect(f, equals(FetchDataFailure()));
      expect(transactionResponse.isLeft(), true);
      verify(() => mockTransactionRepository!.update(transactionModel));
    });

    test('Read Wallet Id Failure: Failure', () async {
      final Either<Failure, void> updateBudgetMonad =
          Left<Failure, void>(FetchDataFailure());
      final Either<Failure, String> dateStringMonad =
          Left<Failure, String>(FetchDataFailure());

      when(() => mockDefaultWalletRepository!.readDefaultWallet())
          .thenAnswer((_) => Future.value(dateStringMonad));
      when(() => mockTransactionRepository!.update(transactionModel))
          .thenAnswer((_) => Future.value(updateBudgetMonad));

      final transactionResponse =
          await updateTransactionUseCase.updateAccountId(
              transactionId: transactionModel.transactionId,
              accountId: transactionModel.accountId);
      final f = transactionResponse.fold(
          (failure) => failure, (_) => GenericFailure());

      expect(f, equals(EmptyResponseFailure()));
      expect(transactionResponse.isLeft(), true);
      verifyNever(() => mockTransactionRepository!.update(transactionModel));
    });
  });

  group('UpdateCategoryId', () {
    final transactionModel = Transaction(
        walletId: transactionModelAsJSON['walletId'],
        transactionId: transactionModelAsJSON['accountId'],
        categoryId: transactionModelAsJSON['category']);

    test('Success', () async {
      const Either<Failure, void> updateBudgetMonad = Right<Failure, void>('');
      final Either<Failure, String> dateStringMonad =
          Right<Failure, String>(transactionModel.walletId!);

      when(() => mockDefaultWalletRepository!.readDefaultWallet()).thenAnswer(
          (_) => Future.value(dateStringMonad));
      when(() => mockTransactionRepository!.update(transactionModel))
          .thenAnswer((_) => Future.value(updateBudgetMonad));

      final transactionResponse =
          await updateTransactionUseCase.updateCategoryId(
              transactionId: transactionModel.transactionId,
              categoryId: transactionModel.categoryId);

      expect(transactionResponse.isRight(), true);
      verify(() => mockTransactionRepository!.update(transactionModel));
    });

    test('Failure Response: Failure', () async {
      final Either<Failure, void> updateBudgetMonad =
          Left<Failure, void>(FetchDataFailure());
      final Either<Failure, String> dateStringMonad =
          Right<Failure, String>(transactionModel.walletId!);

      when(() => mockDefaultWalletRepository!.readDefaultWallet()).thenAnswer(
          (_) => Future.value(dateStringMonad));
      when(() => mockTransactionRepository!.update(transactionModel))
          .thenAnswer((_) => Future.value(updateBudgetMonad));

      final transactionResponse =
          await updateTransactionUseCase.updateCategoryId(
              transactionId: transactionModel.transactionId,
              categoryId: transactionModel.categoryId);
      final f = transactionResponse.fold(
          (failure) => failure, (_) => GenericFailure());

      expect(f, equals(FetchDataFailure()));
      expect(transactionResponse.isLeft(), true);
      verify(() => mockTransactionRepository!.update(transactionModel));
    });

    test('Read Wallet Id Failure: Failure', () async {
      final Either<Failure, void> updateBudgetMonad =
          Left<Failure, void>(FetchDataFailure());
      final Either<Failure, String> dateStringMonad =
          Left<Failure, String>(FetchDataFailure());

      when(() => mockDefaultWalletRepository!.readDefaultWallet())
          .thenAnswer((_) => Future.value(dateStringMonad));
      when(() => mockTransactionRepository!.update(transactionModel))
          .thenAnswer((_) => Future.value(updateBudgetMonad));

      final transactionResponse =
          await updateTransactionUseCase.updateCategoryId(
              transactionId: transactionModel.transactionId,
              categoryId: transactionModel.categoryId);
      final f = transactionResponse.fold(
          (failure) => failure, (_) => GenericFailure());

      expect(f, equals(EmptyResponseFailure()));
      expect(transactionResponse.isLeft(), true);
      verifyNever(() => mockTransactionRepository!.update(transactionModel));
    });
  });

  group('UpdateRecurrence', () {
    final transactionModel = Transaction(
        walletId: transactionModelAsJSON['walletId'],
        transactionId: transactionModelAsJSON['accountId'],
        recurrence:
            parseDynamicAsRecurrence(transactionModelAsJSON['recurrence']));

    test('Success', () async {
      const Either<Failure, void> updateBudgetMonad = Right<Failure, void>('');
      final Either<Failure, String> dateStringMonad =
          Right<Failure, String>(transactionModel.walletId!);

      when(() => mockDefaultWalletRepository!.readDefaultWallet()).thenAnswer(
          (_) => Future.value(dateStringMonad));
      when(() => mockTransactionRepository!.update(transactionModel))
          .thenAnswer((_) => Future.value(updateBudgetMonad));

      final transactionResponse =
          await updateTransactionUseCase.updateRecurrence(
              transactionId: transactionModel.transactionId,
              recurrence: transactionModel.recurrence);

      expect(transactionResponse.isRight(), true);
      verify(() => mockTransactionRepository!.update(transactionModel));
    });

    test('Failure Response: Failure', () async {
      final Either<Failure, void> updateBudgetMonad =
          Left<Failure, void>(FetchDataFailure());
      final Either<Failure, String> dateStringMonad =
          Right<Failure, String>(transactionModel.walletId!);

      when(() => mockDefaultWalletRepository!.readDefaultWallet()).thenAnswer(
          (_) => Future.value(dateStringMonad));
      when(() => mockTransactionRepository!.update(transactionModel))
          .thenAnswer((_) => Future.value(updateBudgetMonad));

      final transactionResponse =
          await updateTransactionUseCase.updateRecurrence(
              transactionId: transactionModel.transactionId,
              recurrence: transactionModel.recurrence);
      final f = transactionResponse.fold(
          (failure) => failure, (_) => GenericFailure());

      expect(f, equals(FetchDataFailure()));
      expect(transactionResponse.isLeft(), true);
      verify(() => mockTransactionRepository!.update(transactionModel));
    });

    test('Read Wallet Id Failure: Failure', () async {
      final Either<Failure, void> updateBudgetMonad =
          Left<Failure, void>(FetchDataFailure());
      final Either<Failure, String> dateStringMonad =
          Left<Failure, String>(FetchDataFailure());

      when(() => mockDefaultWalletRepository!.readDefaultWallet())
          .thenAnswer((_) => Future.value(dateStringMonad));
      when(() => mockTransactionRepository!.update(transactionModel))
          .thenAnswer((_) => Future.value(updateBudgetMonad));

      final transactionResponse =
          await updateTransactionUseCase.updateRecurrence(
              transactionId: transactionModel.transactionId,
              recurrence: transactionModel.recurrence);
      final f = transactionResponse.fold(
          (failure) => failure, (_) => GenericFailure());

      expect(f, equals(EmptyResponseFailure()));
      expect(transactionResponse.isLeft(), true);
      verifyNever(() => mockTransactionRepository!.update(transactionModel));
    });
  });

  group('UpdateTags', () {
    final transactionModel = Transaction(
        walletId: transactionModelAsJSON['walletId'],
        transactionId: transactionModelAsJSON['accountId'],
        tags: tags);

    test('Success', () async {
      const Either<Failure, void> updateBudgetMonad = Right<Failure, void>('');
      final Either<Failure, String> dateStringMonad =
          Right<Failure, String>(transactionModel.walletId!);

      when(() => mockDefaultWalletRepository!.readDefaultWallet()).thenAnswer(
          (_) => Future.value(dateStringMonad));
      when(() => mockTransactionRepository!.update(transactionModel))
          .thenAnswer((_) => Future.value(updateBudgetMonad));

      final transactionResponse = await updateTransactionUseCase.updateTags(
          transactionId: transactionModel.transactionId,
          tags: transactionModel.tags);

      expect(transactionResponse.isRight(), true);
      verify(() => mockTransactionRepository!.update(transactionModel));
    });

    test('Failure Response: Failure', () async {
      final Either<Failure, void> updateBudgetMonad =
          Left<Failure, void>(FetchDataFailure());
      final Either<Failure, String> dateStringMonad =
          Right<Failure, String>(transactionModel.walletId!);

      when(() => mockDefaultWalletRepository!.readDefaultWallet()).thenAnswer(
          (_) => Future.value(dateStringMonad));
      when(() => mockTransactionRepository!.update(transactionModel))
          .thenAnswer((_) => Future.value(updateBudgetMonad));

      final transactionResponse = await updateTransactionUseCase.updateTags(
          transactionId: transactionModel.transactionId,
          tags: transactionModel.tags);
      final f = transactionResponse.fold(
          (failure) => failure, (_) => GenericFailure());

      expect(f, equals(FetchDataFailure()));
      expect(transactionResponse.isLeft(), true);
      verify(() => mockTransactionRepository!.update(transactionModel));
    });

    test('Read Wallet Id Failure: Failure', () async {
      final Either<Failure, void> updateBudgetMonad =
          Left<Failure, void>(FetchDataFailure());
      final Either<Failure, String> dateStringMonad =
          Left<Failure, String>(FetchDataFailure());

      when(() => mockDefaultWalletRepository!.readDefaultWallet())
          .thenAnswer((_) => Future.value(dateStringMonad));
      when(() => mockTransactionRepository!.update(transactionModel))
          .thenAnswer((_) => Future.value(updateBudgetMonad));

      final transactionResponse = await updateTransactionUseCase.updateTags(
          transactionId: transactionModel.transactionId,
          tags: transactionModel.tags);
      final f = transactionResponse.fold(
          (failure) => failure, (_) => GenericFailure());

      expect(f, equals(EmptyResponseFailure()));
      expect(transactionResponse.isLeft(), true);
      verifyNever(() => mockTransactionRepository!.update(transactionModel));
    });
  });

  group('UpdateDateMeantFor', () {
    final transactionModel = Transaction(
        walletId: transactionModelAsJSON['walletId'],
        transactionId: transactionModelAsJSON['accountId'],
        dateMeantFor: transactionModelAsJSON['date_meant_for']);

    test('Success', () async {
      const Either<Failure, void> updateBudgetMonad = Right<Failure, void>('');
      final Either<Failure, String> dateStringMonad =
          Right<Failure, String>(transactionModel.walletId!);

      when(() => mockDefaultWalletRepository!.readDefaultWallet()).thenAnswer(
          (_) => Future.value(dateStringMonad));
      when(() => mockTransactionRepository!.update(transactionModel))
          .thenAnswer((_) => Future.value(updateBudgetMonad));

      final transactionResponse =
          await updateTransactionUseCase.updateDateMeantFor(
              transactionId: transactionModel.transactionId,
              dateMeantFor: transactionModel.dateMeantFor);

      expect(transactionResponse.isRight(), true);
      verify(() => mockTransactionRepository!.update(transactionModel));
    });

    test('Failure Response: Failure', () async {
      final Either<Failure, void> updateBudgetMonad =
          Left<Failure, void>(FetchDataFailure());
      final Either<Failure, String> dateStringMonad =
          Right<Failure, String>(transactionModel.walletId!);

      when(() => mockDefaultWalletRepository!.readDefaultWallet()).thenAnswer(
          (_) => Future.value(dateStringMonad));
      when(() => mockTransactionRepository!.update(transactionModel))
          .thenAnswer((_) => Future.value(updateBudgetMonad));

      final transactionResponse =
          await updateTransactionUseCase.updateDateMeantFor(
              transactionId: transactionModel.transactionId,
              dateMeantFor: transactionModel.dateMeantFor);
      final f = transactionResponse.fold(
          (failure) => failure, (_) => GenericFailure());

      expect(f, equals(FetchDataFailure()));
      expect(transactionResponse.isLeft(), true);
      verify(() => mockTransactionRepository!.update(transactionModel));
    });

    test('Read Wallet Id Failure: Failure', () async {
      final Either<Failure, void> updateBudgetMonad =
          Left<Failure, void>(FetchDataFailure());
      final Either<Failure, String> dateStringMonad =
          Left<Failure, String>(FetchDataFailure());

      when(() => mockDefaultWalletRepository!.readDefaultWallet())
          .thenAnswer((_) => Future.value(dateStringMonad));
      when(() => mockTransactionRepository!.update(transactionModel))
          .thenAnswer((_) => Future.value(updateBudgetMonad));

      final transactionResponse =
          await updateTransactionUseCase.updateDateMeantFor(
              transactionId: transactionModel.transactionId,
              dateMeantFor: transactionModel.dateMeantFor);
      final f = transactionResponse.fold(
          (failure) => failure, (_) => GenericFailure());

      expect(f, equals(EmptyResponseFailure()));
      expect(transactionResponse.isLeft(), true);
      verifyNever(() => mockTransactionRepository!.update(transactionModel));
    });
  });
}
