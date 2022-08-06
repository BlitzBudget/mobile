import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_blitzbudget/data/model/goal/goal_model.dart';
import 'package:mobile_blitzbudget/data/model/response/dashboard/goal_response_model.dart';
import 'package:mobile_blitzbudget/domain/entities/goal/goal.dart';
import 'package:mobile_blitzbudget/domain/entities/response/goal_response.dart';

import '../../../../fixtures/fixture_reader.dart';

void main() {
  final goalResponseModelAsString =
      fixture('responses/dashboard/goal/fetch_goal_info.json');
  final goalResponseModelAsJSON = jsonDecode(goalResponseModelAsString);

  /// Convert goals from the response JSON to List<Goal>
  /// If Empty then return an empty object list
  final goalResponseModel = convertToResponseModel(goalResponseModelAsJSON);

  test(
    'Should be a subclass of GoalModel entity',
    () async {
      // assert
      expect(goalResponseModel, isA<GoalResponse>());
    },
  );

  group('fromJson', () {
    test('Should return a valid model when the JSON is parsed with all data',
        () async {
      final goalModelConverted =
          GoalResponseModel.fromJSON(goalResponseModelAsJSON);
      expect(goalModelConverted, equals(goalResponseModel));
    });

    test(
        'Should return a valid model when the JSON is parsed with empty goal data',
        () async {
      final goalResponseModelWithEmptyGoalAsString =
          fixture('responses/partially-emtpy/goal/empty_goal_goal_info.json');
      final goalResponseModelWithEmptyGoalAsJSON =
          jsonDecode(goalResponseModelWithEmptyGoalAsString);

      /// Convert budgets from the response JSON to List<Budget>
      /// If Empty then return an empty object list
      final goalResponseModelWithEmptyGoalConverted =
          convertToResponseModel(goalResponseModelWithEmptyGoalAsJSON);
      final goalResponseModelWithEmptyGoalFromJSON =
          GoalResponseModel.fromJSON(goalResponseModelWithEmptyGoalAsJSON);
      expect(goalResponseModelWithEmptyGoalFromJSON,
          equals(goalResponseModelWithEmptyGoalConverted));
    });
  });
}

GoalResponseModel convertToResponseModel(
    List<dynamic> goalResponseModelAsJSON) {
  /// Convert categories from the response JSON to List<Category>
  /// If Empty then return an empty object list
  final convertedGoals = List<Goal>.from(goalResponseModelAsJSON
      .map<dynamic>((dynamic model) => GoalModel.fromJSON(model)));

  return GoalResponseModel(goals: convertedGoals);
}
