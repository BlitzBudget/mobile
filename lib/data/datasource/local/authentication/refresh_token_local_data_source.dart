import 'package:flutter/foundation.dart';
import 'package:mobile_blitzbudget/core/persistence/secure_key_value_store.dart';

abstract class RefreshTokenLocalDataSource {
  Future<String> readRefreshToken();

  Future<void> writeRefreshToken(String value);
}

class RefreshTokenLocalDataSourceImpl implements RefreshTokenLocalDataSource {
  final SecureKeyValueStore secureKeyValueStore;

  RefreshTokenLocalDataSourceImpl({@required this.secureKeyValueStore});

  ///
  /// Instantiation of the SharedPreferences library
  ///
  static final String _refreshToken = 'refresh_token';

  /// ------------------------------------------------------------
  /// Method that returns the user refresh token
  /// ------------------------------------------------------------
  @override
  Future<String> readRefreshToken() async {
    return await secureKeyValueStore.getString(key: _refreshToken);
  }

  /// ----------------------------------------------------------
  /// Method that saves the user refresh token
  /// ----------------------------------------------------------
  @override
  Future<void> writeRefreshToken(String value) async {
    await secureKeyValueStore.setString(key: _refreshToken, value: value);
  }
}
