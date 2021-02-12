import 'package:mobile_blitzbudget/data/utils/data_utils.dart';
import 'package:mobile_blitzbudget/domain/entities/goal/goal.dart';
import 'package:mobile_blitzbudget/domain/entities/goal/goal_type.dart';
import 'package:mobile_blitzbudget/domain/entities/goal/target_type.dart';

class GoalModel extends Goal {
  // Mandatory wallet ID
  const GoalModel({
    String walletId,
    String goalId,
    GoalType goalType,
    TargetType targetType,
    double monthlyContribution,
    double targetAmount,
    String targetDate,
    String targetId,
  }) : super(
            walletId: walletId,
            goalId: goalId,
            goalType: goalType,
            targetType: targetType,
            monthlyContribution: monthlyContribution,
            targetAmount: targetAmount,
            targetDate: targetDate,
            targetId: targetId);

  /// Map JSON Goal to List of object
  factory GoalModel.fromJSON(Map<String, dynamic> goal) {
    return GoalModel(
        walletId: parseDynamicAsString(goal['walletId']),
        goalId: parseDynamicAsString(goal['goalId']),
        goalType: parseDynamicAsGoalType(goal['goal_type']),
        targetType: parseDynamicAsTargetType(goal['target_type']),
        monthlyContribution: parseDynamicAsDouble(goal['monthly_contribution']),
        targetAmount: parseDynamicAsDouble(goal['final_amount']),
        targetDate: parseDynamicAsString(goal['preferable_target_date']),
        targetId: parseDynamicAsString(goal['target_id']));
  }

  // JSON for Goal
  Map<String, dynamic> toJSON() => <String, dynamic>{
        'walletId': walletId,
        'goalId': goalId,
        'goalType': goalType.name,
        'targetType': targetType.name,
        'monthlyContribution': monthlyContribution,
        'targetAmount': targetAmount,
        'targetDate': targetDate,
        'targetId': targetId
      };
}
