import 'dart:ffi';

import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';
import 'package:mobile_blitzbudget/core/error/api-exception.dart';
import 'package:mobile_blitzbudget/core/failure/failure.dart';
import 'package:mobile_blitzbudget/data/datasource/remote/dashboard/budget_remote_data_source.dart';
import 'package:mobile_blitzbudget/data/model/budget/budget_model.dart';
import 'package:mobile_blitzbudget/domain/entities/budget/budget.dart';
import 'package:mobile_blitzbudget/domain/repositories/dashboard/budget_repository.dart';

class BudgetRepositoryImpl extends BudgetRepository {
  final BudgetRemoteDataSource budgetRemoteDataSource;

  BudgetRepositoryImpl({
    @required this.budgetRemoteDataSource,
  });

  @override
  Future<Either<Failure, void>> update(Budget updateBudget) async {
    try {
      await budgetRemoteDataSource.update(updateBudget as BudgetModel);
      return Right(Void);
    } on Exception catch (e) {
      return Left(APIException.convertExceptionToFailure(e));
    }
  }

  @override
  Future<Either<Failure, void>> add(Budget addBudget) async {
    try {
      await budgetRemoteDataSource.add(addBudget as BudgetModel);
      return Right(Void);
    } on Exception catch (e) {
      return Left(APIException.convertExceptionToFailure(e));
    }
  }

  @override
  Future<Either<Failure, void>> get(String walletId, String budgetId) async {
    try {
      // TODO
      /*await budgetRemoteDataSource.get();*/
      return Right(Void);
    } on Exception catch (e) {
      return Left(APIException.convertExceptionToFailure(e));
    }
  }
}
