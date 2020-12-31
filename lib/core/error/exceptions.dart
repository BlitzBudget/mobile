///
/// API Flow Exceptions
///
abstract class ApiException implements Exception {}

/// Exception is thrown when the token is expired
class TokenExpiredException implements ApiException {}

/// Exception is thrown when the authorization token is empty
class EmptyAuthorizationTokenException implements ApiException {}

/// Exception is thrown when the refresh token fails
class UnableToRefreshTokenException implements ApiException {}

class EmptyResultException extends ApiException {}

class ConnectionException extends ApiException {}

class ServerErrorException extends ApiException {}

class ClientErrorException extends ApiException {}

class UnknownException extends ApiException {}

///
/// Authentication Flow Exceptions
///
abstract class AuthenticationException implements Exception {}

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
