part of 'goal_bloc.dart';

abstract class GoalEvent extends Equatable {
  const GoalEvent(this.deleteItemId);

  final String? deleteItemId;

  @override
  List<Object> get props => [];
}
