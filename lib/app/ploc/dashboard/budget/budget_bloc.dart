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
      : super(Empty());

  final add_budget_usecase.AddBudgetUseCase addBudgetUseCase;
  final update_budget_usecase.UpdateBudgetUseCase updateBudgetUseCase;
  final delete_budget_usecase.DeleteBudgetUseCase deleteBudgetUseCase;
  final fetch_budget_usecase.FetchBudgetUseCase fetchBudgetUseCase;

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
      final addResponse = await addBudgetUseCase.add(addBudget: addBudget);
      yield addResponse.fold(_convertToMessage, _successResponse);
    } else if (event is UpdateCategoryId) {
      final updateResponse = await updateBudgetUseCase.updateCategoryId(
          categoryId: event.categoryId, budgetId: event.budgetId);
      yield updateResponse.fold(_convertToMessage, _successResponse);
    } else if (event is UpdateDateMeantFor) {
      final updateResponse = await updateBudgetUseCase.updateDateMeantFor(
          dateMeantFor: event.dateMeantFor, budgetId: event.budgetId);
      yield updateResponse.fold(_convertToMessage, _successResponse);
    } else if (event is UpdatePlanned) {
      final updateResponse = await updateBudgetUseCase.updatePlanned(
          planned: event.planned, budgetId: event.budgetId);
      yield updateResponse.fold(_convertToMessage, _successResponse);
    } else if (event is Delete) {
      final deleteResponse =
          await deleteBudgetUseCase.delete(itemID: event.deleteItemId!);
      yield deleteResponse.fold(_convertToMessage, _successResponse);
    } else if (event is Fetch) {
      final fetchResponse = await fetchBudgetUseCase.fetch();
      yield fetchResponse.fold(_convertToMessage, _successResponse);
    }
  }

  BudgetState _successResponse(void r) {
    return Success();
  }

  BudgetState _convertToMessage(Failure failure) {
    debugPrint('Converting login failure to message ${failure.toString()} ');
    if (failure is FetchDataFailure) {
      return RedirectToLogin();
    }

    return const Error(message: constants.GENERIC_ERROR_EXCEPTION);
  }
}
