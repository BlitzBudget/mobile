part of 'goal_bloc.dart';

abstract class GoalState extends Equatable {
  const GoalState();
  
  @override
  List<Object> get props => [];
}

class GoalInitial extends GoalState {}
