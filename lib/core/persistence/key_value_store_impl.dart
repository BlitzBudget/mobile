import 'package:mobile_blitzbudget/core/error/generic_exception.dart';
import 'package:mobile_blitzbudget/core/utils/utils.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'key_value_store.dart';

class KeyValueStoreImpl implements KeyValueStore {
  KeyValueStoreImpl({required this.sharedPreferences});

  final SharedPreferences? sharedPreferences;

  @override
  Future<String> getString({required String key}) async {
    final value = sharedPreferences!.getString(key);
    // Throw an exception when the data is empty
    if (isEmpty(value)) {
      throw NoValueInCacheException();
    }

    return Future.value(value);
  }

  @override
  Future<void> setString({required String value, required String key}) async {
    await sharedPreferences!.setString(key, value);
  }
}
