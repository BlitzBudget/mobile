import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';
import 'package:mobile_blitzbudget/core/error/api-exception.dart';
import 'package:mobile_blitzbudget/core/failure/failure.dart';
import 'package:mobile_blitzbudget/data/datasource/remote/dashboard/overview_remote_data_source.dart';
import 'package:mobile_blitzbudget/domain/entities/response/overview_response.dart';
import 'package:mobile_blitzbudget/domain/repositories/dashboard/overview_repository.dart';

class OverviewRepositoryImpl implements OverviewRepository {
  final OverviewRemoteDataSource overviewRemoteDataSource;

  OverviewRepositoryImpl({@required this.overviewRemoteDataSource});

  @override
  Future<Either<Failure, OverviewResponse>> get(String startsWithDate, String endsWithDate,
      String defaultWallet, String userId) async {
    try {
      return Right(await overviewRemoteDataSource.get(
          startsWithDate, endsWithDate, defaultWallet, userId));
    } on Exception catch (e) {
      return Left(APIException.convertExceptionToFailure(e));
    }
  }
}
