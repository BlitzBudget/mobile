import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

abstract class UserAttributesLocalDataSource {
  Future<String> readUserAttributes();

  Future<void> writeUserAttributes(String value);
}

class _UserAttributesLocalDataSourceImpl
    implements UserAttributesLocalDataSource {
  final FlutterSecureStorage storage;

  _UserAttributesLocalDataSourceImpl({@required this.storage});

  ///
  /// Instantiation of the SharedPreferences library
  ///
  static final String _userAttributes = 'user_attributes';

  /// ------------------------------------------------------------
  /// Method that returns the user user attributes
  /// ------------------------------------------------------------
  @override
  Future<String> readUserAttributes() async {
    return await storage.read(key: _userAttributes);
  }

  /// ----------------------------------------------------------
  /// Method that saves the user user attributes
  /// ----------------------------------------------------------
  @override
  Future<void> writeUserAttributes(String value) async {
    await storage.write(key: _userAttributes, value: value);
  }
}
