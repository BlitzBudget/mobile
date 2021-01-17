import 'package:flutter/material.dart';
import 'package:mobile_blitzbudget/core/error/generic_exception.dart';
import 'package:mobile_blitzbudget/core/utils/utils.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'key_value_store.dart';

class KeyValueStoreImpl implements KeyValueStore {
  final SharedPreferences sharedPreferences;

  KeyValueStoreImpl({@required this.sharedPreferences});

  @override
  Future<String> getString({@required String key}) async {
    var value = sharedPreferences.getString(key);
    // Throw an exception when the data is empty
    if (isEmpty(value)) {
      throw NoValueInCacheException();
    }

    return Future.value(value);
  }

  @override
  Future<void> setString({@required String value, @required String key}) async {
    return sharedPreferences.setString(key, value);
  }
}
