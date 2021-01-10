import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';
import 'package:mobile_blitzbudget/core/error/api_exception.dart';
import 'package:mobile_blitzbudget/core/failure/failure.dart';
import 'package:mobile_blitzbudget/data/datasource/remote/dashboard/overview_remote_data_source.dart';
import 'package:mobile_blitzbudget/domain/entities/response/overview_response.dart';
import 'package:mobile_blitzbudget/domain/repositories/dashboard/overview_repository.dart';

class OverviewRepositoryImpl implements OverviewRepository {
  final OverviewRemoteDataSource overviewRemoteDataSource;

  OverviewRepositoryImpl({@required this.overviewRemoteDataSource});

  @override
  Future<Either<Failure, OverviewResponse>> fetch(
      {@required String startsWithDate,
      @required String endsWithDate,
      @required String defaultWallet,
      @required String userId}) async {
    try {
      return Right(await overviewRemoteDataSource.fetch(
          startsWithDate: startsWithDate,
          endsWithDate: endsWithDate,
          defaultWallet: defaultWallet,
          userId: userId));
    } on Exception catch (e) {
      return Left(APIException.convertExceptionToFailure(e));
    }
  }
}
