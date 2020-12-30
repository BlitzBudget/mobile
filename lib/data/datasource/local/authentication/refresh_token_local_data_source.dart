import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

abstract class RefreshTokenLocalDataSource {
  Future<String> readRefreshToken();

  Future<void> writeRefreshToken(String value);
}

class RefreshTokenLocalDataSourceImpl implements RefreshTokenLocalDataSource {
  final FlutterSecureStorage flutterSecureStorage;

  RefreshTokenLocalDataSourceImpl({@required this.flutterSecureStorage});

  ///
  /// Instantiation of the SharedPreferences library
  ///
  static final String _refreshToken = 'refresh_token';

  /// ------------------------------------------------------------
  /// Method that returns the user refresh token
  /// ------------------------------------------------------------
  @override
  Future<String> readRefreshToken() async {
    return await flutterSecureStorage.read(key: _refreshToken);
  }

  /// ----------------------------------------------------------
  /// Method that saves the user refresh token
  /// ----------------------------------------------------------
  @override
  Future<void> writeRefreshToken(String value) async {
    await flutterSecureStorage.write(key: _refreshToken, value: value);
  }
}
