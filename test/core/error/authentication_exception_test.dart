import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_blitzbudget/core/error/authentication_exception.dart';

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
}
