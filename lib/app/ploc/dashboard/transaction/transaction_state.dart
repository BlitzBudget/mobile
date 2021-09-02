part of 'transaction_bloc.dart';

abstract class TransactionState extends Equatable {
  const TransactionState();

  @override
  List<Object> get props => [];
}

class Loading extends TransactionState {}

class Empty extends TransactionState {}

class Success extends TransactionState {}

class RedirectToLogin extends TransactionState {}

class Error extends TransactionState {
  const Error({required this.message});

  final String message;

  @override
  List<Object> get props => [message];
}
