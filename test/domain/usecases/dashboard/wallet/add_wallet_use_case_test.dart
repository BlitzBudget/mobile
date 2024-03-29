import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_blitzbudget/core/failure/api_failure.dart';
import 'package:mobile_blitzbudget/core/failure/failure.dart';
import 'package:mobile_blitzbudget/core/failure/generic_failure.dart';
import 'package:mobile_blitzbudget/data/model/response/dashboard/wallet_response_model.dart';
import 'package:mobile_blitzbudget/data/model/wallet/wallet_model.dart';
import 'package:mobile_blitzbudget/domain/entities/user.dart';
import 'package:mobile_blitzbudget/domain/entities/wallet/wallet.dart';
import 'package:mobile_blitzbudget/domain/repositories/authentication/user_attributes_repository.dart';
import 'package:mobile_blitzbudget/domain/repositories/dashboard/wallet_repository.dart';
import 'package:mobile_blitzbudget/domain/usecases/dashboard/wallet/add_wallet_use_case.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../fixtures/fixture_reader.dart';

class MockWalletRepository extends Mock implements WalletRepository {}

class MockUserAttributesRepository extends Mock
    implements UserAttributesRepository {}

void main() {
  late AddWalletUseCase addWalletUseCase;
  MockWalletRepository? mockWalletRepository;
  MockUserAttributesRepository? mockUserAttributesRepository;

  final walletResponseModelAsString =
      fixture('responses/dashboard/wallet/fetch_wallet_info.json');
  final walletResponseModelAsJSON = jsonDecode(walletResponseModelAsString);

  /// Convert wallets from the response JSON to List<Wallet>
  /// If Empty then return an empty object list
  final wallet = convertToResponseModel(walletResponseModelAsJSON);

  setUp(() {
    mockWalletRepository = MockWalletRepository();
    mockUserAttributesRepository = MockUserAttributesRepository();
    addWalletUseCase = AddWalletUseCase(
        walletRepository: mockWalletRepository,
        userAttributesRepository: mockUserAttributesRepository);
  });

  group('Add', () {
    final user = User(userId: wallet.wallets!.first.userId);
    final Either<Failure, User> userMonad = Right<Failure, User>(user);

    test('Success', () async {
      const Either<Failure, void> addWalletMonad = Right<Failure, void>('');

      when(() => mockUserAttributesRepository!.readUserAttributes())
          .thenAnswer((_) => Future.value(userMonad));

      when(() => mockWalletRepository!.add(
            userId: wallet.wallets!.first.userId,
            currency: wallet.wallets!.first.currency,
            name: wallet.wallets!.first.walletName,
          )).thenAnswer((_) => Future.value(addWalletMonad));

      final walletResponse = await addWalletUseCase.add(
          currency: wallet.wallets!.first.currency,
          name: wallet.wallets!.first.walletName);

      expect(walletResponse.isRight(), true);
      verify(() => mockWalletRepository!.add(
            userId: wallet.wallets!.first.userId,
            currency: wallet.wallets!.first.currency,
            name: wallet.wallets!.first.walletName,
          ));
    });

    test('Failure', () async {
      final Either<Failure, void> addWalletMonad =
          Left<Failure, void>(FetchDataFailure());

      when(() => mockUserAttributesRepository!.readUserAttributes())
          .thenAnswer((_) => Future.value(userMonad));

      when(() => mockWalletRepository!.add(
            userId: wallet.wallets!.first.userId,
            currency: wallet.wallets!.first.currency,
            name: wallet.wallets!.first.walletName,
          )).thenAnswer((_) => Future.value(addWalletMonad));

      final walletResponse = await addWalletUseCase.add(
        currency: wallet.wallets!.first.currency,
        name: wallet.wallets!.first.walletName,
      );

      expect(walletResponse.isLeft(), true);
      verify(() => mockWalletRepository!.add(
            userId: wallet.wallets!.first.userId,
            currency: wallet.wallets!.first.currency,
            name: wallet.wallets!.first.walletName,
          ));
    });

    test('User Attribute Failure', () async {
      final Either<Failure, void> addWalletMonad =
          Left<Failure, void>(FetchDataFailure());
      final Either<Failure, User> userFailure =
          Left<Failure, User>(FetchDataFailure());

      when(() => mockUserAttributesRepository!.readUserAttributes())
          .thenAnswer((_) => Future.value(userFailure));

      when(() => mockWalletRepository!.add(
            userId: wallet.wallets!.first.userId,
            currency: wallet.wallets!.first.currency,
            name: wallet.wallets!.first.walletName,
          )).thenAnswer((_) => Future.value(addWalletMonad));

      final walletResponse = await addWalletUseCase.add(
        currency: wallet.wallets!.first.currency,
        name: wallet.wallets!.first.walletName,
      );
      final f =
          walletResponse.fold((failure) => failure, (_) => GenericFailure());

      expect(f, equals(EmptyResponseFailure()));
      expect(walletResponse.isLeft(), true);
      verifyNever(() => mockWalletRepository!.add(
            userId: wallet.wallets!.first.userId,
            currency: wallet.wallets!.first.currency,
            name: wallet.wallets!.first.walletName,
          ));
    });
  });
}

WalletResponseModel convertToResponseModel(
    List<dynamic> walletResponseModelAsJSON) {
  /// Convert categories from the response JSON to List<Category>
  /// If Empty then return an empty object list
  final convertedWallet = List<Wallet>.from(walletResponseModelAsJSON
      .map<dynamic>((dynamic model) => WalletModel.fromJSON(model)));

  return WalletResponseModel(wallets: convertedWallet);
}
