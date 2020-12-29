import '../../../utils/network_helper.dart';
import '../datasource/remote/authentication_remote_data_source.dart'
    as authentication;

abstract class DeleteItemRemoteDataSource {
  Future<void> delete(String walletId, String itemId);
}

class _DeleteItemRemoteDataSourceImpl implements DeleteItemRemoteDataSource {
  NetworkUtil _netUtil = new NetworkUtil();
  static final _deleteItemURL = authentication.baseURL + "/delete-item";

  /// Delete Item
  @override
  Future<void> delete(String walletId, String itemId) async {
    // JSON for Get budget [_jsonForGetBudget]
    Map<String, dynamic> _jsonForDeleteItem = {
      'walletId': walletId,
      'itemId': itemId,
    };

    return _netUtil
        .post(_deleteItemURL,
            body: jsonEncode(_jsonForDeleteItem),
            headers: authentication.headers)
        .then((dynamic res) {
      debugPrint('The response from the budget is $res');
    });
  }
}
