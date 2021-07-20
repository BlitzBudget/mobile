import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:mobile_blitzbudget/core/failure/authorization_failure.dart';
import 'package:mobile_blitzbudget/core/failure/failure.dart';

import '../../../domain/usecases/authentication/verify_user.dart'
    as verify_usecase;
import 'verify_constants.dart' as constants;

part 'verify_event.dart';
part 'verify_state.dart';

class VerifyBloc extends Bloc<VerifyEvent, VerifyState> {
  VerifyBloc({@required this.verifyUser})
      : assert(verifyUser != null),
        super(Empty());

  final verify_usecase.VerifyUser verifyUser;

  @override
  Stream<VerifyState> mapEventToState(
    VerifyEvent event,
  ) async* {
    if (event is ResendVerificatonCode) {
      yield Loading();

      yield* processResendVerificationCode(event);
    } else if (event is VerifyUser) {
      yield Loading();

      yield* processVerify(event);
    }
  }

  Stream<VerifyState> processResendVerificationCode(
      ResendVerificatonCode event) async* {
    final email = event.email.toLowerCase().trim();
    final resendVerificationResponse =
        await verifyUser.resendVerificationCode(email: email);
    yield resendVerificationResponse.fold(
      _convertToMessage,
      (_) => ResendVerificationCodeSuccessful(),
    );
  }

  Stream<VerifyState> processVerify(VerifyUser event) async* {
    if (event.verificationCode == null && event.verificationCode.isEmpty) {
      yield const Error(message: constants.VERIFICATION_CODE_EMPTY);
    } else if (event.verificationCode.length != 6) {
      yield const Error(message: constants.VERIFICATION_CODE_LENGTH_MISMATCH);
    } else {
      yield Loading();

      final email = event.email.toLowerCase().trim();
      final verifyUserResponse = await verifyUser.verifyUser(
          email: email,
          password: event.password,
          useVerifyURL: event.useVerifyURL,
          verificationCode: event.verificationCode);

      yield verifyUserResponse.fold(
        _convertToMessage,
        (_) => RedirectToDashboard(),
      );
    }
  }

  VerifyState _convertToMessage(Failure failure) {
    debugPrint('Converting verify failure to message ${failure.toString()} ');
    if (failure is RedirectToLoginDueToFailure) {
      return RedirectToLogin();
    } else if (failure is RedirectToSignupDueToFailure) {
      return RedirectToSignup();
    } else if (failure is RedirectToVerificationDueToFailure) {
      return RedirectToLogin();
    }

    return const Error(message: constants.GENERIC_FAILURE_MESSAGE);
  }
}
