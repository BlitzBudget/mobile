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

class Add extends BudgetEvent {
  const Add(
      {final String? budgetId,
      final String? walletId,
      final double? planned,
      final double? used,
      final String? dateMeantFor,
      final String? categoryId,
      final CategoryType? categoryType})
      : super(
          budgetId: budgetId,
          walletId: walletId,
          planned: planned,
          used: used,
          dateMeantFor: dateMeantFor,
          categoryId: categoryId,
          categoryType: categoryType,
        );
}

class UpdateCategoryId extends BudgetEvent {
  const UpdateCategoryId(
      {final String? budgetId,
      final String? walletId,
      final String? categoryId})
      : super(
          budgetId: budgetId,
          walletId: walletId,
          categoryId: categoryId,
        );
}

class UpdateDateMeantFor extends BudgetEvent {
  const UpdateDateMeantFor({
    final String? budgetId,
    final String? walletId,
    final String? dateMeantFor,
  }) : super(
          budgetId: budgetId,
          walletId: walletId,
          dateMeantFor: dateMeantFor,
        );
}

class UpdatePlanned extends BudgetEvent {
  const UpdatePlanned({
    final String? budgetId,
    final String? walletId,
    final double? planned,
  }) : super(
          budgetId: budgetId,
          walletId: walletId,
          planned: planned,
        );
}

class Update extends BudgetEvent {
  const Update(
      {final String? budgetId,
      final String? walletId,
      final double? planned,
      final double? used,
      final String? dateMeantFor,
      final String? categoryId,
      final CategoryType? categoryType})
      : super(
          budgetId: budgetId,
          walletId: walletId,
          planned: planned,
          used: used,
          dateMeantFor: dateMeantFor,
          categoryId: categoryId,
          categoryType: categoryType,
        );
}

class Delete extends BudgetEvent {
  const Delete({
    final String? deleteItemId,
  }) : super(
          deleteItemId: deleteItemId,
        );
}

class Fetch extends BudgetEvent {}
