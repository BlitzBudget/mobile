import 'failure.dart';

class AuthorizationFailure extends Failure {}

class RedirectToSignupDueToFailure extends AuthorizationFailure {}

class RedirectToVerificationDueToFailure extends AuthorizationFailure {}

class RedirectToLoginDueToFailure extends AuthorizationFailure {}

class InvalidCredentialsFailure extends AuthorizationFailure {}

class GenericAuthorizationFailure extends AuthorizationFailure {}
