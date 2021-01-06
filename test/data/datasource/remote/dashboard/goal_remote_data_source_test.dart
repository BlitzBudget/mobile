import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_blitzbudget/core/network/http_client.dart';
import 'package:mobile_blitzbudget/data/constants/constants.dart' as constants;

import 'package:mobile_blitzbudget/data/datasource/remote/dashboard/goal_remote_data_source.dart';
import 'package:mobile_blitzbudget/data/model/goal/goal_model.dart';

import 'package:mobile_blitzbudget/data/utils/data_utils.dart';
import 'package:mockito/mockito.dart';

import '../../../../fixtures/fixture_reader.dart';

class MockHTTPClientImpl extends Mock implements HTTPClientImpl {}

void main() {
  GoalRemoteDataSourceImpl dataSource;
  HTTPClientImpl mockHTTPClientImpl;

  setUp(() {
    mockHTTPClientImpl = MockHTTPClientImpl();
    dataSource = GoalRemoteDataSourceImpl(httpClient: mockHTTPClientImpl);
  });

  group('Attempt to fetch all goals', () {
    test('Should fetch all goals with wallet id', () async {
      final fetchWalletAsString =
          fixture('responses/dashboard/goal/fetch_goal_info.json');
      final fetchWalletAsJSON =
          jsonDecode(fetchWalletAsString) as Map<String, dynamic>;
      final startsWithDate = DateTime.now().toIso8601String();
      final endsWithDate = startsWithDate;
      final defaultWallet = fetchWalletAsJSON['Goal'][0]['walletId'] as String;
      String userId;
      final contentBody = <String, dynamic>{
        'startsWithDate': startsWithDate,
        'endsWithDate': endsWithDate,
        'walletId': defaultWallet
      };
      // arrange
      when(mockHTTPClientImpl.post(constants.goalURL,
              body: jsonEncode(contentBody), headers: constants.headers))
          .thenAnswer((_) async => fetchWalletAsJSON);
      // act
      var goals = await dataSource.fetch(
          startsWithDate, endsWithDate, defaultWallet, userId);
      // assert
      verify(mockHTTPClientImpl.post(constants.goalURL,
          body: jsonEncode(contentBody), headers: constants.headers));

      expect(goals.goals.last.goalId,
          equals(fetchWalletAsJSON['Goal'][0]['goalId'] as String));
    });
  });

  group('Attempt to add a goal', () {
    test(
      'Should add a goal',
      () async {
        final addGoalAsString =
            fixture('responses/dashboard/goal/add_goal_info.json');
        final addGoalAsJSON =
            jsonDecode(addGoalAsString) as Map<String, dynamic>;
        final goal = GoalModel(
            walletId: addGoalAsJSON['body-json']['walletId'] as String,
            goalId: addGoalAsJSON['body-json']['id'] as String,
            goalType: GoalModel.parseDynamicAsGoalType(
                addGoalAsJSON['body-json']['goalType']),
            monthlyContribution: parseDynamicAsDouble(
                addGoalAsJSON['body-json']['monthlyContribution']),
            targetAmount: parseDynamicAsDouble(
                addGoalAsJSON['body-json']['targetAmount']),
            targetDate:
                parseDynamicAsString(addGoalAsJSON['body-json']['targetDate']),
            targetId: addGoalAsJSON['body-json']['targetId'] as String,
            targetType: GoalModel.parseDynamicAsTargetType(
                addGoalAsJSON['body-json']['targetType']));

        // arrange
        when(mockHTTPClientImpl.put(constants.goalURL,
                body: jsonEncode(goal.toJSON()), headers: constants.headers))
            .thenAnswer((_) async => addGoalAsJSON);
        // act
        await dataSource.add(goal);
        // assert
        verify(mockHTTPClientImpl.put(constants.goalURL,
            body: jsonEncode(goal.toJSON()), headers: constants.headers));
      },
    );
  });

  group('Attempt to update a goal', () {
    test(
      'Should update a goals target amount',
      () async {
        final updateAmountAsString = fixture(
            'responses/dashboard/goal/update/update_goal_target_amount_info.json');
        final updateAmountAsJSON =
            jsonDecode(updateAmountAsString) as Map<String, dynamic>;
        final goal = GoalModel(
            walletId: updateAmountAsJSON['body-json']['walletId'] as String,
            goalId: updateAmountAsJSON['body-json']['goalId'] as String,
            targetAmount: parseDynamicAsDouble(
                updateAmountAsJSON['body-json']['targetAmount']));
        // arrange
        when(mockHTTPClientImpl.patch(constants.goalURL,
                body: jsonEncode(goal.toJSON()), headers: constants.headers))
            .thenAnswer((_) async => updateAmountAsJSON);
        // act
        await dataSource.update(goal);
        // assert
        verify(mockHTTPClientImpl.patch(constants.goalURL,
            body: jsonEncode(goal.toJSON()), headers: constants.headers));
      },
    );

    test(
      'Should update a goals target date',
      () async {
        final updateTargetDateAsString = fixture(
            'responses/dashboard/goal/update/update_goal_target_date_info.json');
        final updateTargetDateAsJSON =
            jsonDecode(updateTargetDateAsString) as Map<String, dynamic>;
        final goal = GoalModel(
            walletId: updateTargetDateAsJSON['body-json']['walletId'] as String,
            goalId: updateTargetDateAsJSON['body-json']['goalId'] as String,
            targetDate:
                updateTargetDateAsJSON['body-json']['targetDate'] as String);
        // arrange
        when(mockHTTPClientImpl.patch(constants.goalURL,
                body: jsonEncode(goal.toJSON()), headers: constants.headers))
            .thenAnswer((_) async => updateTargetDateAsJSON);
        // act
        await dataSource.update(goal);
        // assert
        verify(mockHTTPClientImpl.patch(constants.goalURL,
            body: jsonEncode(goal.toJSON()), headers: constants.headers));
      },
    );

    test(
      'Should update a goals target id',
      () async {
        final updateTargetIdAsString = fixture(
            'responses/dashboard/goal/update/update_goal_target_id_info.json');
        final updateTargetIdAsJSON =
            jsonDecode(updateTargetIdAsString) as Map<String, dynamic>;
        final goal = GoalModel(
            walletId: updateTargetIdAsJSON['body-json']['walletId'] as String,
            goalId: updateTargetIdAsJSON['body-json']['goalId'] as String,
            targetId: updateTargetIdAsJSON['body-json']['targetId'] as String);
        // arrange
        when(mockHTTPClientImpl.patch(constants.goalURL,
                body: jsonEncode(goal.toJSON()), headers: constants.headers))
            .thenAnswer((_) async => updateTargetIdAsJSON);
        // act
        await dataSource.update(goal);
        // assert
        verify(mockHTTPClientImpl.patch(constants.goalURL,
            body: jsonEncode(goal.toJSON()), headers: constants.headers));
      },
    );

    test(
      'Should update a goals target type',
      () async {
        final updateTargetIdAsString = fixture(
            'responses/dashboard/goal/update/update_goal_target_type_info.json');
        final updateTargetIdAsJSON =
            jsonDecode(updateTargetIdAsString) as Map<String, dynamic>;
        final goal = GoalModel(
            walletId: updateTargetIdAsJSON['body-json']['walletId'] as String,
            goalId: updateTargetIdAsJSON['body-json']['goalId'] as String,
            targetType: GoalModel.parseDynamicAsTargetType(
                updateTargetIdAsJSON['body-json']['targetType']));
        // arrange
        when(mockHTTPClientImpl.patch(constants.goalURL,
                body: jsonEncode(goal.toJSON()), headers: constants.headers))
            .thenAnswer((_) async => updateTargetIdAsJSON);
        // act
        await dataSource.update(goal);
        // assert
        verify(mockHTTPClientImpl.patch(constants.goalURL,
            body: jsonEncode(goal.toJSON()), headers: constants.headers));
      },
    );

    test(
      'Should update a goals monthly contribution',
      () async {
        final updateMonthlyContributionAsString = fixture(
            'responses/dashboard/goal/update/update_goal_monthly_contribution_info.json');
        final updateMonthlyContributionAsJSON =
            jsonDecode(updateMonthlyContributionAsString)
                as Map<String, dynamic>;
        final goal = GoalModel(
            walletId: updateMonthlyContributionAsJSON['body-json']['walletId']
                as String,
            goalId: updateMonthlyContributionAsJSON['body-json']['goalId']
                as String,
            monthlyContribution: parseDynamicAsDouble(
                updateMonthlyContributionAsJSON['body-json']
                    ['monthlyContribution']));
        // arrange
        when(mockHTTPClientImpl.patch(constants.goalURL,
                body: jsonEncode(goal.toJSON()), headers: constants.headers))
            .thenAnswer((_) async => updateMonthlyContributionAsJSON);
        // act
        await dataSource.update(goal);
        // assert
        verify(mockHTTPClientImpl.patch(constants.goalURL,
            body: jsonEncode(goal.toJSON()), headers: constants.headers));
      },
    );
  });
}
