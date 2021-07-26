part of 'goal_bloc.dart';

abstract class GoalEvent extends Equatable {
  const GoalEvent(
      {this.deleteItemId,
      this.walletId,
      this.goalId,
      this.goalType,
      this.targetType,
      this.monthlyContribution,
      this.targetAmount,
      this.targetDate,
      this.targetId});

  final String? deleteItemId;
  final String? walletId;
  final String? goalId;
  final GoalType? goalType;
  final TargetType? targetType;
  final double? monthlyContribution;
  final double? targetAmount;
  final String? targetDate;
  final String? targetId;

  @override
  List<Object> get props => [];
}

class Add extends GoalEvent {
  const Add(
      {final String? walletId,
      final String? goalId,
      final GoalType? goalType,
      final TargetType? targetType,
      final double? monthlyContribution,
      final double? targetAmount,
      final String? targetDate,
      final String? targetId})
      : super(
            walletId: walletId,
            goalId: goalId,
            goalType: goalType,
            targetType: targetType,
            monthlyContribution: monthlyContribution,
            targetAmount: targetAmount,
            targetDate: targetDate,
            targetId: targetId);
}

class Update extends GoalEvent {
  const Update(
      {final String? walletId,
      final String? goalId,
      final GoalType? goalType,
      final TargetType? targetType,
      final double? monthlyContribution,
      final double? targetAmount,
      final String? targetDate,
      final String? targetId})
      : super(
            walletId: walletId,
            goalId: goalId,
            goalType: goalType,
            targetType: targetType,
            monthlyContribution: monthlyContribution,
            targetAmount: targetAmount,
            targetDate: targetDate,
            targetId: targetId);
}

class Delete extends GoalEvent {
  const Delete({final String? deleteItemId})
      : super(deleteItemId: deleteItemId);
}

class Fetch extends GoalEvent {}
