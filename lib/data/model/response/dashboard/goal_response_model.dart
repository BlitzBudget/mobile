import 'package:mobile_blitzbudget/data/model/goal/goal_model.dart';
import 'package:mobile_blitzbudget/domain/entities/goal/goal.dart';
import 'package:mobile_blitzbudget/domain/entities/response/goal_response.dart';

class GoalResponseModel extends GoalResponse {
  const GoalResponseModel({List<Goal>? goals}) : super(goals: goals);

  factory GoalResponseModel.fromJSON(List<dynamic> goalResponseModel) {
    /// Convert categories from the response JSON to List<Category>
    /// If Empty then return an empty object list
    final convertedGoals = List<Goal>.from(goalResponseModel
        .map<dynamic>((dynamic model) => GoalModel.fromJSON(model)));

    return GoalResponseModel(goals: convertedGoals);
  }
}
