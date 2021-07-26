part of 'goal_bloc.dart';

abstract class GoalState extends Equatable {
  const GoalState();

  @override
  List<Object> get props => [];
}

class Loading extends GoalState {}

class Empty extends GoalState {}

class Error extends GoalState {
  const Error({required this.message});

  final String message;

  @override
  List<Object> get props => [message];
}
