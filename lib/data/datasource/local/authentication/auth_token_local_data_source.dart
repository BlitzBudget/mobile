import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

abstract class AuthTokenLocalDataSource {
  Future<String> readAuthToken();

  Future<void> writeAuthToken(String value);
}

class _AuthTokenLocalDataSourceImpl implements AuthTokenLocalDataSource {
  final FlutterSecureStorage flutterSecureStorage;

  _AuthTokenLocalDataSourceImpl({@required this.flutterSecureStorage});

  ///
  /// Instantiation of the SharedPreferences library
  ///
  static final String _authToken = 'auth_token';

  /// ------------------------------------------------------------
  /// Method that returns the user authentication token
  /// ------------------------------------------------------------
  @override
  Future<String> readAuthToken() async {
    return await flutterSecureStorage.read(key: _authToken);
  }

  /// ----------------------------------------------------------
  /// Method that saves the user authentication token
  /// ----------------------------------------------------------
  @override
  Future<void> writeAuthToken(String value) async {
    await flutterSecureStorage.write(key: _authToken, value: value);
  }
}
