import 'package:mobile_blitzbudget/data/utils/data_utils.dart';
import 'package:mobile_blitzbudget/domain/entities/goal/goal.dart';

class GoalModel extends Goal {
  // Mandatory wallet ID
  const GoalModel({
    String? walletId,
    String? goalId,
    double? currentAmount,
    double? targetAmount,
    String? targetDate,
    String? goalName,
    bool? goalAchieved,
    String? creationDate,
    String? updateDate,
  }) : super(
            walletId: walletId,
            goalId: goalId,
            targetAmount: targetAmount,
            targetDate: targetDate,
            currentAmount: currentAmount,
            goalName: goalName,
            goalAchieved: goalAchieved,
            creationDate: creationDate,
            updateDate: updateDate);

  /// Map JSON Goal to List of object
  factory GoalModel.fromJSON(Map<String, dynamic> goal) {
    return GoalModel(
        walletId: parseDynamicAsString(goal['pk']),
        goalId: parseDynamicAsString(goal['sk']),
        currentAmount: parseDynamicAsDouble(goal['current_amount']),
        goalName: parseDynamicAsString(goal['goal_name']),
        goalAchieved: parseDynamicAsBool(goal['goal_achieved']),
        targetAmount: parseDynamicAsDouble(goal['target_amount']),
        targetDate: parseDynamicAsString(goal['target_date']),
        creationDate: parseDynamicAsString(goal['creation_date']),
        updateDate: parseDynamicAsString(goal['updated_date']));
  }

  // JSON for Goal
  Map<String, dynamic> toJSON() => <String, dynamic>{
        'pk': walletId,
        'sk': goalId,
        'current_amount': currentAmount,
        'goal_name': goalName,
        'goal_achieved': goalAchieved,
        'target_amount': targetAmount,
        'target_date': targetDate
      };
}
