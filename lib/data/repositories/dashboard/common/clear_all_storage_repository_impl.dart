import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:mobile_blitzbudget/domain/repositories/dashboard/common/clear_all_storage_repository.dart';

import 'package:shared_preferences/shared_preferences.dart';

class ClearAllStorageRepositoryImpl implements ClearAllStorageRepository {
  final SharedPreferences sharedPreferences;
  final FlutterSecureStorage flutterSecureStorage;

  ClearAllStorageRepositoryImpl(
      {@required this.sharedPreferences, @required this.flutterSecureStorage});

  @override
  Future<void> clearAllStorage() async {
    await sharedPreferences.clear();
    await flutterSecureStorage.deleteAll();
  }
}
