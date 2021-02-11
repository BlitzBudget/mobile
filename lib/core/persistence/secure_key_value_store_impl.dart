import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:mobile_blitzbudget/core/error/generic_exception.dart';
import 'package:mobile_blitzbudget/core/utils/utils.dart';

import 'secure_key_value_store.dart';

class SecureKeyValueStoreImpl implements SecureKeyValueStore {
  final FlutterSecureStorage flutterSecureStorage;

  SecureKeyValueStoreImpl({@required this.flutterSecureStorage});

  @override
  Future<String> getString({@required String key}) async {
    var value = await flutterSecureStorage.read(key: key);
    // Throw an exception when the data is empty
    if (isEmpty(value)) {
      throw NoValueInCacheException();
    }

    return Future.value(value);
  }

  @override
  Future<void> setString({@required String value, @required String key}) async {
    return flutterSecureStorage.write(key: key, value: value);
  }
}
