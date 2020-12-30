import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart'
    show SharedPreferences;

abstract class StartsWithDateLocalDataSource {
  Future<String> readStartsWithDate();

  Future<void> writeStartsWithDate(String value);
}

class StartsWithDateLocalDataSourceImpl
    implements StartsWithDateLocalDataSource {
  final SharedPreferences sharedPreferences;

  StartsWithDateLocalDataSourceImpl({@required this.sharedPreferences});

  ///
  /// Instantiation of the SharedPreferences library
  ///
  static final String _startsWithDate = 'starts_with_date';

  /// ------------------------------------------------------------
  /// Method that returns the user starts with date
  /// ------------------------------------------------------------
  @override
  Future<String> readStartsWithDate() async {
    return sharedPreferences.getString(_startsWithDate);
  }

  /// ----------------------------------------------------------
  /// Method that saves the user starts with date
  /// ----------------------------------------------------------
  @override
  Future<void> writeStartsWithDate(String value) async {
    await sharedPreferences.setString(_startsWithDate, value);
  }
}
