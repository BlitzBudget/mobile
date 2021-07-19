import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:email_validator/email_validator.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:mobile_blitzbudget/core/failure/authorization_failure.dart';
import 'package:mobile_blitzbudget/core/failure/failure.dart';

import '../../../domain/usecases/authentication/forgot_password.dart'
    as forgot_password_usecase;
import '../../../domain/usecases/authentication/login_user.dart'
    as login_usecase;
import './login_constants.dart' as constants;

part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  LoginBloc({@required this.loginUser, @required this.forgotPassword})
      : assert(loginUser != null),
        assert(forgotPassword != null),
        super(Empty());

  final login_usecase.LoginUser loginUser;
  final forgot_password_usecase.ForgotPassword forgotPassword;

  @override
  Stream<LoginState> mapEventToState(
    LoginEvent event,
  ) async* {
    if (event is LoginUser) {
      yield Loading();

      yield* processLogin(event);
    } else if (event is ForgotPassword) {
      yield Loading();

      final forgotPasswordResponse =
          await forgotPassword.forgotPassword(email: event.username);

      yield forgotPasswordResponse.fold(
        (failure) =>
            const Error(message: constants.INVALID_INPUT_LOGIN_FAILURE_MESSAGE),
        (_) => RedirectToVerification(),
      );
    }
  }

  Stream<LoginState> processLogin(LoginUser event) async* {
    debugPrint('Bloc Login executed for the user ${event.username} ');

    final email = event.username.toLowerCase().trim();
    if (!EmailValidator.validate(email)) {
      yield const Error(message: constants.EMAIL_INVALID);
    } else if (event.password == null && event.password.isEmpty) {
      yield const Error(message: constants.PASSWORD_EMPTY);
    } else {
      final userResponse =
          await loginUser.loginUser(email: email, password: event.password);

      yield userResponse.fold(
        _convertToMessage,
        (_) => RedirectToDashboard(),
      );
    }
  }

  LoginState _convertToMessage(Failure failure) {
    debugPrint('Converting login failure to message ${failure.toString()} ');
    if (failure is RedirectToSignupDueToFailure) {
      return RedirectToSignup();
    } else if (failure is RedirectToVerificationDueToFailure) {
      return RedirectToVerification();
    } else if (failure is InvalidCredentialsFailure) {
      return const Error(
          message: constants.INVALID_INPUT_LOGIN_FAILURE_MESSAGE);
    }

    return const Error(message: constants.GENERIC_LOGIN_FAILURE_MESSAGE);
  }
}
