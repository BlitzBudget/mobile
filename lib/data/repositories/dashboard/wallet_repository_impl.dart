import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';
import 'package:mobile_blitzbudget/core/error/api-exception.dart';
import 'package:mobile_blitzbudget/core/failure/failure.dart';
import 'package:mobile_blitzbudget/data/datasource/remote/dashboard/wallet_remote_data_source.dart';
import 'package:mobile_blitzbudget/data/model/wallet/wallet_model.dart';
import 'package:mobile_blitzbudget/domain/entities/wallet/wallet.dart';
import 'package:mobile_blitzbudget/domain/repositories/dashboard/wallet_repository.dart';

class WalletRepositoryImpl implements WalletRepository {
  final WalletRemoteDataSource walletRemoteDataSource;

  WalletRepositoryImpl({@required this.walletRemoteDataSource});

  @override
  Future<Either<Failure, List<Wallet>>> get(String startsWithDate,
      String endsWithDate, String defaultWallet, String userId) async {
    try {
      return Right(await walletRemoteDataSource.get(
          startsWithDate, endsWithDate, defaultWallet, userId));
    } on Exception catch (e) {
      return Left(APIException.convertExceptionToFailure(e));
    }
  }

  @override
  Future<Either<Failure, void>> add(String userId, String currency) async {
    try {
      return Right(await walletRemoteDataSource.add(userId, currency));
    } on Exception catch (e) {
      return Left(APIException.convertExceptionToFailure(e));
    }
  }

  @override
  Future<Either<Failure, void>> update(Wallet updateWallet) async {
    try {
      return Right(
          await walletRemoteDataSource.update(updateWallet as WalletModel));
    } on Exception catch (e) {
      return Left(APIException.convertExceptionToFailure(e));
    }
  }

  @override
  Future<Either<Failure, void>> delete(String walletId, String userId) async {
    try {
      return Right(await walletRemoteDataSource.delete(walletId, userId));
    } on Exception catch (e) {
      return Left(APIException.convertExceptionToFailure(e));
    }
  }
}
