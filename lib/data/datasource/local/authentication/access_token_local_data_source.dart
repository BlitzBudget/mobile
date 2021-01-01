import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:mobile_blitzbudget/core/persistence/secure_key_value_store.dart';

abstract class AccessTokenLocalDataSource {
  Future<String> readAccessToken();

  Future<void> writeAccessToken(String value);
}

class AccessTokenLocalDataSourceImpl implements AccessTokenLocalDataSource {
  final SecureKeyValueStore secureKeyValueStore;

  AccessTokenLocalDataSourceImpl({@required this.secureKeyValueStore});

  ///
  /// Instantiation of the SharedPreferences library
  ///
  static final String _accessToken = 'access_token';

  /// ------------------------------------------------------------
  /// Method that returns the user access token
  /// ------------------------------------------------------------
  @override
  Future<String> readAccessToken() async {
    return await secureKeyValueStore.getString(key: _accessToken);
  }

  /// ----------------------------------------------------------
  /// Method that saves the user access token
  /// ----------------------------------------------------------
  @override
  Future<void> writeAccessToken(String value) async {
    await secureKeyValueStore.setString(key: _accessToken, value: value);
  }
}
