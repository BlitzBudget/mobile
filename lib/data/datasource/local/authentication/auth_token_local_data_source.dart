import 'package:flutter_secure_storage/flutter_secure_storage.dart';

abstract class AuthTokenLocalDataSource {
  Future<String> readAuthToken();

  Future<void> writeAuthToken(String value);
}

class _AuthTokenLocalDataSourceImpl implements AuthTokenLocalDataSource {
  final FlutterSecureStorage _storage;

  _AuthTokenLocalDataSourceImpl({@required this._storage});

  ///
  /// Instantiation of the SharedPreferences library
  ///
  static final String _authToken = "auth_token";

  /// ------------------------------------------------------------
  /// Method that returns the user authentication token
  /// ------------------------------------------------------------
  @override
  Future<String> readAuthToken() async {
    return await _storage.read(key: _authToken);
  }

  /// ----------------------------------------------------------
  /// Method that saves the user authentication token
  /// ----------------------------------------------------------
  @override
  Future<void> writeAuthToken(String value) async {
    await _storage.write(key: _authToken, value: value);
  }
}
