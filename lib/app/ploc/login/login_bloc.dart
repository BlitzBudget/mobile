import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:email_validator/email_validator.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

import '../../../core/failure/authorization_failure.dart';
import '../../../core/failure/failure.dart';
import '../../../domain/usecases/authentication/forgot_password.dart'
    as forgot_password_usecase;
import '../../../domain/usecases/authentication/login_user.dart'
    as login_usecase;
import '../../constants/constants.dart' as app_constants;
import './login_constants.dart' as constants;

part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  LoginBloc({required this.loginUser, required this.forgotPassword})
      : super(Empty());

  late final login_usecase.LoginUser loginUser;
  late final forgot_password_usecase.ForgotPassword forgotPassword;

  @override
  Stream<LoginState> mapEventToState(
    LoginEvent event,
  ) async* {
    yield Loading();

    yield* processLoginOrFotgotPassword(event);
  }

  Stream<LoginState> processLoginOrFotgotPassword(LoginEvent event) async* {
    debugPrint('Bloc Login executed for the user ${event.username} ');

    final email = event.username?.toLowerCase().trim() ?? '';
    if (!EmailValidator.validate(email)) {
      yield const Error(message: constants.EMAIL_INVALID);
    } else if (event.password == null || event.password!.isEmpty) {
      yield const Error(message: constants.PASSWORD_EMPTY);
    } else if (!app_constants.passwordExp.hasMatch(event.password!)) {
      yield const Error(message: constants.PASSWORD_INVALID);
    } else {
      yield* _processAPICall(event, email);
    }
  }

  Stream<LoginState> _processAPICall(LoginEvent event, String email) async* {
    if (event is LoginUser) {
      final userResponse =
          await loginUser.loginUser(email: email, password: event.password);

      yield userResponse.fold(
        _convertToMessage,
        (_) => RedirectToDashboard(),
      );
    } else if (event is ForgotPassword) {
      final forgotPasswordResponse =
          await forgotPassword.forgotPassword(email: event.username);

      yield forgotPasswordResponse.fold(
        _convertToMessage,
        (_) => RedirectToVerification(),
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
