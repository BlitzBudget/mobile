import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'secure_key_value_store.dart';

class SecureKeyValueStoreImpl implements SecureKeyValueStore {
  final FlutterSecureStorage flutterSecureStorage;

  SecureKeyValueStoreImpl({@required this.flutterSecureStorage});

  @override
  Future<String> getString({String key}) async {
    return flutterSecureStorage.read(key: key);
  }

  @override
  Future<void> setString({String value, String key}) async {
    return flutterSecureStorage.write(key: key, value: value);
  }
}
