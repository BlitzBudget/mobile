part of 'budget_bloc.dart';

abstract class BudgetState extends Equatable {
  const BudgetState();

  @override
  List<Object> get props => [];
}

class Loading extends BudgetState {}

class Empty extends BudgetState {}

class Add extends BudgetState {}

class UpdateCategoryId extends BudgetState {}

class UpdateDateMeantFor extends BudgetState {}

class UpdatePlanned extends BudgetState {}

class Update extends BudgetState {}

class Delete extends BudgetState {}
