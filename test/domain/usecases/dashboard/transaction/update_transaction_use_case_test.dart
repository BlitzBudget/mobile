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
import 'package:mockito/mockito.dart';

import '../../../../fixtures/fixture_reader.dart';

class MockTransactionRepository extends Mock implements TransactionRepository {}

class MockDefaultWalletRepository extends Mock
    implements DefaultWalletRepository {}

void main() {
  UpdateTransactionUseCase updateTransactionUseCase;
  MockTransactionRepository mockTransactionRepository;
  MockDefaultWalletRepository mockDefaultWalletRepository;

  final transactionModelAsString =
      fixture('models/get/transaction/transaction_model.json');
  final transactionModelAsJSON =
      jsonDecode(transactionModelAsString) as Map<String, dynamic>;
  final tags = (transactionModelAsJSON['tags'] as List)
      ?.map((dynamic item) => item as String)
      ?.toList();
  final transaction = TransactionModel(
      walletId: transactionModelAsJSON['walletId'] as String,
      accountId: transactionModelAsJSON['account'] as String,
      transactionId: transactionModelAsJSON['transactionId'] as String,
      amount: parseDynamicAsDouble(transactionModelAsJSON['amount']),
      description: transactionModelAsJSON['description'] as String,
      recurrence:
          parseDynamicAsRecurrence(transactionModelAsJSON['recurrence']),
      categoryType:
          parseDynamicAsCategoryType(transactionModelAsJSON['category_type']),
      categoryName: transactionModelAsJSON['category_name'] as String,
      tags: tags,
      categoryId: transactionModelAsJSON['category'] as String,
      dateMeantFor: transactionModelAsJSON['date_meant_for'] as String);

  setUp(() {
    mockTransactionRepository = MockTransactionRepository();
    mockDefaultWalletRepository = MockDefaultWalletRepository();
    updateTransactionUseCase = UpdateTransactionUseCase(
        transactionRepository: mockTransactionRepository,
        defaultWalletRepository: mockDefaultWalletRepository);
  });

  group('Update Transaction', () {
    test('Success', () async {
      Either<Failure, void> updateTransactionMonad = Right<Failure, void>('');

      when(mockTransactionRepository.update(transaction))
          .thenAnswer((_) => Future.value(updateTransactionMonad));

      final transactionResponse =
          await updateTransactionUseCase.update(updateTransaction: transaction);

      expect(transactionResponse.isRight(), true);
      verify(mockTransactionRepository.update(transaction));
    });

    test('Failure', () async {
      Either<Failure, void> updateTransactionMonad =
          Left<Failure, void>(FetchDataFailure());

      when(mockTransactionRepository.update(transaction))
          .thenAnswer((_) => Future.value(updateTransactionMonad));

      final transactionResponse =
          await updateTransactionUseCase.update(updateTransaction: transaction);

      expect(transactionResponse.isLeft(), true);
      verify(mockTransactionRepository.update(transaction));
    });
  });

  group('UpdateAmount', () {
    final transactionModel = Transaction(
        walletId: transactionModelAsJSON['walletId'] as String,
        transactionId: transactionModelAsJSON['accountId'] as String,
        amount: parseDynamicAsDouble(transactionModelAsJSON['amount']));

    test('Success', () async {
      Either<Failure, void> updateBudgetMonad = Right<Failure, void>('');
      Either<Failure, String> dateStringMonad =
          Right<Failure, String>(transactionModel.walletId);

      when(mockDefaultWalletRepository.readDefaultWallet())
          .thenAnswer((_) => Future.value(dateStringMonad));
      when(mockTransactionRepository.update(transactionModel))
          .thenAnswer((_) => Future.value(updateBudgetMonad));

      final transactionResponse = await updateTransactionUseCase.updateAmount(
          transactionId: transactionModel.transactionId,
          newAmount: transactionModel.amount);

      expect(transactionResponse.isRight(), true);
      verify(mockTransactionRepository.update(transactionModel));
    });

    test('Failure Response: Failure', () async {
      Either<Failure, void> updateBudgetMonad =
          Left<Failure, void>(FetchDataFailure());
      Either<Failure, String> dateStringMonad =
          Right<Failure, String>(transactionModel.walletId);

      when(mockDefaultWalletRepository.readDefaultWallet())
          .thenAnswer((_) => Future.value(dateStringMonad));
      when(mockTransactionRepository.update(transactionModel))
          .thenAnswer((_) => Future.value(updateBudgetMonad));

      final transactionResponse = await updateTransactionUseCase.updateAmount(
          transactionId: transactionModel.transactionId,
          newAmount: transactionModel.amount);
      final f = transactionResponse.fold(
          (failure) => failure, (_) => GenericFailure());

      expect(f, equals(FetchDataFailure()));
      expect(transactionResponse.isLeft(), true);
      verify(mockTransactionRepository.update(transactionModel));
    });

    test('Read Wallet Id Failure: Failure', () async {
      Either<Failure, void> updateBudgetMonad =
          Left<Failure, void>(FetchDataFailure());
      Either<Failure, String> dateStringMonad =
          Left<Failure, String>(FetchDataFailure());

      when(mockDefaultWalletRepository.readDefaultWallet())
          .thenAnswer((_) => Future.value(dateStringMonad));
      when(mockTransactionRepository.update(transactionModel))
          .thenAnswer((_) => Future.value(updateBudgetMonad));

      final transactionResponse = await updateTransactionUseCase.updateAmount(
          transactionId: transactionModel.transactionId,
          newAmount: transactionModel.amount);
      final f = transactionResponse.fold(
          (failure) => failure, (_) => GenericFailure());

      expect(f, equals(EmptyResponseFailure()));
      expect(transactionResponse.isLeft(), true);
      verifyNever(mockTransactionRepository.update(transactionModel));
    });
  });

  group('UpdateDescription', () {
    final transactionModel = Transaction(
        walletId: transactionModelAsJSON['walletId'] as String,
        transactionId: transactionModelAsJSON['accountId'] as String,
        description: transactionModelAsJSON['description'] as String);

    test('Success', () async {
      Either<Failure, void> updateBudgetMonad = Right<Failure, void>('');
      Either<Failure, String> dateStringMonad =
          Right<Failure, String>(transactionModel.walletId);

      when(mockDefaultWalletRepository.readDefaultWallet())
          .thenAnswer((_) => Future.value(dateStringMonad));
      when(mockTransactionRepository.update(transactionModel))
          .thenAnswer((_) => Future.value(updateBudgetMonad));

      final transactionResponse =
          await updateTransactionUseCase.updateDescription(
              transactionId: transactionModel.transactionId,
              description: transactionModel.description);

      expect(transactionResponse.isRight(), true);
      verify(mockTransactionRepository.update(transactionModel));
    });

    test('Failure Response: Failure', () async {
      Either<Failure, void> updateBudgetMonad =
          Left<Failure, void>(FetchDataFailure());
      Either<Failure, String> dateStringMonad =
          Right<Failure, String>(transactionModel.walletId);

      when(mockDefaultWalletRepository.readDefaultWallet())
          .thenAnswer((_) => Future.value(dateStringMonad));
      when(mockTransactionRepository.update(transactionModel))
          .thenAnswer((_) => Future.value(updateBudgetMonad));

      final transactionResponse =
          await updateTransactionUseCase.updateDescription(
              transactionId: transactionModel.transactionId,
              description: transactionModel.description);
      final f = transactionResponse.fold(
          (failure) => failure, (_) => GenericFailure());

      expect(f, equals(FetchDataFailure()));
      expect(transactionResponse.isLeft(), true);
      verify(mockTransactionRepository.update(transactionModel));
    });

    test('Read Wallet Id Failure: Failure', () async {
      Either<Failure, void> updateBudgetMonad =
          Left<Failure, void>(FetchDataFailure());
      Either<Failure, String> dateStringMonad =
          Left<Failure, String>(FetchDataFailure());

      when(mockDefaultWalletRepository.readDefaultWallet())
          .thenAnswer((_) => Future.value(dateStringMonad));
      when(mockTransactionRepository.update(transactionModel))
          .thenAnswer((_) => Future.value(updateBudgetMonad));

      final transactionResponse =
          await updateTransactionUseCase.updateDescription(
              transactionId: transactionModel.transactionId,
              description: transactionModel.description);
      final f = transactionResponse.fold(
          (failure) => failure, (_) => GenericFailure());

      expect(f, equals(EmptyResponseFailure()));
      expect(transactionResponse.isLeft(), true);
      verifyNever(mockTransactionRepository.update(transactionModel));
    });
  });

  group('UpdateAccountId', () {
    final transactionModel = Transaction(
        walletId: transactionModelAsJSON['walletId'] as String,
        transactionId: transactionModelAsJSON['accountId'] as String,
        accountId: transactionModelAsJSON['account'] as String);

    test('Success', () async {
      Either<Failure, void> updateBudgetMonad = Right<Failure, void>('');
      Either<Failure, String> dateStringMonad =
          Right<Failure, String>(transactionModel.walletId);

      when(mockDefaultWalletRepository.readDefaultWallet())
          .thenAnswer((_) => Future.value(dateStringMonad));
      when(mockTransactionRepository.update(transactionModel))
          .thenAnswer((_) => Future.value(updateBudgetMonad));

      final transactionResponse =
          await updateTransactionUseCase.updateAccountId(
              transactionId: transactionModel.transactionId,
              accountId: transactionModel.accountId);

      expect(transactionResponse.isRight(), true);
      verify(mockTransactionRepository.update(transactionModel));
    });

    test('Failure Response: Failure', () async {
      Either<Failure, void> updateBudgetMonad =
          Left<Failure, void>(FetchDataFailure());
      Either<Failure, String> dateStringMonad =
          Right<Failure, String>(transactionModel.walletId);

      when(mockDefaultWalletRepository.readDefaultWallet())
          .thenAnswer((_) => Future.value(dateStringMonad));
      when(mockTransactionRepository.update(transactionModel))
          .thenAnswer((_) => Future.value(updateBudgetMonad));

      final transactionResponse =
          await updateTransactionUseCase.updateAccountId(
              transactionId: transactionModel.transactionId,
              accountId: transactionModel.accountId);
      final f = transactionResponse.fold(
          (failure) => failure, (_) => GenericFailure());

      expect(f, equals(FetchDataFailure()));
      expect(transactionResponse.isLeft(), true);
      verify(mockTransactionRepository.update(transactionModel));
    });

    test('Read Wallet Id Failure: Failure', () async {
      Either<Failure, void> updateBudgetMonad =
          Left<Failure, void>(FetchDataFailure());
      Either<Failure, String> dateStringMonad =
          Left<Failure, String>(FetchDataFailure());

      when(mockDefaultWalletRepository.readDefaultWallet())
          .thenAnswer((_) => Future.value(dateStringMonad));
      when(mockTransactionRepository.update(transactionModel))
          .thenAnswer((_) => Future.value(updateBudgetMonad));

      final transactionResponse =
          await updateTransactionUseCase.updateAccountId(
              transactionId: transactionModel.transactionId,
              accountId: transactionModel.accountId);
      final f = transactionResponse.fold(
          (failure) => failure, (_) => GenericFailure());

      expect(f, equals(EmptyResponseFailure()));
      expect(transactionResponse.isLeft(), true);
      verifyNever(mockTransactionRepository.update(transactionModel));
    });
  });

  group('UpdateCategoryId', () {
    final transactionModel = Transaction(
        walletId: transactionModelAsJSON['walletId'] as String,
        transactionId: transactionModelAsJSON['accountId'] as String,
        categoryId: transactionModelAsJSON['category'] as String);

    test('Success', () async {
      Either<Failure, void> updateBudgetMonad = Right<Failure, void>('');
      Either<Failure, String> dateStringMonad =
          Right<Failure, String>(transactionModel.walletId);

      when(mockDefaultWalletRepository.readDefaultWallet())
          .thenAnswer((_) => Future.value(dateStringMonad));
      when(mockTransactionRepository.update(transactionModel))
          .thenAnswer((_) => Future.value(updateBudgetMonad));

      final transactionResponse =
          await updateTransactionUseCase.updateCategoryId(
              transactionId: transactionModel.transactionId,
              categoryId: transactionModel.categoryId);

      expect(transactionResponse.isRight(), true);
      verify(mockTransactionRepository.update(transactionModel));
    });

    test('Failure Response: Failure', () async {
      Either<Failure, void> updateBudgetMonad =
          Left<Failure, void>(FetchDataFailure());
      Either<Failure, String> dateStringMonad =
          Right<Failure, String>(transactionModel.walletId);

      when(mockDefaultWalletRepository.readDefaultWallet())
          .thenAnswer((_) => Future.value(dateStringMonad));
      when(mockTransactionRepository.update(transactionModel))
          .thenAnswer((_) => Future.value(updateBudgetMonad));

      final transactionResponse =
          await updateTransactionUseCase.updateCategoryId(
              transactionId: transactionModel.transactionId,
              categoryId: transactionModel.categoryId);
      final f = transactionResponse.fold(
          (failure) => failure, (_) => GenericFailure());

      expect(f, equals(FetchDataFailure()));
      expect(transactionResponse.isLeft(), true);
      verify(mockTransactionRepository.update(transactionModel));
    });

    test('Read Wallet Id Failure: Failure', () async {
      Either<Failure, void> updateBudgetMonad =
          Left<Failure, void>(FetchDataFailure());
      Either<Failure, String> dateStringMonad =
          Left<Failure, String>(FetchDataFailure());

      when(mockDefaultWalletRepository.readDefaultWallet())
          .thenAnswer((_) => Future.value(dateStringMonad));
      when(mockTransactionRepository.update(transactionModel))
          .thenAnswer((_) => Future.value(updateBudgetMonad));

      final transactionResponse =
          await updateTransactionUseCase.updateCategoryId(
              transactionId: transactionModel.transactionId,
              categoryId: transactionModel.categoryId);
      final f = transactionResponse.fold(
          (failure) => failure, (_) => GenericFailure());

      expect(f, equals(EmptyResponseFailure()));
      expect(transactionResponse.isLeft(), true);
      verifyNever(mockTransactionRepository.update(transactionModel));
    });
  });

  group('UpdateRecurrence', () {
    final transactionModel = Transaction(
        walletId: transactionModelAsJSON['walletId'] as String,
        transactionId: transactionModelAsJSON['accountId'] as String,
        recurrence:
            parseDynamicAsRecurrence(transactionModelAsJSON['recurrence']));

    test('Success', () async {
      Either<Failure, void> updateBudgetMonad = Right<Failure, void>('');
      Either<Failure, String> dateStringMonad =
          Right<Failure, String>(transactionModel.walletId);

      when(mockDefaultWalletRepository.readDefaultWallet())
          .thenAnswer((_) => Future.value(dateStringMonad));
      when(mockTransactionRepository.update(transactionModel))
          .thenAnswer((_) => Future.value(updateBudgetMonad));

      final transactionResponse =
          await updateTransactionUseCase.updateRecurrence(
              transactionId: transactionModel.transactionId,
              recurrence: transactionModel.recurrence);

      expect(transactionResponse.isRight(), true);
      verify(mockTransactionRepository.update(transactionModel));
    });

    test('Failure Response: Failure', () async {
      Either<Failure, void> updateBudgetMonad =
          Left<Failure, void>(FetchDataFailure());
      Either<Failure, String> dateStringMonad =
          Right<Failure, String>(transactionModel.walletId);

      when(mockDefaultWalletRepository.readDefaultWallet())
          .thenAnswer((_) => Future.value(dateStringMonad));
      when(mockTransactionRepository.update(transactionModel))
          .thenAnswer((_) => Future.value(updateBudgetMonad));

      final transactionResponse =
          await updateTransactionUseCase.updateRecurrence(
              transactionId: transactionModel.transactionId,
              recurrence: transactionModel.recurrence);
      final f = transactionResponse.fold(
          (failure) => failure, (_) => GenericFailure());

      expect(f, equals(FetchDataFailure()));
      expect(transactionResponse.isLeft(), true);
      verify(mockTransactionRepository.update(transactionModel));
    });

    test('Read Wallet Id Failure: Failure', () async {
      Either<Failure, void> updateBudgetMonad =
          Left<Failure, void>(FetchDataFailure());
      Either<Failure, String> dateStringMonad =
          Left<Failure, String>(FetchDataFailure());

      when(mockDefaultWalletRepository.readDefaultWallet())
          .thenAnswer((_) => Future.value(dateStringMonad));
      when(mockTransactionRepository.update(transactionModel))
          .thenAnswer((_) => Future.value(updateBudgetMonad));

      final transactionResponse =
          await updateTransactionUseCase.updateRecurrence(
              transactionId: transactionModel.transactionId,
              recurrence: transactionModel.recurrence);
      final f = transactionResponse.fold(
          (failure) => failure, (_) => GenericFailure());

      expect(f, equals(EmptyResponseFailure()));
      expect(transactionResponse.isLeft(), true);
      verifyNever(mockTransactionRepository.update(transactionModel));
    });
  });

  group('UpdateTags', () {
    final transactionModel = Transaction(
        walletId: transactionModelAsJSON['walletId'] as String,
        transactionId: transactionModelAsJSON['accountId'] as String,
        tags: tags);

    test('Success', () async {
      Either<Failure, void> updateBudgetMonad = Right<Failure, void>('');
      Either<Failure, String> dateStringMonad =
          Right<Failure, String>(transactionModel.walletId);

      when(mockDefaultWalletRepository.readDefaultWallet())
          .thenAnswer((_) => Future.value(dateStringMonad));
      when(mockTransactionRepository.update(transactionModel))
          .thenAnswer((_) => Future.value(updateBudgetMonad));

      final transactionResponse = await updateTransactionUseCase.updateTags(
          transactionId: transactionModel.transactionId,
          tags: transactionModel.tags);

      expect(transactionResponse.isRight(), true);
      verify(mockTransactionRepository.update(transactionModel));
    });

    test('Failure Response: Failure', () async {
      Either<Failure, void> updateBudgetMonad =
          Left<Failure, void>(FetchDataFailure());
      Either<Failure, String> dateStringMonad =
          Right<Failure, String>(transactionModel.walletId);

      when(mockDefaultWalletRepository.readDefaultWallet())
          .thenAnswer((_) => Future.value(dateStringMonad));
      when(mockTransactionRepository.update(transactionModel))
          .thenAnswer((_) => Future.value(updateBudgetMonad));

      final transactionResponse = await updateTransactionUseCase.updateTags(
          transactionId: transactionModel.transactionId,
          tags: transactionModel.tags);
      final f = transactionResponse.fold(
          (failure) => failure, (_) => GenericFailure());

      expect(f, equals(FetchDataFailure()));
      expect(transactionResponse.isLeft(), true);
      verify(mockTransactionRepository.update(transactionModel));
    });

    test('Read Wallet Id Failure: Failure', () async {
      Either<Failure, void> updateBudgetMonad =
          Left<Failure, void>(FetchDataFailure());
      Either<Failure, String> dateStringMonad =
          Left<Failure, String>(FetchDataFailure());

      when(mockDefaultWalletRepository.readDefaultWallet())
          .thenAnswer((_) => Future.value(dateStringMonad));
      when(mockTransactionRepository.update(transactionModel))
          .thenAnswer((_) => Future.value(updateBudgetMonad));

      final transactionResponse = await updateTransactionUseCase.updateTags(
          transactionId: transactionModel.transactionId,
          tags: transactionModel.tags);
      final f = transactionResponse.fold(
          (failure) => failure, (_) => GenericFailure());

      expect(f, equals(EmptyResponseFailure()));
      expect(transactionResponse.isLeft(), true);
      verifyNever(mockTransactionRepository.update(transactionModel));
    });
  });
}
