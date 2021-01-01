import '../failure/api-failure.dart';
import '../failure/failure.dart';

///
/// API Flow Exceptions
///
class APIException implements Exception {
  ///
  /// Convert Exception to Failure
  ///
  static Failure convertExceptionToFailure(Exception apiException) {
    if (apiException is EmptyAuthorizationTokenException) {
      return FetchDataFailure();
    } else if (apiException is UnableToRefreshTokenException) {
      return FetchDataFailure();
    } else if (apiException is ClientErrorException) {
      return ClientFailure();
    } else if (apiException is ServerErrorException) {
      return ServerFailure();
    } else if (apiException is ConnectionException) {
      return ConnectionFailure();
    } else if (apiException is NoNetworkConnectionException) {
      return NoNetworkFailure();
    }
    return GenericFailure();
  }
}

/// Exception is thrown when the token is expired
class TokenExpiredException extends APIException {}

/// Exception is thrown when the authorization token is empty
class EmptyAuthorizationTokenException extends APIException {}

/// Exception is thrown when the refresh token fails
class UnableToRefreshTokenException extends APIException {}

///
class ConnectionException extends APIException {}

class ServerErrorException extends APIException {}

class ClientErrorException extends APIException {}

class UnknownException extends APIException {}

/// Network Failures
class NoNetworkConnectionException implements APIException {}
