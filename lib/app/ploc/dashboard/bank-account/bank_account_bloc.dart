import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:mobile_blitzbudget/core/failure/api_failure.dart';
import 'package:mobile_blitzbudget/core/failure/failure.dart';
import 'package:mobile_blitzbudget/domain/entities/bank-account/account_sub_type.dart';
import 'package:mobile_blitzbudget/domain/entities/bank-account/account_type.dart';
import 'package:mobile_blitzbudget/domain/entities/bank-account/bank_account.dart';

import '../../../../domain/usecases/dashboard/bank-account/add_bank_account_use_case.dart'
    as add_bank_account_usecase;
import '../../../../domain/usecases/dashboard/bank-account/delete_bank_account_use_case.dart'
    as delete_bank_account_usecase;
import '../../../../domain/usecases/dashboard/bank-account/update_bank_account_use_case.dart'
    as update_bank_account_usecase;
import '../../../../domain/usecases/dashboard/common/clear_all_storage_use_case.dart'
    as clear_all_storage_usecase;
import 'bank_account_constants.dart' as constants;

part 'bank_account_event.dart';
part 'bank_account_state.dart';

class BankAccountBloc extends Bloc<BankAccountEvent, BankAccountState> {
  BankAccountBloc(
      {required this.addBankAccountUseCase,
      required this.updateBankAccountUseCase,
      required this.deleteBankAccountUseCase,
      required this.clearAllStorageUseCase})
      : super(Empty());

  final add_bank_account_usecase.AddBankAccountUseCase addBankAccountUseCase;
  final update_bank_account_usecase.UpdateBankAccountUseCase
      updateBankAccountUseCase;
  final delete_bank_account_usecase.DeleteBankAccountUseCase
      deleteBankAccountUseCase;
  final clear_all_storage_usecase.ClearAllStorageUseCase clearAllStorageUseCase;

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
      final addResponse =
          await addBankAccountUseCase.add(addBankAccount: addBankAccount);

      addResponse.fold((_) => _convertToMessage, (_) => _successResponse);
    } else if (event is UpdateAccountBalance) {
      final updateResponse =
          await updateBankAccountUseCase.updateAccountBalance(
              accountBalance: event.accountBalance, accountId: event.accountId);
      updateResponse.fold((_) => _convertToMessage, (_) => _successResponse);
    } else if (event is UpdateBankAccountName) {
      final updateResponse =
          await updateBankAccountUseCase.updateBankAccountName(
              bankAccountName: event.bankAccountName,
              accountId: event.accountId);
      updateResponse.fold((_) => _convertToMessage, (_) => _successResponse);
    } else if (event is UpdateSelectedAccount) {
      final updateResponse =
          await updateBankAccountUseCase.updateSelectedAccount(
              selectedAccount: event.selectedAccount,
              accountId: event.accountId);
      updateResponse.fold((_) => _convertToMessage, (_) => _successResponse);
    } else if (event is Delete) {
      final deleteResponse =
          await deleteBankAccountUseCase.delete(itemId: event.deleteItemId!);
      deleteResponse.fold((_) => _convertToMessage, (_) => _successResponse);
    }
  }

  Stream<BankAccountState> _successResponse(void r) async* {
    yield Success();
  }

  Stream<BankAccountState> _convertToMessage(Failure failure) async* {
    debugPrint('Converting login failure to message ${failure.toString()} ');
    if (failure is FetchDataFailure) {
      await clearAllStorageUseCase.delete();
      yield RedirectToLogin();
    }

    yield const Error(message: constants.GENERIC_ERROR_EXCEPTION);
  }
}
