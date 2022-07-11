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

import 'bank_account_constants.dart' as constants;

part 'bank_account_event.dart';
part 'bank_account_state.dart';

class BankAccountBloc extends Bloc<BankAccountEvent, BankAccountState> {
  BankAccountBloc(
      {required this.addBankAccountUseCase,
      required this.updateBankAccountUseCase,
      required this.deleteBankAccountUseCase})
      : super(Empty()) {
    on<Add>(_onAdd);
    on<UpdateAccountBalance>(_onUpdateAccountBalance);
    on<UpdateBankAccountName>(_onUpdateBankAccountName);
    on<UpdateSelectedAccount>(_onUpdateSelectedAccount);
    on<Delete>(_onDelete);
  }

  final add_bank_account_usecase.AddBankAccountUseCase addBankAccountUseCase;
  final update_bank_account_usecase.UpdateBankAccountUseCase
      updateBankAccountUseCase;
  final delete_bank_account_usecase.DeleteBankAccountUseCase
      deleteBankAccountUseCase;

  FutureOr<void> _onAdd(Add event, Emitter<BankAccountState> emit) async {
    emit(Loading());
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

    emit(addResponse.fold(_convertToMessage, _successResponse));
  }

  FutureOr<void> _onUpdateAccountBalance(
      UpdateAccountBalance event, Emitter<BankAccountState> emit) async {
    emit(Loading());
    final updateResponse = await updateBankAccountUseCase.updateAccountBalance(
        accountBalance: event.accountBalance, accountId: event.accountId);
    emit(updateResponse.fold(_convertToMessage, _successResponse));
  }

  FutureOr<void> _onUpdateBankAccountName(
      UpdateBankAccountName event, Emitter<BankAccountState> emit) async {
    emit(Loading());
    final updateResponse = await updateBankAccountUseCase.updateBankAccountName(
        bankAccountName: event.bankAccountName, accountId: event.accountId);
    emit(updateResponse.fold(_convertToMessage, _successResponse));
  }

  FutureOr<void> _onUpdateSelectedAccount(
      UpdateSelectedAccount event, Emitter<BankAccountState> emit) async {
    emit(Loading());
    final updateResponse = await updateBankAccountUseCase.updateSelectedAccount(
        selectedAccount: event.selectedAccount, accountId: event.accountId);
    emit(updateResponse.fold(_convertToMessage, _successResponse));
  }

  FutureOr<void> _onDelete(Delete event, Emitter<BankAccountState> emit) async {
    emit(Loading());
    final deleteResponse =
        await deleteBankAccountUseCase.delete(itemId: event.deleteItemId!);
    emit(deleteResponse.fold(_convertToMessage, _successResponse));
  }

  BankAccountState _successResponse(void r) {
    return Success();
  }

  BankAccountState _convertToMessage(Failure failure) {
    debugPrint(
        'Converting bank account failure to message ${failure.toString()} ');
    if (failure is FetchDataFailure) {
      return RedirectToLogin();
    }

    return const Error(message: constants.GENERIC_ERROR_EXCEPTION);
  }
}
