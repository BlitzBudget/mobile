part of 'goal_bloc.dart';

abstract class GoalState extends Equatable {
  const GoalState();

  @override
  List<Object> get props => [];
}

class Loading extends GoalState {}

class Empty extends GoalState {}

class Add extends GoalState {}

class Update extends GoalState {}

class Delete extends GoalState {}
