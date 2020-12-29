import 'package:shared_preferences/shared_preferences.dart';

abstract class DefaultWalletLocalDataSource {
  Future<String> readDefaultWallet();

  Future<void> writeDefaultWallet(String value);
}

class _DefaultWalletLocalDataSourceImpl
    implements DefaultWalletLocalDataSource {
  final SharedPreferences sharedPreferences;

  _DefaultWalletLocalDataSourceImpl({@required this.sharedPreferences});

  ///
  /// Instantiation of the SharedPreferences library
  ///
  static final String _defaultWallet = "default_wallet";

  /// ------------------------------------------------------------
  /// Method that returns the user default wallet
  /// ------------------------------------------------------------
  @override
  Future<String> readDefaultWallet() async {
    return await _storage.read(key: _defaultWallet);
  }

  /// ----------------------------------------------------------
  /// Method that saves the user default wallet
  /// ----------------------------------------------------------
  @override
  Future<void> writeDefaultWallet(String value) async {
    await _storage.write(key: _defaultWallet, value: value);
  }
}
