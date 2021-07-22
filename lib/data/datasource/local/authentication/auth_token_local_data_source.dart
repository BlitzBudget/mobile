import 'package:mobile_blitzbudget/core/persistence/secure_key_value_store.dart';

abstract class AuthTokenLocalDataSource {
  Future<String> readAuthToken();

  Future<void> writeAuthToken(String? value);
}

class AuthTokenLocalDataSourceImpl implements AuthTokenLocalDataSource {
  AuthTokenLocalDataSourceImpl({required this.secureKeyValueStore});

  final SecureKeyValueStore? secureKeyValueStore;

  ///
  /// Instantiation of the SharedPreferences library
  ///
  static const String _authToken = 'auth_token';

  /// ------------------------------------------------------------
  /// Method that returns the user authentication token
  /// ------------------------------------------------------------
  @override
  Future<String> readAuthToken() async {
    return secureKeyValueStore!.getString(key: _authToken);
  }

  /// ----------------------------------------------------------
  /// Method that saves the user authentication token
  /// ----------------------------------------------------------
  @override
  Future<void> writeAuthToken(String? value) async {
    await secureKeyValueStore!.setString(key: _authToken, value: value);
  }
}
