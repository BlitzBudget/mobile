/// Exception is thrown when the token is expired
class TokenExpiredException implements Exception {}

/// Exception is thrown when the refresh token fails
class UnableToRefreshTokenException implements Exception {}
