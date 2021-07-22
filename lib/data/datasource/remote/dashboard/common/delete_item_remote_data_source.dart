import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:mobile_blitzbudget/core/network/http_client.dart';
import 'package:mobile_blitzbudget/data/constants/constants.dart' as constants;

mixin DeleteItemRemoteDataSource {
  Future<void> delete({required String walletId, required String itemId});
}

class DeleteItemRemoteDataSourceImpl with DeleteItemRemoteDataSource {
  DeleteItemRemoteDataSourceImpl({required this.httpClient});

  final HTTPClient? httpClient;

  /// Delete Item
  @override
  Future<void> delete(
      {required String walletId, required String itemId}) async {
    // JSON for Get budget [_jsonForGetBudget]
    final _jsonForDeleteItem = <String, dynamic>{
      'walletId': walletId,
      'itemId': itemId,
    };

    return httpClient!
        .post(constants.deleteItemURL,
            body: jsonEncode(_jsonForDeleteItem), headers: constants.headers)
        .then((dynamic responseBody) {
      debugPrint('The response from the budget update is $responseBody');
    });
  }
}
