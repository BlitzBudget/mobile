import 'package:equatable/equatable.dart';
import 'package:mobile_blitzbudget/domain/entities/budget/budget.dart';

class BudgetResponse extends Equatable {
  const BudgetResponse({this.budgets});

  final List<Budget>? budgets;

  @override
  List<Object?> get props => [budgets];
}
