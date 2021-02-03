import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:mobile_blitzbudget/core/failure/failure.dart';
import 'package:mobile_blitzbudget/domain/repositories/authentication/authentication_repository.dart';
import 'package:mobile_blitzbudget/domain/usecases/use_case.dart';

class VerifyUser extends UseCase {
  final AuthenticationRepository authenticationRepository;

  VerifyUser({@required this.authenticationRepository});

  Future<Either<Failure, void>> verifyUser(
      {@required String email,
      @required String password,
      @required String verificationCode,
      @required bool useVerifyURL}) async {
    return await authenticationRepository.verifyEmail(
        email: email,
        password: password,
        verificationCode: verificationCode,
        useVerifyURL: useVerifyURL);
  }

  Future<Either<Failure, void>> resendVerificationCode(
      {@required String email}) async {
    return await authenticationRepository.resendVerificationCode(email);
  }
}

// TODO
/*
/// Change all the email to lower case and trim the string
    email = email.toLowerCase().trim();
/// Attempt to login after completing verification
      await attemptLogin(context, email, password);*/
