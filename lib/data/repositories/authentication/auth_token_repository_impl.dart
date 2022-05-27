import 'package:dartz/dartz.dart';
import 'package:mobile_blitzbudget/core/error/generic_exception.dart';
import 'package:mobile_blitzbudget/core/failure/failure.dart';
import 'package:mobile_blitzbudget/domain/entities/response/user_response.dart';
import 'package:mobile_blitzbudget/domain/repositories/authentication/auth_token_repository.dart';

import '../../datasource/local/authentication/auth_token_local_data_source.dart'
    show AuthTokenLocalDataSource;

class AuthTokenRepositoryImpl implements AuthTokenRepository {
  AuthTokenRepositoryImpl({required this.authTokenLocalDataSource});

  final AuthTokenLocalDataSource authTokenLocalDataSource;

  @override
  Future<Either<Failure, String>> readAuthToken() async {
    try {
      return Right(await authTokenLocalDataSource.readAuthToken());
    } on Exception catch (e) {
      return Left(GenericException.convertExceptionToFailure(e));
    }
  }

  @override
  Future<void> writeAuthToken(UserResponse? userResponse) async {
    return authTokenLocalDataSource
        .writeAuthToken(userResponse!.authenticationToken);
  }
}
