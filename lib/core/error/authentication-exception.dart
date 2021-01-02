import 'package:mobile_blitzbudget/core/failure/authorization-failure.dart';

import '../failure/api-failure.dart';
import '../failure/failure.dart';

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
    } else if (authorizationException is InvalidUserCredentialsException) {
      return InvalidCredentialsFailure();
    } else if (authorizationException is UserAlreadyExistsException) {
      return RedirectToLoginDueToFailure();
    } else if (authorizationException is UnableToVerifyCodeException) {
      return InvalidVerificationCodeFailure();
    } else if (authorizationException is UnableToResendVerificationCode) {
      return UnableToResendVerficationCodeFailure();
    } else if (authorizationException
        is UnableToInvokeForgotPasswordException) {
      return UnableToInvokeForgotPasswordFailure();
    }
    return GenericFailure();
  }
}

/// Executed when the user is not found when trying to fetch the user
class UserNotFoundException extends AuthenticationException {}

/// Executed when the user is not confirmed when trying to fetch the user
class UserNotConfirmedException extends AuthenticationException {}

/// Executed when the user credentials are invalid when trying to login
class InvalidUserCredentialsException extends AuthenticationException {}

/// Executed when the user credentials are invalid when trying to login
class UserAlreadyExistsException extends AuthenticationException {}

/// Executed when the API is unable to verify the code provided
class UnableToVerifyCodeException extends AuthenticationException {}

/// Executed when the API is not able to resend the verification code
class UnableToResendVerificationCode extends AuthenticationException {}

/// Executed when the API is not able to resend the verification code
class UnableToInvokeForgotPasswordException extends AuthenticationException {}
