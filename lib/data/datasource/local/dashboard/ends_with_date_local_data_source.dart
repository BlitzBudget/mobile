import 'package:shared_preferences/shared_preferences.dart';

abstract class EndsWithDateLocalDataSource {
  Future<String> readEndsWithDate();

  Future<void> writeEndsWithDate(String value);
}

class _EndsWithDateLocalDataSourceImpl implements EndsWithDateLocalDataSource {
  final SharedPreferences sharedPreferences;

  _EndsWithDateLocalDataSourceImpl({@required this.sharedPreferences});

  ///
  /// Instantiation of the SharedPreferences library
  ///
  static final String _endsWithDate = "ends_with_date";

  /// ------------------------------------------------------------
  /// Method that returns the user ends with date
  /// ------------------------------------------------------------
  @override
  Future<String> readEndsWithDate() async {
    return await _storage.read(key: _endsWithDate);
  }

  /// ----------------------------------------------------------
  /// Method that saves the user ends with date
  /// ----------------------------------------------------------
  @override
  Future<void> writeEndsWithDate(String value) async {
    await _storage.write(key: _endsWithDate, value: value);
  }
}
