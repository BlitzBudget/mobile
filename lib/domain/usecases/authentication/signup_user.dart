import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:mobile_blitzbudget/core/failure/failure.dart';
import 'package:mobile_blitzbudget/domain/repositories/authentication/authentication_repository.dart';
import 'package:mobile_blitzbudget/domain/usecases/use_case.dart';

class SignupUser extends UseCase {
  final AuthenticationRepository authenticationRepository;

  SignupUser({@required this.authenticationRepository});

  Future<Either<Failure, void>> signupUser(
      {@required String email, @required String password}) async {
    return authenticationRepository.signupUser(
        email: email, password: password);
  }
}

// TODO
/*
/// Change all the email to lower case and trim the string
    email = email.toLowerCase().trim();
if (isEmpty(confirmPassword)) {
      displayDialog(
          context, 'Empty Password', 'The confirm password cannot be empty');
      return;
    } else if (!passwordExp.hasMatch(confirmPassword)) {
      displayDialog(
          context, 'Invalid Password', 'The confirm password is not valid');
      return;
    } else if (confirmPassword != password) {
      displayDialog(context, 'Password Mismatch',
          'The confirm password and the password do not match');
      return;
    }*/
