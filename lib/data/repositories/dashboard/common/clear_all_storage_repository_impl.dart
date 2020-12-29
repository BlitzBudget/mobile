import 'dart:async';

import 'package:shared_preferences/shared_preferences.dart';
import '../../../../domain/repositories/dashboard/common/default_wallet_local_data_source.dart';

class ClearAllStorageRepositoryImpl implements ClearAllStorageRepository {
final SharedPreferences sharedPreferences;
    final FlutterSecureStorage flutterSecureStorage;

    ClearAllStorageRepositoryImpl({@required this.sharedPreferences, @required this.flutterSecureStorage});

    Future<void> clearAllStorage() async {
        await preferences.clear();
        await flutterSecureStorage.deleteAll();
    }
}
