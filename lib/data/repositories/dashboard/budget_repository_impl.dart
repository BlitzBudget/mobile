import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';
import 'package:mobile_blitzbudget/core/error/api_exception.dart';
import 'package:mobile_blitzbudget/core/failure/failure.dart';
import 'package:mobile_blitzbudget/data/datasource/remote/dashboard/budget_remote_data_source.dart';
import 'package:mobile_blitzbudget/domain/entities/budget/budget.dart';
import 'package:mobile_blitzbudget/domain/entities/response/budget_response.dart';
import 'package:mobile_blitzbudget/domain/repositories/dashboard/budget_repository.dart';

class BudgetRepositoryImpl extends BudgetRepository {
  BudgetRepositoryImpl({
    @required this.budgetRemoteDataSource,
  });

  final BudgetRemoteDataSource budgetRemoteDataSource;

  @override
  Future<Either<Failure, void>> update(Budget updateBudget) async {
    try {
      return Right(
          await budgetRemoteDataSource.update(updateBudget));
    } on Exception catch (e) {
      return Left(APIException.convertExceptionToFailure(e));
    }
  }

  @override
  Future<Either<Failure, void>> add(Budget addBudget) async {
    try {
      return Right(await budgetRemoteDataSource.add(addBudget));
    } on Exception catch (e) {
      return Left(APIException.convertExceptionToFailure(e));
    }
  }

  @override
  Future<Either<Failure, BudgetResponse>> fetch(
      {@required String startsWithDate,
      @required String endsWithDate,
      @required String defaultWallet,
      @required String userId}) async {
    try {
      return Right(await budgetRemoteDataSource.fetch(
          startsWithDate: startsWithDate,
          endsWithDate: endsWithDate,
          defaultWallet: defaultWallet,
          userId: userId));
    } on Exception catch (e) {
      return Left(APIException.convertExceptionToFailure(e));
    }
  }
}
