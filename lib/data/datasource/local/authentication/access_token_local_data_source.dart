import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

abstract class AccessTokenLocalDataSource {
  Future<String> readAccessToken();

  Future<void> writeAccessToken(String value);
}

class _AccessTokenLocalDataSourceImpl implements AccessTokenLocalDataSource {
  final FlutterSecureStorage flutterSecureStorage;

  _AccessTokenLocalDataSourceImpl({@required this.flutterSecureStorage});

  ///
  /// Instantiation of the SharedPreferences library
  ///
  static final String _accessToken = 'access_token';

  /// ------------------------------------------------------------
  /// Method that returns the user access token
  /// ------------------------------------------------------------
  @override
  Future<String> readAccessToken() async {
    return await flutterSecureStorage.read(key: _accessToken);
  }

  /// ----------------------------------------------------------
  /// Method that saves the user access token
  /// ----------------------------------------------------------
  @override
  Future<void> writeAccessToken(String value) async {
    await flutterSecureStorage.write(key: _accessToken, value: value);
  }
}
