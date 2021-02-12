import 'package:flutter/foundation.dart';
import 'package:mobile_blitzbudget/core/persistence/key_value_store.dart';

abstract class DefaultWalletLocalDataSource {
  Future<String> readDefaultWallet();

  Future<void> writeDefaultWallet(String value);
}

class DefaultWalletLocalDataSourceImpl implements DefaultWalletLocalDataSource {
  DefaultWalletLocalDataSourceImpl({@required this.keyValueStore});

  final KeyValueStore keyValueStore;

  ///
  /// Instantiation of the SharedPreferences library
  ///
  static const String _defaultWallet = 'default_wallet';

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
