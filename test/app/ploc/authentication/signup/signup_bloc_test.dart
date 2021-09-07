import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_blitzbudget/app/ploc/authentication/signup/signup_bloc.dart';
import 'package:mobile_blitzbudget/core/failure/authorization_failure.dart';
import 'package:mobile_blitzbudget/core/failure/failure.dart';
import 'package:mobile_blitzbudget/domain/usecases/authentication/signup_user.dart'
    as signup_usecase;
import 'package:mobile_blitzbudget/app/ploc/authentication/signup/signup_constants.dart'
    as constants;
import 'package:mocktail/mocktail.dart';

class MockSignupUser extends Mock implements signup_usecase.SignupUser {}

void main() {
  late MockSignupUser mockSignupUser;
  const VALID_EMAIL = 'n123@gmail.com';
  const VALID_PASSWORD = 'P1234gs.';
  const INVALID_PASSWORD = 'P1234gs';
  const positiveMonadResponse = Right<Failure, void>('');

  setUp(() {
    mockSignupUser = MockSignupUser();
  });

  group('Success: SignupBloc', () {
    blocTest<SignupBloc, SignupState>(
      'Emits [RedirectToLogin] states for login task load',
      build: () {
        return SignupBloc(
          signupUser: mockSignupUser,
        );
      },
      act: (bloc) => bloc.add(const LoginUser()),
      expect: () => [RedirectToLogin()],
    );

    blocTest<SignupBloc, SignupState>(
      'Emits [Loading, RedirectToVerification] states for successful signup',
      build: () {
        when(() => mockSignupUser.signupUser(
                email: VALID_EMAIL, password: VALID_PASSWORD))
            .thenAnswer((_) => Future.value(positiveMonadResponse));
        return SignupBloc(
          signupUser: mockSignupUser,
        );
      },
      act: (bloc) => bloc.add(const SignupUser(
          username: VALID_EMAIL,
          password: VALID_PASSWORD,
          confirmPassword: VALID_PASSWORD)),
      expect: () => [Loading(), RedirectToVerification()],
    );
  });

  group('Error: SignupBloc', () {
    blocTest<SignupBloc, SignupState>(
      'Emits [Loading, Error] states for invalid password',
      build: () {
        return SignupBloc(
          signupUser: mockSignupUser,
        );
      },
      act: (bloc) => bloc.add(const SignupUser(
          username: VALID_EMAIL,
          password: INVALID_PASSWORD,
          confirmPassword: INVALID_PASSWORD)),
      expect: () =>
          [Loading(), const Error(message: constants.PASSWORD_INVALID)],
    );

    blocTest<SignupBloc, SignupState>(
      'Emits [Loading, Error] states for empty confirm password',
      build: () {
        return SignupBloc(
          signupUser: mockSignupUser,
        );
      },
      act: (bloc) => bloc.add(const SignupUser(
          username: VALID_EMAIL,
          password: VALID_PASSWORD,
          confirmPassword: '')),
      expect: () =>
          [Loading(), const Error(message: constants.CONFIRM_PASSWORD_EMPTY)],
    );

    blocTest<SignupBloc, SignupState>(
      'Emits [Loading, Error] states for password mismatch',
      build: () {
        return SignupBloc(
          signupUser: mockSignupUser,
        );
      },
      act: (bloc) => bloc.add(const SignupUser(
          username: VALID_EMAIL,
          password: VALID_PASSWORD,
          confirmPassword: INVALID_PASSWORD)),
      expect: () =>
          [Loading(), const Error(message: constants.PASSWORD_MISMATCH)],
    );

    blocTest<SignupBloc, SignupState>(
      'Emits [Loading, RedirectToLogin] states for RedirectToLoginDueToFailure failure',
      build: () {
        final failureResponse =
            Left<Failure, void>(RedirectToLoginDueToFailure());
        when(() => mockSignupUser.signupUser(
                email: VALID_EMAIL, password: VALID_PASSWORD))
            .thenAnswer((_) => Future.value(failureResponse));
        return SignupBloc(
          signupUser: mockSignupUser,
        );
      },
      act: (bloc) => bloc.add(const SignupUser(
          username: VALID_EMAIL,
          password: VALID_PASSWORD,
          confirmPassword: VALID_PASSWORD)),
      expect: () => [Loading(), RedirectToLogin()],
    );

    blocTest<SignupBloc, SignupState>(
      'Emits [Loading, RedirectToSignup] states for RedirectToSignupDueToFailure failure',
      build: () {
        final failureResponse =
            Left<Failure, void>(RedirectToSignupDueToFailure());
        when(() => mockSignupUser.signupUser(
                email: VALID_EMAIL, password: VALID_PASSWORD))
            .thenAnswer((_) => Future.value(failureResponse));
        return SignupBloc(
          signupUser: mockSignupUser,
        );
      },
      act: (bloc) => bloc.add(const SignupUser(
          username: VALID_EMAIL,
          password: VALID_PASSWORD,
          confirmPassword: VALID_PASSWORD)),
      expect: () => [Loading(), RedirectToSignup()],
    );

    blocTest<SignupBloc, SignupState>(
      'Emits [Loading, RedirectToVerification] states for RedirectToVerificationDueToFailure failure',
      build: () {
        final failureResponse =
            Left<Failure, void>(RedirectToVerificationDueToFailure());
        when(() => mockSignupUser.signupUser(
                email: VALID_EMAIL, password: VALID_PASSWORD))
            .thenAnswer((_) => Future.value(failureResponse));
        return SignupBloc(
          signupUser: mockSignupUser,
        );
      },
      act: (bloc) => bloc.add(const SignupUser(
          username: VALID_EMAIL,
          password: VALID_PASSWORD,
          confirmPassword: VALID_PASSWORD)),
      expect: () => [Loading(), RedirectToVerification()],
    );
  });
}
