import 'dart:async';
import 'dart:convert';
import 'dart:developer' as developer;

import 'package:flutter/foundation.dart';
import 'package:mobile_blitzbudget/core/network/http_client.dart';
import 'package:mobile_blitzbudget/core/utils/utils.dart';
import 'package:mobile_blitzbudget/data/constants/constants.dart' as constants;
import 'package:mobile_blitzbudget/data/model/budget/budget_model.dart';
import 'package:mobile_blitzbudget/data/model/response/dashboard/budget_response_model.dart';

abstract class BudgetRemoteDataSource {
  Future<BudgetResponseModel> fetch(
      {required String startsWithDate,
      required String endsWithDate,
      required String? defaultWallet});

  Future<void> update(BudgetModel updateBudget);

  Future<void> add(BudgetModel addBudget);
}

class BudgetRemoteDataSourceImpl implements BudgetRemoteDataSource {
  BudgetRemoteDataSourceImpl({required this.httpClient});

  final HTTPClient? httpClient;

  /// Get Budgets
  @override
  Future<BudgetResponseModel> fetch(
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
        .post(constants.budgetURL,
            body: jsonEncode(contentBody), headers: constants.headers)
        .then<BudgetResponseModel>((dynamic res) {
      debugPrint('The response from the budget is $res');
      return BudgetResponseModel.fromJSON(res);
    });
  }

  /// Update Budget
  @override
  Future<void> update(BudgetModel updateBudget) {
    developer
        .log('The Map for patching the budget is  ${updateBudget.toString()}');

    return httpClient!
        .patch(constants.budgetURL,
            body: jsonEncode(updateBudget.toJSON()), headers: constants.headers)
        .then((dynamic res) {
      debugPrint('The response from the update budget is $res');
    });
  }

  /// Add Budget
  @override
  Future<void> add(BudgetModel addBudget) {
    return httpClient!
        .put(constants.budgetURL,
            body: jsonEncode(addBudget.toJSON()), headers: constants.headers)
        .then((dynamic res) {
      debugPrint('The response from the add budget is $res');
    });
  }
}
