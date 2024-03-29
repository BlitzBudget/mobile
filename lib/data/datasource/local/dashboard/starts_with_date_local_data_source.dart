import 'package:mobile_blitzbudget/core/persistence/key_value_store.dart';

abstract class StartsWithDateLocalDataSource {
  Future<String> readStartsWithDate();

  Future<void> writeStartsWithDate(String value);
}

class StartsWithDateLocalDataSourceImpl
    implements StartsWithDateLocalDataSource {
  StartsWithDateLocalDataSourceImpl({required this.keyValueStore});

  final KeyValueStore? keyValueStore;

  ///
  /// Instantiation of the SharedPreferences library
  ///
  static const String _startsWithDate = 'starts_with_date';

  /// ------------------------------------------------------------
  /// Method that returns the user starts with date
  /// ------------------------------------------------------------
  @override
  Future<String> readStartsWithDate() async {
    return keyValueStore!.getString(key: _startsWithDate);
  }

  /// ----------------------------------------------------------
  /// Method that saves the user starts with date
  /// ----------------------------------------------------------
  @override
  Future<void> writeStartsWithDate(String value) async {
    await keyValueStore!.setString(key: _startsWithDate, value: value);
  }
}
