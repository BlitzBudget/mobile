import 'package:flutter/foundation.dart';
import 'package:mobile_blitzbudget/core/persistence/secure_key_value_store.dart';

abstract class UserAttributesLocalDataSource {
  Future<String> readUserAttributes();

  Future<void> writeUserAttributes(String value);
}

class UserAttributesLocalDataSourceImpl
    implements UserAttributesLocalDataSource {
  final SecureKeyValueStore secureKeyValueStore;

  UserAttributesLocalDataSourceImpl({@required this.secureKeyValueStore});

  ///
  /// Instantiation of the SharedPreferences library
  ///
  static final String _userAttributes = 'user_attributes';

  /// ------------------------------------------------------------
  /// Method that returns the user user attributes
  /// ------------------------------------------------------------
  @override
  Future<String> readUserAttributes() async {
    return await secureKeyValueStore.getString(key: _userAttributes);
  }

  /// ----------------------------------------------------------
  /// Method that saves the user user attributes
  /// ----------------------------------------------------------
  @override
  Future<void> writeUserAttributes(String value) async {
    await secureKeyValueStore.setString(key: _userAttributes, value: value);
  }
}
