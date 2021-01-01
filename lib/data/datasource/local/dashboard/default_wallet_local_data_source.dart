import 'package:flutter/foundation.dart';
import 'package:mobile_blitzbudget/core/persistence/key_value_store.dart';

abstract class DefaultWalletLocalDataSource {
  Future<String> readDefaultWallet();

  Future<void> writeDefaultWallet(String value);
}

class DefaultWalletLocalDataSourceImpl implements DefaultWalletLocalDataSource {
  final KeyValueStore keyValueStore;

  DefaultWalletLocalDataSourceImpl({@required this.keyValueStore});

  ///
  /// Instantiation of the SharedPreferences library
  ///
  static final String _defaultWallet = 'default_wallet';

  /// ------------------------------------------------------------
  /// Method that returns the user default wallet
  /// ------------------------------------------------------------
  @override
  Future<String> readDefaultWallet() async {
    return keyValueStore.getString(key: _defaultWallet);
  }

  /// ----------------------------------------------------------
  /// Method that saves the user default wallet
  /// ----------------------------------------------------------
  @override
  Future<void> writeDefaultWallet(String value) async {
    await keyValueStore.setString(key: _defaultWallet, value: value);
  }
}
