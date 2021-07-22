import 'package:dartz/dartz.dart';
import 'package:mobile_blitzbudget/core/failure/failure.dart';
import 'package:mobile_blitzbudget/domain/entities/response/user_response.dart';

abstract class AuthTokenRepository {
  Future<Either<Failure, String>> readAuthToken();

  Future<void> writeAuthToken(UserResponse? userResponse);
}
