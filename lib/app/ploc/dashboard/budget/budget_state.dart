part of 'budget_bloc.dart';

abstract class BudgetState extends Equatable {
  const BudgetState();

  @override
  List<Object> get props => [];
}

class Loading extends BudgetState {}

class Empty extends BudgetState {}

class Error extends BudgetState {
  const Error({required this.message});

  final String message;

  @override
  List<Object> get props => [message];
}
