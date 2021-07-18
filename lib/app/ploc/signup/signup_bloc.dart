import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:mobile_blitzbudget/core/failure/authorization_failure.dart';
import 'package:mobile_blitzbudget/core/failure/failure.dart';

import '../../../domain/usecases/authentication/signup_user.dart'
    as signup_usecase;
import './signup_constants.dart' as constants;

part 'signup_event.dart';
part 'signup_state.dart';

class SignupBloc extends Bloc<SignupEvent, SignupState> {
  SignupBloc({@required this.signupUser})
      : assert(signupUser != null),
        super(Empty());

  final signup_usecase.SignupUser signupUser;

  @override
  Stream<SignupState> mapEventToState(
    SignupEvent event,
  ) async* {
    if (event is LoginUser) {
      yield RedirectToLogin();
    } else if (event is SignupUser) {
      yield Loading();

      final signupUserResponse = await signupUser.signupUser(
          email: event.username, password: event.password);

      yield signupUserResponse.fold(
        _convertToMessage,
        (_) => RedirectToVerification(),
      );
    }
  }

  SignupState _convertToMessage(Failure failure) {
    debugPrint('Converting signup failure to message ${failure.toString()} ');
    if (failure is RedirectToLoginDueToFailure) {
      return RedirectToLogin();
    }

    return const Error(message: constants.GENERIC_FAILURE_MESSAGE);
  }
}
