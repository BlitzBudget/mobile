import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'key_value_store.dart';

class KeyValueStoreImpl implements KeyValueStore {
  final SharedPreferences sharedPreferences;

  KeyValueStoreImpl({@required this.sharedPreferences});

  @override
  Future<String> getString({String key}) async {
    return sharedPreferences.getString(key);
  }

  @override
  Future<void> setString({String value, String key}) async {
    return sharedPreferences.setString(key, value);
  }
}
