import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:mobile_blitzbudget/core/network/http_client.dart';
import 'package:mobile_blitzbudget/data/constants/constants.dart' as constants;

mixin CategoryRemoteDataSource {
  Future<void> delete({required String walletId, required String category});
}

class CategoryRemoteDataSourceImpl implements CategoryRemoteDataSource {
  CategoryRemoteDataSourceImpl({required this.httpClient});

  final HTTPClient? httpClient;

  /// Delete Wallet
  @override
  Future<void> delete({required String walletId, required String category}) {
    // JSON for Get wallet [_jsonForGetWallet]
    final _jsonForDeleteCategory = <String, dynamic>{
      'pk': walletId,
      'category': category
    };

    return httpClient!
        .post(constants.deleteCategoryURL,
            body: jsonEncode(_jsonForDeleteCategory),
            headers: constants.headers)
        .then((dynamic res) {
      debugPrint('The response from the delete category is $res');
    });
  }
}
