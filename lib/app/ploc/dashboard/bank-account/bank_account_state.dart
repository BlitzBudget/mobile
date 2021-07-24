part of 'bank_account_bloc.dart';

abstract class BankAccountState extends Equatable {
  const BankAccountState();

  @override
  List<Object> get props => [];
}

class Loading extends BankAccountState {}

class Empty extends BankAccountState {}
