import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:mobile_blitzbudget/core/failure/authorization_failure.dart';
import 'package:mobile_blitzbudget/core/failure/failure.dart';

import '../../../../domain/usecases/authentication/verify_user.dart'
    as verify_usecase;
import 'verify_constants.dart' as constants;

part 'verify_event.dart';
part 'verify_state.dart';

class VerifyBloc extends Bloc<VerifyEvent, VerifyState> {
  VerifyBloc({required this.verifyUser}) : super(Empty()) {
    on<ResendVerificatonCode>(_onResendVerificatonCode);
    on<VerifyUser>(_onVerifyUser);
  }

  final verify_usecase.VerifyUser verifyUser;

  Future<void> _onResendVerificatonCode(
      ResendVerificatonCode event, Emitter<VerifyState> emit) async {
    emit(Loading());

    await processResendVerificationCode(event, emit);
  }

  Future<void> _onVerifyUser(
      VerifyUser event, Emitter<VerifyState> emit) async {
    emit(Loading());

    await processVerify(event, emit);
  }

  Future<void> processResendVerificationCode(
      ResendVerificatonCode event, Emitter<VerifyState> emit) async {
    final email = event.email!.toLowerCase().trim();
    final resendVerificationResponse =
        await verifyUser.resendVerificationCode(email: email);
    emit(resendVerificationResponse.fold(
      _convertToMessage,
      (_) => ResendVerificationCodeSuccessful(),
    ));
  }

  Future<void> processVerify(
      VerifyUser event, Emitter<VerifyState> emit) async {
    if (event.verificationCode == null && event.verificationCode!.isEmpty) {
      emit(const Error(message: constants.VERIFICATION_CODE_EMPTY));
    } else if (event.verificationCode!.length != 6) {
      emit(const Error(message: constants.VERIFICATION_CODE_LENGTH_MISMATCH));
    } else {
      emit(Loading());

      final email = event.email!.toLowerCase().trim();
      final verifyUserResponse = await verifyUser.verifyUser(
          email: email,
          password: event.password,
          useVerifyURL: event.useVerifyURL,
          verificationCode: event.verificationCode);

      emit(verifyUserResponse.fold(
        _convertToMessage,
        (_) => RedirectToDashboard(),
      ));
    }
  }

  VerifyState _convertToMessage(Failure failure) {
    debugPrint('Converting verify failure to message ${failure.toString()} ');
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
