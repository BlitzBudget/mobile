import 'package:flutter/foundation.dart';
import 'package:mobile_blitzbudget/core/persistence/secure_key_value_store.dart';

abstract class UserAttributesLocalDataSource {
  Future<String> readUserAttributes();

  Future<void> writeUserAttributes(String value);
}

class UserAttributesLocalDataSourceImpl
    implements UserAttributesLocalDataSource {
  UserAttributesLocalDataSourceImpl({@required this.secureKeyValueStore});

  final SecureKeyValueStore secureKeyValueStore;

  ///
  /// Instantiation of the SharedPreferences library
  ///
  static const String _userAttributes = 'user_attributes';

  /// ------------------------------------------------------------
  /// Method that returns the user user attributes
  /// ------------------------------------------------------------
  @override
  Future<String> readUserAttributes() async {
    return secureKeyValueStore.getString(key: _userAttributes);
  }

  /// ----------------------------------------------------------
  /// Method that saves the user user attributes
  /// ----------------------------------------------------------
  @override
  Future<void> writeUserAttributes(String value) async {
    await secureKeyValueStore.setString(key: _userAttributes, value: value);
  }
}
