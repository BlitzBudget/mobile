import 'package:flutter/foundation.dart';

import '../failure/api_failure.dart';
import '../failure/failure.dart';

///
/// API Flow Exceptions
///
class APIException implements Exception {
  dynamic res;

  // Constructor to set response
  APIException({@required this.res});

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
    return GenericAPIFailure();
  }
}

/// Exception is thrown when the token is expired
class TokenExpiredException extends APIException {
  TokenExpiredException(dynamic res) : super(res: res);
}

/// Exception is thrown when the authorization token is empty
class EmptyAuthorizationTokenException extends APIException {}

/// Exception is thrown when the refresh token fails
class UnableToRefreshTokenException extends APIException {}

///
class ConnectionException extends APIException {
  ConnectionException(dynamic res) : super(res: res);
}

class ServerErrorException extends APIException {
  ServerErrorException(dynamic res) : super(res: res);
}

class ClientErrorException extends APIException {
  ClientErrorException(dynamic res) : super(res: res);
}

class UnknownException extends APIException {
  UnknownException(dynamic res) : super(res: res);
}

/// Network Failures
class NoNetworkConnectionException extends APIException {}
