part of 'bank_account_bloc.dart';

abstract class BankAccountState extends Equatable {
  const BankAccountState();

  @override
  List<Object> get props => [];
}

class Loading extends BankAccountState {}

class Empty extends BankAccountState {}

class Success extends BankAccountState {}

class RedirectToLogin extends BankAccountState {}

class Error extends BankAccountState {
  const Error({required this.message});

  final String message;

  @override
  List<Object> get props => [message];
}
