import 'dart:convert';
import 'dart:developer' as developer;

import 'package:flutter/foundation.dart';
import 'package:mobile_blitzbudget/core/network/http_client.dart';
import 'package:mobile_blitzbudget/core/utils/utils.dart';
import 'package:mobile_blitzbudget/data/constants/constants.dart' as constants;
import 'package:mobile_blitzbudget/data/model/goal/goal_model.dart';
import 'package:mobile_blitzbudget/data/model/response/dashboard/goal_response_model.dart';

abstract class GoalRemoteDataSource {
  Future<GoalResponseModel> fetch(
      {required String startsWithDate,
      required String endsWithDate,
      required String? defaultWallet});

  Future<void> update(GoalModel updateGoal);

  Future<void> add(GoalModel addGoal);
}

class GoalRemoteDataSourceImpl implements GoalRemoteDataSource {
  GoalRemoteDataSourceImpl({required this.httpClient});

  final HTTPClient? httpClient;

  /// Get Goals
  @override
  Future<GoalResponseModel> fetch(
      {required String startsWithDate,
      required String endsWithDate,
      required String? defaultWallet}) async {
    final contentBody = <String, dynamic>{
      'starts_with_date': startsWithDate,
      'ends_with_date': endsWithDate
    };

    if (isNotEmpty(defaultWallet)) {
      contentBody['pk'] = defaultWallet;
    }

    return httpClient!
        .post(constants.goalURL,
            body: jsonEncode(contentBody), headers: constants.headers)
        .then<GoalResponseModel>((dynamic res) {
      debugPrint('The response from the goal is $res');
      return GoalResponseModel.fromJSON(res);
    });
  }

  /// Update Budget
  @override
  Future<void> update(GoalModel updateGoal) {
    developer.log('The Map for patching the goal is  ${updateGoal.toString()}');

    return httpClient!
        .patch(constants.goalURL,
            body: jsonEncode(updateGoal.toJSON()), headers: constants.headers)
        .then((dynamic res) {
      debugPrint('The response from patching the goal is $res');
    });
  }

  /// Add Goal
  @override
  Future<void> add(GoalModel addGoal) {
    return httpClient!
        .put(constants.goalURL,
            body: jsonEncode(addGoal.toJSON()), headers: constants.headers)
        .then((dynamic res) {
      debugPrint('The response from adding the goal is $res');
    });
  }
}
