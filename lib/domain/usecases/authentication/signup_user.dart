import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:mobile_blitzbudget/core/failure/failure.dart';
import 'package:mobile_blitzbudget/domain/repositories/authentication/authentication_repository.dart';
import 'package:mobile_blitzbudget/domain/usecases/use_case.dart';

class SignupUser extends UseCase {
  SignupUser({@required this.authenticationRepository});

  final AuthenticationRepository authenticationRepository;

  Future<Either<Failure, void>> signupUser(
      {@required String email, @required String password}) async {
    return authenticationRepository.signupUser(
        email: email, password: password);
  }
}
