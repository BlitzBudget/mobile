import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'goal_event.dart';
part 'goal_state.dart';

class GoalBloc extends Bloc<GoalEvent, GoalState> {
  GoalBloc() : super(GoalInitial());

  @override
  Stream<GoalState> mapEventToState(
    GoalEvent event,
  ) async* {
    // TODO: implement mapEventToState
  }
}
