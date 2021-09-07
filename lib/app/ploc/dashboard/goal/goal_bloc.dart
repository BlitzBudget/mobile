import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:mobile_blitzbudget/core/failure/api_failure.dart';
import 'package:mobile_blitzbudget/core/failure/failure.dart';
import 'package:mobile_blitzbudget/domain/entities/goal/goal.dart';
import 'package:mobile_blitzbudget/domain/entities/goal/goal_type.dart';
import 'package:mobile_blitzbudget/domain/entities/goal/target_type.dart';

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
      : super(Empty());

  final delete_goal_usecase.DeleteGoalUseCase deleteGoalUseCase;
  final add_goal_usecase.AddGoalUseCase addGoalUseCase;
  final fetch_goal_usecase.FetchGoalUseCase fetchGoalUseCase;
  final update_goal_usecase.UpdateGoalUseCase updateGoalUseCase;

  @override
  Stream<GoalState> mapEventToState(
    GoalEvent event,
  ) async* {
    yield Loading();

    if (event is Delete) {
      final deleteResponse =
          await deleteGoalUseCase.delete(itemID: event.deleteItemId!);
      yield deleteResponse.fold(_convertToMessage, _successResponse);
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
      yield updateResponse.fold(_convertToMessage, _successResponse);
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
      yield addResponse.fold(_convertToMessage, _successResponse);
    } else if (event is Fetch) {
      final fetchResponse = await fetchGoalUseCase.fetch();
      yield fetchResponse.fold(_convertToMessage, _successResponse);
    }
  }

  GoalState _successResponse(void r) {
    return Success();
  }

  GoalState _convertToMessage(Failure failure) {
    debugPrint('Converting login failure to message ${failure.toString()} ');
    if (failure is FetchDataFailure) {
      return RedirectToLogin();
    }

    return const Error(message: constants.GENERIC_ERROR_EXCEPTION);
  }
}
