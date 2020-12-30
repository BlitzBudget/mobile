abstract class ApiException implements Exception {}

/// Exception is thrown when the token is expired
class TokenExpiredException implements ApiException {}

/// Exception is thrown when the refresh token fails
class EmptyAuthorizationTokenException implements ApiException {}

class EmptyResultException extends ApiException {}

class ConnectionException extends ApiException {}

class ServerErrorException extends ApiException {}

class ClientErrorException extends ApiException {}

class UnknownException extends ApiException {}
