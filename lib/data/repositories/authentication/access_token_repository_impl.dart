import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';
import 'package:mobile_blitzbudget/core/error/generic_exception.dart';
import 'package:mobile_blitzbudget/core/failure/failure.dart';
import 'package:mobile_blitzbudget/domain/entities/response/user_response.dart';
import 'package:mobile_blitzbudget/domain/repositories/authentication/access_token_repository.dart'
    show AccessTokenRepository;

import '../../datasource/local/authentication/access_token_local_data_source.dart';

class AccessTokenRepositoryImpl implements AccessTokenRepository {
  AccessTokenRepositoryImpl({@required this.accessTokenLocalDataSource});

  final AccessTokenLocalDataSource accessTokenLocalDataSource;

  @override
  Future<Either<Failure, String>> readAccessToken() async {
    try {
      return Right(await accessTokenLocalDataSource.readAccessToken());
    } on Exception catch (e) {
      return Left(GenericException.convertExceptionToFailure(e));
    }
  }

  @override
  Future<void> writeAccessToken(UserResponse userResponse) async {
    return accessTokenLocalDataSource
        .writeAccessToken(userResponse.accessToken);
  }
}
