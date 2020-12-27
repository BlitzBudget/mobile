import '../../utils/network_util.dart';
import '../authentication.dart' as authentication;

class TransactionRestData {
  NetworkUtil _netUtil = new NetworkUtil();
  static final _transactionURL = authentication.baseURL + "/transactions";

  /// Get Transaction
  Future<void> get() {
    SharedPreferences _prefs = await SharedPreferences.getInstance();

    /// Get from shared preferences
    final String _defaultWallet = _prefs.getString(constants.defaultWallet);
    final String _startsWithDate =
        await dashboardUtils.fetchStartsWithDate(_prefs);
    final String _endsWithDate = await dashboardUtils.fetchEndsWithDate(_prefs);

    // Read [_userAttributes] from User Attributes
    final String _userAttributes =
        await _storage.read(key: constants.userAttributes);
    // Decode the json user
    Map<String, dynamic> _user = jsonDecode(_userAttributes);
    developer.log('User Attributes retrieved for: ${_user["userid"]}');

    // JSON for Get transaction [_jsonForGetTransaction]
    Map<String, dynamic> _jsonForGetTransaction = {
      "startsWithDate": _startsWithDate,
      "endsWithDate": _endsWithDate
    };

    /// Ensure that the wallet is chosen if not empty
    /// If not then use userid
    if (isNotEmpty(_defaultWallet)) {
      _jsonForGetTransaction["walletId"] = _defaultWallet;
    } else {
      _jsonForGetTransaction["userId"] = _user["userid"];
    }

    developer.log(
        "The Map for getting the transaction is  ${_jsonForGetTransaction.toString()}");

    // Set Authorization header
    authentication.headers['Authorization'] =
        await _storage.read(key: constants.authToken);

    developer
        .log('The response from the transaction is ${authentication.headers}');
    return _netUtil
        .post(_transactionURL,
            body: jsonEncode(_jsonForGetTransaction),
            headers: authentication.headers)
        .then((dynamic res) {
      debugPrint('The response from the transaction is $res');
    });
  }

  /// Update Transaction
  Future<void> update() {}

  /// Delete Transaction
  Future<void> delete() {}
}
