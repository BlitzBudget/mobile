import 'dart:ffi';

import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';
import 'package:mobile_blitzbudget/core/error/exceptions.dart';
import 'package:mobile_blitzbudget/core/error/failure.dart';
import 'package:mobile_blitzbudget/core/network/network_info.dart';
import 'package:mobile_blitzbudget/data/datasource/remote/dashboard/budget_remote_data_source.dart';
import 'package:mobile_blitzbudget/data/model/budget/budget_model.dart';
import 'package:mobile_blitzbudget/domain/entities/budget/budget.dart';
import 'package:mobile_blitzbudget/domain/repositories/dashboard/budget_repository.dart';

class BudgetRepositoryImpl extends BudgetRepository {
  final NetworkInfo networkInfo;
  final BudgetRemoteDataSource budgetRemoteDataSource;

  BudgetRepositoryImpl({
    @required this.networkInfo,
    @required this.budgetRemoteDataSource,
  });

  @override
  Future<Either<Failure, void>> update(Budget updateBudget) async {
    if (await networkInfo.isConnected) {
      try {
        await budgetRemoteDataSource.update(updateBudget as BudgetModel);
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
  Future<Either<Failure, void>> add(Budget addBudget) async {
    if (await networkInfo.isConnected) {
      try {
        await budgetRemoteDataSource.add(addBudget as BudgetModel);
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
  Future<Either<Failure, void>> get(String walletId, String budgetId) async {
    if (await networkInfo.isConnected) {
      try {
        // TODO
        /*await budgetRemoteDataSource.get();*/
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
