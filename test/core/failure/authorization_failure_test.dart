import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_blitzbudget/core/failure/authorization_failure.dart';

void main() {
  group('Is an APIFailure', () {
    test(
      'RedirectToSignupDueToFailure',
      () async {
        final authorizationFailure = RedirectToSignupDueToFailure();
        // assert
        expect(authorizationFailure, isA<AuthorizationFailure>());
      },
    );

    test(
      'RedirectToVerificationDueToFailure',
      () async {
        final authorizationFailure = RedirectToVerificationDueToFailure();
        // assert
        expect(authorizationFailure, isA<AuthorizationFailure>());
      },
    );

    test(
      'RedirectToLoginDueToFailure',
      () async {
        final authorizationFailure = RedirectToLoginDueToFailure();
        // assert
        expect(authorizationFailure, isA<AuthorizationFailure>());
      },
    );

    test(
      'InvalidCredentialsFailure',
      () async {
        final authorizationFailure = InvalidCredentialsFailure();
        // assert
        expect(authorizationFailure, isA<AuthorizationFailure>());
      },
    );

    test(
      'GenericAuthorizationFailure',
      () async {
        final authorizationFailure = GenericAuthorizationFailure();
        // assert
        expect(authorizationFailure, isA<AuthorizationFailure>());
      },
    );
  });
}
