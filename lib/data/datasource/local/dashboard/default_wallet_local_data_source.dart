import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart'
    show SharedPreferences;

abstract class DefaultWalletLocalDataSource {
  Future<String> readDefaultWallet();

  Future<void> writeDefaultWallet(String value);
}

class DefaultWalletLocalDataSourceImpl implements DefaultWalletLocalDataSource {
  final SharedPreferences sharedPreferences;

  DefaultWalletLocalDataSourceImpl({@required this.sharedPreferences});

  ///
  /// Instantiation of the SharedPreferences library
  ///
  static final String _defaultWallet = 'default_wallet';

  /// ------------------------------------------------------------
  /// Method that returns the user default wallet
  /// ------------------------------------------------------------
  @override
  Future<String> readDefaultWallet() async {
    return await sharedPreferences.getString(_defaultWallet);
  }

  /// ----------------------------------------------------------
  /// Method that saves the user default wallet
  /// ----------------------------------------------------------
  @override
  Future<void> writeDefaultWallet(String value) async {
    await sharedPreferences.setString(_defaultWallet, value);
  }
}
