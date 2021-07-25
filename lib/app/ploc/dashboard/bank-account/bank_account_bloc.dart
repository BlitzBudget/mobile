import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:mobile_blitzbudget/domain/entities/bank-account/account_sub_type.dart';
import 'package:mobile_blitzbudget/domain/entities/bank-account/account_type.dart';
import 'package:mobile_blitzbudget/domain/entities/bank-account/bank_account.dart';

import '../../../../domain/usecases/dashboard/bank-account/add_bank_account_use_case.dart'
    as add_bank_account_usecase;
import '../../../../domain/usecases/dashboard/bank-account/delete_bank_account_use_case.dart'
    as delete_bank_account_usecase;
import '../../../../domain/usecases/dashboard/bank-account/update_bank_account_use_case.dart'
    as update_bank_account_usecase;

part 'bank_account_event.dart';
part 'bank_account_state.dart';

class BankAccountBloc extends Bloc<BankAccountEvent, BankAccountState> {
  BankAccountBloc() : super(Empty());

  late final add_bank_account_usecase.AddBankAccountUseCase
      addBankAccountUseCase;
  late final update_bank_account_usecase.UpdateBankAccountUseCase
      updateBankAccountUseCase;
  late final delete_bank_account_usecase.DeleteBankAccountUseCase
      deleteBankAccountUseCase;

  @override
  Stream<BankAccountState> mapEventToState(
    BankAccountEvent event,
  ) async* {
    yield Loading();

    if (event is Add) {
      final addBankAccount = BankAccount(
          accountBalance: event.accountBalance,
          accountId: event.accountId,
          walletId: event.walletId,
          bankAccountName: event.bankAccountName,
          selectedAccount: event.selectedAccount,
          linked: event.linked,
          accountSubType: event.accountSubType,
          accountType: event.accountType);
      await addBankAccountUseCase.add(addBankAccount: addBankAccount);
    } else if (event is UpdateAccountBalance) {
      await updateBankAccountUseCase.updateAccountBalance(
          accountBalance: event.accountBalance, accountId: event.accountId);
    } else if (event is UpdateBankAccountName) {
      await updateBankAccountUseCase.updateBankAccountName(
          bankAccountName: event.bankAccountName, accountId: event.accountId);
    } else if (event is UpdateSelectedAccount) {
      await updateBankAccountUseCase.updateSelectedAccount(
          selectedAccount: event.selectedAccount, accountId: event.accountId);
    } else if (event is Delete) {
      await deleteBankAccountUseCase.delete(itemId: event.deleteItemId!);
    }
  }
}
