part of 'budget_bloc.dart';

abstract class BudgetEvent extends Equatable {
  const BudgetEvent(
      {this.deleteItemId,
      this.budgetId,
      this.walletId,
      this.planned,
      this.used,
      this.dateMeantFor,
      this.categoryId,
      this.categoryType});

  final String? budgetId;
  final String? walletId;
  final double? planned;
  final double? used;
  final String? dateMeantFor;
  final String? categoryId;
  final CategoryType? categoryType;
  final String? deleteItemId;

  @override
  List<Object> get props => [];
}
