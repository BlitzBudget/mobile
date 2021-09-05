import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:mobile_blitzbudget/core/failure/api_failure.dart';
import 'package:mobile_blitzbudget/core/failure/failure.dart';
import 'package:mobile_blitzbudget/domain/entities/goal/goal.dart';
import 'package:mobile_blitzbudget/domain/entities/goal/goal_type.dart';
import 'package:mobile_blitzbudget/domain/entities/goal/target_type.dart';

import '../../../../domain/usecases/dashboard/common/clear_all_storage_use_case.dart'
    as clear_all_storage_usecase;
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
      required this.deleteGoalUseCase,
      required this.clearAllStorageUseCase})
      : super(Empty());

  final delete_goal_usecase.DeleteGoalUseCase deleteGoalUseCase;
  final add_goal_usecase.AddGoalUseCase addGoalUseCase;
  final fetch_goal_usecase.FetchGoalUseCase fetchGoalUseCase;
  final update_goal_usecase.UpdateGoalUseCase updateGoalUseCase;
  final clear_all_storage_usecase.ClearAllStorageUseCase clearAllStorageUseCase;

  @override
  Stream<GoalState> mapEventToState(
    GoalEvent event,
  ) async* {
    yield Loading();

    if (event is Delete) {
      final deleteResponse =
          await deleteGoalUseCase.delete(itemID: event.deleteItemId!);
      deleteResponse.fold((_) => _convertToMessage, (_) => _successResponse);
    } else if (event is Update) {
      final updateGoal = Goal(
          walletId: event.walletId,
          goalId: event.goalId,
          goalType: event.goalType,
          targetType: event.targetType,
          monthlyContribution: event.monthlyContribution,
          targetAmount: event.targetAmount,
          targetDate: event.targetDate,
          targetId: event.targetId);
      final updateResponse =
          await updateGoalUseCase.update(updateGoal: updateGoal);
      updateResponse.fold((_) => _convertToMessage, (_) => _successResponse);
    } else if (event is Add) {
      final addGoal = Goal(
          walletId: event.walletId,
          goalId: event.goalId,
          goalType: event.goalType,
          targetType: event.targetType,
          monthlyContribution: event.monthlyContribution,
          targetAmount: event.targetAmount,
          targetDate: event.targetDate,
          targetId: event.targetId);
      final addResponse = await addGoalUseCase.add(addGoal: addGoal);
      addResponse.fold((_) => _convertToMessage, (_) => _successResponse);
    } else if (event is Fetch) {
      final fetchResponse = await fetchGoalUseCase.fetch();
      fetchResponse.fold((_) => _convertToMessage, (_) => _successResponse);
    }
  }

  Stream<GoalState> _successResponse(void r) async* {
    yield Success();
  }

  Stream<GoalState> _convertToMessage(Failure failure) async* {
    debugPrint('Converting login failure to message ${failure.toString()} ');
    if (failure is FetchDataFailure) {
      await clearAllStorageUseCase.delete();
      yield RedirectToLogin();
    }

    yield const Error(message: constants.GENERIC_ERROR_EXCEPTION);
  }
}