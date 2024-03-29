import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:mobile_blitzbudget/core/failure/api_failure.dart';
import 'package:mobile_blitzbudget/core/failure/failure.dart';
import 'package:mobile_blitzbudget/domain/entities/goal/goal.dart';

import '../../../../domain/usecases/dashboard/goal/add_goal_use_case.dart'
    as add_goal_usecase;
import '../../../../domain/usecases/dashboard/goal/delete_goal_use_case.dart'
    as delete_goal_usecase;
import '../../../../domain/usecases/dashboard/goal/fetch_goal_use_case.dart'
    as fetch_goal_usecase;
import '../../../../domain/usecases/dashboard/goal/update_goal_use_case.dart'
    as update_goal_usecase;
import 'goal_constants.dart' as constants;

part 'goal_event.dart';
part 'goal_state.dart';

class GoalBloc extends Bloc<GoalEvent, GoalState> {
  GoalBloc(
      {required this.updateGoalUseCase,
      required this.fetchGoalUseCase,
      required this.addGoalUseCase,
      required this.deleteGoalUseCase})
      : super(Empty()) {
    on<Add>(_onAdd);
    on<Update>(_onUpdate);
    on<Fetch>(_onFetch);
    on<Delete>(_onDelete);
  }

  final delete_goal_usecase.DeleteGoalUseCase deleteGoalUseCase;
  final add_goal_usecase.AddGoalUseCase addGoalUseCase;
  final fetch_goal_usecase.FetchGoalUseCase fetchGoalUseCase;
  final update_goal_usecase.UpdateGoalUseCase updateGoalUseCase;

  FutureOr<void> _onAdd(Add event, Emitter<GoalState> emit) async {
    emit(Loading());
    final addGoal = Goal(
        walletId: event.walletId,
        goalId: event.goalId,
        targetAmount: event.targetAmount,
        targetDate: event.targetDate,
        currentAmount: event.currentAmount,
        goalName: event.goalName,
        goalAchieved: event.goalAchieved,
        creationDate: event.creationDate,
        updateDate: event.updateDate);
    final addResponse = await addGoalUseCase.add(addGoal: addGoal);
    emit(addResponse.fold(_convertToMessage, _successResponse));
  }

  FutureOr<void> _onUpdate(Update event, Emitter<GoalState> emit) async {
    emit(Loading());
    final updateGoal = Goal(
        walletId: event.walletId,
        goalId: event.goalId,
        targetAmount: event.targetAmount,
        targetDate: event.targetDate,
        currentAmount: event.currentAmount,
        goalName: event.goalName,
        goalAchieved: event.goalAchieved,
        creationDate: event.creationDate,
        updateDate: event.updateDate);
    final updateResponse =
        await updateGoalUseCase.update(updateGoal: updateGoal);
    emit(updateResponse.fold(_convertToMessage, _successResponse));
  }

  FutureOr<void> _onFetch(Fetch event, Emitter<GoalState> emit) async {
    emit(Loading());
    final fetchResponse = await fetchGoalUseCase.fetch();
    emit(fetchResponse.fold(_convertToMessage, _successResponse));
  }

  FutureOr<void> _onDelete(Delete event, Emitter<GoalState> emit) async {
    emit(Loading());

    final deleteResponse =
        await deleteGoalUseCase.delete(itemID: event.deleteItemId!);
    emit(deleteResponse.fold(_convertToMessage, _successResponse));
  }

  GoalState _successResponse(void r) {
    return Success();
  }

  GoalState _convertToMessage(Failure failure) {
    debugPrint('Converting goal failure to message ${failure.toString()} ');
    if (failure is FetchDataFailure) {
      return RedirectToLogin();
    }

    return const Error(message: constants.GENERIC_ERROR_EXCEPTION);
  }
}
