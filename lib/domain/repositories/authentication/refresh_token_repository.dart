import 'package:dartz/dartz.dart';
import 'package:mobile_blitzbudget/core/failure/failure.dart';
import 'package:mobile_blitzbudget/domain/entities/response/user_response.dart';

abstract class RefreshTokenRepository {
  Future<Either<Failure, String?>> readRefreshToken();

  Future<void> writeRefreshToken(UserResponse? userResponse);
}
