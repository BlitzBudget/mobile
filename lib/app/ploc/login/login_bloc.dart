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

      debugPrint('Bloc Login executed for the user ${event.username} ');

      final userResponse = await loginUser.loginUser(
          email: event.username, password: event.password);

      yield userResponse.fold(
        (failure) =>
            // TODO Convert Failure to generic messages
            const Error(message: constants.INVALID_INPUT_FAILURE_MESSAGE),
        (_) => Success(),
      );
    } else if (event is ForgotPassword) {
      yield Loading();

      final forgotPasswordResponse =
          await forgotPassword.forgotPassword(email: event.username);

      yield forgotPasswordResponse.fold(
        (failure) =>
            const Error(message: constants.INVALID_INPUT_FAILURE_MESSAGE),
        (_) => Success(),
      );
    }
  }
}
