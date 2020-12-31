import 'dart:async';
import 'dart:convert';
import 'dart:developer' as developer;

import 'package:mobile_blitzbudget/core/network/http_client.dart';
import 'package:mobile_blitzbudget/data/constants/constants.dart' as constants;
import 'package:mobile_blitzbudget/data/model/budget/budget_model.dart';
import 'package:flutter/foundation.dart';

abstract class BudgetRemoteDataSource {
  Future<void> get(Map<String, dynamic> contentBody);

  Future<void> update(BudgetModel updateBudget);

  Future<void> add(BudgetModel addBudget);
}

class BudgetRemoteDataSourceImpl implements BudgetRemoteDataSource {
  final HttpClient httpClient;

  BudgetRemoteDataSourceImpl({@required this.httpClient});

  /// Get Budgets
  @override
  Future<void> get(Map<String, dynamic> contentBody) async {
    return httpClient
        .post(constants.budgetURL,
            body: jsonEncode(contentBody), headers: constants.headers)
        .then((dynamic res) {
      debugPrint('The response from the budget is $res');
      //TODO
    });
  }

  /// Update Budget
  @override
  Future<void> update(BudgetModel updateBudget) {
    developer
        .log('The Map for patching the budget is  ${updateBudget.toString()}');

    return httpClient
        .patch(constants.budgetURL,
            body: jsonEncode(updateBudget.toJSON()), headers: constants.headers)
        .then((dynamic res) {
      debugPrint('The response from the budget is $res');
      //TODO
    });
  }

  /// Add Budget
  @override
  Future<void> add(BudgetModel addBudget) {
    return httpClient
        .put(constants.budgetURL,
            body: jsonEncode(addBudget.toJSON()), headers: constants.headers)
        .then((dynamic res) {
      debugPrint('The response from the budget is $res');
      //TODO
    });
  }
}
