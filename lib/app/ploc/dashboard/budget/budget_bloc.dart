import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:mobile_blitzbudget/core/failure/api_failure.dart';
import 'package:mobile_blitzbudget/core/failure/failure.dart';
import 'package:mobile_blitzbudget/domain/entities/budget/budget.dart';
import 'package:mobile_blitzbudget/domain/entities/category/category_type.dart';

import '../../../../domain/usecases/dashboard/budget/add_budget_use_case.dart'
    as add_budget_usecase;
import '../../../../domain/usecases/dashboard/budget/delete_budget_use_case.dart'
    as delete_budget_usecase;
import '../../../../domain/usecases/dashboard/budget/fetch_budget_use_case.dart'
    as fetch_budget_usecase;
import '../../../../domain/usecases/dashboard/budget/update_budget_use_case.dart'
    as update_budget_usecase;
import 'budget_constants.dart' as constants;

part 'budget_event.dart';
part 'budget_state.dart';

class BudgetBloc extends Bloc<BudgetEvent, BudgetState> {
  BudgetBloc(
      {required this.fetchBudgetUseCase,
      required this.deleteBudgetUseCase,
      required this.updateBudgetUseCase,
      required this.addBudgetUseCase})
      : super(Empty()) {
    on<Add>(_onAdd);
    on<UpdateCategoryId>(_onUpdateCategoryId);
    on<UpdatePlanned>(_onUpdatePlanned);
    on<Delete>(_onDelete);
    on<Fetch>(_onFetch);
  }

  final add_budget_usecase.AddBudgetUseCase addBudgetUseCase;
  final update_budget_usecase.UpdateBudgetUseCase updateBudgetUseCase;
  final delete_budget_usecase.DeleteBudgetUseCase deleteBudgetUseCase;
  final fetch_budget_usecase.FetchBudgetUseCase fetchBudgetUseCase;

  FutureOr<void> _onAdd(Add event, Emitter<BudgetState> emit) async {
    emit(Loading());
    final addBudget = Budget(
        walletId: event.walletId,
        planned: event.planned,
        categoryId: event.categoryId,
        budgetId: event.budgetId);
    final addResponse = await addBudgetUseCase.add(addBudget: addBudget);
    emit(addResponse.fold(_convertToMessage, _successResponse));
  }

  FutureOr<void> _onUpdateCategoryId(
      UpdateCategoryId event, Emitter<BudgetState> emit) async {
    emit(Loading());
    final updateResponse = await updateBudgetUseCase.updateCategoryId(
        categoryId: event.categoryId, budgetId: event.budgetId);
    emit(updateResponse.fold(_convertToMessage, _successResponse));
  }

  FutureOr<void> _onUpdatePlanned(
      UpdatePlanned event, Emitter<BudgetState> emit) async {
    emit(Loading());
    final updateResponse = await updateBudgetUseCase.updatePlanned(
        planned: event.planned, budgetId: event.budgetId);
    emit(updateResponse.fold(_convertToMessage, _successResponse));
  }

  FutureOr<void> _onDelete(Delete event, Emitter<BudgetState> emit) async {
    emit(Loading());
    final deleteResponse =
        await deleteBudgetUseCase.delete(itemID: event.deleteItemId!);
    emit(deleteResponse.fold(_convertToMessage, _successResponse));
  }

  FutureOr<void> _onFetch(Fetch event, Emitter<BudgetState> emit) async {
    emit(Loading());
    final fetchResponse = await fetchBudgetUseCase.fetch();
    emit(fetchResponse.fold(_convertToMessage, _successResponse));
  }

  BudgetState _successResponse(void r) {
    return Success();
  }

  BudgetState _convertToMessage(Failure failure) {
    debugPrint('Converting budget failure to message ${failure.toString()} ');
    if (failure is FetchDataFailure) {
      return RedirectToLogin();
    }

    return const Error(message: constants.GENERIC_ERROR_EXCEPTION);
  }
}
