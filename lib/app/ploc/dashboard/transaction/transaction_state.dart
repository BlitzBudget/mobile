part of 'transaction_bloc.dart';

abstract class TransactionState extends Equatable {
  const TransactionState();

  @override
  List<Object> get props => [];
}

class Loading extends TransactionState {}

class Empty extends TransactionState {}
