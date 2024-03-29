import 'package:dartz/dartz.dart';
import 'package:mobile_blitzbudget/core/error/generic_exception.dart';
import 'package:mobile_blitzbudget/core/failure/failure.dart';
import 'package:mobile_blitzbudget/domain/entities/response/user_response.dart';
import 'package:mobile_blitzbudget/domain/repositories/authentication/refresh_token_repository.dart';

import '../../datasource/local/authentication/refresh_token_local_data_source.dart';

class RefreshTokenRepositoryImpl implements RefreshTokenRepository {
  RefreshTokenRepositoryImpl({required this.refreshTokenLocalDataSource});

  final RefreshTokenLocalDataSource? refreshTokenLocalDataSource;

  @override
  Future<Either<Failure, String?>> readRefreshToken() async {
    try {
      return Right(await refreshTokenLocalDataSource!.readRefreshToken());
    } on Exception catch (e) {
      return Left(GenericException.convertExceptionToFailure(e));
    }
  }

  @override
  Future<void> writeRefreshToken(UserResponse? userResponse) async {
    return refreshTokenLocalDataSource!
        .writeRefreshToken(userResponse!.refreshToken);
  }
}
