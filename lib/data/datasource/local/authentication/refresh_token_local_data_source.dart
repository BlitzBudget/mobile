import 'package:flutter_secure_storage/flutter_secure_storage.dart';

abstract class RefreshTokenLocalDataSource {
  Future<String> readRefreshToken();

  Future<void> writeRefreshToken(String value);
}

class _RefreshTokenLocalDataSourceImpl implements RefreshTokenLocalDataSource {
  final FlutterSecureStorage _storage;

  _RefreshTokenLocalDataSourceImpl({@required this._storage});

  ///
  /// Instantiation of the SharedPreferences library
  ///
  static final String _refreshToken = "refresh_token";

  /// ------------------------------------------------------------
  /// Method that returns the user refresh token
  /// ------------------------------------------------------------
  @override
  Future<String> readRefreshToken() async {
    return await _storage.read(key: _refreshToken);
  }

  /// ----------------------------------------------------------
  /// Method that saves the user refresh token
  /// ----------------------------------------------------------
  @override
  Future<void> writeRefreshToken(String value) async {
    await _storage.write(key: _refreshToken, value: value);
  }
}
