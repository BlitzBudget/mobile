import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_blitzbudget/core/failure/api_failure.dart';
import 'package:mobile_blitzbudget/core/failure/failure.dart';
import 'package:mobile_blitzbudget/core/failure/generic_failure.dart';
import 'package:mobile_blitzbudget/domain/repositories/dashboard/bank_account_repository.dart';
import 'package:mobile_blitzbudget/domain/repositories/dashboard/common/default_wallet_repository.dart';
import 'package:mobile_blitzbudget/domain/usecases/dashboard/bank-account/delete_bank_account_use_case.dart';
import 'package:mockito/mockito.dart';

class MockBankAccountRepository extends Mock implements BankAccountRepository {}

class MockDefaultWalletRepository extends Mock
    implements DefaultWalletRepository {}

void main() {
  DeleteBankAccountUseCase deleteBankAccountUseCase;
  MockBankAccountRepository mockBankAccountRepository;
  MockDefaultWalletRepository mockDefaultWalletRepository;

  setUp(() {
    mockBankAccountRepository = MockBankAccountRepository();
    mockDefaultWalletRepository = MockDefaultWalletRepository();
    deleteBankAccountUseCase = DeleteBankAccountUseCase(
        bankAccountRepository: mockBankAccountRepository,
        defaultWalletRepository: mockDefaultWalletRepository);
  });

  group('Delete', () {
    final accountId = 'BankAccount#2021-01-06T12:51:31.215Z';
    final walletId = 'Wallet#2020-12-21T20:35:49.295Z';

    test('Success', () async {
      Either<Failure, void> addBankAccountMonad = Right<Failure, void>('');

      Either<Failure, String> defaultWalletMonad =
          Right<Failure, String>(walletId);

      when(mockDefaultWalletRepository.readDefaultWallet())
          .thenAnswer((_) => Future.value(defaultWalletMonad));
      when(mockBankAccountRepository.delete(
              walletId: walletId, account: accountId))
          .thenAnswer((_) => Future.value(addBankAccountMonad));

      final bankAccountResponse =
          await deleteBankAccountUseCase.delete(itemId: accountId);

      expect(bankAccountResponse.isRight(), true);
      verify(mockBankAccountRepository.delete(
          account: accountId, walletId: walletId));
    });

    test('Failure', () async {
      Either<Failure, String> defaultWalletMonad =
          Right<Failure, String>(walletId);
      Either<Failure, void> deleteBankAccountMonad =
          Left<Failure, void>(FetchDataFailure());

      when(mockDefaultWalletRepository.readDefaultWallet())
          .thenAnswer((_) => Future.value(defaultWalletMonad));
      when(mockBankAccountRepository.delete(
              walletId: walletId, account: accountId))
          .thenAnswer((_) => Future.value(deleteBankAccountMonad));

      final bankAccountResponse =
          await deleteBankAccountUseCase.delete(itemId: accountId);

      expect(bankAccountResponse.isLeft(), true);
      verify(mockBankAccountRepository.delete(
          account: accountId, walletId: walletId));
    });

    test('ReadDefaultWallet: Failure', () async {
      Either<Failure, String> defaultWalletMonad =
          Left<Failure, String>(EmptyResponseFailure());

      when(mockDefaultWalletRepository.readDefaultWallet())
          .thenAnswer((_) => Future.value(defaultWalletMonad));

      final bankAccountResponse =
          await deleteBankAccountUseCase.delete(itemId: accountId);

      final f =bankAccountResponse.fold((failure) => failure, (_) => GenericFailure());
      
      expect(f, EmptyResponseFailure());
      expect(bankAccountResponse.isLeft(), true);
      verifyNever(mockBankAccountRepository.delete(
          account: accountId, walletId: walletId));
    });
  });
}
