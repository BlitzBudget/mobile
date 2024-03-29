import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:mobile_blitzbudget/core/error/generic_exception.dart';
import 'package:mobile_blitzbudget/core/utils/utils.dart';

import 'secure_key_value_store.dart';

class SecureKeyValueStoreImpl implements SecureKeyValueStore {
  SecureKeyValueStoreImpl({required this.flutterSecureStorage});

  final FlutterSecureStorage? flutterSecureStorage;

  @override
  Future<String> getString({required String key}) async {
    final value = await flutterSecureStorage!.read(key: key);
    // Throw an exception when the data is empty
    if (isEmpty(value)) {
      throw NoValueInCacheException();
    }

    return Future.value(value);
  }

  @override
  Future<void> setString({required String? value, required String key}) async {
    await flutterSecureStorage!.write(key: key, value: value);
  }
}
