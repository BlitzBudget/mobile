import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_blitzbudget/app/ploc/authentication/change_password/change_password_bloc.dart';
import 'package:mobile_blitzbudget/core/failure/authorization_failure.dart';
import 'package:mobile_blitzbudget/core/failure/failure.dart';
import 'package:mobile_blitzbudget/core/failure/generic_failure.dart';
import 'package:mobile_blitzbudget/domain/usecases/dashboard/common/clear_all_storage_use_case.dart';
import 'package:mobile_blitzbudget/domain/usecases/authentication/change_password.dart'
    as change_password_usecase;
import 'package:mocktail/mocktail.dart';

class MockClearAllStorageUseCase extends Mock
    implements ClearAllStorageUseCase {}

class MockChangePassword extends Mock
    implements change_password_usecase.ChangePassword {}

void main() {
  const NEW_PASS = 'newPass';
  const OLD_PASS = 'oldPass';
  // ignore: unused_local_variable
  late ChangePasswordBloc changePasswordBloc;
  late MockClearAllStorageUseCase mockClearAllStorageUseCase;
  late MockChangePassword mockChangePassword;
  const positiveMonadResponse = Right<Failure, void>('');

  setUp(() {
    mockClearAllStorageUseCase = MockClearAllStorageUseCase();
    mockChangePassword = MockChangePassword();
  });

  group('Success: ChangePasswordBloc', () {
    blocTest<ChangePasswordBloc, ChangePasswordState>(
      'Emits [Loading, Success] states for successful task load',
      build: () {
        changePasswordBloc = ChangePasswordBloc(
          clearAllStorageUseCase: mockClearAllStorageUseCase,
          changePassword: mockChangePassword,
        );
        when(() => mockChangePassword.changePassword(
                oldPassword: OLD_PASS, newPassword: NEW_PASS))
            .thenAnswer((_) => Future.value(positiveMonadResponse));

        return changePasswordBloc;
      },
      act: (bloc) => bloc.add(
          const ChangePassword(newPassword: NEW_PASS, oldPassword: OLD_PASS)),
      expect: () => [Loading(), Success()],
    );
  });

  group('Error: ChangePasswordBloc', () {
    blocTest<ChangePasswordBloc, ChangePasswordState>(
      'Emits [Loading, RedirectToLogin] states for EmptyResponse response',
      build: () {
        final changePasswordResponseLeft =
            Left<Failure, void>(EmptyResponseFailure());
        changePasswordBloc = ChangePasswordBloc(
          clearAllStorageUseCase: mockClearAllStorageUseCase,
          changePassword: mockChangePassword,
        );

        when(() => mockChangePassword.changePassword(
                oldPassword: OLD_PASS, newPassword: NEW_PASS))
            .thenAnswer((_) => Future.value(changePasswordResponseLeft));
        when(() => mockClearAllStorageUseCase.delete())
            .thenAnswer((_) => Future.value(positiveMonadResponse));

        return changePasswordBloc;
      },
      act: (bloc) => bloc.add(
          const ChangePassword(newPassword: NEW_PASS, oldPassword: OLD_PASS)),
      expect: () => [
        Loading(),
        RedirectToLogin(),
      ],
    );

    blocTest<ChangePasswordBloc, ChangePasswordState>(
      'Emits [Loading, Error] states for GenericFailure response',
      build: () {
        final changePasswordResponseLeft =
            Left<Failure, void>(GenericFailure());
        changePasswordBloc = ChangePasswordBloc(
          clearAllStorageUseCase: mockClearAllStorageUseCase,
          changePassword: mockChangePassword,
        );

        when(() => mockChangePassword.changePassword(
                oldPassword: OLD_PASS, newPassword: NEW_PASS))
            .thenAnswer((_) => Future.value(changePasswordResponseLeft));
        when(() => mockClearAllStorageUseCase.delete())
            .thenAnswer((_) => Future.value(positiveMonadResponse));

        return changePasswordBloc;
      },
      act: (bloc) => bloc.add(
          const ChangePassword(newPassword: NEW_PASS, oldPassword: OLD_PASS)),
      expect: () => [
        Loading(),
        const Error(
            message:
                'An error occured while changing password in. Please try again later!')
      ],
    );

    blocTest<ChangePasswordBloc, ChangePasswordState>(
      'Emits [Loading, RedirectToSignup] states for RedirectToSignupDueToFailure response',
      build: () {
        final changePasswordResponseLeft =
            Left<Failure, void>(RedirectToSignupDueToFailure());
        changePasswordBloc = ChangePasswordBloc(
          clearAllStorageUseCase: mockClearAllStorageUseCase,
          changePassword: mockChangePassword,
        );

        when(() => mockChangePassword.changePassword(
                oldPassword: OLD_PASS, newPassword: NEW_PASS))
            .thenAnswer((_) => Future.value(changePasswordResponseLeft));
        when(() => mockClearAllStorageUseCase.delete())
            .thenAnswer((_) => Future.value(positiveMonadResponse));

        return changePasswordBloc;
      },
      act: (bloc) => bloc.add(
          const ChangePassword(newPassword: NEW_PASS, oldPassword: OLD_PASS)),
      expect: () => [
        Loading(),
        RedirectToSignup(),
      ],
    );

    blocTest<ChangePasswordBloc, ChangePasswordState>(
      'Emits [Loading, RedirectToSignup] states for RedirectToVerificationDueToFailure response',
      build: () {
        final changePasswordResponseLeft =
            Left<Failure, void>(RedirectToVerificationDueToFailure());
        changePasswordBloc = ChangePasswordBloc(
          clearAllStorageUseCase: mockClearAllStorageUseCase,
          changePassword: mockChangePassword,
        );

        when(() => mockChangePassword.changePassword(
                oldPassword: OLD_PASS, newPassword: NEW_PASS))
            .thenAnswer((_) => Future.value(changePasswordResponseLeft));
        when(() => mockClearAllStorageUseCase.delete())
            .thenAnswer((_) => Future.value(positiveMonadResponse));

        return changePasswordBloc;
      },
      act: (bloc) => bloc.add(
          const ChangePassword(newPassword: NEW_PASS, oldPassword: OLD_PASS)),
      expect: () => [
        Loading(),
        RedirectToVerification(),
      ],
    );
  });
}
