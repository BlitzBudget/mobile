import 'package:flutter/foundation.dart';
import 'package:mobile_blitzbudget/core/persistence/key_value_store.dart';

abstract class EndsWithDateLocalDataSource {
  Future<String> readEndsWithDate();

  Future<void> writeEndsWithDate(String value);
}

class EndsWithDateLocalDataSourceImpl implements EndsWithDateLocalDataSource {
  final KeyValueStore keyValueStore;

  EndsWithDateLocalDataSourceImpl({@required this.keyValueStore});

  ///
  /// Instantiation of the SharedPreferences library
  ///
  static final String _endsWithDate = 'ends_with_date';

  /// ------------------------------------------------------------
  /// Method that returns the user ends with date
  /// ------------------------------------------------------------
  @override
  Future<String> readEndsWithDate() async {
    return keyValueStore.getString(key: _endsWithDate);
  }

  /// ----------------------------------------------------------
  /// Method that saves the user ends with date
  /// ----------------------------------------------------------
  @override
  Future<void> writeEndsWithDate(String value) async {
    await keyValueStore.setString(key: _endsWithDate, value: value);
  }
}
