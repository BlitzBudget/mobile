import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:mobile_blitzbudget/core/failure/authorization_failure.dart';
import 'package:mobile_blitzbudget/core/failure/failure.dart';

import './signup_constants.dart' as constants;
import '../../../../domain/usecases/authentication/signup_user.dart'
    as signup_usecase;
import '../../../constants/constants.dart' as app_constants;

part 'signup_event.dart';
part 'signup_state.dart';

class SignupBloc extends Bloc<SignupEvent, SignupState> {
  SignupBloc({required this.signupUser}) : super(Empty());

  final signup_usecase.SignupUser signupUser;

  @override
  Stream<SignupState> mapEventToState(
    SignupEvent event,
  ) async* {
    if (event is LoginUser) {
      yield RedirectToLogin();
    } else if (event is SignupUser) {
      yield Loading();

      yield* processSignup(event);
    }
  }

  Stream<SignupState> processSignup(SignupUser event) async* {
    if (event.confirmPassword == null || event.confirmPassword!.isEmpty) {
      yield const Error(message: constants.CONFIRM_PASSWORD_EMPTY);
    } else if (event.confirmPassword != event.password) {
      yield const Error(message: constants.PASSWORD_MISMATCH);
    } else if (!app_constants.passwordExp.hasMatch(event.password!)) {
      yield const Error(message: constants.PASSWORD_INVALID);
    } else {
      final email = event.username!.toLowerCase().trim();
      final signupUserResponse = await signupUser.signupUser(
          email: email, password: event.confirmPassword);

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
    } else if (failure is RedirectToSignupDueToFailure) {
      return RedirectToSignup();
    } else if (failure is RedirectToVerificationDueToFailure) {
      return RedirectToVerification();
    }

    return const Error(message: constants.GENERIC_FAILURE_MESSAGE);
  }
}
