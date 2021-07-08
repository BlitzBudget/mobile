import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_blitzbudget/core/error/api_exception.dart';
import 'package:mobile_blitzbudget/core/error/authentication_exception.dart';
import 'package:mobile_blitzbudget/core/failure/authorization_failure.dart';

void main() {
  group('Is an AuthenticationException', () {
    test(
      'UserNotFoundException',
      () async {
        final authorizationException = UserNotFoundException();
        // assert
        expect(authorizationException, isA<AuthenticationException>());
      },
    );

    test(
      'UserNotConfirmedException',
      () async {
        final authorizationException = UserNotConfirmedException();
        // assert
        expect(authorizationException, isA<AuthenticationException>());
      },
    );

    test(
      'NotAuthorizedException',
      () async {
        final authorizationException = NotAuthorizedException();
        // assert
        expect(authorizationException, isA<AuthenticationException>());
      },
    );

    test(
      'UserAlreadyExistsException',
      () async {
        final authorizationException = UserAlreadyExistsException();
        // assert
        expect(authorizationException, isA<AuthenticationException>());
      },
    );
  });

  group('Convert Authentication Exception to Failure', () {
    test(
      'TokenExpiredException is a GenericAuthorizationFailure',
      () async {
        final failure = AuthenticationException.convertExceptionToFailure(
            TokenExpiredException(null));
        // assert
        expect(failure, equals(GenericAuthorizationFailure()));
      },
    );

    test(
      'UserNotFoundException is a RedirectToSignupDueToFailure',
      () async {
        final failure = AuthenticationException.convertExceptionToFailure(
            UserNotFoundException());
        // assert
        expect(failure, equals(RedirectToSignupDueToFailure()));
      },
    );

    test(
      'UserNotConfirmedException is a RedirectToVerificationDueToFailure',
      () async {
        final failure = AuthenticationException.convertExceptionToFailure(
            UserNotConfirmedException());
        // assert
        expect(failure, equals(RedirectToVerificationDueToFailure()));
      },
    );

    test(
      'NotAuthorizedException is a InvalidCredentialsFailure',
      () async {
        final failure = AuthenticationException.convertExceptionToFailure(
            NotAuthorizedException());
        // assert
        expect(failure, equals(InvalidCredentialsFailure()));
      },
    );

    test(
      'UserAlreadyExistsException is a RedirectToLoginDueToFailure',
      () async {
        final failure = AuthenticationException.convertExceptionToFailure(
            UserAlreadyExistsException());
        // assert
        expect(failure, equals(RedirectToLoginDueToFailure()));
      },
    );
  });
}
