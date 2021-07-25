part of 'bank_account_bloc.dart';

abstract class BankAccountState extends Equatable {
  const BankAccountState();

  @override
  List<Object> get props => [];
}

class Loading extends BankAccountState {}

class Empty extends BankAccountState {}

class Add extends BankAccountState {}

class Delete extends BankAccountState {}

class UpdateAccountBalance extends BankAccountState {}

class UpdateBankAccountName extends BankAccountState {}

class UpdateSelectedAccount extends BankAccountState {}
