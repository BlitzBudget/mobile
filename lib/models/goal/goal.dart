import 'goal_type.dart';
import 'target_type.dart';

class Goal {
  String walletId;
  String goalId;
  GoalType goalType;
  TargetType targetType;
  double monthlyContribution;
  double targetAmount;
  String targetDate;
  String targetId;

  // Mandatory wallet ID
  Goal(this.walletId,
      {this.goalId,
      this.goalType,
      this.targetType,
      this.monthlyContribution,
      this.targetAmount,
      this.targetDate,
      this.targetId});

  // JSON for Goal
  Map<String, dynamic> toJSON() => {
        'walletId': walletId,
        'goalId': goalId,
        'goalType': goalType,
        'targetType': targetType,
        'monthlyContribution': monthlyContribution,
        'targetAmount': targetAmount,
        'targetDate': targetDate,
        'targetId': targetId
      };
}
