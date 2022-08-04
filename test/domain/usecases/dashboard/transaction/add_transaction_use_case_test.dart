import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_blitzbudget/core/failure/api_failure.dart';
import 'package:mobile_blitzbudget/core/failure/failure.dart';
import 'package:mobile_blitzbudget/data/model/transaction/transaction_model.dart';
import 'package:mobile_blitzbudget/data/utils/data_utils.dart';
import 'package:mobile_blitzbudget/domain/entities/transaction/transaction.dart';
import 'package:mobile_blitzbudget/domain/repositories/dashboard/transaction/transaction_repository.dart';
import 'package:mobile_blitzbudget/domain/usecases/dashboard/transaction/add_transaction_use_case.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../fixtures/fixture_reader.dart';
import '../bank-account/delete_bank_account_use_case_test.dart';

class MockTransactionRepository extends Mock implements TransactionRepository {}

void main() {
  late AddTransactionUseCase addTransactionUseCase;
  MockTransactionRepository? mockTransactionRepository;
  MockDefaultWalletRepository? mockDefaultWalletRepository;

  final transactionModelAsString =
      fixture('models/get/transaction/transaction_model.json');
  final transactionModelAsJSON = jsonDecode(transactionModelAsString);
  final tags = (transactionModelAsJSON['tags'])
      ?.map<String>(parseDynamicAsString)
      ?.toList();
  final transaction = TransactionModel(
      walletId: transactionModelAsJSON['walletId'],
      transactionId: transactionModelAsJSON['transactionId'],
      amount: parseDynamicAsDouble(transactionModelAsJSON['amount']),
      description: transactionModelAsJSON['description'],
      tags: tags,
      categoryId: transactionModelAsJSON['category']);

  setUp(() {
    // For Mock any() to fallback to Transaction
    registerFallbackValue(const Transaction());
    mockTransactionRepository = MockTransactionRepository();
    mockDefaultWalletRepository = MockDefaultWalletRepository();
    addTransactionUseCase = AddTransactionUseCase(
        transactionRepository: mockTransactionRepository,
        defaultWalletRepository: mockDefaultWalletRepository);
  });

  group('Add', () {
    test('Success', () async {
      const Either<Failure, void> addTransactionMonad =
          Right<Failure, void>('');
      const Either<Failure, String> walletIdMonad =
          Right<Failure, String>('walletId');

      when(() => mockTransactionRepository!.add(any()))
          .thenAnswer((_) => Future.value(addTransactionMonad));
      when(() => mockDefaultWalletRepository!.readDefaultWallet())
          .thenAnswer((_) => Future.value(walletIdMonad));

      final transactionResponse =
          await addTransactionUseCase.add(addTransaction: transaction);

      expect(transactionResponse.isRight(), true);
      verify(() => mockTransactionRepository!.add(any()));
      verify(() => mockDefaultWalletRepository!.readDefaultWallet());
    });

    test('Failure', () async {
      final Either<Failure, void> addTransactionMonad =
          Left<Failure, void>(FetchDataFailure());
      const Either<Failure, String> walletIdMonad =
          Right<Failure, String>('walletId');

      when(() => mockTransactionRepository!.add(any()))
          .thenAnswer((_) => Future.value(addTransactionMonad));
      when(() => mockDefaultWalletRepository!.readDefaultWallet())
          .thenAnswer((_) => Future.value(walletIdMonad));

      final transactionResponse =
          await addTransactionUseCase.add(addTransaction: transaction);

      expect(transactionResponse.isLeft(), true);
      verify(() => mockTransactionRepository!.add(any()));
      verify(() => mockDefaultWalletRepository!.readDefaultWallet());
    });
  });
}
