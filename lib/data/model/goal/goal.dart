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
  Goal({this.walletId,
      this.goalId,
      this.goalType,
      this.targetType,
      this.monthlyContribution,
      this.targetAmount,
      this.targetDate,
      this.targetId});

  /// Map JSON Goal to List of object
  factory Goal.fromJSON(Map<String, dynamic> goal) {
    return Goal(
      walletId : goal['userId'],
    goalId = goal['goalId'],
    goalType = goal['goal_type'],
    targetType = goal['target_type'],
    monthlyContribution = goal['monthly_contribution'],
    targetAmount = goal['final_amount'],
    targetDate = goal['preferable_target_date'],
    targetId = goal['target_id']
    );
  }

  // JSON for Goal
  Map<String, dynamic> toJSON() => <String, dynamic>{
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
