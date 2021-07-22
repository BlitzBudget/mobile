import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_blitzbudget/core/failure/api_failure.dart';
import 'package:mobile_blitzbudget/core/failure/failure.dart';
import 'package:mobile_blitzbudget/data/model/bank-account/bank_account_model.dart';
import 'package:mobile_blitzbudget/data/model/budget/budget_model.dart';
import 'package:mobile_blitzbudget/data/model/category/category_model.dart';
import 'package:mobile_blitzbudget/data/model/date_model.dart';
import 'package:mobile_blitzbudget/data/model/recurring-transaction/recurring_transaction_model.dart';
import 'package:mobile_blitzbudget/data/model/transaction/transaction_model.dart';
import 'package:mobile_blitzbudget/data/model/response/dashboard/transaction_response_model.dart';
import 'package:mobile_blitzbudget/data/model/wallet/wallet_model.dart';
import 'package:mobile_blitzbudget/data/utils/data_utils.dart';
import 'package:mobile_blitzbudget/domain/entities/bank-account/bank_account.dart';
import 'package:mobile_blitzbudget/domain/entities/budget/budget.dart';
import 'package:mobile_blitzbudget/domain/entities/category/category.dart';
import 'package:mobile_blitzbudget/domain/entities/date.dart';
import 'package:mobile_blitzbudget/domain/entities/recurring-transaction/recurring_transaction.dart';
import 'package:mobile_blitzbudget/domain/entities/transaction/transaction.dart';
import 'package:mobile_blitzbudget/domain/entities/response/transaction_response.dart';
import 'package:mobile_blitzbudget/domain/entities/user.dart';
import 'package:mobile_blitzbudget/domain/entities/wallet/wallet.dart';
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
          defaultWallet: dateString,
          userId: null)).thenAnswer((_) => Future.value(fetchTransactionMonad));

      final transactionResponse = await fetchTransactionUseCase.fetch();

      expect(transactionResponse.isRight(), true);
      verify(() => mockTransactionRepository!.fetch(
          startsWithDate: dateString,
          endsWithDate: dateString,
          defaultWallet: dateString,
          userId: null));
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
              defaultWallet: null,
              userId: userId))
          .thenAnswer((_) => Future.value(fetchTransactionMonad));

      final transactionResponse = await fetchTransactionUseCase.fetch();

      expect(transactionResponse.isRight(), true);
      verify(() => mockTransactionRepository!.fetch(
          startsWithDate: dateString,
          endsWithDate: dateString,
          defaultWallet: null,
          userId: userId));
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
          defaultWallet: null,
          userId: userId));
    });
  });
}

TransactionResponseModel convertToResponseModel(
    Map<String, dynamic> transactionResponseModelAsJSON) {
  /// Convert transactions from the response JSON to List<Transaction>
  /// If Empty then return an empty object list
  final responseTransactions = transactionResponseModelAsJSON['Transaction'];
  final convertedTransactions = List<Transaction>.from(responseTransactions
      ?.map<dynamic>((dynamic model) => TransactionModel.fromJSON(model)));

  /// Convert recurring transactions from the response JSON to List<RecurringTransaction>
  /// If Empty then return an empty object list
  final responseRecurringTransactions =
      transactionResponseModelAsJSON['RecurringTransactions'];
  final convertedRecurringTransactions = List<RecurringTransaction>.from(
      responseRecurringTransactions?.map<dynamic>(
              (dynamic model) => RecurringTransactionModel.fromJSON(model)) ??
          <RecurringTransaction>[]);

  /// Convert budgets from the response JSON to List<Budget>
  /// If Empty then return an empty object list
  final responseBudgets = transactionResponseModelAsJSON['Budget'];
  final convertedBudgets = List<Budget>.from(responseBudgets
          ?.map<dynamic>((dynamic model) => BudgetModel.fromJSON(model)) ??
      <Budget>[]);

  /// Convert categories from the response JSON to List<Category>
  /// If Empty then return an empty object list
  final responseCategories = transactionResponseModelAsJSON['Category'];
  final convertedCategories = List<Category>.from(responseCategories
          ?.map<dynamic>((dynamic model) => CategoryModel.fromJSON(model)) ??
      <Category>[]);

  /// Convert BankAccount from the response JSON to List<BankAccount>
  /// If Empty then return an empty object list
  final responseBankAccounts = transactionResponseModelAsJSON['BankAccount'];
  final convertedBankAccounts = List<BankAccount>.from(responseBankAccounts
          ?.map<dynamic>((dynamic model) => BankAccountModel.fromJSON(model)) ??
      <BankAccount>[]);

  /// Convert Dates from the response JSON to List<Date>
  /// If Empty then return an empty object list
  final responseDate = transactionResponseModelAsJSON['Date'];
  final convertedDates = List<Date>.from(responseDate
          ?.map<dynamic>((dynamic model) => DateModel.fromJSON(model)) ??
      <Date>[]);

  final responseWallet = transactionResponseModelAsJSON['Wallet'];
  Wallet? convertedWallet;

  /// Check if the response is a string or a list
  ///
  /// If string then convert them into a wallet
  /// If List then convert them into list of wallets and take the first wallet.
  if (responseWallet is Map) {
    convertedWallet =
        WalletModel.fromJSON(responseWallet as Map<String, dynamic>);
  } else if (responseWallet is List) {
    final convertedWallets = List<Wallet>.from(responseWallet
        .map<dynamic>((dynamic model) => WalletModel.fromJSON(model)));

    convertedWallet = convertedWallets[0];
  }

  return TransactionResponseModel(
      transactions: convertedTransactions,
      recurringTransactions: convertedRecurringTransactions,
      budgets: convertedBudgets,
      categories: convertedCategories,
      bankAccounts: convertedBankAccounts,
      dates: convertedDates,
      wallet: convertedWallet,
      incomeTotal:
          parseDynamicAsDouble(transactionResponseModelAsJSON['incomeTotal']),
      expenseTotal:
          parseDynamicAsDouble(transactionResponseModelAsJSON['expenseTotal']),
      balance: parseDynamicAsDouble(transactionResponseModelAsJSON['balance']));
}
