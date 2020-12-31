import 'dart:ffi';

import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';
import 'package:mobile_blitzbudget/core/error/exceptions.dart';
import 'package:mobile_blitzbudget/core/error/failure.dart';
import 'package:mobile_blitzbudget/core/network/network_info.dart';
import 'package:mobile_blitzbudget/data/datasource/remote/dashboard/bank_account_remote_data_source.dart';
import 'package:mobile_blitzbudget/data/model/bank-account/bank_account_model.dart';
import 'package:mobile_blitzbudget/domain/entities/bank-account/bank_account.dart';
import 'package:mobile_blitzbudget/domain/repositories/dashboard/bank_account_repository.dart';

class BankAccountRepositoryImpl extends BankAccountRepository {
  final NetworkInfo networkInfo;
  final BankAccountRemoteDataSource bankAccountRemoteDataSource;

  BankAccountRepositoryImpl({
    @required this.networkInfo,
    @required this.bankAccountRemoteDataSource,
  });

  @override
  Future<Either<Failure, void>> update(BankAccount updateBankAccount) async {
    if (await networkInfo.isConnected) {
      try {
        await bankAccountRemoteDataSource
            .update(updateBankAccount as BankAccountModel);
        return Right(Void);
      } on UnableToRefreshTokenException {
        return Left(FetchDataFailure());
      } on EmptyAuthorizationTokenException {
        return Left(FetchDataFailure());
      }
    } else {
      return Left(NetworkConnectivityFailure());
    }
  }

  @override
  Future<Either<Failure, void>> add(BankAccount addBankAccount) async {
    if (await networkInfo.isConnected) {
      try {
        await bankAccountRemoteDataSource
            .add(addBankAccount as BankAccountModel);
        return Right(Void);
      } on UnableToRefreshTokenException {
        return Left(FetchDataFailure());
      } on EmptyAuthorizationTokenException {
        return Left(FetchDataFailure());
      }
    } else {
      return Left(NetworkConnectivityFailure());
    }
  }

  @override
  Future<Either<Failure, void>> delete(String walletId, String account) async {
    if (await networkInfo.isConnected) {
      try {
        await bankAccountRemoteDataSource.delete(walletId, account);
        return Right(Void);
      } on UnableToRefreshTokenException {
        return Left(FetchDataFailure());
      } on EmptyAuthorizationTokenException {
        return Left(FetchDataFailure());
      }
    } else {
      return Left(NetworkConnectivityFailure());
    }
  }
}
