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
  SignupBloc({required this.signupUser}) : super(Empty()) {
    on<LoginUser>((event, emit) => emit(RedirectToLogin()));
    on<SignupUser>(_onSignupUser);
  }

  final signup_usecase.SignupUser signupUser;

  Future<void> _onSignupUser(
      SignupUser event, Emitter<SignupState> emit) async {
    emit(Loading());
    await processSignup(event, emit);
  }

  Future<void> processSignup(
      SignupUser event, Emitter<SignupState> emit) async {
    if (event.confirmPassword == null || event.confirmPassword!.isEmpty) {
      emit(const Error(message: constants.CONFIRM_PASSWORD_EMPTY));
    } else if (event.confirmPassword != event.password) {
      emit(const Error(message: constants.PASSWORD_MISMATCH));
    } else if (!app_constants.passwordExp.hasMatch(event.password!)) {
      emit(const Error(message: constants.PASSWORD_INVALID));
    } else {
      final email = event.username!.toLowerCase().trim();
      final signupUserResponse = await signupUser.signupUser(
          email: email, password: event.confirmPassword);

      emit(signupUserResponse.fold(
        _convertToMessage,
        (_) => RedirectToVerification(),
      ));
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
