import 'package:mobile_blitzbudget/data/utils/data_utils.dart';
import 'package:mobile_blitzbudget/domain/entities/goal/goal.dart';
import 'package:mobile_blitzbudget/domain/entities/goal/goal_type.dart';
import 'package:mobile_blitzbudget/domain/entities/goal/target_type.dart';

class GoalModel extends Goal {
  // Mandatory wallet ID
  GoalModel({
    String walletId,
    String goalId,
    GoalType goalType,
    TargetType targetType,
    double monthlyContribution,
    double targetAmount,
    String targetDate,
    String targetId,
  }) : super();

  /// Map JSON Goal to List of object
  factory GoalModel.fromJSON(Map<String, dynamic> goal) {
    return GoalModel(
        walletId: parseDynamicToString(goal['userId']),
        goalId: parseDynamicToString(goal['goalId']),
        goalType: parseDynamicToGoalType(goal['goal_type']),
        targetType: parseDynamicToTargetType(goal['target_type']),
        monthlyContribution: parseDynamicToDouble(goal['monthly_contribution']),
        targetAmount: parseDynamicToDouble(goal['final_amount']),
        targetDate: parseDynamicToString(goal['preferable_target_date']),
        targetId: parseDynamicToString(goal['target_id']));
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

  /// Parse dynamic to Goal Type
  static GoalType parseDynamicToGoalType(dynamic obj) {
    if (obj is GoalType) {
      return obj;
    }
    return null;
  }

  /// Parse dynamic to Target Type
  static TargetType parseDynamicToTargetType(dynamic obj) {
    if (obj is TargetType) {
      return obj;
    }
    return null;
  }
}
