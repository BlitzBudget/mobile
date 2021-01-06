import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';
import 'package:mobile_blitzbudget/core/error/authentication-exception.dart';
import 'package:mobile_blitzbudget/core/failure/failure.dart';
import 'package:mobile_blitzbudget/domain/entities/response/user_response.dart';
import 'package:mobile_blitzbudget/domain/repositories/authentication/authentication_repository.dart';

import '../../datasource/remote/authentication_remote_data_source.dart';

class AuthenticationRepositoryImpl implements AuthenticationRepository {
  final AuthenticationRemoteDataSource authenticationRemoteDataSource;

  AuthenticationRepositoryImpl({@required this.authenticationRemoteDataSource});

  @override
  Future<Either<Failure, UserResponse>> loginUser(
      String email, String password) async {
    try {
      return Right(
          await authenticationRemoteDataSource.attemptLogin(email, password));
    } on Exception catch (e) {
      return Left(AuthenticationException.convertExceptionToFailure(e));
    }
  }

  @override
  Future<Either<Failure, void>> signupUser(String email, String password,
      String firstName, String surName, String acceptLanguage) async {
    try {
      return Right(await authenticationRemoteDataSource.signupUser(
          email, password, firstName, surName, acceptLanguage));
    } on Exception catch (e) {
      return Left(AuthenticationException.convertExceptionToFailure(e));
    }
  }

  @override
  Future<Either<Failure, void>> verifyEmail(String email, String password,
      String verificationCode, bool useVerifyURL) async {
    try {
      return Right(await authenticationRemoteDataSource.verifyEmail(
          email, password, verificationCode, useVerifyURL));
    } on Exception catch (e) {
      return Left(AuthenticationException.convertExceptionToFailure(e));
    }
  }

  @override
  Future<Either<Failure, void>> resendVerificationCode(String email) async {
    try {
      return Right(
          await authenticationRemoteDataSource.resendVerificationCode(email));
    } on Exception catch (e) {
      return Left(AuthenticationException.convertExceptionToFailure(e));
    }
  }

  @override
  Future<Either<Failure, void>> forgotPassword(
      String email, String password) async {
    try {
      return Right(await authenticationRemoteDataSource.forgotPassword(email));
    } on Exception catch (e) {
      return Left(AuthenticationException.convertExceptionToFailure(e));
    }
  }
}
