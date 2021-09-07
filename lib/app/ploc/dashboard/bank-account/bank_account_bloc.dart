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
      : super(Empty());

  final add_bank_account_usecase.AddBankAccountUseCase addBankAccountUseCase;
  final update_bank_account_usecase.UpdateBankAccountUseCase
      updateBankAccountUseCase;
  final delete_bank_account_usecase.DeleteBankAccountUseCase
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
      final addResponse =
          await addBankAccountUseCase.add(addBankAccount: addBankAccount);

      yield addResponse.fold(_convertToMessage, _successResponse);
    } else if (event is UpdateAccountBalance) {
      final updateResponse =
          await updateBankAccountUseCase.updateAccountBalance(
              accountBalance: event.accountBalance, accountId: event.accountId);
      yield updateResponse.fold(_convertToMessage, _successResponse);
    } else if (event is UpdateBankAccountName) {
      final updateResponse =
          await updateBankAccountUseCase.updateBankAccountName(
              bankAccountName: event.bankAccountName,
              accountId: event.accountId);
      yield updateResponse.fold(_convertToMessage, _successResponse);
    } else if (event is UpdateSelectedAccount) {
      final updateResponse =
          await updateBankAccountUseCase.updateSelectedAccount(
              selectedAccount: event.selectedAccount,
              accountId: event.accountId);
      yield updateResponse.fold(_convertToMessage, _successResponse);
    } else if (event is Delete) {
      final deleteResponse =
          await deleteBankAccountUseCase.delete(itemId: event.deleteItemId!);
      yield deleteResponse.fold(_convertToMessage, _successResponse);
    }
  }

  BankAccountState _successResponse(void r) {
    return Success();
  }

  BankAccountState _convertToMessage(Failure failure) {
    debugPrint('Converting login failure to message ${failure.toString()} ');
    if (failure is FetchDataFailure) {
      return RedirectToLogin();
    }

    return const Error(message: constants.GENERIC_ERROR_EXCEPTION);
  }
}
