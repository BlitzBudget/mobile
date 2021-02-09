import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_blitzbudget/core/failure/api_failure.dart';
import 'package:mobile_blitzbudget/core/failure/failure.dart';
import 'package:mobile_blitzbudget/core/failure/generic_failure.dart';
import 'package:mobile_blitzbudget/data/utils/data_utils.dart';
import 'package:mobile_blitzbudget/domain/entities/bank-account/bank_account.dart';
import 'package:mobile_blitzbudget/domain/repositories/dashboard/bank_account_repository.dart';
import 'package:mobile_blitzbudget/domain/repositories/dashboard/common/default_wallet_repository.dart';
import 'package:mobile_blitzbudget/domain/usecases/dashboard/bank-account/update_bank_account_use_case.dart';
import 'package:mockito/mockito.dart';

import '../../../../fixtures/fixture_reader.dart';

class MockBankAccountRepository extends Mock implements BankAccountRepository {}

class MockDefaultWalletRepository extends Mock
    implements DefaultWalletRepository {}

void main() {
  UpdateBankAccountUseCase updateBankAccountUseCase;
  MockBankAccountRepository mockBankAccountRepository;
  MockDefaultWalletRepository mockDefaultWalletRepository;

  final bankAccountModelAsString =
      fixture('models/get/bank-account/bank_account_model.json');
  final bankAccountModelAsJSON =
      jsonDecode(bankAccountModelAsString) as Map<String, dynamic>;
  final bankAccount = BankAccount(
      walletId: bankAccountModelAsJSON['walletId'] as String,
      accountId: bankAccountModelAsJSON['accountId'] as String,
      accountBalance:
          parseDynamicAsDouble(bankAccountModelAsJSON['account_balance']),
      bankAccountName: bankAccountModelAsJSON['bank_account_name'] as String,
      accountType:
          parseDynamicAsAccountType(bankAccountModelAsJSON['account_type']),
      accountSubType: parseDynamicAsAccountSubType(
          bankAccountModelAsJSON['account_sub_type']),
      selectedAccount: bankAccountModelAsJSON['selected_account'] as bool,
      linked: bankAccountModelAsJSON['linked'] as bool);

  setUp(() {
    mockBankAccountRepository = MockBankAccountRepository();
    mockDefaultWalletRepository = MockDefaultWalletRepository();
    updateBankAccountUseCase = UpdateBankAccountUseCase(
        bankAccountRepository: mockBankAccountRepository,
        defaultWalletRepository: mockDefaultWalletRepository);
  });

  group('Update', () {
    test('Success', () async {
      Either<Failure, void> updateBankAccountMonad = Right<Failure, void>('');

      when(mockBankAccountRepository.update(bankAccount))
          .thenAnswer((_) => Future.value(updateBankAccountMonad));

      final bankAccountResponse =
          await updateBankAccountUseCase.update(updateBankAccount: bankAccount);

      expect(bankAccountResponse.isRight(), true);
      verify(mockBankAccountRepository.update(bankAccount));
    });

    test('Failure', () async {
      Either<Failure, void> updateBankAccountMonad =
          Left<Failure, void>(FetchDataFailure());

      when(mockBankAccountRepository.update(bankAccount))
          .thenAnswer((_) => Future.value(updateBankAccountMonad));

      final bankAccountResponse =
          await updateBankAccountUseCase.update(updateBankAccount: bankAccount);

      expect(bankAccountResponse.isLeft(), true);
      verify(mockBankAccountRepository.update(bankAccount));
    });
  });

  group('UpdateBankAccountName', () {
    final bankAccountModel = BankAccount(
        walletId: bankAccountModelAsJSON['walletId'] as String,
        accountId: bankAccountModelAsJSON['accountId'] as String,
        bankAccountName: bankAccountModelAsJSON['bank_account_name'] as String);

    test('Success', () async {
      Either<Failure, void> updateBankAccountMonad = Right<Failure, void>('');
      Either<Failure, String> dateStringMonad =
          Right<Failure, String>(bankAccountModel.walletId);

      when(mockDefaultWalletRepository.readDefaultWallet())
          .thenAnswer((_) => Future.value(dateStringMonad));
      when(mockBankAccountRepository.update(bankAccountModel))
          .thenAnswer((_) => Future.value(updateBankAccountMonad));

      final bankAccountResponse =
          await updateBankAccountUseCase.updateBankAccountName(
              accountId: bankAccountModel.accountId,
              bankAccountName: bankAccountModel.bankAccountName);

      expect(bankAccountResponse.isRight(), true);
      verify(mockBankAccountRepository.update(bankAccountModel));
    });

    test('Failure Response: Failure', () async {
      Either<Failure, void> updateBankAccountMonad =
          Left<Failure, void>(FetchDataFailure());
      Either<Failure, String> dateStringMonad =
          Right<Failure, String>(bankAccountModel.walletId);

      when(mockDefaultWalletRepository.readDefaultWallet())
          .thenAnswer((_) => Future.value(dateStringMonad));
      when(mockBankAccountRepository.update(bankAccountModel))
          .thenAnswer((_) => Future.value(updateBankAccountMonad));

      final bankAccountResponse =
          await updateBankAccountUseCase.updateBankAccountName(
              accountId: bankAccountModel.accountId,
              bankAccountName: bankAccountModel.bankAccountName);
      final f = bankAccountResponse.fold(
          (failure) => failure, (_) => GenericFailure());

      expect(f, equals(FetchDataFailure()));
      expect(bankAccountResponse.isLeft(), true);
      verify(mockBankAccountRepository.update(bankAccountModel));
    });

    test('Read Wallet Id Failure: Failure', () async {
      Either<Failure, void> updateBankAccountMonad =
          Left<Failure, void>(FetchDataFailure());
      Either<Failure, String> dateStringMonad =
          Left<Failure, String>(FetchDataFailure());

      when(mockDefaultWalletRepository.readDefaultWallet())
          .thenAnswer((_) => Future.value(dateStringMonad));
      when(mockBankAccountRepository.update(bankAccountModel))
          .thenAnswer((_) => Future.value(updateBankAccountMonad));

      final bankAccountResponse =
          await updateBankAccountUseCase.updateBankAccountName(
              accountId: bankAccountModel.accountId,
              bankAccountName: bankAccountModel.bankAccountName);
      final f = bankAccountResponse.fold(
          (failure) => failure, (_) => GenericFailure());

      expect(f, equals(EmptyResponseFailure()));
      expect(bankAccountResponse.isLeft(), true);
      verifyNever(mockBankAccountRepository.update(bankAccountModel));
    });
  });

  group('UpdateSelectedAccount', () {
    final bankAccountModel = BankAccount(
        walletId: bankAccountModelAsJSON['walletId'] as String,
        accountId: bankAccountModelAsJSON['accountId'] as String,
        selectedAccount: bankAccountModelAsJSON['selected_account'] as bool);

    test('Success', () async {
      Either<Failure, void> updateBankAccountMonad = Right<Failure, void>('');
      Either<Failure, String> dateStringMonad =
          Right<Failure, String>(bankAccountModel.walletId);

      when(mockDefaultWalletRepository.readDefaultWallet())
          .thenAnswer((_) => Future.value(dateStringMonad));
      when(mockBankAccountRepository.update(bankAccountModel))
          .thenAnswer((_) => Future.value(updateBankAccountMonad));

      final bankAccountResponse =
          await updateBankAccountUseCase.updateSelectedAccount(
              accountId: bankAccountModel.accountId,
              selectedAccount: bankAccountModel.selectedAccount);

      expect(bankAccountResponse.isRight(), true);
      verify(mockBankAccountRepository.update(bankAccountModel));
    });

    test('Failure Response: Failure', () async {
      Either<Failure, void> updateBankAccountMonad =
          Left<Failure, void>(FetchDataFailure());
      Either<Failure, String> dateStringMonad =
          Right<Failure, String>(bankAccountModel.walletId);

      when(mockDefaultWalletRepository.readDefaultWallet())
          .thenAnswer((_) => Future.value(dateStringMonad));
      when(mockBankAccountRepository.update(bankAccountModel))
          .thenAnswer((_) => Future.value(updateBankAccountMonad));

      final bankAccountResponse =
          await updateBankAccountUseCase.updateSelectedAccount(
              accountId: bankAccountModel.accountId,
              selectedAccount: bankAccountModel.selectedAccount);
      final f = bankAccountResponse.fold(
          (failure) => failure, (_) => GenericFailure());

      expect(f, equals(FetchDataFailure()));
      expect(bankAccountResponse.isLeft(), true);
      verify(mockBankAccountRepository.update(bankAccountModel));
    });

    test('Read Wallet Id Failure: Failure', () async {
      Either<Failure, void> updateBankAccountMonad =
          Left<Failure, void>(FetchDataFailure());
      Either<Failure, String> dateStringMonad =
          Left<Failure, String>(FetchDataFailure());

      when(mockDefaultWalletRepository.readDefaultWallet())
          .thenAnswer((_) => Future.value(dateStringMonad));
      when(mockBankAccountRepository.update(bankAccountModel))
          .thenAnswer((_) => Future.value(updateBankAccountMonad));

      final bankAccountResponse =
          await updateBankAccountUseCase.updateSelectedAccount(
              accountId: bankAccountModel.accountId,
              selectedAccount: bankAccountModel.selectedAccount);
      final f = bankAccountResponse.fold(
          (failure) => failure, (_) => GenericFailure());

      expect(f, equals(EmptyResponseFailure()));
      expect(bankAccountResponse.isLeft(), true);
      verifyNever(mockBankAccountRepository.update(bankAccountModel));
    });
  });

  group('UpdateAccountBalance', () {
    final bankAccountModel = BankAccount(
        walletId: bankAccountModelAsJSON['walletId'] as String,
        accountId: bankAccountModelAsJSON['accountId'] as String,
        accountBalance:
          parseDynamicAsDouble(bankAccountModelAsJSON['account_balance']));

    test('Success', () async {
      Either<Failure, void> updateBankAccountMonad = Right<Failure, void>('');
      Either<Failure, String> dateStringMonad =
          Right<Failure, String>(bankAccountModel.walletId);

      when(mockDefaultWalletRepository.readDefaultWallet())
          .thenAnswer((_) => Future.value(dateStringMonad));
      when(mockBankAccountRepository.update(bankAccountModel))
          .thenAnswer((_) => Future.value(updateBankAccountMonad));

      final bankAccountResponse =
          await updateBankAccountUseCase.updateAccountBalance(
              accountId: bankAccountModel.accountId,
              accountBalance: bankAccountModel.accountBalance);

      expect(bankAccountResponse.isRight(), true);
      verify(mockBankAccountRepository.update(bankAccountModel));
    });

    test('Failure Response: Failure', () async {
      Either<Failure, void> updateBankAccountMonad =
          Left<Failure, void>(FetchDataFailure());
      Either<Failure, String> dateStringMonad =
          Right<Failure, String>(bankAccountModel.walletId);

      when(mockDefaultWalletRepository.readDefaultWallet())
          .thenAnswer((_) => Future.value(dateStringMonad));
      when(mockBankAccountRepository.update(bankAccountModel))
          .thenAnswer((_) => Future.value(updateBankAccountMonad));

      final bankAccountResponse =
          await updateBankAccountUseCase.updateAccountBalance(
              accountId: bankAccountModel.accountId,
              accountBalance: bankAccountModel.accountBalance);
      final f = bankAccountResponse.fold(
          (failure) => failure, (_) => GenericFailure());

      expect(f, equals(FetchDataFailure()));
      expect(bankAccountResponse.isLeft(), true);
      verify(mockBankAccountRepository.update(bankAccountModel));
    });

    test('Read Wallet Id Failure: Failure', () async {
      Either<Failure, void> updateBankAccountMonad =
          Left<Failure, void>(FetchDataFailure());
      Either<Failure, String> dateStringMonad =
          Left<Failure, String>(FetchDataFailure());

      when(mockDefaultWalletRepository.readDefaultWallet())
          .thenAnswer((_) => Future.value(dateStringMonad));
      when(mockBankAccountRepository.update(bankAccountModel))
          .thenAnswer((_) => Future.value(updateBankAccountMonad));

      final bankAccountResponse =
          await updateBankAccountUseCase.updateAccountBalance(
              accountId: bankAccountModel.accountId,
              accountBalance: bankAccountModel.accountBalance);
      final f = bankAccountResponse.fold(
          (failure) => failure, (_) => GenericFailure());

      expect(f, equals(EmptyResponseFailure()));
      expect(bankAccountResponse.isLeft(), true);
      verifyNever(mockBankAccountRepository.update(bankAccountModel));
    });
  });
}
