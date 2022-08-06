part of 'goal_bloc.dart';

abstract class GoalEvent extends Equatable {
  const GoalEvent(
      {this.deleteItemId,
      this.walletId,
      this.goalId,
      this.currentAmount,
      this.targetAmount,
      this.targetDate,
      this.goalName,
      this.goalAchieved,
      this.creationDate,
      this.updateDate});

  final String? deleteItemId;
  final String? walletId;
  final String? goalId;
  final double? currentAmount;
  final double? targetAmount;
  final String? targetDate;
  final String? goalName;
  final bool? goalAchieved;
  final String? creationDate;
  final String? updateDate;

  @override
  List<Object> get props => [];
}

class Add extends GoalEvent {
  const Add(
      {required final String? walletId,
      required final String? goalId,
      required final double? currentAmount,
      required final double? targetAmount,
      required final String? targetDate,
      required final String? goalName,
      required final bool? goalAchieved,
      required final String? creationDate,
      required final String? updateDate})
      : super(
            walletId: walletId,
            goalId: goalId,
            targetAmount: targetAmount,
            targetDate: targetDate,
            currentAmount: currentAmount,
            goalName: goalName,
            goalAchieved: goalAchieved,
            creationDate: creationDate,
            updateDate: updateDate);
}

class Update extends GoalEvent {
  const Update(
      {required final String? walletId,
      required final String? goalId,
      required final double? currentAmount,
      required final double? targetAmount,
      required final String? targetDate,
      required final String? goalName,
      required final bool? goalAchieved,
      required final String? creationDate,
      required final String? updateDate})
      : super(
            walletId: walletId,
            goalId: goalId,
            targetAmount: targetAmount,
            targetDate: targetDate,
            currentAmount: currentAmount,
            goalName: goalName,
            goalAchieved: goalAchieved,
            creationDate: creationDate,
            updateDate: updateDate);
}

class Delete extends GoalEvent {
  const Delete({required final String? deleteItemId})
      : super(deleteItemId: deleteItemId);
}

class Fetch extends GoalEvent {}
