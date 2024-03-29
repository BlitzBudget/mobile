import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:mobile_blitzbudget/core/failure/authorization_failure.dart';
import 'package:mobile_blitzbudget/core/failure/failure.dart';
import 'package:mobile_blitzbudget/core/failure/generic_failure.dart';

import './change_password_constants.dart' as constants;
import '../../../../domain/usecases/authentication/change_password.dart'
    as change_password_usecase;
import '../../../../domain/usecases/dashboard/common/clear_all_storage_use_case.dart'
    as clear_all_storage_usecase;

part 'change_password_event.dart';
part 'change_password_state.dart';

class ChangePasswordBloc
    extends Bloc<ChangePasswordEvent, ChangePasswordState> {
  ChangePasswordBloc(
      {required this.changePassword, required this.clearAllStorageUseCase})
      : super(Empty()) {
    on<ChangePassword>(_onChangePassword);
  }

  final change_password_usecase.ChangePassword changePassword;
  final clear_all_storage_usecase.ClearAllStorageUseCase clearAllStorageUseCase;

  Future<void> _onChangePassword(
      ChangePasswordEvent event, Emitter<ChangePasswordState> emit) async {
    emit(Loading());

    if (event is ChangePassword) {
      final changePasswordResponse = await changePassword.changePassword(
          oldPassword: event.oldPassword!, newPassword: event.newPassword!);

      await changePasswordResponse.fold(
        (failure) async {
          await _convertToMessage(failure, emit);
        },
        (_) {
          emit(Success());
        },
      );
    }
  }

  Future<void> _convertToMessage(
      Failure failure, Emitter<ChangePasswordState> emit) async {
    debugPrint(
        'Converting change password failure to message ${failure.toString()} ');
    if (failure is EmptyResponseFailure ||
        failure is InvalidCredentialsFailure) {
      await clearAllStorageUseCase.delete();
      emit(RedirectToLogin());
    } else if (failure is RedirectToSignupDueToFailure) {
      emit(RedirectToSignup());
    } else if (failure is RedirectToVerificationDueToFailure) {
      emit(RedirectToVerification());
    } else {
      emit(const Error(
          message: constants.GENERIC_CHANGE_PASSWORD_FAILURE_MESSAGE));
    }
  }
}
