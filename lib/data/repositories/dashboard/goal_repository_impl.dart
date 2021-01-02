import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';
import 'package:mobile_blitzbudget/core/error/api-exception.dart';
import 'package:mobile_blitzbudget/core/failure/failure.dart';
import 'package:mobile_blitzbudget/data/datasource/remote/dashboard/goal_remote_data_source.dart';
import 'package:mobile_blitzbudget/data/model/goal/goal_model.dart';
import 'package:mobile_blitzbudget/domain/repositories/dashboard/goal_repository.dart';

class GoalRepositoryImpl implements GoalRepository {
  final GoalRemoteDataSource goalRemoteDataSource;

  GoalRepositoryImpl({@required this.goalRemoteDataSource});

  @override
  Future<Either<Failure, void>> add(GoalModel addGoal) async {
    try {
      return Right(await goalRemoteDataSource.add(addGoal));
    } on Exception catch (e) {
      return Left(APIException.convertExceptionToFailure(e));
    }
  }

  @override
  Future<Either<Failure, void>> update(GoalModel updateGoal) async {
    try {
      return Right(await goalRemoteDataSource.update(updateGoal));
    } on Exception catch (e) {
      return Left(APIException.convertExceptionToFailure(e));
    }
  }
}
