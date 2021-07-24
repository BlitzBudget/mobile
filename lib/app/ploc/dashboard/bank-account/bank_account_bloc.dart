import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:mobile_blitzbudget/domain/entities/bank-account/bank_account.dart';

import '../../../../domain/usecases/dashboard/bank-account/add_bank_account_use_case.dart'
    as add_bank_account_usecase;

part 'bank_account_event.dart';
part 'bank_account_state.dart';

class BankAccountBloc extends Bloc<BankAccountEvent, BankAccountState> {
  BankAccountBloc() : super(Empty());

  late final add_bank_account_usecase.AddBankAccountUseCase
      addBankAccountUseCase;

  @override
  Stream<BankAccountState> mapEventToState(
    BankAccountEvent event,
  ) async* {
    yield Loading();

    const addBankAccount = BankAccount();

    await addBankAccountUseCase.add(addBankAccount: addBankAccount);
  }
}
