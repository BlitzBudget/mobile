import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_blitzbudget/core/failure/api_failure.dart';
import 'package:mobile_blitzbudget/core/failure/failure.dart';
import 'package:mobile_blitzbudget/data/model/response/dashboard/transaction_response_model.dart';
import 'package:mobile_blitzbudget/data/model/transaction/transaction_model.dart';
import 'package:mobile_blitzbudget/data/utils/data_utils.dart';
import 'package:mobile_blitzbudget/domain/entities/response/transaction_response.dart';
import 'package:mobile_blitzbudget/domain/entities/transaction/transaction.dart';
import 'package:mobile_blitzbudget/domain/entities/user.dart';
import 'package:mobile_blitzbudget/domain/repositories/authentication/user_attributes_repository.dart';
import 'package:mobile_blitzbudget/domain/repositories/dashboard/common/default_wallet_repository.dart';
import 'package:mobile_blitzbudget/domain/repositories/dashboard/common/ends_with_date_repository.dart';
import 'package:mobile_blitzbudget/domain/repositories/dashboard/common/starts_with_date_repository.dart';
import 'package:mobile_blitzbudget/domain/repositories/dashboard/transaction/transaction_repository.dart';
import 'package:mobile_blitzbudget/domain/usecases/dashboard/transaction/fetch_transaction_use_case.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../fixtures/fixture_reader.dart';

class MockTransactionRepository extends Mock implements TransactionRepository {}

class MockDefaultWalletRepository extends Mock
    implements DefaultWalletRepository {}

class MockEndsWithDateRepository extends Mock
    implements EndsWithDateRepository {}

class MockStartsWithDateRepository extends Mock
    implements StartsWithDateRepository {}

class MockUserAttributesRepository extends Mock
    implements UserAttributesRepository {}

void main() {
  late FetchTransactionUseCase fetchTransactionUseCase;
  MockTransactionRepository? mockTransactionRepository;
  MockDefaultWalletRepository? mockDefaultWalletRepository;
  MockEndsWithDateRepository? mockEndsWithDateRepository;
  MockStartsWithDateRepository? mockStartsWithDateRepository;
  MockUserAttributesRepository? mockUserAttributesRepository;

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

  final transactionResponseModelAsJSONAsString =
      fixture('responses/dashboard/transaction/fetch_transaction_info.json');
  final transactionResponseModelAsJSONAsJSON =
      jsonDecode(transactionResponseModelAsJSONAsString);

  /// Convert transactions from the response JSON to List<Transaction>
  /// If Empty then return an empty object list
  final transactionResponseModelAsJSON =
      convertToResponseModel(transactionResponseModelAsJSONAsJSON);

  setUp(() {
    mockTransactionRepository = MockTransactionRepository();
    mockDefaultWalletRepository = MockDefaultWalletRepository();
    mockEndsWithDateRepository = MockEndsWithDateRepository();
    mockStartsWithDateRepository = MockStartsWithDateRepository();
    mockUserAttributesRepository = MockUserAttributesRepository();
    fetchTransactionUseCase = FetchTransactionUseCase(
        transactionRepository: mockTransactionRepository,
        defaultWalletRepository: mockDefaultWalletRepository,
        endsWithDateRepository: mockEndsWithDateRepository,
        startsWithDateRepository: mockStartsWithDateRepository,
        userAttributesRepository: mockUserAttributesRepository);
  });

  group('Fetch', () {
    final now = DateTime.now();
    final dateString = now.toIso8601String();
    const userId = 'User#2020-12-21T20:32:06.003Z';

    test('Success', () async {
      const Either<Failure, void> addTransactionMonad =
          Right<Failure, void>('');
      final Either<Failure, String> dateStringMonad =
          Right<Failure, String>(dateString);

      when(() => mockTransactionRepository!.add(transaction))
          .thenAnswer((_) => Future.value(addTransactionMonad));
      when(() => mockDefaultWalletRepository!.readDefaultWallet())
          .thenAnswer((_) => Future.value(dateStringMonad));
      when(() => mockEndsWithDateRepository!.readEndsWithDate())
          .thenAnswer((_) => Future.value(dateString));
      when(() => mockStartsWithDateRepository!.readStartsWithDate())
          .thenAnswer((_) => Future.value(dateString));
      final Either<Failure, TransactionResponse> fetchTransactionMonad =
          Right<Failure, TransactionResponse>(transactionResponseModelAsJSON);

      when(() => mockTransactionRepository!.fetch(
              startsWithDate: dateString,
              endsWithDate: dateString,
              defaultWallet: dateString))
          .thenAnswer((_) => Future.value(fetchTransactionMonad));

      final transactionResponse = await fetchTransactionUseCase.fetch();

      expect(transactionResponse.isRight(), true);
      verify(() => mockTransactionRepository!.fetch(
          startsWithDate: dateString,
          endsWithDate: dateString,
          defaultWallet: dateString));
    });

    test('Default Wallet Empty: Failure', () async {
      const Either<Failure, void> addTransactionMonad =
          Right<Failure, void>('');
      const user = User(userId: userId);
      const Either<Failure, User> userMonad = Right<Failure, User>(user);
      final Either<Failure, String> dateFailure =
          Left<Failure, String>(FetchDataFailure());

      when(() => mockTransactionRepository!.add(transaction))
          .thenAnswer((_) => Future.value(addTransactionMonad));
      when(() => mockDefaultWalletRepository!.readDefaultWallet())
          .thenAnswer((_) => Future.value(dateFailure));
      when(() => mockEndsWithDateRepository!.readEndsWithDate())
          .thenAnswer((_) => Future.value(dateString));
      when(() => mockStartsWithDateRepository!.readStartsWithDate())
          .thenAnswer((_) => Future.value(dateString));
      when(() => mockUserAttributesRepository!.readUserAttributes())
          .thenAnswer((_) => Future.value(userMonad));
      final Either<Failure, TransactionResponse> fetchTransactionMonad =
          Right<Failure, TransactionResponse>(transactionResponseModelAsJSON);

      when(() => mockTransactionRepository!.fetch(
              startsWithDate: dateString,
              endsWithDate: dateString,
              defaultWallet: null))
          .thenAnswer((_) => Future.value(fetchTransactionMonad));

      final transactionResponse = await fetchTransactionUseCase.fetch();

      expect(transactionResponse.isLeft(), true);
      verifyNever(() => mockTransactionRepository!.fetch(
          startsWithDate: dateString,
          endsWithDate: dateString,
          defaultWallet: null));
    });

    test('Default Wallet Empty && User Attribute Failure: Failure', () async {
      const Either<Failure, void> addTransactionMonad =
          Right<Failure, void>('');
      final Either<Failure, String> dateFailure =
          Left<Failure, String>(FetchDataFailure());
      final Either<Failure, User> userFailure =
          Left<Failure, User>(FetchDataFailure());

      when(() => mockTransactionRepository!.add(transaction))
          .thenAnswer((_) => Future.value(addTransactionMonad));
      when(() => mockDefaultWalletRepository!.readDefaultWallet())
          .thenAnswer((_) => Future.value(dateFailure));
      when(() => mockEndsWithDateRepository!.readEndsWithDate())
          .thenAnswer((_) => Future.value(dateString));
      when(() => mockStartsWithDateRepository!.readStartsWithDate())
          .thenAnswer((_) => Future.value(dateString));
      when(() => mockUserAttributesRepository!.readUserAttributes())
          .thenAnswer((_) => Future.value(userFailure));

      final transactionResponse = await fetchTransactionUseCase.fetch();

      expect(transactionResponse.isLeft(), true);
      verifyNever(() => mockTransactionRepository!.fetch(
          startsWithDate: dateString,
          endsWithDate: dateString,
          defaultWallet: null));
    });
  });
}

TransactionResponseModel convertToResponseModel(
    List<dynamic> transactionResponseModelAsJSON) {
  /// Convert transactions from the response JSON to List<Transaction>
  /// If Empty then return an empty object list
  final convertedTransactions = List<Transaction>.from(
      transactionResponseModelAsJSON
          .map<dynamic>((dynamic model) => TransactionModel.fromJSON(model)));

  return TransactionResponseModel(transactions: convertedTransactions);
}
