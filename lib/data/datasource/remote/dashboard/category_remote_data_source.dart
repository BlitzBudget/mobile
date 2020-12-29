import 'dart:convert';
import 'dart:developer' as developer;

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../../../utils/network_helper.dart';

abstract class CategoryRemoteDataSource {
  Future<void> delete(String walletId, String category);
}

class _CategoryRemoteDataSourceImpl implements CategoryRemoteDataSource {
  NetworkUtil _netUtil = new NetworkUtil();

  /// Create storage
  final _storage = new FlutterSecureStorage();
  static final _categoryURL = authentication.baseURL + "/categories/delete";

  /// Delete Wallet
  @override
  Future<void> delete(String walletId, String category) {
    // JSON for Get wallet [_jsonForGetWallet]
    Map<String, dynamic> _jsonForDeleteCategory = {
      "walletId": walletId,
      "category": category
    };

    return _netUtil
        .post(_categoryURL,
            body: jsonEncode(_jsonForDeleteCategory),
            headers: authentication.headers)
        .then((dynamic res) {
      debugPrint('The response from the budget is $res');
      //TODO
    });
  }
}
