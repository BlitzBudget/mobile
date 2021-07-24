import 'dart:async';
import 'dart:ffi';
import 'package:dartz/dartz.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:mobile_blitzbudget/core/failure/failure.dart';
import 'package:mobile_blitzbudget/core/failure/generic_failure.dart';
import 'package:mobile_blitzbudget/domain/repositories/dashboard/common/clear_all_storage_repository.dart';

import 'package:shared_preferences/shared_preferences.dart';

class ClearAllStorageRepositoryImpl implements ClearAllStorageRepository {
  ClearAllStorageRepositoryImpl(
      {required this.sharedPreferences, required this.flutterSecureStorage});

  late final SharedPreferences sharedPreferences;
  late final FlutterSecureStorage flutterSecureStorage;

  @override
  Future<Either<Failure, void>> clearAllStorage() async {
    final deleted = await sharedPreferences.clear();

    if (!deleted) {
      return Left(EmptyResponseFailure());
    }

    return Right(await flutterSecureStorage.deleteAll());
  }
}
