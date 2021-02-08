import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_blitzbudget/core/failure/api_failure.dart';
import 'package:mobile_blitzbudget/core/failure/failure.dart';
import 'package:mobile_blitzbudget/data/model/bank-account/bank_account_model.dart';
import 'package:mobile_blitzbudget/data/model/budget/budget_model.dart';
import 'package:mobile_blitzbudget/data/model/category/category_model.dart';
import 'package:mobile_blitzbudget/data/model/date_model.dart';
import 'package:mobile_blitzbudget/data/model/response/dashboard/budget_response_model.dart';
import 'package:mobile_blitzbudget/data/model/wallet/wallet_model.dart';
import 'package:mobile_blitzbudget/data/utils/data_utils.dart';
import 'package:mobile_blitzbudget/domain/entities/bank-account/bank_account.dart';
import 'package:mobile_blitzbudget/domain/entities/budget/budget.dart';
import 'package:mobile_blitzbudget/domain/entities/category/category.dart';
import 'package:mobile_blitzbudget/domain/entities/date.dart';
import 'package:mobile_blitzbudget/domain/entities/response/budget_response.dart';
import 'package:mobile_blitzbudget/domain/entities/user.dart';
import 'package:mobile_blitzbudget/domain/entities/wallet/wallet.dart';
import 'package:mobile_blitzbudget/domain/repositories/authentication/user_attributes_repository.dart';
import 'package:mobile_blitzbudget/domain/repositories/dashboard/budget_repository.dart';
import 'package:mobile_blitzbudget/domain/repositories/dashboard/common/default_wallet_repository.dart';
import 'package:mobile_blitzbudget/domain/repositories/dashboard/common/ends_with_date_repository.dart';
import 'package:mobile_blitzbudget/domain/repositories/dashboard/common/starts_with_date_repository.dart';
import 'package:mobile_blitzbudget/domain/usecases/dashboard/budget/fetch_budget_use_case.dart';
import 'package:mockito/mockito.dart';

import '../../../../fixtures/fixture_reader.dart';

class MockBudgetRepository extends Mock implements BudgetRepository {}

class MockDefaultWalletRepository extends Mock
    implements DefaultWalletRepository {}

class MockEndsWithDateRepository extends Mock
    implements EndsWithDateRepository {}

class MockStartsWithDateRepository extends Mock
    implements StartsWithDateRepository {}

class MockUserAttributesRepository extends Mock
    implements UserAttributesRepository {}

void main() {
  FetchBudgetUseCase fetchBudgetUseCase;
  MockBudgetRepository mockBudgetRepository;
  MockDefaultWalletRepository mockDefaultWalletRepository;
  MockEndsWithDateRepository mockEndsWithDateRepository;
  MockStartsWithDateRepository mockStartsWithDateRepository;
  MockUserAttributesRepository mockUserAttributesRepository;

  final budgetModelAsString = fixture('models/get/budget/budget_model.json');
  final budgetModelAsJSON =
      jsonDecode(budgetModelAsString) as Map<String, dynamic>;
  final budget = Budget(
      walletId: budgetModelAsJSON['walletId'] as String,
      budgetId: budgetModelAsJSON['budgetId'] as String,
      planned: parseDynamicAsDouble(budgetModelAsJSON['planned']),
      categoryId: budgetModelAsJSON['category'] as String,
      categoryType:
          parseDynamicAsCategoryType(budgetModelAsJSON['category_type']),
      dateMeantFor: budgetModelAsJSON['date_meant_for'] as String);

  final budgetResponseModelAsString =
      fixture('responses/dashboard/budget/fetch_budget_info.json');
  final budgetResponseModelAsJSON =
      jsonDecode(budgetResponseModelAsString) as Map<String, dynamic>;

  /// Convert budgets from the response JSON to List<Budget>
  /// If Empty then return an empty object list
  var budgetResponseModel = convertToResponseModel(budgetResponseModelAsJSON);

  setUp(() {
    mockBudgetRepository = MockBudgetRepository();
    mockDefaultWalletRepository = MockDefaultWalletRepository();
    mockEndsWithDateRepository = MockEndsWithDateRepository();
    mockStartsWithDateRepository = MockStartsWithDateRepository();
    mockUserAttributesRepository = MockUserAttributesRepository();
    fetchBudgetUseCase = FetchBudgetUseCase(
        budgetRepository: mockBudgetRepository,
        defaultWalletRepository: mockDefaultWalletRepository,
        endsWithDateRepository: mockEndsWithDateRepository,
        startsWithDateRepository: mockStartsWithDateRepository,
        userAttributesRepository: mockUserAttributesRepository);
  });

  group('Fetch', () {
    var now = DateTime.now();
    var dateString = now.toIso8601String();
    final userId = 'User#2020-12-21T20:32:06.003Z';

    test('Success', () async {
      Either<Failure, void> addBudgetMonad = Right<Failure, void>('');
      Either<Failure, String> dateStringMonad =
          Right<Failure, String>(dateString);
      final user = User(userId: userId);
      Either<Failure, User> userMonad = Right<Failure, User>(user);

      when(mockBudgetRepository.add(budget))
          .thenAnswer((_) => Future.value(addBudgetMonad));
      when(mockDefaultWalletRepository.readDefaultWallet())
          .thenAnswer((_) => Future.value(dateStringMonad));
      when(mockEndsWithDateRepository.readEndsWithDate())
          .thenAnswer((_) => Future.value(dateString));
      when(mockStartsWithDateRepository.readStartsWithDate())
          .thenAnswer((_) => Future.value(dateString));
      Either<Failure, BudgetResponse> fetchBudgetMonad =
          Right<Failure, BudgetResponse>(budgetResponseModel);

      when(mockBudgetRepository.fetch(
              startsWithDate: dateString,
              endsWithDate: dateString,
              defaultWallet: dateString,
              userId: null))
          .thenAnswer((_) => Future.value(fetchBudgetMonad));

      final budgetResponse = await fetchBudgetUseCase.fetch();

      expect(budgetResponse.isRight(), true);
      verify(mockBudgetRepository.fetch(
          startsWithDate: dateString,
          endsWithDate: dateString,
          defaultWallet: dateString,
          userId: null));
    });

    test('Default Wallet Empty: Success', () async {
      Either<Failure, void> addBudgetMonad = Right<Failure, void>('');
      final user = User(userId: userId);
      Either<Failure, User> userMonad = Right<Failure, User>(user);
      Either<Failure, String> dateFailure =
          Left<Failure, String>(FetchDataFailure());

      when(mockBudgetRepository.add(budget))
          .thenAnswer((_) => Future.value(addBudgetMonad));
      when(mockDefaultWalletRepository.readDefaultWallet())
          .thenAnswer((_) => Future.value(dateFailure));
      when(mockEndsWithDateRepository.readEndsWithDate())
          .thenAnswer((_) => Future.value(dateString));
      when(mockStartsWithDateRepository.readStartsWithDate())
          .thenAnswer((_) => Future.value(dateString));
      when(mockUserAttributesRepository.readUserAttributes())
          .thenAnswer((_) => Future.value(userMonad));
      Either<Failure, BudgetResponse> fetchBudgetMonad =
          Right<Failure, BudgetResponse>(budgetResponseModel);

      when(mockBudgetRepository.fetch(
              startsWithDate: dateString,
              endsWithDate: dateString,
              defaultWallet: null,
              userId: userId))
          .thenAnswer((_) => Future.value(fetchBudgetMonad));

      final budgetResponse = await fetchBudgetUseCase.fetch();

      expect(budgetResponse.isRight(), true);
      verify(mockBudgetRepository.fetch(
          startsWithDate: dateString,
          endsWithDate: dateString,
          defaultWallet: null,
          userId: userId));
    });

    test('Default Wallet Empty && User Attribute Failure: Success', () async {
      Either<Failure, void> addBudgetMonad = Right<Failure, void>('');
      Either<Failure, String> dateFailure =
          Left<Failure, String>(FetchDataFailure());
      Either<Failure, User> userFailure =
          Left<Failure, User>(FetchDataFailure());

      when(mockBudgetRepository.add(budget))
          .thenAnswer((_) => Future.value(addBudgetMonad));
      when(mockDefaultWalletRepository.readDefaultWallet())
          .thenAnswer((_) => Future.value(dateFailure));
      when(mockEndsWithDateRepository.readEndsWithDate())
          .thenAnswer((_) => Future.value(dateString));
      when(mockStartsWithDateRepository.readStartsWithDate())
          .thenAnswer((_) => Future.value(dateString));
      when(mockUserAttributesRepository.readUserAttributes())
          .thenAnswer((_) => Future.value(userFailure));

      final budgetResponse = await fetchBudgetUseCase.fetch();

      expect(budgetResponse.isLeft(), true);
      verifyNever(mockBudgetRepository.fetch(
          startsWithDate: dateString,
          endsWithDate: dateString,
          defaultWallet: null,
          userId: userId));
    });
  });
}

BudgetResponseModel convertToResponseModel(
    Map<String, dynamic> budgetResponseModelAsJSON) {
  /// Convert budgets from the response JSON to List<Budget>
  /// If Empty then return an empty object list
  var responseBudgets = budgetResponseModelAsJSON['Budget'] as List;
  var convertedBudgets = List<Budget>.from(responseBudgets?.map<dynamic>(
          (dynamic model) =>
              BudgetModel.fromJSON(model as Map<String, dynamic>)) ??
      <Budget>[]);

  /// Convert categories from the response JSON to List<Category>
  /// If Empty then return an empty object list
  var responseCategories = budgetResponseModelAsJSON['Category'] as List;
  var convertedCategories = List<Category>.from(
      responseCategories?.map<dynamic>((dynamic model) =>
              CategoryModel.fromJSON(model as Map<String, dynamic>)) ??
          <Category>[]);

  /// Convert BankAccount from the response JSON to List<BankAccount>
  /// If Empty then return an empty object list
  var responseBankAccounts = budgetResponseModelAsJSON['BankAccount'] as List;
  var convertedBankAccounts = List<BankAccount>.from(
      responseBankAccounts?.map<dynamic>((dynamic model) =>
              BankAccountModel.fromJSON(model as Map<String, dynamic>)) ??
          <BankAccount>[]);

  /// Convert Dates from the response JSON to List<Date>
  /// If Empty then return an empty object list
  var responseDate = budgetResponseModelAsJSON['Date'] as List;
  var convertedDates = List<Date>.from(responseDate?.map<dynamic>(
          (dynamic model) =>
              DateModel.fromJSON(model as Map<String, dynamic>)) ??
      <Date>[]);

  dynamic responseWallet = budgetResponseModelAsJSON['Wallet'];
  Wallet convertedWallet;

  /// Check if the response is a string or a list
  ///
  /// If string then convert them into a wallet
  /// If List then convert them into list of wallets and take the first wallet.
  if (responseWallet is Map) {
    convertedWallet =
        WalletModel.fromJSON(responseWallet as Map<String, dynamic>);
  } else if (responseWallet is List) {
    var convertedWallets = List<Wallet>.from(responseWallet.map<dynamic>(
        (dynamic model) =>
            WalletModel.fromJSON(model as Map<String, dynamic>)));

    convertedWallet = convertedWallets[0];
  }

  final budgetResponseModel = BudgetResponseModel(
      budgets: convertedBudgets,
      categories: convertedCategories,
      bankAccounts: convertedBankAccounts,
      dates: convertedDates,
      wallet: convertedWallet);
  return budgetResponseModel;
}
