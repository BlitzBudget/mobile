import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_blitzbudget/data/model/goal/goal_model.dart';
import 'package:mobile_blitzbudget/data/utils/data_utils.dart';
import 'package:mobile_blitzbudget/domain/entities/goal/goal.dart';

import '../../../fixtures/fixture_reader.dart';

void main() {
  final goalModelAsString =
      fixture('models/get/goal/emergency_fund_model.json');
  final goalModelAsJSON = jsonDecode(goalModelAsString);
  final goalModel = GoalModel(
      walletId: parseDynamicAsString(goalModelAsJSON['pk']),
      goalId: parseDynamicAsString(goalModelAsJSON['sk']),
      currentAmount: parseDynamicAsDouble(goalModelAsJSON['current_amount']),
      goalName: parseDynamicAsString(goalModelAsJSON['goal_name']),
      goalAchieved: parseDynamicAsBool(goalModelAsJSON['goal_achieved']),
      targetAmount: parseDynamicAsDouble(goalModelAsJSON['target_amount']),
      targetDate: parseDynamicAsString(goalModelAsJSON['target_date']),
      creationDate: parseDynamicAsString(goalModelAsJSON['creation_date']),
      updateDate: parseDynamicAsString(goalModelAsJSON['updated_date']));
  test(
    'Should be a subclass of Goal entity',
    () async {
      // assert
      expect(goalModel, isA<Goal>());
    },
  );

  group('fromJson', () {
    test('Should return a valid model when the JSON is parsed with all data',
        () async {
      final goalModelConverted = GoalModel.fromJSON(goalModelAsJSON);
      expect(goalModelConverted, equals(goalModel));
    });
  });

  group('toJson', () {
    test('Should return a JSON map containing the proper data', () async {
      final addGoalModelAsString =
          fixture('models/add/goal/emergency_fund_model.json');
      final addGoalModelAsJSON = jsonDecode(addGoalModelAsString);
      expect(goalModel.toJSON(), equals(addGoalModelAsJSON));
    });
  });
}
