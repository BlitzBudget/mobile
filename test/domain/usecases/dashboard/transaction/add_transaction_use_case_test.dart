import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_blitzbudget/core/failure/api_failure.dart';
import 'package:mobile_blitzbudget/core/failure/failure.dart';
import 'package:mobile_blitzbudget/data/model/transaction/transaction_model.dart';
import 'package:mobile_blitzbudget/data/utils/data_utils.dart';
import 'package:mobile_blitzbudget/domain/repositories/dashboard/transaction/transaction_repository.dart';
import 'package:mobile_blitzbudget/domain/usecases/dashboard/transaction/add_transaction_use_case.dart';
import 'package:mockito/mockito.dart';

import '../../../../fixtures/fixture_reader.dart';

class MockTransactionRepository extends Mock implements TransactionRepository {}

void main() {
  AddTransactionUseCase addTransactionUseCase;
  MockTransactionRepository mockTransactionRepository;

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
    addTransactionUseCase =
        AddTransactionUseCase(transactionRepository: mockTransactionRepository);
  });

  group('Add', () {
    test('Success', () async {
      Either<Failure, void> addTransactionMonad = Right<Failure, void>('');

      when(mockTransactionRepository.add(transaction))
          .thenAnswer((_) => Future.value(addTransactionMonad));

      final transactionResponse =
          await addTransactionUseCase.add(addTransaction: transaction);

      expect(transactionResponse.isRight(), true);
      verify(mockTransactionRepository.add(transaction));
    });

    test('Failure', () async {
      Either<Failure, void> addTransactionMonad =
          Left<Failure, void>(FetchDataFailure());

      when(mockTransactionRepository.add(transaction))
          .thenAnswer((_) => Future.value(addTransactionMonad));

      final transactionResponse =
          await addTransactionUseCase.add(addTransaction: transaction);

      expect(transactionResponse.isLeft(), true);
      verify(mockTransactionRepository.add(transaction));
    });
  });
}
