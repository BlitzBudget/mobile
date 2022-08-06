import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_blitzbudget/core/failure/api_failure.dart';
import 'package:mobile_blitzbudget/core/failure/failure.dart';
import 'package:mobile_blitzbudget/data/model/response/dashboard/wallet_response_model.dart';
import 'package:mobile_blitzbudget/data/model/wallet/wallet_model.dart';
import 'package:mobile_blitzbudget/domain/entities/user.dart';
import 'package:mobile_blitzbudget/domain/entities/wallet/wallet.dart';
import 'package:mobile_blitzbudget/domain/repositories/authentication/user_attributes_repository.dart';
import 'package:mobile_blitzbudget/domain/repositories/dashboard/common/default_wallet_repository.dart';
import 'package:mobile_blitzbudget/domain/repositories/dashboard/common/ends_with_date_repository.dart';
import 'package:mobile_blitzbudget/domain/repositories/dashboard/common/starts_with_date_repository.dart';
import 'package:mobile_blitzbudget/domain/repositories/dashboard/wallet_repository.dart';
import 'package:mobile_blitzbudget/domain/usecases/dashboard/wallet/fetch_wallet_use_case.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../fixtures/fixture_reader.dart';

class MockWalletRepository extends Mock implements WalletRepository {}

class MockDefaultWalletRepository extends Mock
    implements DefaultWalletRepository {}

class MockEndsWithDateRepository extends Mock
    implements EndsWithDateRepository {}

class MockStartsWithDateRepository extends Mock
    implements StartsWithDateRepository {}

class MockUserAttributesRepository extends Mock
    implements UserAttributesRepository {}

void main() {
  late FetchWalletUseCase fetchWalletUseCase;
  MockWalletRepository? mockWalletRepository;
  MockDefaultWalletRepository? mockDefaultWalletRepository;
  MockEndsWithDateRepository? mockEndsWithDateRepository;
  MockStartsWithDateRepository? mockStartsWithDateRepository;
  MockUserAttributesRepository? mockUserAttributesRepository;

  final walletResponseModelAsString =
      fixture('responses/dashboard/wallet/fetch_wallet_info.json');
  final walletResponseModelAsJSON = jsonDecode(walletResponseModelAsString);

  /// Convert wallets from the response JSON to List<Wallet>
  /// If Empty then return an empty object list
  final walletResponseModel = convertToResponseModel(walletResponseModelAsJSON);

  setUp(() {
    mockWalletRepository = MockWalletRepository();
    mockDefaultWalletRepository = MockDefaultWalletRepository();
    mockEndsWithDateRepository = MockEndsWithDateRepository();
    mockStartsWithDateRepository = MockStartsWithDateRepository();
    mockUserAttributesRepository = MockUserAttributesRepository();
    fetchWalletUseCase = FetchWalletUseCase(
        walletRepository: mockWalletRepository,
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
      final Either<Failure, List<Wallet>?> fetchWalletMonad =
          Right<Failure, List<Wallet>?>(walletResponseModel.wallets);

      when(() => mockWalletRepository!.fetch(
          startsWithDate: dateString,
          endsWithDate: dateString,
          defaultWallet: dateString,
          userId: null)).thenAnswer((_) => Future.value(fetchWalletMonad));

      final walletResponse = await fetchWalletUseCase.fetch();

      expect(walletResponse.isRight(), true);
      verify(() => mockWalletRepository!.fetch(
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
      final Either<Failure, List<Wallet>?> fetchWalletMonad =
          Right<Failure, List<Wallet>?>(walletResponseModel.wallets);

      when(() => mockWalletRepository!.fetch(
          startsWithDate: dateString,
          endsWithDate: dateString,
          defaultWallet: null,
          userId: userId)).thenAnswer((_) => Future.value(fetchWalletMonad));

      final walletResponse = await fetchWalletUseCase.fetch();

      expect(walletResponse.isRight(), true);
      verify(() => mockWalletRepository!.fetch(
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

      final walletResponse = await fetchWalletUseCase.fetch();

      expect(walletResponse.isLeft(), true);
      verifyNever(() => mockWalletRepository!.fetch(
          startsWithDate: dateString,
          endsWithDate: dateString,
          defaultWallet: null,
          userId: userId));
    });
  });
}

WalletResponseModel convertToResponseModel(
    List<dynamic> walletResponseModelAsJSON) {
  /// Convert wallets from the response JSON to List<Wallet>
  /// If Empty then return an empty object list
  final convertedWallets = List<Wallet>.from(walletResponseModelAsJSON
      .map<dynamic>((dynamic model) => WalletModel.fromJSON(model)));

  final walletResponseModel = WalletResponseModel(wallets: convertedWallets);
  return walletResponseModel;
}
