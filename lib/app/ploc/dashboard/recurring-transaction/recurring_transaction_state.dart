part of 'recurring_transaction_bloc.dart';

abstract class RecurringTransactionState extends Equatable {
  const RecurringTransactionState();

  @override
  List<Object> get props => [];
}

class Loading extends RecurringTransactionState {}

class Empty extends RecurringTransactionState {}

class Error extends RecurringTransactionState {
  const Error({required this.message});

  final String message;

  @override
  List<Object> get props => [message];
}
