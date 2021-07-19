import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:mobile_blitzbudget/core/failure/failure.dart';
import 'package:mobile_blitzbudget/domain/repositories/authentication/authentication_repository.dart';
import 'package:mobile_blitzbudget/domain/usecases/use_case.dart';

class VerifyUser extends UseCase {
  VerifyUser({@required this.authenticationRepository});

  final AuthenticationRepository authenticationRepository;

  Future<Either<Failure, void>> verifyUser(
      {@required String email,
      @required String password,
      @required String verificationCode,
      @required bool useVerifyURL}) async {
    return authenticationRepository.verifyEmail(
        email: email,
        password: password,
        verificationCode: verificationCode,
        useVerifyURL: useVerifyURL);
  }

  Future<Either<Failure, void>> resendVerificationCode(
      {@required String email}) async {
    return authenticationRepository.resendVerificationCode(email);
  }
}
