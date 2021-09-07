import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_blitzbudget/app/ploc/dashboard/bank-account/bank_account_bloc.dart';
import 'package:mobile_blitzbudget/core/failure/failure.dart';
import 'package:mobile_blitzbudget/domain/entities/bank-account/account_sub_type.dart';
import 'package:mobile_blitzbudget/domain/entities/bank-account/account_type.dart';
import 'package:mobile_blitzbudget/domain/entities/bank-account/bank_account.dart';
import 'package:mocktail/mocktail.dart';
import 'package:mobile_blitzbudget/domain/usecases/dashboard/bank-account/add_bank_account_use_case.dart'
    as add_bank_account_usecase;
import 'package:mobile_blitzbudget/domain/usecases/dashboard/bank-account/delete_bank_account_use_case.dart'
    as delete_bank_account_usecase;
import 'package:mobile_blitzbudget/domain/usecases/dashboard/bank-account/update_bank_account_use_case.dart'
    as update_bank_account_usecase;
import 'package:mobile_blitzbudget/domain/usecases/dashboard/common/clear_all_storage_use_case.dart'
    as clear_all_storage_usecase;

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
  late MockClearAllStorageUseCase mockClearAllStorageUseCase;
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
    mockClearAllStorageUseCase = MockClearAllStorageUseCase();
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
            clearAllStorageUseCase: mockClearAllStorageUseCase,
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
      'Emits [Success] states for update bank account name success',
      build: () {
        when(() =>
                mockUpdateBankAccountUseCase.updateBankAccountName(bankAccountName: BANK_ACCOUNT_NAME, accountId: ACCOUNT_ID))
            .thenAnswer((_) => Future.value(positiveMonadResponse));
        return BankAccountBloc(
            addBankAccountUseCase: mockAddBankAccountUsecase,
            clearAllStorageUseCase: mockClearAllStorageUseCase,
            deleteBankAccountUseCase: mockDeleteBankAccountUseCase,
            updateBankAccountUseCase: mockUpdateBankAccountUseCase);
      },
      act: (bloc) => bloc.add(const UpdateBankAccountName(accountId: ACCOUNT_ID, bankAccountName: BANK_ACCOUNT_NAME)),
      expect: () => [Loading(), Success()],
    );
  });
}
