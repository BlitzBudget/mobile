import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_blitzbudget/app/ploc/dashboard/bank-account/bank_account_bloc.dart';
import 'package:mobile_blitzbudget/app/ploc/dashboard/bank-account/bank_account_constants.dart'
    as constants;
import 'package:mobile_blitzbudget/core/failure/api_failure.dart';
import 'package:mobile_blitzbudget/core/failure/failure.dart';
import 'package:mobile_blitzbudget/domain/entities/bank-account/account_sub_type.dart';
import 'package:mobile_blitzbudget/domain/entities/bank-account/account_type.dart';
import 'package:mobile_blitzbudget/domain/entities/bank-account/bank_account.dart';
import 'package:mobile_blitzbudget/domain/usecases/dashboard/bank-account/add_bank_account_use_case.dart'
    as add_bank_account_usecase;
import 'package:mobile_blitzbudget/domain/usecases/dashboard/bank-account/delete_bank_account_use_case.dart'
    as delete_bank_account_usecase;
import 'package:mobile_blitzbudget/domain/usecases/dashboard/bank-account/update_bank_account_use_case.dart'
    as update_bank_account_usecase;
import 'package:mobile_blitzbudget/domain/usecases/dashboard/common/clear_all_storage_use_case.dart'
    as clear_all_storage_usecase;
import 'package:mocktail/mocktail.dart';

class MockAddBankAccountUsecase extends Mock
    implements add_bank_account_usecase.AddBankAccountUseCase {}

class MockDeleteBankAccountUseCase extends Mock
    implements delete_bank_account_usecase.DeleteBankAccountUseCase {}

class MockUpdateBankAccountUseCase extends Mock
    implements update_bank_account_usecase.UpdateBankAccountUseCase {}

class MockClearAllStorageUseCase extends Mock
    implements clear_all_storage_usecase.ClearAllStorageUseCase {}

void main() {
  const ACCOUNT_ID = 'accountID';
  const WALLET_ID = 'walletID';
  const BANK_ACCOUNT_NAME = 'bankAccountName';

  late MockAddBankAccountUsecase mockAddBankAccountUsecase;
  late MockDeleteBankAccountUseCase mockDeleteBankAccountUseCase;
  late MockUpdateBankAccountUseCase mockUpdateBankAccountUseCase;
  const positiveMonadResponse = Right<Failure, void>('');
  const addBankAccount = BankAccount(
      accountBalance: 1,
      accountId: ACCOUNT_ID,
      walletId: WALLET_ID,
      bankAccountName: BANK_ACCOUNT_NAME,
      selectedAccount: true,
      linked: false,
      accountSubType: AccountSubType.assets,
      accountType: AccountType.asset);

  setUp(() {
    mockAddBankAccountUsecase = MockAddBankAccountUsecase();
    mockDeleteBankAccountUseCase = MockDeleteBankAccountUseCase();
    mockUpdateBankAccountUseCase = MockUpdateBankAccountUseCase();
  });

  group('Success: BankAccountBloc', () {
    blocTest<BankAccountBloc, BankAccountState>(
      'Emits [Success] states for add bank account success',
      build: () {
        when(() =>
                mockAddBankAccountUsecase.add(addBankAccount: addBankAccount))
            .thenAnswer((_) => Future.value(positiveMonadResponse));
        return BankAccountBloc(
            addBankAccountUseCase: mockAddBankAccountUsecase,
            deleteBankAccountUseCase: mockDeleteBankAccountUseCase,
            updateBankAccountUseCase: mockUpdateBankAccountUseCase);
      },
      act: (bloc) => bloc.add(const Add(
          accountBalance: 1,
          accountId: ACCOUNT_ID,
          walletId: WALLET_ID,
          bankAccountName: BANK_ACCOUNT_NAME,
          selectedAccount: true,
          linked: false,
          accountSubType: AccountSubType.assets,
          accountType: AccountType.asset)),
      expect: () => [Loading(), Success()],
    );

    blocTest<BankAccountBloc, BankAccountState>(
      'Emits [Success] states for update bank account balance success',
      build: () {
        when(() => mockUpdateBankAccountUseCase.updateAccountBalance(
                accountBalance: 1, accountId: ACCOUNT_ID))
            .thenAnswer((_) => Future.value(positiveMonadResponse));
        return BankAccountBloc(
            addBankAccountUseCase: mockAddBankAccountUsecase,
            deleteBankAccountUseCase: mockDeleteBankAccountUseCase,
            updateBankAccountUseCase: mockUpdateBankAccountUseCase);
      },
      act: (bloc) => bloc.add(
          const UpdateAccountBalance(accountBalance: 1, accountId: ACCOUNT_ID)),
      expect: () => [Loading(), Success()],
    );

    blocTest<BankAccountBloc, BankAccountState>(
      'Emits [Success] states for update bank account name success',
      build: () {
        when(() => mockUpdateBankAccountUseCase.updateBankAccountName(
                bankAccountName: BANK_ACCOUNT_NAME, accountId: ACCOUNT_ID))
            .thenAnswer((_) => Future.value(positiveMonadResponse));
        return BankAccountBloc(
            addBankAccountUseCase: mockAddBankAccountUsecase,
            deleteBankAccountUseCase: mockDeleteBankAccountUseCase,
            updateBankAccountUseCase: mockUpdateBankAccountUseCase);
      },
      act: (bloc) => bloc.add(const UpdateBankAccountName(
          accountId: ACCOUNT_ID, bankAccountName: BANK_ACCOUNT_NAME)),
      expect: () => [Loading(), Success()],
    );

    blocTest<BankAccountBloc, BankAccountState>(
      'Emits [Success] states for delete bank account success',
      build: () {
        when(() => mockDeleteBankAccountUseCase.delete(itemId: ACCOUNT_ID))
            .thenAnswer((_) => Future.value(positiveMonadResponse));
        return BankAccountBloc(
            addBankAccountUseCase: mockAddBankAccountUsecase,
            deleteBankAccountUseCase: mockDeleteBankAccountUseCase,
            updateBankAccountUseCase: mockUpdateBankAccountUseCase);
      },
      act: (bloc) => bloc.add(const Delete(deleteItemId: ACCOUNT_ID)),
      expect: () => [Loading(), Success()],
    );
  });

  group('Error Generic API Failure: BankAccountBloc', () {
    blocTest<BankAccountBloc, BankAccountState>(
      'Emits [Error] states for add bank account success',
      build: () {
        final failureMonadResponse = Left<Failure, void>(GenericAPIFailure());
        when(() =>
                mockAddBankAccountUsecase.add(addBankAccount: addBankAccount))
            .thenAnswer((_) => Future.value(failureMonadResponse));
        return BankAccountBloc(
            addBankAccountUseCase: mockAddBankAccountUsecase,
            deleteBankAccountUseCase: mockDeleteBankAccountUseCase,
            updateBankAccountUseCase: mockUpdateBankAccountUseCase);
      },
      act: (bloc) => bloc.add(const Add(
          accountBalance: 1,
          accountId: ACCOUNT_ID,
          walletId: WALLET_ID,
          bankAccountName: BANK_ACCOUNT_NAME,
          selectedAccount: true,
          linked: false,
          accountSubType: AccountSubType.assets,
          accountType: AccountType.asset)),
      expect: () =>
          [Loading(), const Error(message: constants.GENERIC_ERROR_EXCEPTION)],
    );

    blocTest<BankAccountBloc, BankAccountState>(
      'Emits [Error] states for update bank account balance success',
      build: () {
        final failureMonadResponse = Left<Failure, void>(GenericAPIFailure());
        when(() => mockUpdateBankAccountUseCase.updateAccountBalance(
                accountBalance: 1, accountId: ACCOUNT_ID))
            .thenAnswer((_) => Future.value(failureMonadResponse));
        return BankAccountBloc(
            addBankAccountUseCase: mockAddBankAccountUsecase,
            deleteBankAccountUseCase: mockDeleteBankAccountUseCase,
            updateBankAccountUseCase: mockUpdateBankAccountUseCase);
      },
      act: (bloc) => bloc.add(
          const UpdateAccountBalance(accountBalance: 1, accountId: ACCOUNT_ID)),
      expect: () =>
          [Loading(), const Error(message: constants.GENERIC_ERROR_EXCEPTION)],
    );

    blocTest<BankAccountBloc, BankAccountState>(
      'Emits [Error] states for update bank account name success',
      build: () {
        final failureMonadResponse = Left<Failure, void>(GenericAPIFailure());
        when(() => mockUpdateBankAccountUseCase.updateBankAccountName(
                bankAccountName: BANK_ACCOUNT_NAME, accountId: ACCOUNT_ID))
            .thenAnswer((_) => Future.value(failureMonadResponse));
        return BankAccountBloc(
            addBankAccountUseCase: mockAddBankAccountUsecase,
            deleteBankAccountUseCase: mockDeleteBankAccountUseCase,
            updateBankAccountUseCase: mockUpdateBankAccountUseCase);
      },
      act: (bloc) => bloc.add(const UpdateBankAccountName(
          accountId: ACCOUNT_ID, bankAccountName: BANK_ACCOUNT_NAME)),
      expect: () =>
          [Loading(), const Error(message: constants.GENERIC_ERROR_EXCEPTION)],
    );

    blocTest<BankAccountBloc, BankAccountState>(
      'Emits [Error] states for delete bank account success',
      build: () {
        final failureMonadResponse = Left<Failure, void>(GenericAPIFailure());
        when(() => mockDeleteBankAccountUseCase.delete(itemId: ACCOUNT_ID))
            .thenAnswer((_) => Future.value(failureMonadResponse));
        return BankAccountBloc(
            addBankAccountUseCase: mockAddBankAccountUsecase,
            deleteBankAccountUseCase: mockDeleteBankAccountUseCase,
            updateBankAccountUseCase: mockUpdateBankAccountUseCase);
      },
      act: (bloc) => bloc.add(const Delete(deleteItemId: ACCOUNT_ID)),
      expect: () =>
          [Loading(), const Error(message: constants.GENERIC_ERROR_EXCEPTION)],
    );
  });

  group('Error Fetch Data Failure: BankAccountBloc', () {
    blocTest<BankAccountBloc, BankAccountState>(
      'Emits [Error] states for add bank account success',
      build: () {
        final failureMonadResponse = Left<Failure, void>(FetchDataFailure());
        when(() =>
                mockAddBankAccountUsecase.add(addBankAccount: addBankAccount))
            .thenAnswer((_) => Future.value(failureMonadResponse));
        return BankAccountBloc(
            addBankAccountUseCase: mockAddBankAccountUsecase,
            deleteBankAccountUseCase: mockDeleteBankAccountUseCase,
            updateBankAccountUseCase: mockUpdateBankAccountUseCase);
      },
      act: (bloc) => bloc.add(const Add(
          accountBalance: 1,
          accountId: ACCOUNT_ID,
          walletId: WALLET_ID,
          bankAccountName: BANK_ACCOUNT_NAME,
          selectedAccount: true,
          linked: false,
          accountSubType: AccountSubType.assets,
          accountType: AccountType.asset)),
      expect: () => [Loading(), RedirectToLogin()],
    );

    blocTest<BankAccountBloc, BankAccountState>(
      'Emits [Error] states for update bank account balance success',
      build: () {
        final failureMonadResponse = Left<Failure, void>(FetchDataFailure());
        when(() => mockUpdateBankAccountUseCase.updateAccountBalance(
                accountBalance: 1, accountId: ACCOUNT_ID))
            .thenAnswer((_) => Future.value(failureMonadResponse));
        return BankAccountBloc(
            addBankAccountUseCase: mockAddBankAccountUsecase,
            deleteBankAccountUseCase: mockDeleteBankAccountUseCase,
            updateBankAccountUseCase: mockUpdateBankAccountUseCase);
      },
      act: (bloc) => bloc.add(
          const UpdateAccountBalance(accountBalance: 1, accountId: ACCOUNT_ID)),
      expect: () => [Loading(), RedirectToLogin()],
    );

    blocTest<BankAccountBloc, BankAccountState>(
      'Emits [Error] states for update bank account name success',
      build: () {
        final failureMonadResponse = Left<Failure, void>(FetchDataFailure());
        when(() => mockUpdateBankAccountUseCase.updateBankAccountName(
                bankAccountName: BANK_ACCOUNT_NAME, accountId: ACCOUNT_ID))
            .thenAnswer((_) => Future.value(failureMonadResponse));
        return BankAccountBloc(
            addBankAccountUseCase: mockAddBankAccountUsecase,
            deleteBankAccountUseCase: mockDeleteBankAccountUseCase,
            updateBankAccountUseCase: mockUpdateBankAccountUseCase);
      },
      act: (bloc) => bloc.add(const UpdateBankAccountName(
          accountId: ACCOUNT_ID, bankAccountName: BANK_ACCOUNT_NAME)),
      expect: () => [Loading(), RedirectToLogin()],
    );

    blocTest<BankAccountBloc, BankAccountState>(
      'Emits [Error] states for delete bank account success',
      build: () {
        final failureMonadResponse = Left<Failure, void>(FetchDataFailure());
        when(() => mockDeleteBankAccountUseCase.delete(itemId: ACCOUNT_ID))
            .thenAnswer((_) => Future.value(failureMonadResponse));
        return BankAccountBloc(
            addBankAccountUseCase: mockAddBankAccountUsecase,
            deleteBankAccountUseCase: mockDeleteBankAccountUseCase,
            updateBankAccountUseCase: mockUpdateBankAccountUseCase);
      },
      act: (bloc) => bloc.add(const Delete(deleteItemId: ACCOUNT_ID)),
      expect: () => [Loading(), RedirectToLogin()],
    );
  });
}
