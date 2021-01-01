import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:mobile_blitzbudget/core/network/http_client.dart';
import 'package:mobile_blitzbudget/data/constants/constants.dart' as constants;

abstract class CategoryRemoteDataSource {
  Future<void> delete(String walletId, String category);
}

class CategoryRemoteDataSourceImpl implements CategoryRemoteDataSource {
  final HTTPClient httpClient;

  CategoryRemoteDataSourceImpl({@required this.httpClient});

  /// Delete Wallet
  @override
  Future<void> delete(String walletId, String category) {
    // JSON for Get wallet [_jsonForGetWallet]
    var _jsonForDeleteCategory = <String, dynamic>{
      'walletId': walletId,
      'category': category
    };

    return httpClient
        .post(constants.deleteCategoryURL,
            body: jsonEncode(_jsonForDeleteCategory),
            headers: constants.headers)
        .then((dynamic res) {
      debugPrint('The response from the budget is $res');
      //TODO
    });
  }
}
