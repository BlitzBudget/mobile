import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_blitzbudget/app/ploc/authentication/login/login_bloc.dart';
import 'package:mobile_blitzbudget/app/ploc/authentication/login/login_constants.dart'
    as constants;
import 'package:mobile_blitzbudget/core/failure/authorization_failure.dart';
import 'package:mobile_blitzbudget/core/failure/failure.dart';
import 'package:mobile_blitzbudget/domain/entities/response/user_response.dart';
import 'package:mobile_blitzbudget/domain/usecases/authentication/forgot_password.dart'
    as forgot_password_usecase;
import 'package:mobile_blitzbudget/domain/usecases/authentication/login_user.dart'
    as login_user_usecase;
import 'package:mocktail/mocktail.dart';

class MockForgotPassword extends Mock
    implements forgot_password_usecase.ForgotPassword {}

class MockLoginUser extends Mock implements login_user_usecase.LoginUser {}

void main() {
  // ignore: unused_local_variable
  late LoginBloc loginBloc;
  late MockForgotPassword mockForgotPassword;
  late MockLoginUser mockLoginUser;
  const VALID_EMAIL = 'n123@gmail.com';
  const VALID_PASSWORD = 'P1234gs.';
  const INVALID_EMAIL = 'gmail';
  const INVALID_PASSWORD = 'P1234gs';

  setUp(() {
    mockForgotPassword = MockForgotPassword();
    mockLoginUser = MockLoginUser();
  });

  group('Success: LoginBloc', () {
    blocTest<LoginBloc, LoginState>(
      'Emits [Loading, RedirectToDashboard] states for successful task load',
      build: () {
        const userResponse = Some(UserResponse());
        const positiveMonadResponse =
            Right<Failure, Option<UserResponse>>(userResponse);
        loginBloc = LoginBloc(
          forgotPassword: mockForgotPassword,
          loginUser: mockLoginUser,
        );
        when(() => mockLoginUser.loginUser(
                email: VALID_EMAIL, password: VALID_PASSWORD))
            .thenAnswer((_) => Future.value(positiveMonadResponse));

        return loginBloc;
      },
      act: (bloc) => bloc.add(
          const LoginUser(username: VALID_EMAIL, password: VALID_PASSWORD)),
      expect: () => [Loading(), RedirectToDashboard()],
    );
  });

  group('ERROR: LoginBloc', () {
    blocTest<LoginBloc, LoginState>(
      'Emits [Loading, Error] states for invalid email',
      build: () {
        return LoginBloc(
          forgotPassword: mockForgotPassword,
          loginUser: mockLoginUser,
        );
      },
      act: (bloc) => bloc.add(
          const LoginUser(username: INVALID_EMAIL, password: VALID_PASSWORD)),
      expect: () => [Loading(), const Error(message: constants.EMAIL_INVALID)],
    );

    blocTest<LoginBloc, LoginState>(
      'Emits [Loading, Error] states for invalid password',
      build: () {
        return LoginBloc(
          forgotPassword: mockForgotPassword,
          loginUser: mockLoginUser,
        );
      },
      act: (bloc) => bloc.add(
          const LoginUser(username: VALID_EMAIL, password: INVALID_PASSWORD)),
      expect: () =>
          [Loading(), const Error(message: constants.PASSWORD_INVALID)],
    );

    blocTest<LoginBloc, LoginState>(
      'Emits [Loading, Error] states for empty password',
      build: () {
        return LoginBloc(
          forgotPassword: mockForgotPassword,
          loginUser: mockLoginUser,
        );
      },
      act: (bloc) =>
          bloc.add(const LoginUser(username: VALID_EMAIL, password: '')),
      expect: () => [Loading(), const Error(message: constants.PASSWORD_EMPTY)],
    );

    blocTest<LoginBloc, LoginState>(
      'Emits [Loading, RedirectToSignup] states for RedirectToSignup',
      build: () {
        final leftMonadResponse =
            Left<Failure, Option<UserResponse>>(RedirectToSignupDueToFailure());
        loginBloc = LoginBloc(
          forgotPassword: mockForgotPassword,
          loginUser: mockLoginUser,
        );
        when(() => mockLoginUser.loginUser(
                email: VALID_EMAIL, password: VALID_PASSWORD))
            .thenAnswer((_) => Future.value(leftMonadResponse));

        return loginBloc;
      },
      act: (bloc) => bloc.add(
          const LoginUser(username: VALID_EMAIL, password: VALID_PASSWORD)),
      expect: () => [Loading(), RedirectToSignup()],
    );

    blocTest<LoginBloc, LoginState>(
      'Emits [Loading, RedirectToVerification] states for RedirectToVerification',
      build: () {
        final leftMonadResponse = Left<Failure, Option<UserResponse>>(
            RedirectToVerificationDueToFailure());
        loginBloc = LoginBloc(
          forgotPassword: mockForgotPassword,
          loginUser: mockLoginUser,
        );
        when(() => mockLoginUser.loginUser(
                email: VALID_EMAIL, password: VALID_PASSWORD))
            .thenAnswer((_) => Future.value(leftMonadResponse));

        return loginBloc;
      },
      act: (bloc) => bloc.add(
          const LoginUser(username: VALID_EMAIL, password: VALID_PASSWORD)),
      expect: () => [Loading(), RedirectToVerification()],
    );

    blocTest<LoginBloc, LoginState>(
      'Emits [Loading, Error] states for Invalid Credentials',
      build: () {
        final leftMonadResponse =
            Left<Failure, Option<UserResponse>>(InvalidCredentialsFailure());
        loginBloc = LoginBloc(
          forgotPassword: mockForgotPassword,
          loginUser: mockLoginUser,
        );
        when(() => mockLoginUser.loginUser(
                email: VALID_EMAIL, password: VALID_PASSWORD))
            .thenAnswer((_) => Future.value(leftMonadResponse));

        return loginBloc;
      },
      act: (bloc) => bloc.add(
          const LoginUser(username: VALID_EMAIL, password: VALID_PASSWORD)),
      expect: () => [
        Loading(),
        const Error(message: constants.INVALID_INPUT_LOGIN_FAILURE_MESSAGE)
      ],
    );
  });
}
