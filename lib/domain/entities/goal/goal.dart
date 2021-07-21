import 'package:equatable/equatable.dart';

import 'goal_type.dart';
import 'target_type.dart';

class Goal extends Equatable {
  // Mandatory wallet ID
  const Goal(
      {this.walletId,
      this.goalId,
      this.goalType,
      this.targetType,
      this.monthlyContribution,
      this.targetAmount,
      this.targetDate,
      this.targetId});

  final String? walletId;
  final String? goalId;
  final GoalType? goalType;
  final TargetType? targetType;
  final double? monthlyContribution;
  final double? targetAmount;
  final String? targetDate;
  final String? targetId;

  @override
  List<Object?> get props => [
        walletId,
        goalId,
        goalType,
        targetType,
        monthlyContribution,
        targetAmount,
        targetDate,
        targetId
      ];
}
