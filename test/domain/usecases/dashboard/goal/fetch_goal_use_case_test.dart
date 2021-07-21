import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_blitzbudget/core/failure/api_failure.dart';
import 'package:mobile_blitzbudget/core/failure/failure.dart';
import 'package:mobile_blitzbudget/data/model/bank-account/bank_account_model.dart';
import 'package:mobile_blitzbudget/data/model/date_model.dart';
import 'package:mobile_blitzbudget/data/model/goal/goal_model.dart';
import 'package:mobile_blitzbudget/data/model/response/dashboard/goal_response_model.dart';
import 'package:mobile_blitzbudget/data/model/wallet/wallet_model.dart';
import 'package:mobile_blitzbudget/domain/entities/bank-account/bank_account.dart';
import 'package:mobile_blitzbudget/domain/entities/date.dart';
import 'package:mobile_blitzbudget/domain/entities/goal/goal.dart';
import 'package:mobile_blitzbudget/domain/entities/response/goal_response.dart';
import 'package:mobile_blitzbudget/domain/entities/user.dart';
import 'package:mobile_blitzbudget/domain/entities/wallet/wallet.dart';
import 'package:mobile_blitzbudget/domain/repositories/authentication/user_attributes_repository.dart';
import 'package:mobile_blitzbudget/domain/repositories/dashboard/common/default_wallet_repository.dart';
import 'package:mobile_blitzbudget/domain/repositories/dashboard/common/ends_with_date_repository.dart';
import 'package:mobile_blitzbudget/domain/repositories/dashboard/common/starts_with_date_repository.dart';
import 'package:mobile_blitzbudget/domain/repositories/dashboard/goal_repository.dart';
import 'package:mobile_blitzbudget/domain/usecases/dashboard/goal/fetch_goal_use_case.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../fixtures/fixture_reader.dart';

class MockGoalRepository extends Mock implements GoalRepository {}

class MockDefaultWalletRepository extends Mock
    implements DefaultWalletRepository {}

class MockEndsWithDateRepository extends Mock
    implements EndsWithDateRepository {}

class MockStartsWithDateRepository extends Mock
    implements StartsWithDateRepository {}

class MockUserAttributesRepository extends Mock
    implements UserAttributesRepository {}

void main() {
  late FetchGoalUseCase fetchGoalUseCase;
  MockGoalRepository? mockGoalRepository;
  MockDefaultWalletRepository? mockDefaultWalletRepository;
  MockEndsWithDateRepository? mockEndsWithDateRepository;
  MockStartsWithDateRepository? mockStartsWithDateRepository;
  MockUserAttributesRepository? mockUserAttributesRepository;

  final goalResponseModelAsString =
      fixture('responses/dashboard/goal/fetch_goal_info.json');
  final goalResponseModelAsJSON = jsonDecode(goalResponseModelAsString);

  /// Convert goals from the response JSON to List<Goal>
  /// If Empty then return an empty object list
  final goalResponseModel = convertToResponseModel(goalResponseModelAsJSON);

  setUp(() {
    mockGoalRepository = MockGoalRepository();
    mockDefaultWalletRepository = MockDefaultWalletRepository();
    mockEndsWithDateRepository = MockEndsWithDateRepository();
    mockStartsWithDateRepository = MockStartsWithDateRepository();
    mockUserAttributesRepository = MockUserAttributesRepository();
    fetchGoalUseCase = FetchGoalUseCase(
        goalRepository: mockGoalRepository,
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
      final Either<Failure, String> dateStringMonad =
          Right<Failure, String>(dateString);

      when(() => mockDefaultWalletRepository!.readDefaultWallet())
          .thenAnswer((_) => Future.value(dateStringMonad));
      when(() => mockEndsWithDateRepository!.readEndsWithDate())
          .thenAnswer((_) => Future.value(dateString));
      when(() => mockStartsWithDateRepository!.readStartsWithDate())
          .thenAnswer((_) => Future.value(dateString));
      final Either<Failure, GoalResponse> fetchGoalMonad =
          Right<Failure, GoalResponse>(goalResponseModel);

      when(() => mockGoalRepository!.fetch(
          startsWithDate: dateString,
          endsWithDate: dateString,
          defaultWallet: dateString,
          userId: null)).thenAnswer((_) => Future.value(fetchGoalMonad));

      final goalResponse = await fetchGoalUseCase.fetch();

      expect(goalResponse.isRight(), true);
      verify(() => mockGoalRepository!.fetch(
          startsWithDate: dateString,
          endsWithDate: dateString,
          defaultWallet: dateString,
          userId: null));
    });

    test('Default Wallet Empty: Failure', () async {
      const user = User(userId: userId);
      const Either<Failure, User> userMonad = Right<Failure, User>(user);
      final Either<Failure, String> dateFailure =
          Left<Failure, String>(FetchDataFailure());

      when(() => mockDefaultWalletRepository!.readDefaultWallet())
          .thenAnswer((_) => Future.value(dateFailure));
      when(() => mockEndsWithDateRepository!.readEndsWithDate())
          .thenAnswer((_) => Future.value(dateString));
      when(() => mockStartsWithDateRepository!.readStartsWithDate())
          .thenAnswer((_) => Future.value(dateString));
      when(() => mockUserAttributesRepository!.readUserAttributes())
          .thenAnswer((_) => Future.value(userMonad));
      final Either<Failure, GoalResponse> fetchGoalMonad =
          Right<Failure, GoalResponse>(goalResponseModel);

      when(() => mockGoalRepository!.fetch(
          startsWithDate: dateString,
          endsWithDate: dateString,
          defaultWallet: null,
          userId: userId)).thenAnswer((_) => Future.value(fetchGoalMonad));

      final goalResponse = await fetchGoalUseCase.fetch();

      expect(goalResponse.isRight(), true);
      verify(() => mockGoalRepository!.fetch(
          startsWithDate: dateString,
          endsWithDate: dateString,
          defaultWallet: null,
          userId: userId));
    });

    test('Default Wallet Empty && User Attribute Failure: Failure', () async {
      final Either<Failure, String> dateFailure =
          Left<Failure, String>(FetchDataFailure());
      final Either<Failure, User> userFailure =
          Left<Failure, User>(FetchDataFailure());

      when(() => mockDefaultWalletRepository!.readDefaultWallet())
          .thenAnswer((_) => Future.value(dateFailure));
      when(() => mockEndsWithDateRepository!.readEndsWithDate())
          .thenAnswer((_) => Future.value(dateString));
      when(() => mockStartsWithDateRepository!.readStartsWithDate())
          .thenAnswer((_) => Future.value(dateString));
      when(() => mockUserAttributesRepository!.readUserAttributes())
          .thenAnswer((_) => Future.value(userFailure));

      final goalResponse = await fetchGoalUseCase.fetch();

      expect(goalResponse.isLeft(), true);
      verifyNever(() => mockGoalRepository!.fetch(
          startsWithDate: dateString,
          endsWithDate: dateString,
          defaultWallet: null,
          userId: userId));
    });
  });
}

GoalResponseModel convertToResponseModel(
    Map<String, dynamic> goalResponseModelAsJSON) {
  /// Convert goals from the response JSON to List<Goal>
  /// If Empty then return an empty object list
  final responseGoals = goalResponseModelAsJSON['Goal'];
  final convertedGoals = List<Goal>.from(responseGoals
          ?.map<dynamic>((dynamic model) => GoalModel.fromJSON(model)) ??
      <Goal>[]);

  /// Convert BankAccount from the response JSON to List<BankAccount>
  /// If Empty then return an empty object list
  final responseBankAccounts = goalResponseModelAsJSON['BankAccount'];
  final convertedBankAccounts = List<BankAccount>.from(responseBankAccounts
          ?.map<dynamic>((dynamic model) => BankAccountModel.fromJSON(model)) ??
      <BankAccount>[]);

  /// Convert Dates from the response JSON to List<Date>
  /// If Empty then return an empty object list
  final responseDate = goalResponseModelAsJSON['Date'];
  final convertedDates = List<Date>.from(responseDate
          ?.map<dynamic>((dynamic model) => DateModel.fromJSON(model)) ??
      <Date>[]);

  final responseWallet = goalResponseModelAsJSON['Wallet'];
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

  final goalResponseModel = GoalResponseModel(
      goals: convertedGoals,
      bankAccounts: convertedBankAccounts,
      dates: convertedDates,
      wallet: convertedWallet);
  return goalResponseModel;
}
