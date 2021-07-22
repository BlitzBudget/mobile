import 'package:dartz/dartz.dart';
import 'package:mobile_blitzbudget/core/failure/failure.dart';
import 'package:mobile_blitzbudget/domain/entities/response/user_response.dart';

abstract class AccessTokenRepository {
  Future<Either<Failure, String>> readAccessToken();

  Future<void> writeAccessToken(UserResponse? userResponse);
}
