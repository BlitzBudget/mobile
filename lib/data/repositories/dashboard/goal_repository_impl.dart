import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';
import 'package:mobile_blitzbudget/core/error/api_exception.dart';
import 'package:mobile_blitzbudget/core/failure/failure.dart';
import 'package:mobile_blitzbudget/data/datasource/remote/dashboard/goal_remote_data_source.dart';
import 'package:mobile_blitzbudget/domain/entities/goal/goal.dart';
import 'package:mobile_blitzbudget/domain/entities/response/goal_response.dart';
import 'package:mobile_blitzbudget/domain/repositories/dashboard/goal_repository.dart';

class GoalRepositoryImpl implements GoalRepository {
  

  GoalRepositoryImpl({@required this.goalRemoteDataSource});

  final GoalRemoteDataSource goalRemoteDataSource;

  @override
  Future<Either<Failure, void>> add(Goal addGoal) async {
    try {
      return Right(await goalRemoteDataSource.add(addGoal));
    } on Exception catch (e) {
      return Left(APIException.convertExceptionToFailure(e));
    }
  }

  @override
  Future<Either<Failure, void>> update(Goal updateGoal) async {
    try {
      return Right(await goalRemoteDataSource.update(updateGoal));
    } on Exception catch (e) {
      return Left(APIException.convertExceptionToFailure(e));
    }
  }

  @override
  Future<Either<Failure, GoalResponse>> fetch(
      {@required String startsWithDate,
      @required String endsWithDate,
      @required String defaultWallet,
      @required String userId}) async {
    try {
      return Right(await goalRemoteDataSource.fetch(
          startsWithDate: startsWithDate,
          endsWithDate: endsWithDate,
          defaultWallet: defaultWallet,
          userId: userId));
    } on Exception catch (e) {
      return Left(APIException.convertExceptionToFailure(e));
    }
  }
}
