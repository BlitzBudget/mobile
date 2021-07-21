import 'package:dartz/dartz.dart';
import 'package:mobile_blitzbudget/core/error/authentication_exception.dart';
import 'package:mobile_blitzbudget/core/failure/failure.dart';
import 'package:mobile_blitzbudget/domain/entities/response/user_response.dart';
import 'package:mobile_blitzbudget/domain/repositories/authentication/authentication_repository.dart';

import '../../datasource/remote/authentication/authentication_remote_data_source.dart';

class AuthenticationRepositoryImpl implements AuthenticationRepository {
  AuthenticationRepositoryImpl({required this.authenticationRemoteDataSource});

  final AuthenticationRemoteDataSource? authenticationRemoteDataSource;

  @override
  Future<Either<Failure, Option<UserResponse>>> loginUser(
      {required String email, required String? password}) async {
    try {
      return Right(await authenticationRemoteDataSource!
          .attemptLogin(email: email, password: password));
    } on Exception catch (e) {
      return Left(AuthenticationException.convertExceptionToFailure(e));
    }
  }

  @override
  Future<Either<Failure, void>> signupUser(
      {required String email, required String? password}) async {
    try {
      return Right(await authenticationRemoteDataSource!
          .signupUser(email: email, password: password));
    } on Exception catch (e) {
      return Left(AuthenticationException.convertExceptionToFailure(e));
    }
  }

  @override
  Future<Either<Failure, void>> verifyEmail(
      {required String email,
      required String? password,
      required String? verificationCode,
      required bool? useVerifyURL}) async {
    try {
      return Right(await authenticationRemoteDataSource!.verifyEmail(
          email: email,
          password: password,
          verificationCode: verificationCode,
          useVerifyURL: useVerifyURL));
    } on Exception catch (e) {
      return Left(AuthenticationException.convertExceptionToFailure(e));
    }
  }

  @override
  Future<Either<Failure, void>> resendVerificationCode(String email) async {
    try {
      return Right(
          await authenticationRemoteDataSource!.resendVerificationCode(email));
    } on Exception catch (e) {
      return Left(AuthenticationException.convertExceptionToFailure(e));
    }
  }

  @override
  Future<Either<Failure, void>> forgotPassword({required String? email}) async {
    try {
      return Right(await authenticationRemoteDataSource!.forgotPassword(email));
    } on Exception catch (e) {
      return Left(AuthenticationException.convertExceptionToFailure(e));
    }
  }
}
