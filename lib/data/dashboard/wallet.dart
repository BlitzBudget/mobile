import '../../utils/network_util.dart';
import '../authentication.dart' as authentication;

class WalletRestData {
  NetworkUtil _netUtil = new NetworkUtil();
  static final _walletURL = authentication.baseURL + "/wallet";

  /// Get Wallet
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

    // JSON for Get wallet [_jsonForGetWallet]
    Map<String, dynamic> _jsonForGetWallet = {
      "startsWithDate": _startsWithDate,
      "endsWithDate": _endsWithDate
    };

    /// Ensure that the wallet is chosen if not empty
    /// If not then use userid
    if (isNotEmpty(_defaultWallet)) {
      _jsonForGetWallet["walletId"] = _defaultWallet;
    } else {
      _jsonForGetWallet["userId"] = _user["userid"];
    }

    developer.log(
        "The Map for getting the wallet is  ${_jsonForGetWallet.toString()}");

    // Set Authorization header
    authentication.headers['Authorization'] =
        await _storage.read(key: constants.authToken);

    developer.log('The response from the wallet is ${authentication.headers}');
    return _netUtil
        .post(_walletURL,
            body: jsonEncode(_jsonForGetWallet),
            headers: authentication.headers)
        .then((dynamic res) {
      debugPrint('The response from the wallet is $res');
    });
  }

  /// Update Wallet
  Future<void> update() {}

  /// Delete Wallet
  Future<void> delete() {}
}
