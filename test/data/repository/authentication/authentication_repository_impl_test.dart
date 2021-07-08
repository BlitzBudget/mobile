import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_blitzbudget/core/error/api_exception.dart';
import 'package:mobile_blitzbudget/core/error/authentication_exception.dart';
import 'package:mobile_blitzbudget/core/failure/authorization_failure.dart';
import 'package:mobile_blitzbudget/core/failure/failure.dart';
import 'package:mobile_blitzbudget/core/failure/generic_failure.dart';
import 'package:mobile_blitzbudget/data/datasource/remote/authentication/authentication_remote_data_source.dart';
import 'package:mobile_blitzbudget/data/repositories/authentication/authentication_repository_impl.dart';
import 'package:mobile_blitzbudget/domain/repositories/authentication/authentication_repository.dart';
import 'package:mockito/mockito.dart';

class MockAuthenticationRemoteDataSource extends Mock
    implements AuthenticationRemoteDataSource {}

void main() {
  MockAuthenticationRemoteDataSource mockAuthenticationRemoteDataSource;
  AuthenticationRepositoryImpl authenticationRepositoryImpl;

  const email = 'nagarjun_nagesh@outlook.com';
  const password = '12345678';
  const verificationCode = '1234';

  setUp(() {
    mockAuthenticationRemoteDataSource = MockAuthenticationRemoteDataSource();
    authenticationRepositoryImpl = AuthenticationRepositoryImpl(
        authenticationRemoteDataSource: mockAuthenticationRemoteDataSource);
  });
  test(
    'Should be a subclass of AuthenticationRepository entity',
    () async {
      // assert
      expect(authenticationRepositoryImpl, isA<AuthenticationRepository>());
    },
  );

  group('Login User', () {
    test('Should return Generic Authorization Failure', () async {
      when(mockAuthenticationRemoteDataSource.attemptLogin(
              email: '', password: ''))
          .thenThrow(UserNotFoundException());
      final loginInfo =
          await authenticationRepositoryImpl.loginUser(email: '', password: '');

      /// Expect an exception to be thrown
      final f = loginInfo.fold<Failure>((f) => f, (_) => GenericFailure());
      expect(loginInfo.isLeft(), equals(true));
      expect(f, equals(RedirectToSignupDueToFailure()));
    });

    test('Should return Generic Authorization Failure', () async {
      when(mockAuthenticationRemoteDataSource.signupUser(
              email: '', password: ''))
          .thenThrow(EmptyAuthorizationTokenException());
      final loginInfo = await authenticationRepositoryImpl.signupUser(
          email: '', password: '');

      /// Expect an exception to be thrown
      final f = loginInfo.fold<Failure>((f) => f, (_) => GenericFailure());
      verify(mockAuthenticationRemoteDataSource.signupUser(
          email: '', password: ''));
      expect(loginInfo.isLeft(), equals(true));
      expect(f, equals(GenericAuthorizationFailure()));
    });
  });

  group('Verify Email', () {
    test('Should verify email', () async {
      const eitherUserResponseMonad = Right<Failure, void>('');
      when(mockAuthenticationRemoteDataSource.verifyEmail(
              email: email,
              password: password,
              verificationCode: verificationCode,
              useVerifyURL: true))
          .thenAnswer((_) => Future.value(eitherUserResponseMonad));
      final verifyUserResponse = await authenticationRepositoryImpl.verifyEmail(
          email: email,
          password: password,
          verificationCode: verificationCode,
          useVerifyURL: true);
      expect(verifyUserResponse.isRight(), true);
      verify(mockAuthenticationRemoteDataSource.verifyEmail(
          email: email,
          password: password,
          verificationCode: verificationCode,
          useVerifyURL: true));
    });

    test('Should return Generic Authorization Failure', () async {
      when(mockAuthenticationRemoteDataSource.verifyEmail(
              email: email,
              password: password,
              verificationCode: verificationCode,
              useVerifyURL: true))
          .thenThrow(EmptyAuthorizationTokenException());
      final verifyUserResponse = await authenticationRepositoryImpl.verifyEmail(
          email: email,
          password: password,
          verificationCode: verificationCode,
          useVerifyURL: true);

      /// Expect an exception to be thrown
      final f =
          verifyUserResponse.fold<Failure>((f) => f, (_) => GenericFailure());
      verify(mockAuthenticationRemoteDataSource.verifyEmail(
          email: email,
          password: password,
          verificationCode: verificationCode,
          useVerifyURL: true));
      expect(verifyUserResponse.isLeft(), equals(true));
      expect(f, equals(GenericAuthorizationFailure()));
    });
  });

  group('Success: resendVerificationCode', () {
    test('Should receive a successful response', () async {
      const eitherUserResponseMonad = Right<Failure, void>('');
      when(mockAuthenticationRemoteDataSource.resendVerificationCode(email))
          .thenAnswer((_) => Future.value(eitherUserResponseMonad));
      final verifyUserResponse =
          await authenticationRepositoryImpl.resendVerificationCode(email);
      expect(verifyUserResponse.isRight(), true);
      verify(mockAuthenticationRemoteDataSource.resendVerificationCode(email));
    });

    test('Should return Generic Authorization Failure', () async {
      when(mockAuthenticationRemoteDataSource.resendVerificationCode(email))
          .thenThrow(EmptyAuthorizationTokenException());
      final verifyUserResponse =
          await authenticationRepositoryImpl.resendVerificationCode(email);

      /// Expect an exception to be thrown
      final f =
          verifyUserResponse.fold<Failure>((f) => f, (_) => GenericFailure());
      verify(mockAuthenticationRemoteDataSource.resendVerificationCode(email));
      expect(verifyUserResponse.isLeft(), equals(true));
      expect(f, equals(GenericAuthorizationFailure()));
    });
  });

  group('Success: forgotPassword', () {
    test('Should receive a successful response', () async {
      const eitherUserResponseMonad = Right<Failure, void>('');
      when(mockAuthenticationRemoteDataSource.forgotPassword(email))
          .thenAnswer((_) => Future.value(eitherUserResponseMonad));
      final verifyUserResponse =
          await authenticationRepositoryImpl.forgotPassword(email: email);
      expect(verifyUserResponse.isRight(), true);
      verify(mockAuthenticationRemoteDataSource.forgotPassword(email));
    });

    test('Should return Generic Authorization Failure', () async {
      when(mockAuthenticationRemoteDataSource.forgotPassword(email))
          .thenThrow(EmptyAuthorizationTokenException());
      final verifyUserResponse =
          await authenticationRepositoryImpl.forgotPassword(email: email);

      /// Expect an exception to be thrown
      final f =
          verifyUserResponse.fold<Failure>((f) => f, (_) => GenericFailure());
      verify(mockAuthenticationRemoteDataSource.forgotPassword(email));
      expect(verifyUserResponse.isLeft(), equals(true));
      expect(f, equals(GenericAuthorizationFailure()));
    });
  });
}
