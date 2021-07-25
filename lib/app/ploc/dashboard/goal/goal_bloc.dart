import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../../domain/usecases/dashboard/goal/delete_goal_use_case.dart'
    as delete_goal_usecase;

part 'goal_event.dart';
part 'goal_state.dart';

class GoalBloc extends Bloc<GoalEvent, GoalState> {
  GoalBloc({required this.deleteGoalUseCase}) : super(Empty());

  final delete_goal_usecase.DeleteGoalUseCase deleteGoalUseCase;

  @override
  Stream<GoalState> mapEventToState(
    GoalEvent event,
  ) async* {
    yield Loading();

    if (event is Delete) {
      await deleteGoalUseCase.delete(itemID: event.deleteItemId!);
    }
  }
}
