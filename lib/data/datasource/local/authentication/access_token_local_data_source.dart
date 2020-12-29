import 'package:flutter_secure_storage/flutter_secure_storage.dart';

abstract class AccessTokenLocalDataSource {
  Future<String> readAccessToken();

  Future<void> writeAccessToken(String value);
}

class _AccessTokenLocalDataSourceImpl implements AccessTokenLocalDataSource {
  final FlutterSecureStorage _storage;

  _AccessTokenLocalDataSourceImpl({@required this._storage});

  ///
  /// Instantiation of the SharedPreferences library
  ///
  static final String _accessToken = "access_token";

  /// ------------------------------------------------------------
  /// Method that returns the user access token
  /// ------------------------------------------------------------
  @override
  Future<String> readAccessToken() async {
    return await _storage.read(key: _accessToken);
  }

  /// ----------------------------------------------------------
  /// Method that saves the user access token
  /// ----------------------------------------------------------
  @override
  Future<void> writeAccessToken(String value) async {
    await _storage.write(key: _accessToken, value: value);
  }
}
