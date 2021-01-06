import 'package:dartz/dartz.dart';
import 'package:mobile_blitzbudget/core/failure/failure.dart';
import 'package:mobile_blitzbudget/domain/entities/response/user_response.dart';

abstract class AuthenticationRepository {
  Future<Either<Failure, UserResponse>> loginUser(
      String email, String password);

  Future<Either<Failure, void>> signupUser(String email, String password,
      String firstName, String surName, String acceptHeaders);

  Future<Either<Failure, void>> verifyEmail(String email, String password,
      String verificationCode, bool useVerifyURL);

  Future<Either<Failure, void>> resendVerificationCode(String email);

  Future<Either<Failure, void>> forgotPassword(String email, String password);
}
