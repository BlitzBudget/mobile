import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';
import 'package:mobile_blitzbudget/core/error/api_exception.dart';
import 'package:mobile_blitzbudget/core/failure/failure.dart';
import 'package:mobile_blitzbudget/data/datasource/remote/dashboard/wallet_remote_data_source.dart';
import 'package:mobile_blitzbudget/domain/entities/response/wallet_response.dart';
import 'package:mobile_blitzbudget/domain/entities/wallet/wallet.dart';
import 'package:mobile_blitzbudget/domain/repositories/dashboard/wallet_repository.dart';

class WalletRepositoryImpl implements WalletRepository {
  WalletRepositoryImpl({@required this.walletRemoteDataSource});

  final WalletRemoteDataSource walletRemoteDataSource;

  @override
  Future<Either<Failure, List<Wallet>>> fetch(
      {@required String startsWithDate,
      @required String endsWithDate,
      @required String defaultWallet,
      @required String userId}) async {
    try {
      final WalletResponse walletResponse = await walletRemoteDataSource.fetch(
          startsWithDate: startsWithDate,
          endsWithDate: endsWithDate,
          defaultWallet: defaultWallet,
          userId: userId);
      return Right(walletResponse.wallets);
    } on Exception catch (e) {
      return Left(APIException.convertExceptionToFailure(e));
    }
  }

  @override
  Future<Either<Failure, void>> add(
      {@required String userId, @required String currency}) async {
    try {
      return Right(
          await walletRemoteDataSource.add(userId: userId, currency: currency));
    } on Exception catch (e) {
      return Left(APIException.convertExceptionToFailure(e));
    }
  }

  @override
  Future<Either<Failure, void>> update(Wallet updateWallet) async {
    try {
      return Right(await walletRemoteDataSource.update(updateWallet));
    } on Exception catch (e) {
      return Left(APIException.convertExceptionToFailure(e));
    }
  }

  @override
  Future<Either<Failure, void>> delete(
      {@required String walletId, @required String userId}) async {
    try {
      return Right(await walletRemoteDataSource.delete(
          walletId: walletId, userId: userId));
    } on Exception catch (e) {
      return Left(APIException.convertExceptionToFailure(e));
    }
  }
}
