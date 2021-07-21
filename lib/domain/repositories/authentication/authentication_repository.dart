import 'package:dartz/dartz.dart';
import 'package:mobile_blitzbudget/core/failure/failure.dart';
import 'package:mobile_blitzbudget/domain/entities/response/user_response.dart';

abstract class AuthenticationRepository {
  Future<Either<Failure, Option<UserResponse>>> loginUser(
      {required String email, required String? password});

  Future<Either<Failure, void>> signupUser(
      {required String email, required String? password});

  Future<Either<Failure, void>> verifyEmail(
      {required String email,
      required String? password,
      required String? verificationCode,
      required bool? useVerifyURL});

  Future<Either<Failure, void>> resendVerificationCode(String email);

  Future<Either<Failure, void>> forgotPassword({required String? email});
}
