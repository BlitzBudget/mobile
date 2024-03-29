import 'package:mobile_blitzbudget/core/failure/authorization_failure.dart';

import '../failure/failure.dart';

// ignore: avoid_classes_with_only_static_members
///
/// Authentication Flow Exceptions
///
abstract class AuthenticationException implements Exception {
  /// Convert Exception to Failure
  static Failure convertExceptionToFailure(Exception authorizationException) {
    if (authorizationException is UserNotFoundException) {
      return RedirectToSignupDueToFailure();
    } else if (authorizationException is UserNotConfirmedException) {
      return RedirectToVerificationDueToFailure();
    } else if (authorizationException is NotAuthorizedException) {
      return InvalidCredentialsFailure();
    } else if (authorizationException is UserAlreadyExistsException) {
      return RedirectToLoginDueToFailure();
    }
    return GenericAuthorizationFailure();
  }
}

/// Executed when the user is not found when trying to fetch the user
class UserNotFoundException extends AuthenticationException {}

/// Executed when the user is not confirmed when trying to fetch the user
class UserNotConfirmedException extends AuthenticationException {}

/// Executed when the user credentials are invalid when trying to login
class NotAuthorizedException extends AuthenticationException {}

/// Executed when the user credentials are invalid when trying to login
class UserAlreadyExistsException extends AuthenticationException {}

/// Executed when the authorization fails for some other reason
class GenericAuthorizationException extends AuthenticationException {}
