import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart'
    show SharedPreferences;

abstract class EndsWithDateLocalDataSource {
  Future<String> readEndsWithDate();

  Future<void> writeEndsWithDate(String value);
}

class EndsWithDateLocalDataSourceImpl implements EndsWithDateLocalDataSource {
  final SharedPreferences sharedPreferences;

  EndsWithDateLocalDataSourceImpl({@required this.sharedPreferences});

  ///
  /// Instantiation of the SharedPreferences library
  ///
  static final String _endsWithDate = 'ends_with_date';

  /// ------------------------------------------------------------
  /// Method that returns the user ends with date
  /// ------------------------------------------------------------
  @override
  Future<String> readEndsWithDate() async {
    return sharedPreferences.getString(_endsWithDate);
  }

  /// ----------------------------------------------------------
  /// Method that saves the user ends with date
  /// ----------------------------------------------------------
  @override
  Future<void> writeEndsWithDate(String value) async {
    await sharedPreferences.setString(_endsWithDate, value);
  }
}
