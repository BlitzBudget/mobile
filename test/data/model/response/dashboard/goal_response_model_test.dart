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
        'Should return a valid model when the JSON is parsed with empty bank account data',
        () async {
      final goalResponseModelWithEmptyBankAccountAsString = fixture(
          'responses/partially-emtpy/goal/empty_bank_account_goal_info.json');
      final goalResponseModelWithEmptyBankAccountAsJSON =
          jsonDecode(goalResponseModelWithEmptyBankAccountAsString);

      /// Convert budgets from the response JSON to List<Budget>
      /// If Empty then return an empty object list
      final goalResponseModelWithEmptyBankAccountConverted =
          convertToResponseModel(goalResponseModelWithEmptyBankAccountAsJSON);
      final goalResponseModelWithEmptyBankAccountFromJSON =
          GoalResponseModel.fromJSON(
              goalResponseModelWithEmptyBankAccountAsJSON);
      expect(goalResponseModelWithEmptyBankAccountFromJSON,
          equals(goalResponseModelWithEmptyBankAccountConverted));
    });

    test(
        'Should return a valid model when the JSON is parsed with empty date data',
        () async {
      final goalResponseModelWithEmptyDateAsString =
          fixture('responses/partially-emtpy/goal/empty_date_goal_info.json');
      final goalResponseModelWithEmptyDateAsJSON =
          jsonDecode(goalResponseModelWithEmptyDateAsString);

      /// Convert budgets from the response JSON to List<Budget>
      /// If Empty then return an empty object list
      final goalResponseModelWithEmptyDateConverted =
          convertToResponseModel(goalResponseModelWithEmptyDateAsJSON);
      final goalResponseModelWithEmptyDateFromJSON =
          GoalResponseModel.fromJSON(goalResponseModelWithEmptyDateAsJSON);
      expect(goalResponseModelWithEmptyDateFromJSON,
          equals(goalResponseModelWithEmptyDateConverted));
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

    test(
        'Should return a valid model when the JSON is parsed with empty wallet data',
        () async {
      final goalResponseModelWithEmptyWalletAsString =
          fixture('responses/partially-emtpy/goal/empty_wallet_goal_info.json');
      final goalResponseModelWithEmptyWalletAsJSON =
          jsonDecode(goalResponseModelWithEmptyWalletAsString);

      /// Convert budgets from the response JSON to List<Budget>
      /// If Empty then return an empty object list
      final goalResponseModelWithEmptyWalletConverted =
          convertToResponseModel(goalResponseModelWithEmptyWalletAsJSON);
      final goalResponseModelWithEmptyWalletFromJSON =
          GoalResponseModel.fromJSON(goalResponseModelWithEmptyWalletAsJSON);
      expect(goalResponseModelWithEmptyWalletFromJSON,
          equals(goalResponseModelWithEmptyWalletConverted));
    });

    test(
        'Should return a valid model when the JSON is parsed with wallet list data',
        () async {
      final goalResponseModelWithWalletAsList = fixture(
          'responses/dashboard/goal/with-wallet-data/wallet_as_list.json');
      final goalResponseModelWithWalletAsListJSON =
          jsonDecode(goalResponseModelWithWalletAsList);

      /// Convert budgets from the response JSON to List<Budget>
      /// If Empty then return an empty object list
      final goalResponseModelWithWalletAsListConverted =
          convertToResponseModel(goalResponseModelWithWalletAsListJSON);
      final goalResponseModelWithWalletAsListFromJSON =
          GoalResponseModel.fromJSON(goalResponseModelWithWalletAsListJSON);
      expect(goalResponseModelWithWalletAsListFromJSON,
          equals(goalResponseModelWithWalletAsListConverted));
    });

    test(
        'Should return a valid model when the JSON is parsed with wallet list data',
        () async {
      final goalResponseModelWithWalletAsMap = fixture(
          'responses/dashboard/goal/with-wallet-data/wallet_as_map.json');
      final goalResponseModelWithWalletAsMapJSON =
          jsonDecode(goalResponseModelWithWalletAsMap);

      /// Convert budgets from the response JSON to List<Budget>
      /// If Empty then return an empty object list
      final goalResponseModelWithWalletAsMapConverted =
          convertToResponseModel(goalResponseModelWithWalletAsMapJSON);
      final goalResponseModelWithWalletAsMapFromJSON =
          GoalResponseModel.fromJSON(goalResponseModelWithWalletAsMapJSON);
      expect(goalResponseModelWithWalletAsMapFromJSON,
          equals(goalResponseModelWithWalletAsMapConverted));
    });
  });
}

GoalResponseModel convertToResponseModel(
    Map<String, dynamic> goalResponseModelAsJSON) {
  /// Convert categories from the response JSON to List<Category>
  /// If Empty then return an empty object list
  final responseGoals = goalResponseModelAsJSON['Goal'];
  final convertedGoals = List<Goal>.from(responseGoals
          ?.map<dynamic>((dynamic model) => GoalModel.fromJSON(model)) ??
      <Goal>[]);

  return GoalResponseModel(goals: convertedGoals);
}
