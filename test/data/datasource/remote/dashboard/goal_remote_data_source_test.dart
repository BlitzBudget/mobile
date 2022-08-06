import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_blitzbudget/core/network/http_client.dart';
import 'package:mobile_blitzbudget/data/constants/constants.dart' as constants;
import 'package:mobile_blitzbudget/data/datasource/remote/dashboard/goal_remote_data_source.dart';
import 'package:mobile_blitzbudget/data/model/goal/goal_model.dart';
import 'package:mobile_blitzbudget/data/utils/data_utils.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../fixtures/fixture_reader.dart';

class MockHTTPClientImpl extends Mock implements HTTPClientImpl {}

void main() {
  late GoalRemoteDataSourceImpl dataSource;
  HTTPClientImpl? mockHTTPClientImpl;

  setUp(() {
    mockHTTPClientImpl = MockHTTPClientImpl();
    dataSource = GoalRemoteDataSourceImpl(httpClient: mockHTTPClientImpl);
  });

  group('Attempt to fetch all goals', () {
    test('Should fetch all goals with wallet id', () async {
      final fetchWalletAsString =
          fixture('responses/dashboard/goal/fetch_goal_info.json');
      final fetchWalletAsJSON = jsonDecode(fetchWalletAsString);
      final startsWithDate = DateTime.now().toIso8601String();
      final endsWithDate = startsWithDate;
      final defaultWallet = fetchWalletAsJSON[0]['pk'];
      final contentBody = <String, dynamic>{
        'starts_with_date': startsWithDate,
        'ends_with_date': endsWithDate,
        'pk': defaultWallet
      };
      // arrange
      when(() => mockHTTPClientImpl!.post(constants.goalURL,
              body: jsonEncode(contentBody), headers: constants.headers))
          .thenAnswer((_) async => fetchWalletAsJSON);
      // act
      final goals = await dataSource.fetch(
          startsWithDate: startsWithDate,
          endsWithDate: endsWithDate,
          defaultWallet: defaultWallet);
      // assert
      verify(() => mockHTTPClientImpl!.post(constants.goalURL,
          body: jsonEncode(contentBody), headers: constants.headers));

      expect(goals.goals!.last.goalId, equals(fetchWalletAsJSON.last['sk']));
      expect(goals.goals!.last.walletId, equals(fetchWalletAsJSON.last['pk']));
    });
  });

  group('Attempt to add a goal', () {
    test(
      'Should add a goal',
      () async {
        final addGoalAsString =
            fixture('responses/dashboard/goal/add_goal_info.json');
        final addGoalAsJSON = jsonDecode(addGoalAsString);
        final goal = GoalModel(
            walletId: parseDynamicAsString(addGoalAsJSON['pk']),
            goalId: parseDynamicAsString(addGoalAsJSON['sk']),
            currentAmount:
                parseDynamicAsDouble(addGoalAsJSON['current_amount']),
            goalName: parseDynamicAsString(addGoalAsJSON['goal_name']),
            goalAchieved: parseDynamicAsBool(addGoalAsJSON['goal_achieved']),
            targetAmount: parseDynamicAsDouble(addGoalAsJSON['target_amount']),
            targetDate: parseDynamicAsString(addGoalAsJSON['target_date']),
            creationDate: parseDynamicAsString(addGoalAsJSON['creation_date']),
            updateDate: parseDynamicAsString(addGoalAsJSON['updated_date']));

        // arrange
        when(() => mockHTTPClientImpl!.put(constants.goalURL,
            body: jsonEncode(goal.toJSON()),
            headers: constants.headers)).thenAnswer((_) async => addGoalAsJSON);
        // act
        await dataSource.add(goal);
        // assert
        verify(() => mockHTTPClientImpl!.put(constants.goalURL,
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
        final updateAmountAsJSON = jsonDecode(updateAmountAsString);
        final goal = GoalModel(
            walletId: updateAmountAsJSON['body-json']['pk'],
            goalId: updateAmountAsJSON['body-json']['sk'],
            targetAmount: parseDynamicAsDouble(
                updateAmountAsJSON['body-json']['targetAmount']));
        // arrange
        when(() => mockHTTPClientImpl!.patch(constants.goalURL,
                body: jsonEncode(goal.toJSON()), headers: constants.headers))
            .thenAnswer((_) async => updateAmountAsJSON);
        // act
        await dataSource.update(goal);
        // assert
        verify(() => mockHTTPClientImpl!.patch(constants.goalURL,
            body: jsonEncode(goal.toJSON()), headers: constants.headers));
      },
    );

    test(
      'Should update a goals target date',
      () async {
        final updateTargetDateAsString = fixture(
            'responses/dashboard/goal/update/update_goal_target_date_info.json');
        final updateTargetDateAsJSON = jsonDecode(updateTargetDateAsString);
        final goal = GoalModel(
            walletId: updateTargetDateAsJSON['body-json']['pk'],
            goalId: updateTargetDateAsJSON['body-json']['sk'],
            targetDate: updateTargetDateAsJSON['body-json']['target_date']);
        // arrange
        when(() => mockHTTPClientImpl!.patch(constants.goalURL,
                body: jsonEncode(goal.toJSON()), headers: constants.headers))
            .thenAnswer((_) async => updateTargetDateAsJSON);
        // act
        await dataSource.update(goal);
        // assert
        verify(() => mockHTTPClientImpl!.patch(constants.goalURL,
            body: jsonEncode(goal.toJSON()), headers: constants.headers));
      },
    );

    test(
      'Should update a goals current amount',
      () async {
        final updateTargetIdAsString = fixture(
            'responses/dashboard/goal/update/update_goal_current_amount_info.json');
        final updateTargetIdAsJSON = jsonDecode(updateTargetIdAsString);
        final goal = GoalModel(
            walletId: parseDynamicAsString(updateTargetIdAsJSON['pk']),
            goalId: parseDynamicAsString(updateTargetIdAsJSON['sk']),
            currentAmount:
                parseDynamicAsDouble(updateTargetIdAsJSON['current_amount']));
        // arrange
        when(() => mockHTTPClientImpl!.patch(constants.goalURL,
                body: jsonEncode(goal.toJSON()), headers: constants.headers))
            .thenAnswer((_) async => updateTargetIdAsJSON);
        // act
        await dataSource.update(goal);
        // assert
        verify(() => mockHTTPClientImpl!.patch(constants.goalURL,
            body: jsonEncode(goal.toJSON()), headers: constants.headers));
      },
    );

    test(
      'Should update a goals goal name',
      () async {
        final updateTargetIdAsString = fixture(
            'responses/dashboard/goal/update/update_goal_goal_name_info.json');
        final updateTargetIdAsJSON = jsonDecode(updateTargetIdAsString);
        final goal = GoalModel(
            walletId: parseDynamicAsString(updateTargetIdAsJSON['pk']),
            goalId: parseDynamicAsString(updateTargetIdAsJSON['sk']),
            goalName: parseDynamicAsString(updateTargetIdAsJSON['goal_name']));
        // arrange
        when(() => mockHTTPClientImpl!.patch(constants.goalURL,
                body: jsonEncode(goal.toJSON()), headers: constants.headers))
            .thenAnswer((_) async => updateTargetIdAsJSON);
        // act
        await dataSource.update(goal);
        // assert
        verify(() => mockHTTPClientImpl!.patch(constants.goalURL,
            body: jsonEncode(goal.toJSON()), headers: constants.headers));
      },
    );
  });
}
