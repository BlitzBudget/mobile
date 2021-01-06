import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';
import 'package:mobile_blitzbudget/core/failure/failure.dart';
import 'package:mobile_blitzbudget/core/failure/generic-failure.dart';
import 'package:mobile_blitzbudget/data/datasource/local/dashboard/default_wallet_local_data_source.dart';
import 'package:mobile_blitzbudget/domain/repositories/dashboard/common/default_wallet_repository.dart';

class DefaultWalletRepositoryImpl implements DefaultWalletRepository {
  final DefaultWalletLocalDataSource defaultWalletLocalDataSource;

  DefaultWalletRepositoryImpl({@required this.defaultWalletLocalDataSource});

  @override
  Future<Either<Failure, String>> readDefaultWallet() async {
    try {
      return Right(await defaultWalletLocalDataSource.readDefaultWallet());
    } on Exception {
      return Left(EmptyResponseFailure());
    }
  }

  @override
  Future<void> writeDefaultWallet(String value) async {
    return await defaultWalletLocalDataSource.writeDefaultWallet(value);
  }
}
