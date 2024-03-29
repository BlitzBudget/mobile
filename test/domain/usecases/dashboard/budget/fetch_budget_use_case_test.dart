import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_blitzbudget/core/failure/api_failure.dart';
import 'package:mobile_blitzbudget/core/failure/failure.dart';
import 'package:mobile_blitzbudget/data/model/budget/budget_model.dart';
import 'package:mobile_blitzbudget/data/model/response/dashboard/budget_response_model.dart';
import 'package:mobile_blitzbudget/data/utils/data_utils.dart';
import 'package:mobile_blitzbudget/domain/entities/budget/budget.dart';
import 'package:mobile_blitzbudget/domain/entities/response/budget_response.dart';
import 'package:mobile_blitzbudget/domain/entities/user.dart';
import 'package:mobile_blitzbudget/domain/repositories/authentication/user_attributes_repository.dart';
import 'package:mobile_blitzbudget/domain/repositories/dashboard/budget_repository.dart';
import 'package:mobile_blitzbudget/domain/repositories/dashboard/common/default_wallet_repository.dart';
import 'package:mobile_blitzbudget/domain/repositories/dashboard/common/ends_with_date_repository.dart';
import 'package:mobile_blitzbudget/domain/repositories/dashboard/common/starts_with_date_repository.dart';
import 'package:mobile_blitzbudget/domain/usecases/dashboard/budget/fetch_budget_use_case.dart';
import 'package:mocktail/mocktail.dart';

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
  late FetchBudgetUseCase fetchBudgetUseCase;
  late MockBudgetRepository mockBudgetRepository;
  late MockDefaultWalletRepository mockDefaultWalletRepository;
  late MockEndsWithDateRepository mockEndsWithDateRepository;
  late MockStartsWithDateRepository mockStartsWithDateRepository;
  late MockUserAttributesRepository mockUserAttributesRepository;

  final budgetModelAsString = fixture('models/get/budget/budget_model.json');
  final budgetModelAsJSON = jsonDecode(budgetModelAsString);
  final budget = Budget(
      walletId: budgetModelAsJSON['pk'],
      budgetId: budgetModelAsJSON['sk'],
      planned: parseDynamicAsDouble(budgetModelAsJSON['planned']),
      categoryId: budgetModelAsJSON['category'],
      creationDate: budgetModelAsJSON['creation_date']);

  final budgetResponseModelAsString =
      fixture('responses/dashboard/budget/fetch_budget_info.json');
  final budgetResponseModelAsJSON = jsonDecode(budgetResponseModelAsString);

  /// Convert budgets from the response JSON to List<Budget>
  /// If Empty then return an empty object list
  final budgetResponseModel = convertToResponseModel(budgetResponseModelAsJSON);

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
    final now = DateTime.now();
    final dateString = now.toIso8601String();
    const userId = 'User#2020-12-21T20:32:06.003Z';

    test('Success', () async {
      const Either<Failure, void> addBudgetMonad = Right<Failure, void>('');
      final Either<Failure, String> dateStringMonad =
          Right<Failure, String>(dateString);

      when(() => mockBudgetRepository.add(budget))
          .thenAnswer((_) => Future.value(addBudgetMonad));
      when(() => mockDefaultWalletRepository.readDefaultWallet())
          .thenAnswer((_) => Future.value(dateStringMonad));
      when(() => mockEndsWithDateRepository.readEndsWithDate())
          .thenAnswer((_) => Future.value(dateString));
      when(() => mockStartsWithDateRepository.readStartsWithDate())
          .thenAnswer((_) => Future.value(dateString));
      final Either<Failure, BudgetResponse> fetchBudgetMonad =
          Right<Failure, BudgetResponse>(budgetResponseModel);

      when(() => mockBudgetRepository.fetch(
          startsWithDate: dateString,
          endsWithDate: dateString,
          defaultWallet: dateString,
          userId: null)).thenAnswer((_) => Future.value(fetchBudgetMonad));

      final budgetResponse = await fetchBudgetUseCase.fetch();

      expect(budgetResponse.isRight(), true);
      verify(() => mockBudgetRepository.fetch(
          startsWithDate: dateString,
          endsWithDate: dateString,
          defaultWallet: dateString,
          userId: null));
    });

    test('Default Wallet Empty: Failure', () async {
      const Either<Failure, void> addBudgetMonad = Right<Failure, void>('');
      const user = User(userId: userId);
      const Either<Failure, User> userMonad = Right<Failure, User>(user);
      final Either<Failure, String> dateFailure =
          Left<Failure, String>(FetchDataFailure());

      when(() => mockBudgetRepository.add(budget))
          .thenAnswer((_) => Future.value(addBudgetMonad));
      when(() => mockDefaultWalletRepository.readDefaultWallet())
          .thenAnswer((_) => Future.value(dateFailure));
      when(() => mockEndsWithDateRepository.readEndsWithDate())
          .thenAnswer((_) => Future.value(dateString));
      when(() => mockStartsWithDateRepository.readStartsWithDate())
          .thenAnswer((_) => Future.value(dateString));
      when(() => mockUserAttributesRepository.readUserAttributes())
          .thenAnswer((_) => Future.value(userMonad));
      final Either<Failure, BudgetResponse> fetchBudgetMonad =
          Right<Failure, BudgetResponse>(budgetResponseModel);

      when(() => mockBudgetRepository.fetch(
          startsWithDate: dateString,
          endsWithDate: dateString,
          defaultWallet: null,
          userId: userId)).thenAnswer((_) => Future.value(fetchBudgetMonad));

      final budgetResponse = await fetchBudgetUseCase.fetch();

      expect(budgetResponse.isRight(), true);
      verify(() => mockBudgetRepository.fetch(
          startsWithDate: dateString,
          endsWithDate: dateString,
          defaultWallet: null,
          userId: userId));
    });

    test('Default Wallet Empty && User Attribute Failure: Failure', () async {
      const Either<Failure, void> addBudgetMonad = Right<Failure, void>('');
      final Either<Failure, String> dateFailure =
          Left<Failure, String>(FetchDataFailure());
      final Either<Failure, User> userFailure =
          Left<Failure, User>(FetchDataFailure());

      when(() => mockBudgetRepository.add(budget))
          .thenAnswer((_) => Future.value(addBudgetMonad));
      when(() => mockDefaultWalletRepository.readDefaultWallet())
          .thenAnswer((_) => Future.value(dateFailure));
      when(() => mockEndsWithDateRepository.readEndsWithDate())
          .thenAnswer((_) => Future.value(dateString));
      when(() => mockStartsWithDateRepository.readStartsWithDate())
          .thenAnswer((_) => Future.value(dateString));
      when(() => mockUserAttributesRepository.readUserAttributes())
          .thenAnswer((_) => Future.value(userFailure));

      final budgetResponse = await fetchBudgetUseCase.fetch();

      expect(budgetResponse.isLeft(), true);
      verifyNever(() => mockBudgetRepository.fetch(
          startsWithDate: dateString,
          endsWithDate: dateString,
          defaultWallet: null,
          userId: userId));
    });
  });
}

BudgetResponseModel convertToResponseModel(
    List<dynamic> budgetResponseModelAsJSON) {
  /// Convert budgets from the response JSON to List<Budget>
  /// If Empty then return an empty object list
  final convertedBudgets = List<Budget>.from(budgetResponseModelAsJSON
      .map<dynamic>((dynamic model) => BudgetModel.fromJSON(model)));

  final budgetResponseModel = BudgetResponseModel(budgets: convertedBudgets);
  return budgetResponseModel;
}
