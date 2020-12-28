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

  /// Map JSON Goal to List of object
  Goal.map(dynamic goal) {
    this.walletId = goal['userId'];
    this.goalId = goal['goalId'];
    this.goalType = goal['goal_type'];
    this.targetType = goal['target_type'];
    this.monthlyContribution = goal['monthly_contribution'];
    this.targetAmount = goal['final_amount'];
    this.targetDate = goal['preferable_target_date'];
    this.targetId = goal['target_id'];
  }

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
