import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';
import 'package:mobile_blitzbudget/core/error/api-exception.dart';
import 'package:mobile_blitzbudget/core/failure/failure.dart';
import 'package:mobile_blitzbudget/data/datasource/remote/dashboard/goal_remote_data_source.dart';
import 'package:mobile_blitzbudget/data/model/goal/goal_model.dart';
import 'package:mobile_blitzbudget/domain/entities/goal/goal.dart';
import 'package:mobile_blitzbudget/domain/entities/response/goal_response.dart';
import 'package:mobile_blitzbudget/domain/repositories/dashboard/goal_repository.dart';

class GoalRepositoryImpl implements GoalRepository {
  final GoalRemoteDataSource goalRemoteDataSource;

  GoalRepositoryImpl({@required this.goalRemoteDataSource});

  @override
  Future<Either<Failure, void>> add(Goal addGoal) async {
    try {
      return Right(await goalRemoteDataSource.add(addGoal as GoalModel));
    } on Exception catch (e) {
      return Left(APIException.convertExceptionToFailure(e));
    }
  }

  @override
  Future<Either<Failure, void>> update(Goal updateGoal) async {
    try {
      return Right(await goalRemoteDataSource.update(updateGoal as GoalModel));
    } on Exception catch (e) {
      return Left(APIException.convertExceptionToFailure(e));
    }
  }

  @override
  Future<Either<Failure, GoalResponse>> fetch(String startsWithDate,
      String endsWithDate, String defaultWallet, String userId) async {
    try {
      return Right(await goalRemoteDataSource.fetch(
          startsWithDate, endsWithDate, defaultWallet, userId));
    } on Exception catch (e) {
      return Left(APIException.convertExceptionToFailure(e));
    }
  }
}
