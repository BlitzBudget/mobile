import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_blitzbudget/core/failure/api_failure.dart';
import 'package:mobile_blitzbudget/core/failure/failure.dart';
import 'package:mobile_blitzbudget/core/failure/generic_failure.dart';
import 'package:mobile_blitzbudget/data/model/wallet/wallet_model.dart';
import 'package:mobile_blitzbudget/data/utils/data_utils.dart';
import 'package:mobile_blitzbudget/domain/entities/wallet/wallet.dart';
import 'package:mobile_blitzbudget/domain/repositories/dashboard/common/default_wallet_repository.dart';
import 'package:mobile_blitzbudget/domain/repositories/dashboard/wallet_repository.dart';
import 'package:mobile_blitzbudget/domain/usecases/dashboard/wallet/update_wallet_use_case.dart';
import 'package:mockito/mockito.dart';

import '../../../../fixtures/fixture_reader.dart';

class MockWalletRepository extends Mock implements WalletRepository {}

class MockDefaultWalletRepository extends Mock
    implements DefaultWalletRepository {}

void main() {
  UpdateWalletUseCase updateWalletUseCase;
  MockWalletRepository mockWalletRepository;

  final walletModelAsString = fixture('models/get/wallet/wallet_model.json');
  final walletModelAsJSON =
      jsonDecode(walletModelAsString);
  final wallet = WalletModel(
      walletId: walletModelAsJSON['walletId'],
      userId: walletModelAsJSON['userId'],
      currency: parseDynamicAsString(walletModelAsJSON['currency']),
      walletName: walletModelAsJSON['wallet_name'],
      totalAssetBalance:
          parseDynamicAsDouble(walletModelAsJSON['total_asset_balance']),
      totalDebtBalance:
          parseDynamicAsDouble(walletModelAsJSON['total_debt_balance']),
      walletBalance: parseDynamicAsDouble(walletModelAsJSON['wallet_balance']));

  setUp(() {
    mockWalletRepository = MockWalletRepository();
    updateWalletUseCase =
        UpdateWalletUseCase(walletRepository: mockWalletRepository);
  });

  group('Update Wallet', () {
    test('Success', () async {
      const Either<Failure, void> updateWalletMonad = Right<Failure, void>('');

      when(mockWalletRepository.update(wallet))
          .thenAnswer((_) => Future.value(updateWalletMonad));

      final walletResponse =
          await updateWalletUseCase.update(updateWallet: wallet);

      expect(walletResponse.isRight(), true);
      verify(mockWalletRepository.update(wallet));
    });

    test('Failure', () async {
      final Either<Failure, void> updateWalletMonad =
          Left<Failure, void>(FetchDataFailure());

      when(mockWalletRepository.update(wallet))
          .thenAnswer((_) => Future.value(updateWalletMonad));

      final walletResponse =
          await updateWalletUseCase.update(updateWallet: wallet);

      expect(walletResponse.isLeft(), true);
      verify(mockWalletRepository.update(wallet));
    });
  });

  group('UpdateWalletName', () {
    final walletModel = Wallet(
        walletId: walletModelAsJSON['walletId'],
        walletName: walletModelAsJSON['bank_account_name']);

    test('Success', () async {
      const Either<Failure, void> updateWalletMonad = Right<Failure, void>('');

      when(mockWalletRepository.update(walletModel))
          .thenAnswer((_) => Future.value(updateWalletMonad));

      final walletResponse = await updateWalletUseCase.updateWalletName(
          walletId: walletModel.walletId, name: walletModel.walletName);

      expect(walletResponse.isRight(), true);
      verify(mockWalletRepository.update(walletModel));
    });

    test('Failure Response: Failure', () async {
      final Either<Failure, void> updateWalletMonad =
          Left<Failure, void>(FetchDataFailure());

      when(mockWalletRepository.update(walletModel))
          .thenAnswer((_) => Future.value(updateWalletMonad));

      final walletResponse = await updateWalletUseCase.updateWalletName(
          walletId: walletModel.walletId, name: walletModel.walletName);
      final f =
          walletResponse.fold((failure) => failure, (_) => GenericFailure());

      expect(f, equals(FetchDataFailure()));
      expect(walletResponse.isLeft(), true);
      verify(mockWalletRepository.update(walletModel));
    });
  });

  group('updateCurrency', () {
    final walletModel = Wallet(
        walletId: walletModelAsJSON['walletId'],
        currency: walletModelAsJSON['currency']);

    test('Success', () async {
      const Either<Failure, void> updateWalletMonad = Right<Failure, void>('');

      when(mockWalletRepository.update(walletModel))
          .thenAnswer((_) => Future.value(updateWalletMonad));

      final walletResponse = await updateWalletUseCase.updateCurrency(
          walletId: walletModel.walletId, currency: walletModel.currency);

      expect(walletResponse.isRight(), true);
      verify(mockWalletRepository.update(walletModel));
    });

    test('Failure Response: Failure', () async {
      final Either<Failure, void> updateWalletMonad =
          Left<Failure, void>(FetchDataFailure());

      when(mockWalletRepository.update(walletModel))
          .thenAnswer((_) => Future.value(updateWalletMonad));

      final walletResponse = await updateWalletUseCase.updateCurrency(
          walletId: walletModel.walletId, currency: walletModel.currency);
      final f =
          walletResponse.fold((failure) => failure, (_) => GenericFailure());

      expect(f, equals(FetchDataFailure()));
      expect(walletResponse.isLeft(), true);
      verify(mockWalletRepository.update(walletModel));
    });
  });
}
