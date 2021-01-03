import 'dart:convert';
import 'dart:developer' as developer;

import 'package:flutter/foundation.dart';
import 'package:mobile_blitzbudget/core/network/http_client.dart';
import 'package:mobile_blitzbudget/data/constants/constants.dart' as constants;
import 'package:mobile_blitzbudget/data/model/goal/goal_model.dart';
import 'package:mobile_blitzbudget/core/utils/utils.dart';
import 'package:mobile_blitzbudget/data/model/response/dashboard/goal_response_model.dart';

abstract class GoalRemoteDataSource {
  Future<GoalResponseModel> get(String startsWithDate, String endsWithDate,
      String defaultWallet, String userId);

  Future<void> update(GoalModel updateGoal);

  Future<void> add(GoalModel addGoal);
}

class GoalRemoteDataSourceImpl implements GoalRemoteDataSource {
  final HTTPClient httpClient;

  GoalRemoteDataSourceImpl({@required this.httpClient});

  /// Get Goals
  @override
  Future<GoalResponseModel> get(String startsWithDate, String endsWithDate,
      String defaultWallet, String userId) async {
    var contentBody = <String, dynamic>{
      'startsWithDate': startsWithDate,
      'endsWithDate': endsWithDate
    };

    if (isNotEmpty(defaultWallet)) {
      contentBody['walletId'] = defaultWallet;
    } else {
      contentBody['userId'] = userId;
    }
    return httpClient
        .post(constants.goalURL,
            body: jsonEncode(contentBody), headers: constants.headers)
        .then<GoalResponseModel>((dynamic res) {
      debugPrint('The response from the goal is $res');
      return GoalResponseModel.fromJSON(res as Map<String, dynamic>);
    });
  }

  /// Update Budget
  @override
  Future<void> update(GoalModel updateGoal) {
    developer.log('The Map for patching the goal is  ${updateGoal.toString()}');

    return httpClient
        .patch(constants.goalURL,
            body: jsonEncode(updateGoal.toJSON()), headers: constants.headers)
        .then((dynamic res) {
      debugPrint('The response from patching the goal is $res');
    });
  }

  /// Add Goal
  @override
  Future<void> add(GoalModel addGoal) {
    return httpClient
        .put(constants.goalURL,
            body: jsonEncode(addGoal.toJSON()), headers: constants.headers)
        .then((dynamic res) {
      debugPrint('The response from adding the goal is $res');
    });
  }
}
