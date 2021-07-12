import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

import '../../../domain/usecases/authentication/forgot_password.dart'
    as forgot_password_usecase;
import '../../../domain/usecases/authentication/login_user.dart'
    as login_usecase;
import '../../constants/constants.dart' as constants;

part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  LoginBloc(this._loginUser, this._forgotPassword)
      : assert(_loginUser != null),
        assert(_forgotPassword != null),
        super(Empty());

  final login_usecase.LoginUser _loginUser;
  final forgot_password_usecase.ForgotPassword _forgotPassword;

  @override
  Stream<LoginState> mapEventToState(
    LoginEvent event,
  ) async* {
    if (event is LoginUser) {
      yield Loading();

      final userResponse = await _loginUser.loginUser(
          email: event.username, password: event.password);

      yield userResponse.fold(
        (failure) =>
            const Error(message: constants.INVALID_INPUT_FAILURE_MESSAGE),
        (_) => Success(),
      );
    } else if (event is ForgotPassword) {
      yield Loading();

      final forgotPasswordResponse =
          await _forgotPassword.forgotPassword(email: event.username);

      yield forgotPasswordResponse.fold(
        (failure) =>
            const Error(message: constants.INVALID_INPUT_FAILURE_MESSAGE),
        (_) => Success(),
      );
    }
  }
}
