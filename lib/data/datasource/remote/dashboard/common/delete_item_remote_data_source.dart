import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:mobile_blitzbudget/core/network/http_client.dart';
import 'package:mobile_blitzbudget/data/constants/constants.dart' as constants;

abstract class DeleteItemRemoteDataSource {
  Future<void> delete(String walletId, String itemId);
}

class DeleteItemRemoteDataSourceImpl implements DeleteItemRemoteDataSource {
  final HTTPClient httpClient;

  DeleteItemRemoteDataSourceImpl(this.httpClient);

  /// Delete Item
  @override
  Future<void> delete(String walletId, String itemId) async {
    // JSON for Get budget [_jsonForGetBudget]
    var _jsonForDeleteItem = <String, dynamic>{
      'walletId': walletId,
      'itemId': itemId,
    };

    return httpClient
        .post(constants.deleteItemURL,
            body: jsonEncode(_jsonForDeleteItem), headers: constants.headers)
        .then((dynamic responseBody) {
      debugPrint('The response from the budget update is $responseBody');
    });
  }
}
