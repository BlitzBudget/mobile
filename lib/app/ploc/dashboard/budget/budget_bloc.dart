import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:mobile_blitzbudget/domain/entities/budget/budget.dart';
import 'package:mobile_blitzbudget/domain/entities/category/category_type.dart';

import '../../../../domain/usecases/dashboard/budget/add_budget_use_case.dart'
    as add_budget_usecase;
import '../../../../domain/usecases/dashboard/budget/delete_budget_use_case.dart'
    as delete_budget_usecase;
import '../../../../domain/usecases/dashboard/budget/update_budget_use_case.dart'
    as update_budget_usecase;

part 'budget_event.dart';
part 'budget_state.dart';

class BudgetBloc extends Bloc<BudgetEvent, BudgetState> {
  BudgetBloc(
      {required this.deleteBudgetUseCase,
      required this.updateBudgetUseCase,
      required this.addBudgetUseCase})
      : super(Empty());

  final add_budget_usecase.AddBudgetUseCase addBudgetUseCase;
  final update_budget_usecase.UpdateBudgetUseCase updateBudgetUseCase;
  final delete_budget_usecase.DeleteBudgetUseCase deleteBudgetUseCase;

  @override
  Stream<BudgetState> mapEventToState(
    BudgetEvent event,
  ) async* {
    yield Loading();

    if (event is Add) {
      final addBudget = Budget(
          walletId: event.walletId,
          planned: event.planned,
          dateMeantFor: event.dateMeantFor,
          categoryId: event.categoryId,
          budgetId: event.budgetId,
          categoryType: event.categoryType,
          used: event.used);
      await addBudgetUseCase.add(addBudget: addBudget);
    } else if (event is Update) {
      if (event.categoryType != null) {
        final updateBudget = Budget(
            walletId: event.walletId,
            budgetId: event.budgetId,
            categoryType: event.categoryType);
        await updateBudgetUseCase.update(updateBudget: updateBudget);
      }

      if (event.used != null) {
        final updateBudget = Budget(
            walletId: event.walletId,
            budgetId: event.budgetId,
            used: event.used);
        await updateBudgetUseCase.update(updateBudget: updateBudget);
      }
    } else if (event is UpdateCategoryId) {
      await updateBudgetUseCase.updateCategoryId(
          categoryId: event.categoryId, budgetId: event.budgetId);
    } else if (event is UpdateDateMeantFor) {
      await updateBudgetUseCase.updateDateMeantFor(
          dateMeantFor: event.dateMeantFor, budgetId: event.budgetId);
    } else if (event is UpdatePlanned) {
      await updateBudgetUseCase.updatePlanned(
          planned: event.planned, budgetId: event.budgetId);
    } else if (event is Delete) {
      await deleteBudgetUseCase.delete(itemID: event.deleteItemId!);
    }
  }
}
