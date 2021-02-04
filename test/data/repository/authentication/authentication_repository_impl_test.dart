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
      var loginInfo =
          await authenticationRepositoryImpl.loginUser(email: '', password: '');

      /// Expect an exception to be thrown
      var f = loginInfo.fold<Failure>((f) => f, (_) => GenericFailure());
      expect(loginInfo.isLeft(), equals(true));
      expect(f, equals(RedirectToSignupDueToFailure()));
    });

    test('Should return Generic Authorization Failure', () async {
      when(mockAuthenticationRemoteDataSource.signupUser(
              email: '', password: ''))
          .thenThrow(EmptyAuthorizationTokenException());
      var loginInfo = await authenticationRepositoryImpl.signupUser(
          email: '', password: '');

      /// Expect an exception to be thrown
      var f = loginInfo.fold<Failure>((f) => f, (_) => GenericFailure());
      verify(mockAuthenticationRemoteDataSource.signupUser(
          email: '', password: ''));
      expect(loginInfo.isLeft(), equals(true));
      expect(f, equals(GenericAuthorizationFailure()));
    });
  });
}
