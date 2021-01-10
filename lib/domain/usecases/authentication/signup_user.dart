import 'dart:developer' as developer;

import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:mobile_blitzbudget/core/constants/constants.dart';
import 'package:mobile_blitzbudget/core/failure/failure.dart';
import 'package:mobile_blitzbudget/domain/repositories/authentication/authentication_repository.dart';
import 'package:mobile_blitzbudget/domain/usecases/use_case.dart';
import 'package:devicelocale/devicelocale.dart';

class SignupUser extends UseCase {
  AuthenticationRepository authenticationRepository;

  Future<Either<Failure, void>> forgotPassword(
      {@required String email, @required String password}) async {
    /// Change all the email to lower case and trim the string
    email = email.toLowerCase().trim();

    // Fetch Names
    var fullname = email.split('@')[0];
    var names = fetchNames(fullname);

    var acceptLanguage = await Devicelocale.currentLocale;

    return authenticationRepository.signupUser(
        email: email,
        password: password,
        firstName: names[0],
        surName: names[1],
        acceptLanguage: acceptLanguage);
  }
}

/// Parse the user name with Email
List<String> fetchNames(String fullname) {
  Match match = emailExp.firstMatch(fullname);
  var name = <String>[];

  if (match == null) {
    developer.log('No match found for $fullname');

    /// Sur name cannot be empty
    name.addAll([fullname, ' ']);
  } else {
    // TODO SPLIT the name and then assign it to first and surname
    name.addAll([fullname, ' ']);
    developer.log(
        'Fullname $fullname, First match: ${match.start}, end Match: ${match.input}');
  }

  return name;
}

// TODO
/*

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
